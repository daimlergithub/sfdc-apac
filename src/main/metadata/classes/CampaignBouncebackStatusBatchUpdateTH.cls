global class CampaignBouncebackStatusBatchUpdateTH implements Database.batchable<Sobject>,schedulable, Database.Stateful{
set<Account> acctoupdate=new set<Account>();
global Database.QueryLocator start(Database.BatchableContext bc){
Date to_day = Date.Today();
date nextday = to_day.addDays(1);
Id campExecutionrecid= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    if(test.isRunningTest()){
        return DataBase.getQueryLocator([select id,name,(select id,Status__c,Contact_Id__r.Email_Status__c,Contact_Id__c from Campaign_Members__r where Status__c='Executed') from Retail_Campaign__C where recordtypeid=:campExecutionrecid and md__c='TH' and Close_Date__c=:nextday]);
    }
return DataBase.getQueryLocator([select id,name,(select id,Status__c,Contact_Id__r.Email_Status__c,Contact_Id__c from Campaign_Members__r where Status__c='Executed') from Retail_Campaign__C where recordtypeid=:campExecutionrecid and md__c='TH' and Close_Date__c<=:to_day]);
}
global void Execute(Database.BatchableContext bc,List<Retail_Campaign__c> retailCampaign){
    List<Campaign_Member__c> campmembertoupdate=new List<Campaign_Member__c>();
    
    for(Retail_Campaign__c retcamp:retailCampaign){
        for(Campaign_member__c campmember:retcamp.campaign_members__r){
            campmember.status__c='Not Responded';
            campmembertoupdate.add(campmember);
            if(campmember.Contact_Id__c !=null){
            
                campmember.Contact_Id__r.Email_Status__c='Bounce-Back';
                acctoupdate.add(campmember.contact_id__r);
            }
        }
    }
    if(campmembertoupdate.size()>0){
        
        DMLManagerService.updateAsSystem(campmembertoupdate);
        //update campmembertoupdate;
        
    }
}
global void finish(Database.BatchableContext bc){
    if(acctoupdate.size()>0){
        List<Account> acclst=new List<Account>();
        acclst.addall(acctoupdate);
        //AsyncExecutionExample asc=
        System.enqueuejob(new AsyncExecutionQueue(acclst));
        }         
        }
global void execute(SchedulableContext ctx) 
    {
        Database.Executebatch(new CampaignBouncebackStatusBatchUpdateTH());                
    }
}