/*
    Type:       Apex Class
    Purpose:    Generat task by vehicle
    User Story: 
    Used By:    TriggerCampaign.trigger
    ---------------------------------------------------------------
    History:
  
    4-June-2013 Stephano Shi (Breakingpoint)    Created
    24-June-2013 Stephano Shi (Breakingpoint)    Modified
    2014-04-03 updated by Justin Yu
    2014-04-18 updated by Shuang Li
*/
global class UtilCampaignTaskGenerationByVehicle implements Database.Batchable<sObject>{
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
    global UtilCampaignTaskGenerationByVehicle(List<Campaign> cpList, Id nexJobId) {
        //obuserList = [select id, name from User where UserRole.Name = 'OB Supervisor' and IsActive = true LIMIT 1];
        intUser = [SELECT Id FROM User WHERE Profile.Name = 'IntegrationAPI' AND isActive = true  LIMIT 1];
        //fulfillmentSpUser = [SELECT Id FROM User WHERE UserRole.Name like '%Fulfillment Specialist%' AND isActive = true LIMIT 1];
        for(Campaign cp : cpList) {
            cpIdList.add(cp.Id);
            cpUpdateList.add(new Campaign(id = cp.Id, Create_Task__c = false));
        }
        
        // Initiate Mis
        mis = new MisunderstoodTaskGeneration(cpList, false);

        // Campaign Members 
        campMembers = [select id, ContactId, Contact.AccountId, LeadId, Task_Generated__c, CampaignId, Campaign.Content_Preview__c,
                                Campaign.Execution_Type__c,  Campaign.Name, Contact.DUP_Number__c, Campaign.Template_Name__c, Campaign.DM_Material__c, Campaign.Flow_URL__c, Vehicle_Case_ID__c,
                                Campaign.Template__r.Subject__c, Campaign.Template__r.Template_ID__c, Campaign.Template__r.Type__c,
                                Campaign.Parent.Task_De_dup_Range__c,
                                Campaign.Parent.ParentId,
                                Campaign.Previous_Campaign_Execution__c,
                                Campaign.Template__c
                                from CampaignMember where CampaignId in :cpIdList and Task_Generated__c = false];
        
        System.debug('campMembers >>>' + campMembers);
        
        // Campaign Members ID List
        for(CampaignMember campMem:campMembers){
            cpmIdList.add(campMem.Id);
            System.debug('Vehicle_Case_ID__c >>>' + campMem.Vehicle_Case_ID__c);
            if(campMem.Vehicle_Case_ID__c != null && campMem.Vehicle_Case_ID__c != ''){
                for(String vcId:campMem.Vehicle_Case_ID__c.split(';')){
                    vechCaseIdList.add((ID)vcId);
                }
            }
        }
        
        System.debug('vechCaseIdList >>>' + vechCaseIdList);
        
        // Batch Job ID
        jobId = nexJobId;
    }
    
    /* Start Method */
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Vehicle Relationship
        return Database.getQueryLocator([Select Id, Contact__c, Contact__r.PersonMobilePhone, Contact__r.PersonEmail, Vehicle_ID__c From Vehicle_Relationship__c Where Id in :vechCaseIdList]);
    } 
    
    /* Execute Method */
    global void execute(Database.BatchableContext BC, List<Vehicle_Relationship__c> scope) {
        // Map:Campaign Member and Vehicle Relationship
        Map<CampaignMember, List<Vehicle_Relationship__c>> cmp_vehMap = new Map<CampaignMember, List<Vehicle_Relationship__c>>();
        taskRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
        for(CampaignMember cm : campMembers){
            System.debug('cm.Vehicle_Case_ID__c>>>' + cm.Vehicle_Case_ID__c);
            System.debug('scope >>>' + scope);
            List<Vehicle_Relationship__c> vrList = new List<Vehicle_Relationship__c>();
            for(Vehicle_Relationship__c vr : scope){
                if(cm.Vehicle_Case_ID__c != null && cm.Vehicle_Case_ID__c.contains(String.valueOf(vr.Id).subString(0, 15))){
                    vrList.add(vr);
                }   
            }
            
            System.debug('Vr List>>>' + vrList);
            
            cmp_vehMap.put(cm,vrList);
        }
        
        // Task list
        List<Task> taskList = new List<Task>();
        Savepoint sp = Database.setSavepoint();
        try {
            System.debug('Scope>>>' + scope);
            System.debug('campMembers>>>' + campMembers);
            // Generate Tasks
            for(CampaignMember cpm : campMembers) {
                taskList.addAll(generateTask(cpm, cmp_vehMap.get(cpm), taskRecordTypeMap));
                cpm.Task_Generated__c = true;
            }
            Database.insert(taskList, false) ;
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
    private List<Task> generateTask(CampaignMember cpm, List<Vehicle_Relationship__c> vrList, Map<String, Schema.RecordTypeInfo> taskRecordTypeMap) {
        
        List<Task> taskList = new List<Task>();
        
        System.debug('Vehicle_Relationship__c>>>'+vrList);
        for(Vehicle_Relationship__c vr : vrList){
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
                //for(user u : obuserList) {
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
                //}   Flow_URL__c = cpm.Campaign.Flow_URL__c,        
            } else if (cpm.Campaign.Execution_Type__c == strSMS && vr.Contact__r.PersonMobilePhone != null && vr.Contact__r.PersonMobilePhone != '') {
                taskList.add(new Task(
                    Subject= strSMS, 
                    RecordTypeId = taskRecordTypeMap.get('SMS').getRecordTypeId(),
                    OwnerId = intUser.Id,
                    Activity_Status__c = strVeriStatus,
                    Phone__c = vr.Contact__r.PersonMobilePhone,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    ActivityDate = date.today(),
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignMobile__c = cpm.Campaign.Id + '-' + vr.Contact__r.PersonMobilePhone,                                      
                    SMS_Content__c = cpm.Campaign.Content_Preview__c,
                    SMSTemplateID__c = cpm.Campaign.Template__c,
                    UniqueCampaignGenerateTask__c = uniqueTaskField)
                );
            }
            else if (cpm.Campaign.Execution_Type__c == 'MMS' && vr.Contact__r.PersonMobilePhone != null && vr.Contact__r.PersonMobilePhone != '') {
                taskList.add(new Task(
                    Subject= 'MMS', 
                    RecordTypeId = taskRecordTypeMap.get('MMS').getRecordTypeId(),
                    OwnerId = intUser.Id,
                    Activity_Status__c = strVeriStatus,
                    Phone__c = vr.Contact__r.PersonMobilePhone,
                    WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId),
                    WhatId = (cpm.ContactId == null ? null : cpm.CampaignId),
                    ActivityDate = date.today(),
                    Vehicle_Case_ID__c = String.valueOf(vr.Id),
                    UniqueCampaignMobile__c = cpm.Campaign.Id + '-' + vr.Contact__r.PersonMobilePhone,                                      
                    SMSTemplateID__c = cpm.Campaign.Template__c,
                    eDM_Template__c = cpm.Campaign.Template__r.Template_ID__c,
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
                    Email_Address__c = vr.Contact__r.PersonEmail,
                    Activity_Status__c = strSentActivityStatus,
                    ActivityDate = date.today(),
                    UniqueCampaignEmail__c = cpm.Campaign.Id + '-' + vr.Contact__r.PersonEmail,                                     
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
        System.debug('taskList>>>'+taskList);
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
                System.debug('cpUpdateList'+cpUpdateList);
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