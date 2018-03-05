/* Purpose: Generic class hosting code to be executed in Batch class CampaignBouncebackStatusBatchUpdateMY
   Date: 01/02/2018
   Created By: Sushma */

global class CampaignBouncebackStatusBatchUpdate{
    
    global Database.QueryLocator queryMethod(Database.BatchableContext bc, String market){
    Date to_day = Date.Today();
    date nextday = to_day.addDays(1);
    Id campExecutionrecid= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
        if(test.isRunningTest()){
            return DataBase.getQueryLocator([select id,name,(select id,Status__c,Contact_Id__r.Email_Status__c,Contact_Id__c from Campaign_Members__r where Status__c='Execution') from Retail_Campaign__C where recordtypeid=:campExecutionrecid and md__c=:market and Close_Date__c=:nextday]);
        }
    return DataBase.getQueryLocator([select id,name,(select id,Status__c,Contact_Id__r.Email_Status__c,Contact_Id__c from Campaign_Members__r where Status__c='Execution') from Retail_Campaign__C where recordtypeid=:campExecutionrecid and md__c=:market and Close_Date__c<=:to_day]);
    }
}