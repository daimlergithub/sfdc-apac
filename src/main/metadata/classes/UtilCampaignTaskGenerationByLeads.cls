/*
    Type:       Apex Class
    Purpose:    Define methods used in trigger.DearlerOffering
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    TriggerCampaign.trigger
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
    28-May-2013 Stephano Shi (Breakingpoint)    Modified
    24-June-2013 Stephano Shi (Breakingpoint)    Modified   
    2014-04-03 updated by Justin Yu
    2014-04-18 updated by Shuang Li
*/

global Class UtilCampaignTaskGenerationByLeads implements Database.Batchable<sObject>{
    global List<ID> cpIdList = new List<ID>();    
    private MisunderstoodTaskGeneration mis;
    public List<Campaign> cpUpdateList = new List<Campaign>();  
    public List<User> intUser=new List<User>();
    private String strSMS = 'SMS';
    private String strOBCall = 'OB Call';
    private String streDM = 'eDM';
    private String strDM = 'DM';    
    private String strOpenStatus = 'Open';
    private String strCloseStatus = 'Closed';
    private String strVeriStatus = 'Need Verification';    
    private String strSentActivityStatus = 'Sent';
    
    public List<DM_Request__c> dmRequestList = new List<DM_Request__c>();
    // Batch Job Id
    global Id jobId;
    global Map<String, Schema.RecordTypeInfo> taskRecordTypeMap;
    
    global UtilCampaignTaskGenerationByLeads(List<Campaign> cpList,Id nexJobId) {         
         intUser = [SELECT Id FROM User WHERE Profile.Name = 'IntegrationAPI' AND isActive = true  LIMIT 1];        
         if(cpList!=Null && (!cpList.isEmpty())){
             for(Campaign cp : cpList) {
                cpIdList.add(cp.Id);
                cpUpdateList.add(new Campaign(id = cp.Id, Create_Task__c = false));
             }
        // Initiate Mis
            mis = new MisunderstoodTaskGeneration(cpList, true);
         }
        // Batch Job ID
         if(nexJobId!=Null){
          jobId = nexJobId;
         }       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(
            [select id, Lead_Account_Id__c, Lead__r.Contact__r.PersonMobilePhone, 
                    Lead__r.Contact__r.PersonEmail, Lead__r.Contact__r.PersonContactId, 
                    Lead__c, Task_Generated__c, Campaign__c, Campaign__r.Name, 
                    Campaign__r.Content_Preview__c,
                    Campaign__r.Execution_Type__c, Lead__r.DUP_Number__c, 
                    Campaign__r.Template_Name__c, Campaign__r.DM_Material__c, Lead__r.Interested_Vehicle_Model__c,
                    Campaign__r.Flow_URL__c, Campaign__r.Template__r.Subject__c, 
                    Campaign__r.Template__r.Template_ID__c,
                    Campaign__r.Parent.Task_De_dup_Range__c,
                    Campaign__r.Parent.ParentId,
                    Campaign__r.Previous_Campaign_Execution__c,
                    Campaign__r.Template__c
            from Campaign_Lead__c
            // 2014-2-21 added by Justin Yu - only first time imported campaign lead need to create ob task
            where Campaign__c in :cpIdList and Task_Generated__c = false and FirstTimeImported__c = true]);
    } 
    
    global void execute(Database.BatchableContext BC, List<Campaign_Lead__c> scope) {
        List<Task> taskList = new List<Task>();
        taskRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Savepoint sp = Database.setSavepoint();
        try {           
            for(Campaign_Lead__c cpm : scope) {
                taskList.addAll(generateTask(cpm, taskRecordTypeMap));
                cpm.Task_Generated__c = true;
            }
            update scope;
            if(dmRequestList!=Null && !dmRequestList.isEmpty()) insert dmRequestList;

            Database.SaveResult[] srs = Database.insert(taskList, false);
            mis.processMisunderstoodTasks(srs, taskList);
        }
        catch(exception ex) {  
            Database.rollback(sp);           
            throw ex;           
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus  
                           FROM   AsyncApexJob 
                           WHERE  Id = :BC.getJobId()];
        
        // Batch Job Compeleted.
        if(jobId != null){
            String updateMsg = '';
            try{               
                if(cpUpdateList!=Null && !cpUpdateList.isEmpty()) update cpUpdateList;
                }catch (Exception ex){
                   updateMsg = ex.getMessage();
              }

            Batch_Job__c bj = new Batch_Job__c(Id = jobId);
            if (job.ExtendedStatus == null && updateMsg.length() == 0) {                
                bj.Status__c = 'Completed';                
            }else{
                bj.Status__c = 'Fail';  
                bj.Fail_Reason__c =  job.ExtendedStatus != null ? job.ExtendedStatus : updateMsg;    
            }
            update bj;
        } else {
            System.debug('JOBID>>> null');
        }
    }
    
    private List<Task> generateTask(Campaign_Lead__c cpm, Map<String, Schema.RecordTypeInfo> taskRecordTypeMap) {
        List<Task> taskList = new List<Task>();
        String uniqueTaskField = '';
        if (cpm.Campaign__r.Parent.Task_De_dup_Range__c == 'By Campaign Execution'
                && cpm.Campaign__r.Previous_Campaign_Execution__c == null) {
            uniqueTaskField = 
                String.valueOf(cpm.Campaign__r.ParentId) + 
                String.valueOf(cpm.Lead__c) + 
                cpm.Campaign__r.Execution_Type__c;
        }
        else if (cpm.Campaign__r.Parent.Task_De_dup_Range__c == 'By CAC Campaign') {
            uniqueTaskField = 
                String.valueOf(cpm.Campaign__r.Parent.ParentId) + 
                String.valueOf(cpm.Lead__c) + 
                cpm.Campaign__r.Execution_Type__c;
        }     
      if (cpm.Campaign__r.Execution_Type__c == strSMS && cpm.Lead__r.Contact__r.PersonMobilePhone != null && cpm.Lead__r.Contact__r.PersonMobilePhone != '') {                      
                 taskList.add(new Task(
                        Subject= strSMS, 
                        RecordTypeId = taskRecordTypeMap.get('SMS').getRecordTypeId(),
                        OwnerId = intUser[0].Id,
                        Activity_Status__c = strVeriStatus,
                        Phone__c = cpm.Lead__r.Contact__r.PersonMobilePhone,
                        WhoId = cpm.Lead__r.Contact__r.PersonContactId,
                        WhatId = cpm.Id,
                        ActivityDate = date.today(),
                        UniqueCampaignMobile__c = cpm.Campaign__c + '-' + cpm.Lead__r.Contact__r.PersonMobilePhone,                                 
                        SMS_Content__c = cpm.Campaign__r.Content_Preview__c,
                        SMSTemplateID__c = cpm.Campaign__r.Template__c,
                        UniqueCampaignGenerateTask__c = uniqueTaskField)
                    );
               }         
        else if (cpm.Campaign__r.Execution_Type__c == 'MMS' && cpm.Lead__r.Contact__r.PersonMobilePhone != null && cpm.Lead__r.Contact__r.PersonMobilePhone != '') {            
                taskList.add(new Task(
                        Subject= 'MMS', 
                        RecordTypeId = taskRecordTypeMap.get('MMS').getRecordTypeId(),
                        OwnerId = intUser[0].Id,
                        Activity_Status__c = strVeriStatus,
                        Phone__c = cpm.Lead__r.Contact__r.PersonMobilePhone,
                        WhoId = cpm.Lead__r.Contact__r.PersonContactId,
                        WhatId = cpm.Id,
                        ActivityDate = date.today(),
                        UniqueCampaignMobile__c = cpm.Campaign__c + '-' + cpm.Lead__r.Contact__r.PersonMobilePhone,                                 
                        SMSTemplateID__c = cpm.Campaign__r.Template__c,
                        eDM_Template__c = cpm.Campaign__r.Template__r.Template_ID__c,
                        UniqueCampaignGenerateTask__c = uniqueTaskField)
                  );
            }        
        else if (cpm.Campaign__r.Execution_Type__c == streDM) {        
                taskList.add(new Task(
                    Subject= streDM, 
                    RecordTypeId = taskRecordTypeMap.get('eDM').getRecordTypeId(),
                    OwnerId = intUser[0].Id,
                    Status = strCloseStatus,
                    Campaign_eDM_Template_Subject__c = cpm.Campaign__r.Template__r.Subject__c, 
                    Campaign_eDM_Template_ID__c = cpm.Campaign__r.Template__r.Template_ID__c,                                  
                    WhoId = cpm.Lead__r.Contact__r.PersonContactId,
                    WhatId = cpm.Id,
                    Email_Address__c = cpm.Lead__r.Contact__r.PersonEmail,
                    Activity_Status__c = strSentActivityStatus,
                    Car_Series__c = cpm.Lead__r.Interested_Vehicle_Model__c,
                    UniqueCampaignEmail__c = cpm.Campaign__c + '-' + cpm.Lead__r.Contact__r.PersonEmail,                                 
                    ActivityDate = date.today(),
                    eDM_Template__c = cpm.Campaign__r.Template_Name__c,
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
            }       
      return taskList;
    }
}