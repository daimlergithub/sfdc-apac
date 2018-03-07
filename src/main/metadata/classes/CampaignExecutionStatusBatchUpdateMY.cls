/* Purpose: Batch class hosting code to be executed for Malaysia
   Date: 01/02/2018
   Purpose: changes the campaign member status to Execution once its related Retail campaign reaches to execution date
   Created By: Sushma */

global class CampaignExecutionStatusBatchUpdateMY implements Database.batchable<Sobject>,schedulable, Database.Stateful{
    String market=System.Label.MarketMY;
    CampaignExecutionStatusBatchUpdate bag=new CampaignExecutionStatusBatchUpdate();
    global Database.QueryLocator start(Database.BatchableContext bc){
        return bag.querymethod(bc,market);
    }
    
    global void Execute(Database.BatchableContext bc,List<Retail_Campaign__c> retailCampaign){
        List<Campaign_Member__c> campmembertoupdate=new List<Campaign_Member__c>();
        List<Account> acctoupdate=new List<Account>();
        for(Retail_Campaign__c retcamp:retailCampaign){
            for(Campaign_member__c campmember:retcamp.campaign_members__r){
                campmember.status__c='Execution';
                campmembertoupdate.add(campmember);
            }
        }
        if(campmembertoupdate.size()>0){
            DMLManagerService.updateAsSystem(campmembertoupdate);
        }
    }
    
    global void finish(Database.BatchableContext bc){

    }
    global void execute(SchedulableContext ctx) {
        Database.Executebatch(new CampaignExecutionStatusBatchUpdateMY());                    
    }
}