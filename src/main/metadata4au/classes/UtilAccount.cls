/*
    Type:       Utility for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City and Province 
    User Story: US-DS-001, US-Lead-009
    Used By:    TriggerAccount.trigger
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28
    2. Mouse Updated on 2013-07-04 for US-Lead-009
*/
public class UtilAccount {
    // US-DS-001
    public static void linkDealerCity(List<Account> triggerNew, Id dealerRecordTypeId,Map<id,Account> oldAcc,boolean isUpdate,boolean isBefore,boolean isExecuting) {
        if (isUpdate && isBefore && isExecuting) {
            // Get cities, provinces and the dealer which city or province has change
            Set<Id> dealerIdSet = new Set<Id>();
            Set<String> cities = new Set<String>();
            Set<String> provinces = new Set<String>();
            if(triggerNew!=Null && !triggerNew.isEmpty()){
                for (Account acc : triggerNew) {
                    // Get the dealer which City or Province has change                
                  if(oldAcc!=Null && !oldAcc.isEmpty()){
                    if(acc.RecordTypeId == dealerRecordTypeId && 
                            (acc.City__c != oldAcc.get(acc.Id).City__c ||
                             acc.Province__c != oldAcc.get(acc.Id).Province__c)) {
                        dealerIdSet.add(acc.Id);
    
                        // Populate cities and provinces
                        if (acc.City__c != null) {
                            cities.add(acc.City__c);
                        }
    
                        if (acc.Province__c != null) {
                            provinces.add(acc.Province__c);
                        }
                     }
                   }
                }
             }
        }
    }
    // When Account Allow Data Sharing is True
    public static void accountSetForUpdateLead(List<Account> triggerNew,Map<id,Account> oldAcc){
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> accIdSetForUpdateLead = new Set<Id>();
        if(triggerNew!=Null && !triggerNew.isEmpty()){
            for (Account newAcc : triggerNew) {             
                // US-Lead-009
                if(oldAcc!=Null && !oldAcc.isEmpty()){
                    if (newAcc.Allow_Data_Sharing__c != oldAcc.get(newAcc.Id).Allow_Data_Sharing__c) {
                        accIdSet.add(newAcc.Id);
                    }            
                    // US-DP-022, US-DP-023
                    if((newAcc.Allow_Data_Sharing__c == 'Yes' && newAcc.Allow_Data_Sharing__c != oldAcc.get(newAcc.Id).Allow_Data_Sharing__c) ||  
                       (newAcc.Gender__c != null && newAcc.Gender__c != '' && newAcc.Gender__c != oldAcc.get(newAcc.Id).Gender__c) ||
                       (newAcc.Province__c != null && newAcc.Province__c != '' && newAcc.Province__c != oldAcc.get(newAcc.Id).Province__c) ||
                       (newAcc.City_CN__c != null && newAcc.City_CN__c != '' && newAcc.City_CN__c != oldAcc.get(newAcc.Id).City_CN__c) ||
                       (newAcc.Preferred_Language__c != null && newAcc.Preferred_Language__c != '' && newAcc.Preferred_Language__c != oldAcc.get(newAcc.Id).Preferred_Language__c) ) {
                        accIdSetForUpdateLead.add(newAcc.Id);
                    }
                }
            }
          }
        // US-Lead-009
        if (accIdSet.size() > 0) {
            UtilAccount.updateLeadForDataSharing(accIdSet);
        }        
        // US-DP-022, US-DP-023
        if (accIdSetForUpdateLead.size() > 0) {
            AccountHelper.updateLeads(accIdSetForUpdateLead);
        }
    }       
    // US-Lead-009
    // When Account Allow Data Sharing is False, 
    public static void updateLeadForDataSharing(Set<Id> accIds) {
        List<Lead__c> leadList = 
            [SELECT Allow_Data_Sharing__c, Contact__r.Allow_Data_Sharing__c 
             FROM Lead__c WHERE Contact__c IN :accIds];

        for (Lead__c lead : leadList) {
            if (lead.contact__r.Allow_Data_Sharing__c == 'Yes') {
                lead.Allow_Data_Sharing__c = true;
            }
            else {
                lead.Allow_Data_Sharing__c = false;
            }
        }

        try {
            update leadList;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('UtilAccount.updateLeadForDataSharing eXception: ' + e);
        }
    }
  //dealerCodes Info for an Account
   public static void beforeAccDealerInfo(List<Account> triggerNew,Map<id,Account> oldAcc,boolean isInsert,boolean isUpdate){
        Map<String, boolean> cp010Map = new Map<String, boolean>();
        Set<Id> cp016Map = new Set<Id>();
        Map<String, id> cp017Map = new Map<String, id>();
        List<String> dealerCodes = new List<String>();
        List<id> ids = new List<id>();
        List<String> citys = new List<String>();        
        Profile IngretionProfile = [select Id from Profile where Name = 'IntegrationAPI'];
        for(Account curAcc:triggerNew){        
            // "Dealer DMS SR Code 1" has a value and "Dealer Default Flag" 
            if (curAcc.Dealer_Default_Flag__c && String.isBlank(curAcc.Dealer_DMS_SR_Code__c)){
                if(isInsert){
                    dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
                }
                if(isUpdate){  
                  if(oldAcc!=Null && !oldAcc.isEmpty()){                    
                    if (oldAcc.get(curAcc.Id).Dealer_Default_Flag__c != curAcc.Dealer_Default_Flag__c ||
                         oldAcc.get(curAcc.Id).Dealer_DMS_SR_Code__c != curAcc.Dealer_DMS_SR_Code__c){
                         dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
                    }
                  }
                }
            }    
            
            if ('Customer' == curAcc.Status__c && UserInfo.getProfileId() != IngretionProfile.Id){
                //if(trigger.isInsert){
                    //ids.add(curAcc.id);
                //}
                if(isUpdate){ 
                   if(oldAcc!=Null && !oldAcc.isEmpty()){                  
                    if (oldAcc.get(curAcc.Id).Status__c != curAcc.Status__c){
                        ids.add(curAcc.id);
                     }
                   }
                }           
            }            
            if (!String.isBlank(curAcc.City_CN__c)){
                citys.add(curAcc.City_CN__c);
            }            
         }
            
     //get record counts from accout which Dealer_Default_Flag__c = true and "Dealer DMS SR Code 1" has a value
      if(dealerCodes.size()>0){
            cp010Map = AccountHelper.getDealerCountInfo(dealerCodes);
        }
        
        //get record counts from Vehichle relationShip which Contact is current Acount.
        if (ids.size()>0){
            cp016Map = AccountHelper.getVSCountInfo(ids);
        }      
           
       
       /* Added by Justin Yu on 2014-3-4. Fill in the Zip Code automatically based on the City */
        
        for(Account account : triggerNew){   
          if(oldAcc!=Null && !oldAcc.isEmpty()){         
            if(!isUpdate || account.City_CN__c != oldAcc.get(account.Id).City_CN__c){
                try{
                    City__c city = City__c.getInstance(account.City_CN__c);
                    account.ZipCode__c = city != null ? city.Zip__c : null;
                }
                catch (System.InvalidParameterValueException e){
                   	system.debug('DML Exception: ' + e.getMessage());
                }
            }
          }
        }   
   }
}