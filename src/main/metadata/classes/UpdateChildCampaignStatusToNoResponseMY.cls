/* Purpose: Batch class hosting code to be executed for Malaysia. updates the child campaign status to no response  Once the parent campaign reaches its end date
   Date: 01/02/2018
   Created By: Sushma */

global class UpdateChildCampaignStatusToNoResponseMY implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    String market=System.Label.MarketMY;
    UpdateChildCampaignStatusToNoResponse bag=new UpdateChildCampaignStatusToNoResponse();
    global Database.QueryLocator start(Database.BatchableContext bc) {
         return bag.queryMethod(bc,market);
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
        Database.ExecuteBatch(new UpdateChildCampaignStatusToNoResponseMY(),10);
    }
}