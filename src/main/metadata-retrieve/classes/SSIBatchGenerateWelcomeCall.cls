/*
    Type:       SSI VIN Match 
    Purpose:    At the end of month, system generates Welcome call task based on unmatched DMS record against SSI record. 
    User Story: US-SSI-006
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-21

*/
global class SSIBatchGenerateWelcomeCall implements Database.Batchable<SObject>, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;
    
    // default task assign user
    private User OBSV;
    
    global SSIBatchGenerateWelcomeCall(String q) {
        this.query = q;
        if(OBSV == null){
            List<Profile> ps = [Select Id From Profile Where Name = 'CAC OB SV' Limit 1];
            if(ps != null && ps.size() > 0){
                List<User> us = [Select Id From User Where ProfileId = :ps[0].Id  And IsActive = true Limit 1];
                if(us != null && us.size() > 0){
                    OBSV = us[0];
                }
            }
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<Task> tasks = new List<Task>();
        
        for(Account acc : (List<Account>)scope){
            Boolean hasTask = false;
            for(ActivityHistory ah : acc.ActivityHistories){
                if(ah.Subject == 'Welcome Call' || ah.Subject == 'Welcome Call + 1st Survey Call'){
                    hasTask = true;
                    break;
                }
            }

            for(OpenActivity ah : acc.OpenActivities){
                if(ah.Subject == 'Welcome Call' || ah.Subject == 'Welcome Call + 1st Survey Call'){
                    hasTask = true;
                    break;
                }
            }
            
            if(hasTask){
                continue;
            }
            
            Boolean generateTask = false;
            
            if(acc.Retail_Tasks3__r.size() > 0){
                generateTask = true;
            }
            
            if(generateTask == true){
                tasks.add(createWelcomeCallTask(acc));
            }
        }  
        
        if(tasks.size()>0){
            insert tasks;
            successCount += tasks.size();
        }

    }
    
    private Id WCRTID = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
    
    private Task createWelcomeCallTask(Account acc){
        Task t = new Task();
        t.RecordTypeId = WCRTID;
        t.Subject = 'Welcome Call';
        t.WhatId = acc.Id;
        t.WhoId = acc.PersonContactId;
        t.CustomerName__c = acc.Name;
        t.OwnerId = OBSV.Id;
        t.Status = 'Open';
        t.Welcome_Call_Source__c = 'Welcome Call';
        return t;
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           JobItemsProcessed, TotalJobItems
                    FROM AsyncApexJob
                    WHERE Id = :bc.getJobId()]; 
                                        
        User currentUser = [Select Email From User Where Id = :UserInfo.getUserId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {currentUser.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Generate Welcome Call Batch Status: ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems +
            ' batches with '+ job.NumberOfErrors + ' failures. \nTotal Welcome Call tasks created: ' + successCount);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex) {
            system.debug('Send Generate Welcome Call Batch Status Email Exception ::' + ex.getMessage());
        }
    }
}