/**
Type:       Batch class for News Approval Reminders    
Purpose:    1. Send Reminder email alerts to approvers

User Story: RCP-53
Used By:    
---------------------------------------------------------------
History:

22-August-2018 Surendranath  Created
*/
global class BatchNewsReminderEmails implements Database.Batchable<sObject>, Schedulable, Database.Stateful {
    
    //Variable Section
    global FINAL String strQuery;
    global List<String> errorMessages = new List<String>();    
    global BatchNewsReminderEmails() { 
        this.strQuery = getBatchQuery();
    }
    
    //Returns the Query String to Batch constructor to fetch right records.
    private String getBatchQuery() {
        String approvalStatus = 'Pending';
        String strQuery = 'SELECT Approval_Status__c,Approver_List__c,Count__c,CreatedDate,Description__c,Document_Status__c,Expiration_Date__c,Id,Name,Need_Approval__c,OwnerId,Owner_Name__c,RecordTypeId,Remarks__c,Save_As_Draft__c,Send_Reminder__c,Share_With_Groups__c,Start_Date__c,Title__c,WorkFlow_Group__c,Owner.Email FROM News__c WHERE Approval_Status__c = \'' + approvalStatus + '\' AND Send_Reminder__c = true'; 
        return strQuery;
    }
    
    //Batch Start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
    
    //Batch Execute method calls
    global void execute(Database.BatchableContext BC, List<sObject> scopeList) {
        System.debug(LoggingLevel.INFO, '== scopeList size ==' + scopeList.size());
        
        List<News__c> newsList = (List<News__c>) scopeList;
        Map<String,String> customMap=new Map<String,String>();
        Public_Group_Labels__mdt[] mdtNames = [select MasterLabel,Public_Group_Name__c from Public_Group_Labels__mdt];
        for(Public_Group_Labels__mdt pg :mdtNames){
            customMap.put(pg.MasterLabel, pg.Public_Group_Name__c);
        }
        system.debug('customMap '+customMap);       
        if(!newsList.isEmpty()) { 
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            List<News__c> updateNews = new List<News__c>();
            for (News__c n : newsList)
            {               
                Set<Id> UserIds = new Set<Id>();
                List<String> grpList = new List<String>();
                if(n.Approver_List__c != null){
                    List<string> approverList = n.Approver_List__c.split(';');
                    for(Integer i=0; i < approverList.size(); i++){
                        grpList.add(customMap.get(approverList[i]));                        
                    }
                }
                if(grpList != null && grpList.size() > 0){
                    List<Group> groupMemberList = [SELECT Id, (select userOrGroupId from groupMembers) FROM group WHERE DeveloperName=:grpList];
                    for(Group grp : groupMemberList){
                        
                        for(GroupMember GM : grp.groupMembers){
                            UserIds.add(GM.UserOrGroupId);
                        }
                    }
                }
                List<User> userRec = new List<User>();
                List<String> toEmailList = new List<String>();
                if(UserIds !=null && UserIds.size() > 0){
                    userRec = [select id,Email from user where id IN:UserIds];                    
                    for(User u:userRec){
                        toEmailList.add(u.Email);
                    }                   
                }
                //To get approval URL 
                String approvalUrl='';                  
                List<ProcessInstanceWorkitem> workItemLst =[SELECT id FROM ProcessInstanceWorkitem WHERE processInstance.TargetObjectId=:n.Id];   
                
                if(workItemLst.size() > 0)  
                {                    
                    approvalUrl='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
                        '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
                }
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                String[] ccAddress = new String[] {n.Owner.Email};                    
                Message.setToAddresses(toEmailList);
                Message.setCcAddresses(ccAddress);
                Message.SaveAsActivity = false;
                //Message.setTargetObjectId(n.OwnerId);
                //Message.setTemplateId(et.id);
                String emailBody = 'Hello, <br/><br/>';
				emailBody += 'The following News is waiting for your Approval . <br/><br/>';
				emailBody += 'Below are the News Details: <br/><br/>';
				emailBody += 'Author : ' +n.Owner_Name__c+'<br/>';
                emailBody += 'Title : ' +n.Title__c+'<br/>';
                emailBody += 'Start Date : ' +String.valueOf(n.Start_Date__c.format())+'<br/>';
                emailBody += 'End Date : ' +String.valueOf(n.Expiration_Date__c.format())+'<br/><br/>';
				emailBody +='Please click on below link to view the record.<br/>';
				emailBody +='<a href='+approvalUrl+'>Click here to Approve or Reject</a> <br/><br/>';
                system.debug('emailBody: '+emailBody);
                Message.setSubject('Reminder: News is waiting for your approval');
                Message.setHtmlBody(emailBody);
                mailList.add(Message);                
                double ct = n.Count__c.intValue()+1;
                News__c news1 = new News__c();
                news1.Count__c = ct;
                news1.Id = n.Id;
                updateNews.add(news1);
            }
            if(!mailList.isEmpty()) {
                try{
                    Messaging.sendEmail(mailList);
                    update updateNews;
                }
                catch (Exception ex) {
                    errorMessages.add('Unable to send email: '+ ex.getMessage());
                }
            }
        }
    }  
    
    //Batch Finish method for after execution of batch work
    global void finish(Database.BatchableContext BC) { 
        AsyncApexJob aaj = [Select Id, Status, NumberOfErrors, JobItemsProcessed, MethodName, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {aaj.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('JOB Salesforce Send Notification Batch: ' + aaj.Status);
        String bodyText='Total Job Items ' + aaj.TotalJobItems + ' Number of records processed ' + aaj.JobItemsProcessed + ' with '+ aaj.NumberOfErrors + ' failures.\n';
        bodyText += 'Number of Error Messages ' + errorMessages.size() + '\n';
        bodyText += 'Error Message' + String.join(errorMessages, '\n');
        mail.setPlainTextBody(bodyText);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Method which schedules the Batch
    global void execute(SchedulableContext sc) {        
        BatchNewsReminderEmails bnInstance = new BatchNewsReminderEmails();
        ID batchprocessid = Database.executeBatch(bnInstance);
    }   
}