/* Purpose: Batch class hosting code to be executed for Malaysia. Automatically creates tasks and leads depends on execution type.
   Date: 01/02/2018
   Created By: Sushma */

global class Batch_AutoTaskANDLead_MY implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    String market=System.Label.MarketMY;
    Batch_AutoTaskANDLead_Generic bag=new Batch_AutoTaskANDLead_Generic();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return bag.method1(bc,market);
    }
    
    global void execute(Database.BatchableContext bc, List<Campaign_Member__c> scope) {
        bag.method2(bc,scope);
    }
    
    global void finish(Database.BatchableContext bc) {
    
    }
    
    global void execute(SchedulableContext ctx) {
        Database.ExecuteBatch(new Batch_AutoTaskANDLead_MY(),1);
    }
}