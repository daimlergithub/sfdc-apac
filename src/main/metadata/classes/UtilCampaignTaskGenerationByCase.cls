/*
    Type:       Apex Class
    Purpose:    Generat task by case
    User Story: 
    Used By:    TriggerCampaign.trigger
    ---------------------------------------------------------------
    History:
  
    23-September-2013 Tony Li (Breakingpoint)    Created
    2014-04-03 updated by Justin Yu
    2014-04-18 updated by Shuang Li
*/
global class UtilCampaignTaskGenerationByCase implements Database.Batchable<sObject>{
    global List<ID> cpIdList = new List<ID>();
    global List<ID> cpmIdList = new List<ID>(); 
    global List<ID> vechCaseIdList = new List<ID>();
    global List<CampaignMember> campMembers = new List<CampaignMember>();
    
    private MisunderstoodTaskGeneration mis;
    public List<Campaign> cpUpdateList = new List<Campaign>(); 
    public List<User> obuserList = new List<User>(); 
    public User intUser;
    public User fulfillmentSpUser;
    
    private ID taskRecordTypeId;
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
    
    /* Construction Method */
    global UtilCampaignTaskGenerationByCase(List<Campaign> cpList, Id nexJobId) {
        //obuserList = [select id, name from User where UserRole.Name = 'OB Supervisor' and IsActive = true LIMIT 1];
        intUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true  LIMIT 1];
       // fulfillmentSpUser = [SELECT Id FROM User WHERE UserRole.Name like '%Fulfillment Specialist%' AND isActive = true LIMIT 1];
        for(Campaign cp : cpList) {
            cpIdList.add(cp.Id);
            cpUpdateList.add(new Campaign(id = cp.Id, Create_Task__c = false));
        }
        
        // Initiate Mis
        mis = new MisunderstoodTaskGeneration(cpList, false);
        
        // Campaign Members 
        campMembers = [select id, ContactId, Contact.AccountId, LeadId, Task_Generated__c, CampaignId, Campaign.Content_Preview__c,
                                Campaign.Execution_Type__c,  Campaign.Name, Contact.DUP_Number__c, Campaign.Template_Name__c, Campaign.DM_Material__c, Campaign.Flow_URL__c, Vehicle_Case_ID__c,
                                Campaign.Template__r.Subject__c, Campaign.Template__r.Template_ID__c,
                                Campaign.Parent.Task_De_dup_Range__c,
                                Campaign.Parent.ParentId,
                                Campaign.Previous_Campaign_Execution__c,
                                Campaign.Template__c
                      from CampaignMember where CampaignId in :cpIdList and Task_Generated__c = false];
        // Campaign Members ID List
        for(CampaignMember campMem:campMembers){
            cpmIdList.add(campMem.Id);
            if(campMem.Vehicle_Case_ID__c != null && campMem.Vehicle_Case_ID__c != ''){
                for(String vcId:campMem.Vehicle_Case_ID__c.split(';')){
                    vechCaseIdList.add((ID)vcId);
                }
            }
        }
        
        // Batch Job ID
        jobId = nexJobId;
    }
    
    /* Start Method */
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Case
        return Database.getQueryLocator([Select Id, AccountId, Account.PersonMobilePhone, Account.PersonEmail From Case Where Id in :vechCaseIdList]);
    } 
    
    /* Execute Method */
    global void execute(Database.BatchableContext BC, List<Case> scope) {
        // Map:Campaign Member and Case
        Map<CampaignMember, List<Case>> cmp_caseMap = new Map<CampaignMember, List<Case>>();
        taskRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
        for(CampaignMember cm : campMembers){
            List<Case> vrList = new List<Case>();
            for(Case vr : scope){
                if(cm.Vehicle_Case_ID__c != null && cm.Vehicle_Case_ID__c.contains(String.valueOf(vr.Id).subString(0, 15))){
                    vrList.add(vr);
                }   
            }

            cmp_caseMap.put(cm,vrList);
        }
        
        // Task list
        List<Task> taskList = new List<Task>();
        Savepoint sp = Database.setSavepoint();
        try {
            // Generate Tasks
            for(CampaignMember cpm : campMembers) {
                taskList.addAll(generateTask(cpm, cmp_caseMap.get(cpm), taskRecordTypeMap));
                cpm.Task_Generated__c = true;
            }
                        
            update campMembers;
            if(dmRequestList.size() > 0) insert dmRequestList;
            Database.SaveResult[] srs = Database.insert(taskList, false);
            mis.processMisunderstoodTasks(srs, taskList);
        } 
        catch(exception ex) {
            Database.rollback(sp);
            System.debug('create task failed : ' + ex.getMessage());   
            throw ex;          
        }
    }
    
    /* Method : generateTask */
    private List<Task> generateTask(CampaignMember cpm, List<Case> vrList, Map<String, Schema.RecordTypeInfo> taskRecordTypeMap) {
        
        List<Task> taskList = new List<Task>();
        for(Case vr : vrList){
            // Combine Task.UniqueCampaignGenerateTask__c
            String uniqueTaskField = '';
            if (cpm.Campaign.Parent.Task_De_dup_Range__c == 'By Campaign Execution'
                    && cpm.Campaign.Previous_Campaign_Execution__c == null) {
                uniqueTaskField = 
                    String.valueOf(cpm.Campaign.ParentId) + 
                    String.valueOf(cpm.ContactId) + 
                    String.valueOf(vr.Id) + 
                    cpm.Campaign.Execution_Type__c;
            }
            else if (cpm.Campaign.Parent.Task_De_dup_Range__c == 'By CAC Campaign') {
                uniqueTaskField = 
                    String.valueOf(cpm.Campaign.Parent.ParentId) + 
                    String.valueOf(cpm.ContactId) + 
                    String.valueOf(vr.Id) + 
                    cpm.Campaign.Execution_Type__c;
            }

            if(cpm.Campaign.Execution_Type__c == strOBCall) {        
               // for(user u : obuserList) {
                    taskList.add(new Task(
                        Subject= strOBCall, 
                        RecordTypeId = taskRecordTypeMap.get('OB Task').getRecordTypeId(),
                        //OwnerId = u.Id,
                        Status = strOpenStatus,
                        DUP_Number__c = (cpm.ContactId == null ? ' ' : cpm.Contact.DUP_Number__c), 
                        WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                        WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                        Campaign_Name__c = cpm.Campaign.Name, 
                        Activity_Status__c = 'not started',
                        Campaign_Member_ID__c = String.valueOf(cpm.Id),
                                                          
                        ActivityDate = date.today(),
                        Vehicle_Case_ID__c = String.valueOf(vr.Id),
                        UniqueCampaignGenerateTask__c = uniqueTaskField)
                    );
                //} Flow_URL__c = cpm.Campaign.Flow_URL__c, removed as part of SFDCJP-1765
            } else if (cpm.Campaign.Execution_Type__c == strSMS && vr.Account.PersonMobilePhone != null && vr.Account.PersonMobilePhone != '') {
                taskList.add(new Task(
                    Subject= strSMS, 
                    RecordTypeId = taskRecordTypeMap.get('SMS').getRecordTypeId(),
                    OwnerId = intUser.Id,
                    Activity_Status__c = strVeriStatus,
                    Phone__c = vr.Account.PersonMobilePhone,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    ActivityDate = date.today(),
                    UniqueCampaignMobile__c = cpm.Campaign.Id + '-' + vr.Account.PersonMobilePhone,                                      
                    SMSTemplateID__c = cpm.Campaign.Template__c,
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
            } 
            else if (cpm.Campaign.Execution_Type__c == 'MMS' && vr.Account.PersonMobilePhone != null && vr.Account.PersonMobilePhone != '') {
                taskList.add(new Task(
                    Subject= 'MMS', 
                    RecordTypeId = taskRecordTypeMap.get('MMS').getRecordTypeId(),
                    OwnerId = intUser.Id,
                    Activity_Status__c = strVeriStatus,
                    Phone__c = vr.Account.PersonMobilePhone,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    ActivityDate = date.today(),
                    UniqueCampaignMobile__c = cpm.Campaign.Id + '-' + vr.Account.PersonMobilePhone,                                      
                    SMS_Content__c = cpm.Campaign.Content_Preview__c,
                    SMSTemplateID__c = cpm.Campaign.Template__c,
                    eDM_Template__c = cpm.Campaign.Template__r.Template_ID__c,
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
            }
            else if (cpm.Campaign.Execution_Type__c == streDM) {
                taskList.add(new Task(
                    Subject= streDM, 
                    RecordTypeId = taskRecordTypeMap.get('eDM').getRecordTypeId(),
                    OwnerId = intUser.Id,
                    Status = strCloseStatus,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    Campaign_eDM_Template_Subject__c = cpm.Campaign.Template__r.Subject__c, 
                    Campaign_eDM_Template_ID__c = cpm.Campaign.Template__r.Template_ID__c,
                    Email_Address__c = vr.Account.PersonEmail,
                    Activity_Status__c = strSentActivityStatus,
                    ActivityDate = date.today(),
                    UniqueCampaignEmail__c = cpm.Campaign.Id + '-' + vr.Account.PersonEmail,                                     
                    eDM_Template__c = cpm.Campaign.Template_Name__c,
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
            } else if (cpm.Campaign.Execution_Type__c == strDM) {
                taskList.add(new Task(
                    Subject= strDM, 
                    RecordTypeId = taskRecordTypeMap.get('DM').getRecordTypeId(),
                    //OwnerId = fulfillmentSpUser.Id,
                    Status = strOpenStatus,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    ActivityDate = date.today(),
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
                
                if(cpm.Contact.AccountId <> null && cpm.ContactId <> null)
                    dmRequestList.add(new DM_Request__c(
                        Campaign__c = cpm.CampaignId, 
                        Customer_Name__c = cpm.Contact.AccountId,
                        Expected_DM_Material1__c = cpm.Campaign.DM_Material__c)
                    );
            } 
        }
        return taskList;
    }
    
    /* Finish Method */
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus  
                           FROM   AsyncApexJob 
                           WHERE  Id = :BC.getJobId()];
        
        // Batch Job Compeleted.
        if(jobId != null){
            String updateMsg = '';
            try{
                if(cpUpdateList.size() > 0) update cpUpdateList;
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
}