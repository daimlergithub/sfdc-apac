/*
    Type:       Trigger
    Purpose:    1. If customer has no vehicle relationship, Status must not be ‘Customer’ 
                2. Update dealer record in salesforce manually check
                3. When city change , update look up
                
    User Story: US-CP-010 , US-CP-016  ,US-CP-017 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-06-05
*/

trigger AccountBeforeInsertUpdate on Account (before insert, before update) {
    if (!UtilCustomSettings.isEnabled('AccountBeforeInsertUpdate')) {
        return;
    }
    
    Map<String, boolean> cp010Map = new Map<String, boolean>();
    Set<Id> cp016Map = new Set<Id>();
    Map<String, id> cp017Map = new Map<String, id>();
    List<String> dealerCodes = new List<String>();
    List<id> ids = new List<id>();
    List<String> citys = new List<String>();
    
    Profile IngretionProfile = [select Id from Profile where Name = 'IntegrationAPI'];
    
    for(Account curAcc: trigger.new){
        
        // "Dealer DMS SR Code 1" has a value and "Dealer Default Flag" 
        if (curAcc.Dealer_Default_Flag__c && String.isBlank(curAcc.Dealer_DMS_SR_Code__c)){
            if(trigger.isInsert){
                dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
            }
            if(trigger.isUpdate){
                if (trigger.oldMap.get(curAcc.id).Dealer_Default_Flag__c != curAcc.Dealer_Default_Flag__c ||
                    trigger.oldMap.get(curAcc.id).Dealer_DMS_SR_Code__c != curAcc.Dealer_DMS_SR_Code__c){
                    dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
                }
            }
        }

        
        if ('Customer' == curAcc.Status__c && UserInfo.getProfileId() != IngretionProfile.Id){
            //if(trigger.isInsert){
                //ids.add(curAcc.id);
            //}
            if(trigger.isUpdate){
                if (trigger.oldMap.get(curAcc.id).Status__c != curAcc.Status__c){
                    ids.add(curAcc.id);
                }
            }           
        }
        
        if (!String.isBlank(curAcc.City_CN__c)){
            citys.add(curAcc.City_CN__c);
        }
        
    }
    
    //get record counts from accout which Dealer_Default_Flag__c = true and "Dealer DMS SR Code 1" has a value
    if (dealerCodes.size() > 0){
        cp010Map = AccountHelper.getDealerCountInfo(dealerCodes);
    }
    
    //get record counts from Vehichle relationShip which Contact is current Acount.
    if (ids.size() > 0){
        cp016Map = AccountHelper.getVSCountInfo(ids);
    }
    
    if ( cp010Map.size() > 0 || citys.size() > 0 || ids.size() > 0){
        for(Account curAcc: trigger.new){
    
            //if an other dealer update "Dealer DMS SR Code 1" with the same value. 
            //and  "Dealer Default Flag" checked. Show error messages.
            if (cp010Map.size() > 0 && curAcc.Dealer_Default_Flag__c &&  String.isBlank(curAcc.Dealer_DMS_SR_Code__c)){
                if(!cp010Map.get(String.valueOf(curAcc.Dealer_DMS_SR_Code__c))){
                    //curAcc.addError(AccountHelper.ERROR_MSG_CP_010);
                }
            }
            
            // If customer has no vehicle relationship, Status must not be ‘Customer’. Else, Show Error messages.
            if(ids.size() > 0){
                if ('Customer' == curAcc.Status__c && !cp016Map.contains(curAcc.id)){
                    //curAcc.addError(AccountHelper.ERROR_MSG_CP_016);
                }
            }
            
            //when city changed， update look up 
            if (!String.isBlank(curAcc.City_CN__c)){
                if (cp017Map.containsKey(curAcc.City_CN__c)){
                   curAcc.Region_City_Mapping__c = cp017Map.get(curAcc.City_CN__c);
                }else{
                   curAcc.Region_City_Mapping__c = null;
                }
            }else{
                curAcc.Region_City_Mapping__c = null;
            }
        }
    } 
    
    /**
     * Added by Justin Yu on 2014-3-4. Fill in the Zip Code automatically based on the City
     */
    for(Account account : Trigger.new){
        if(!Trigger.isUpdate || account.City_CN__c != Trigger.oldMap.get(account.Id).City_CN__c){
            try{
                City__c city = City__c.getInstance(account.City_CN__c);
                account.ZipCode__c = city != null ? city.Zip__c : null;
            }
            catch (System.InvalidParameterValueException e){
                // City_CN__c probably too long
            }
        }
    }   
}