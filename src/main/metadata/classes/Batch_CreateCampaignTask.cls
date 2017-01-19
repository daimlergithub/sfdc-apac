/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    01.18.2017
Company             :    NTT Data,Inc.
Usage               :    Campaign Execution via OB Call Scheduler and Notification
                          
JIRA NO             :    SFDCJP-1013                                               
************************************************************************************/

global class Batch_CreateCampaignTask implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    global List<String> notiMailerList = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id devRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
        String strExecutionType = 'OB Call';
        String strChildCampStatus= 'Segmentation';
        Date today = Date.Today();
        String query = 'Select Id, Campaign_CCC_Manager__c, Child_Campaign_Status__c from Campaign Where Execution_Type__c =: strExecutionType AND Child_Campaign_Status__c =: strChildCampStatus'+
                        +' AND Execution_Start_Date__c =:today';
        
        return Database.getQueryLocator(query);
    
    }
     
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
        
        List<Task> tskList = new List<Task>();
        List<Campaign> campList = new List<Campaign>();

        for(Campaign camp : scope){
            Task task = new Task();
            task.WhatID = camp.Id;
            task.Status = 'Completed';
            task.Type = 'Campaign';
            task.subject = 'Campaign Executed';
            task.ownerId = camp.Campaign_CCC_Manager__c;
            task.priority = 'Normal';
            camp.Child_Campaign_Status__c = 'Execution';
            tskList.add(task);
            campList.add(camp);  
            if(camp.Campaign_CCC_Manager__c != null){
                notiMailerList.add(camp.Campaign_CCC_Manager__c);
            }
        }
        if(tskList.size() > 0){
            Database.insert(tskList,false);
        }
        if(campList.size() > 0){
            Database.update(campList,false);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
       
       EmailTemplate templateId = [Select id from EmailTemplate where name = 'test email'];
       List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
       
       for(String userId : notiMailerList){
           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
           msg.SetsaveAsActivity(false); 
           msg.setTemplateId(templateId.Id);
           msg.setTargetObjectId(userId);  
           msgList.add(msg);
       }
       Messaging.sendEmail(msgList);    
    }
    
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_CreateCampaignTask ());
    }
}