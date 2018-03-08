global class UpdateChildCampaignStatusToNoResponseTH implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
Date todaydate=DATE.TODAY();
Id executionRecordId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
global Database.QueryLocator start(Database.BatchableContext bc) {
if(!Test.isRunningTest()){
  return Database.getQueryLocator('SELECT Id,Recordtype.name,Parent_Campaign1__r.status__c,child_campaign_status__c,Name FROM REtail_campaign__c WHERE Parent_Campaign1__c!=null and Parent_Campaign1__r.close_Date__c=:todaydate and recordtypeid=:executionRecordId and md__C=\'TH\'');
}
else{
  Date todaydate=DATE.TODAY();
    Date nextdate=todaydate.addDays(5);
    return Database.getQueryLocator('SELECT Id,Recordtype.name,Parent_Campaign1__r.status__c,child_campaign_status__c,Name FROM REtail_campaign__c WHERE Parent_Campaign1__c!=null and Parent_Campaign1__r.close_Date__c=:nextdate and recordtype.id=:executionRecordId and md__C=\'TH\'');
}
}
global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
set<Retail_campaign__C> retcampaignset=new Set<Retail_campaign__C>();
List<Retail_campaign__C> retcampaigntoupdate=new List<Retail_campaign__C>();
for(Retail_campaign__C retcamp:scope){
//retcamp.Parent_Campaign1__r.status__c='Completed';
if(retcamp.child_campaign_status__c=='Execution'){
retcamp.child_campaign_status__c='No Response';
    retcampaignset.add(retcamp);
}
//retcampaignset.add(retcamp.Parent_Campaign1__r);
}
if(retcampaignset.size()>0){
retcampaigntoupdate.addAll(retcampaignset);
update retcampaigntoUpdate;
}
}
global void finish(Database.BatchableContext bc) {
    
    }
global void execute(SchedulableContext ctx) {
    Database.ExecuteBatch(new UpdateChildCampaignStatusToNoResponseTH(),10);
}
}