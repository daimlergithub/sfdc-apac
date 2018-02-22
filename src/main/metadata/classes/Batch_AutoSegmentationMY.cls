/* Purpose: Batch class hosting code to be executed for Malaysia
   Date: 01/02/2018
   Created By: Sushma */

global class Batch_AutoSegmentationMY implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    String communityName='Daimler Community MB Malaysia';
    String market=System.Label.MarketMY;
    Batch_AutoSegmentation_Generic bag=new Batch_AutoSegmentation_Generic();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return bag.method1(bc,communityName,market);
    }
    
    global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
        bag.method2(bc,scope);
    }
    
    global void finish(Database.BatchableContext bc) {
    
    }
    
    global void execute(SchedulableContext ctx) {
        Database.ExecuteBatch(new Batch_AutoSegmentationMY(),10);
    }
}