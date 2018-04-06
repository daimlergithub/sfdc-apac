/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Account Link record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingAccountLink implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Retail_Allow_Data_Sharing__c, fromRole__r.Allow_Data_Sharing2__c, 
                                         toRole__r.Allow_Data_Sharing2__c, fromRole__r.MB_Customer_Info_Remove__c, 
                                         toRole__r.MB_Customer_Info_Remove__c 
                                         FROM Account_Link__c where MD__c = 'JP' 
                                         and (((fromRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         toRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         fromRole__r.MB_Customer_Info_Remove__c = true or 
                                         toRole__r.MB_Customer_Info_Remove__c = true) and Retail_Allow_Data_Sharing__c != 'No') 
                                         or ((fromRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         toRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         fromRole__r.MB_Customer_Info_Remove__c != true and 
                                         toRole__r.MB_Customer_Info_Remove__c != true) and Retail_Allow_Data_Sharing__c = 'No'))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
        system.debug('Account Link Scope :'+Scope);
        
        Map<Id, Account_Link__c> updateAccountLinkMap = new  Map<Id, Account_Link__c>();
                
        for(Account_Link__c al : Scope){
            if(al.fromRole__r.Allow_Data_Sharing2__c == 'No' || al.toRole__r.Allow_Data_Sharing2__c == 'No' || al.fromRole__r.MB_Customer_Info_Remove__c == true || al.toRole__r.MB_Customer_Info_Remove__c == true){
                al.Retail_Allow_Data_Sharing__c = 'No';
            } else {
                al.Retail_Allow_Data_Sharing__c = 'Yes';
            }
            
            updateAccountLinkMap.put(al.id,al);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();
        
        if(updateAccountLinkMap.size() > 0){
            SRList = Database.update(updateAccountLinkMap.values(), false);
        }
        
        for (Database.SaveResult sr : SRList) {
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred:' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
    } 
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
   
   
   
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new UpdateAllowDataSharingAccountLink(), 10);
    }
}