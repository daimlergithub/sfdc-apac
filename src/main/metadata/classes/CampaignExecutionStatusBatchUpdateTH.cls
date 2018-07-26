global class CampaignExecutionStatusBatchUpdateTH implements Database.batchable<Sobject>,schedulable, Database.Stateful{

global Database.QueryLocator start(Database.BatchableContext bc){
Date to_day = Date.Today();
Id campExecutionrecid= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
return DataBase.getQueryLocator([select id,name,(select id,Status__c,Contact_Id__r.Email_Status__c,Contact_Id__c from Campaign_Members__r where Status__c='Ready') from Retail_Campaign__C where recordtypeid=:campExecutionrecid and md__c='TH' and Execution_Start_Date__c=:to_day]);
}
global void Execute(Database.BatchableContext bc,List<Retail_Campaign__c> retailCampaign){
    List<Campaign_Member__c> campmembertoupdate=new List<Campaign_Member__c>();
    List<Account> acctoupdate=new List<Account>();
    for(Retail_Campaign__c retcamp:retailCampaign){
        for(Campaign_member__c campmember:retcamp.campaign_members__r){
            campmember.status__c='Executed';
            campmembertoupdate.add(campmember);
        }
    }
    if(campmembertoupdate.size()>0){
        DMLManagerService.updateAsSystem(campmembertoupdate);
        //update campmembertoupdate;
    }
}
global void finish(Database.BatchableContext bc){

}
global void execute(SchedulableContext ctx) 
{
Database.Executebatch(new CampaignExecutionStatusBatchUpdateTH()); 

                   
}
}