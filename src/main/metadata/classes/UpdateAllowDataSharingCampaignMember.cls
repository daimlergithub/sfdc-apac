/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Campaign Member (Custom Object) record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingCampaignMember implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Contact_Id__r.Allow_Data_Sharing2__c, Contact_Id__r.MB_Customer_Info_Remove__c 
                                         FROM Campaign_Member__c where MD__c = 'JP' 
                                         and (((Contact_Id__r.Allow_Data_Sharing2__c = 'No' or Contact_Id__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Contact_Id__r.Allow_Data_Sharing2__c != 'No' and Contact_Id__r.MB_Customer_Info_Remove__c = false) and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Campaign_Member__c> scope){
        system.debug('Campaign Member Scope :'+Scope);
        
        Map<Id, Campaign_Member__c> updateCampaignMemberMap = new  Map<Id, Campaign_Member__c>();
                
        for(Campaign_Member__c cm : Scope){
            if(cm.Contact_Id__r.Allow_Data_Sharing2__c == 'No' || cm.Contact_Id__r.MB_Customer_Info_Remove__c == true){
                cm.Allow_Data_Sharing__c = false;
            } else {
                cm.Allow_Data_Sharing__c = true;
            }
            
            updateCampaignMemberMap.put(cm.id,cm);
        }

        List<Database.SaveResult> SRList = new List<Database.SaveResult>();
        
        if(updateCampaignMemberMap.size() > 0){
            SRList = Database.update(updateCampaignMemberMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingCampaignMember());
    }
}