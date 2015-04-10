/*
    Type:       Batch Class
    Purpose:    Batch Assign Tasks To Prevent 10001 DML Rows Limit. 
    User Story: 
    Used By:    MassAssignRecallTasksControllerExtension
    ---------------------------------------------------------------
    History:
    
    1. Chris.Huang (Breakingpoint) Created on 2013-12-06
    2. Shuang Li Edit on 2014-03-17  US-SMART_SSI-007
*/
global class BatchAssignTasks implements Database.Batchable<sObject>{
    global final String query;
    global final List<User> userList;
    private Integer successCount = 0;
    
    global BatchAssignTasks(String q, List<User> users){
        query = q;
        userList = users;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Task> scope){
        //System.debug('--------scope.size()-------->' + scope.size());
        Integer i = 0;
        for(Task s : scope){
            if (i >= userList.size()) {
                i = 0;
            }
            User u = userList[i];
            i++;
            s.OwnerId = u.Id;
        }      
        update scope;
        successCount += scope.size();
        
        scope = [Select Id, OwnerId, WhatId, What.Type From Task Where Id In :scope];
        Set<Id> ssiIds = new Set<Id>();
        Set<String> assignTaskIds = new Set<String>();
        Map<Id, Id> ssiOwnerMap = new Map<Id, Id>();
        for (Task tk : scope) {
            if (tk.WhatId != null && tk.What.Type == 'SSI__c') {
                ssiIds.add(tk.WhatId);
                ssiOwnerMap.put(tk.WhatId, tk.OwnerId);
                String tkid = tk.Id;
                tkid = tkid.length() > 15 ? tkid.subString(0, 15) : tkid;
                assignTaskIds.add(tkid); 
            //ADD START Shuang Li US-SMART_SSI-007
            }else if(tk.WhatId != null && tk.What.Type == 'smart_SSI__c') {
                ssiOwnerMap.put(tk.WhatId, tk.OwnerId);
                String tkid = tk.Id;
                tkid = tkid.length() > 15 ? tkid.subString(0, 15) : tkid;
                assignTaskIds.add(tkid); 
            }
            //END START Shuang Li US-SMART_SSI-007
        }
        if (ssiIds.size() > 0) {
            List<SSI__c> ssiList = [Select Id, OwnerId From SSI__c Where Id In :ssiIds];
            for (SSI__c ssiObj : ssiList) {
                ssiObj.OwnerId = ssiOwnerMap.get(ssiObj.Id);
            }
            if (ssiList.size() > 0) {
                update ssiList;
            } 
        }
    }
    
    global void finish(Database.BatchableContext BC){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           JobItemsProcessed, TotalJobItems
                    FROM AsyncApexJob
                    WHERE Id = :bc.getJobId()]; 
                    
        User currentUser = [Select Email From User Where Id = :UserInfo.getUserId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {currentUser.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Mass Assign / Recall Tasks Batch Status: ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems +
            ' batches with '+ job.NumberOfErrors + ' failures. \nTotal Records Updated: ' + successCount);
        try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception ex) {
            system.debug('Send Collaboration Team Email Exception : finish :' + ex.getMessage());
        }
    }    

}