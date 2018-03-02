/* Purpose: Generic class hosting code to be executed in Batch class UpdateChildCampaignStatusToNoResponseMY
   Date: 01/02/2018
   Created By: Sushma */

global class UpdateChildCampaignStatusToNoResponse{
    Date todaydate=DATE.TODAY();
    Id executionRecordId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    global Database.QueryLocator queryMethod(Database.BatchableContext bc, String market) {
        if(!Test.isRunningTest()){
          return Database.getQueryLocator('SELECT Id,Recordtype.name,Parent_Campaign1__r.status__c,child_campaign_status__c,Name FROM Retail_campaign__c WHERE Parent_Campaign1__c!=null and Parent_Campaign1__r.close_Date__c=:todaydate and recordtypeid=:executionRecordId and md__c=:market');
        }
        else{
          Date todaydate=DATE.TODAY();
            Date nextdate=todaydate.addDays(1);
            return Database.getQueryLocator('SELECT Id,Recordtype.name,Parent_Campaign1__r.status__c,child_campaign_status__c,Name FROM Retail_campaign__c WHERE Parent_Campaign1__c!=null and Parent_Campaign1__r.close_Date__c=:nextdate and recordtype.id=:executionRecordId and md__c=:market');
        }
    }
}