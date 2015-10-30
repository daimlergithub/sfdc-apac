/**
** @Description Link Dealer to Dealer City by City and Province.
** Type:       Utility for TriggerAccount
** Created By: 
** Date: 2013-03-28
** Modified By : 
** Modified date : Updated on 2013-07-04 for US-Lead-009; 27-10-2015
** User Story: US-DS-001, US-Lead-009
** Used By:    TriggerAccount.trigger
**/

public class UtilAccount {
    // When Account Allow Data Sharing is True
	
	 /**	
     * @Description Based on the Query if allow data sharing field is updated or changed to yes then lead owner to dealer owner		 
     * @author  
     * @Date 10/27/2015(mm/dd/yy)
	 * @param  List of new accounts and map of Old accounts
	 * @return 
	 * @see  TriggerAccountTriggerHandler(UtilAccount.accountSetForUpdateLead)
	 */   
	 	 
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
                       (newAcc.Gender__c != null && !String.isBlank(newAcc.Gender__c) && newAcc.Gender__c != oldAcc.get(newAcc.Id).Gender__c) ||
                       (newAcc.Province__c != null && !String.isBlank(newAcc.Province__c) && newAcc.Province__c != oldAcc.get(newAcc.Id).Province__c) ||
                       (newAcc.City_CN__c != null && !String.isBlank(newAcc.City_CN__c) && newAcc.City_CN__c != oldAcc.get(newAcc.Id).City_CN__c) ||
                       (newAcc.Preferred_Language__c != null && !String.isBlank(newAcc.Preferred_Language__c) && newAcc.Preferred_Language__c != oldAcc.get(newAcc.Id).Preferred_Language__c) ) {
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
	
	  
	
	 /**	
     * @Description  When Account Allow Data Sharing is True
     * @author  
     * @Date 10/27/2015(mm/dd/yy)
	 * @param  Set of Account Id's
	 * @return 
	 * @see   UtilAccount
	 */   
	
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
    	
	 /**	
     * @Description  DealerCodes Info for an Account. 
	 *				 It gets record counts from Vehichle relationShip which Contact is current Acount.
	 *				 Also fills in the Zip Code automatically based on the City
     * @author  
     * @Date 10/27/2015(mm/dd/yy)
	 * @param  Passing trigger Parameters.
	 * @return 
	 * @see   TriggerAccountTriggerHandler(UtilAccount.beforeAccDealerInfo)
	 */   
	 
   public static void beforeAccDealerInfo(List<Account> triggerNew,Map<id,Account> oldAcc,boolean isInsert,boolean isUpdate){
      
        
                List<String> dealerCodes = new List<String>();
        List<id> ids = new List<id>();
        List<String> citys = new List<String>();        
        Profile integrationProfile = [select Id from Profile where Name = 'IntegrationAPI'];
       
        for (Account curAcc : triggerNew) {        
            // "Dealer DMS SR Code 1" has a value and "Dealer Default Flag" 
            if (curAcc.Dealer_Default_Flag__c && String.isBlank(curAcc.Dealer_DMS_SR_Code__c)){
                if (isInsert) {
                    dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
                }
                if (isUpdate) {  
                  if (oldAcc!=Null && !oldAcc.isEmpty()) {                    
                    if (oldAcc.get(curAcc.Id).Dealer_Default_Flag__c != curAcc.Dealer_Default_Flag__c ||
                         oldAcc.get(curAcc.Id).Dealer_DMS_SR_Code__c != curAcc.Dealer_DMS_SR_Code__c){
                         dealerCodes.add(curAcc.Dealer_DMS_SR_Code__c);
                    }
                  }
                }
            }    
            
            if ('Customer' == curAcc.Status__c && UserInfo.getProfileId() != integrationProfile.Id){
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
             
       /*Fill in the Zip Code automatically based on the City*/
        
        for(Account account : triggerNew){   
          if(oldAcc!=Null && !oldAcc.isEmpty()){         
            if(!isUpdate || account.City_CN__c != oldAcc.get(account.Id).City_CN__c){
                try{
                    City__c city = City__c.getInstance(account.City_CN__c);
                    account.ZipCode__c = city == null ? null:city.Zip__c;
                }
                catch (System.InvalidParameterValueException e){
                   	system.debug('DML Exception: ' + e.getMessage());
                }
            }
          }
        }   
   }
}