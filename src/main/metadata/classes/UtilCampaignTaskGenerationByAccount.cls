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

global Class UtilCampaignTaskGenerationByAccount implements Database.Batchable<sObject>{
    global List<ID> cpIdList = new List<ID>();    
    private static String mms ='MMS';
    private MisunderstoodTaskGeneration mis;
    public List<Campaign> cpUpdateList = new List<Campaign>(); 
    public List<User> genericUserQueryList = new List<User>(); 
    public List<GroupMember> obuserList = new List<GroupMember>();
    
    public Group CCCQueue;
    public User intUser;
    public User fulfillmentSpUser;
    public User usr ;
    public List<User> usr_th;
    public User loggedinUser;
    public string alias=System.Label.Task_Assigned_User;
    
    private ID taskRecordTypeId;
    private String strSMS = 'SMS';
    private String strOBCall = 'OB Call';
    private String streDM = 'eDM';
    private String strDM = 'DM';
    private String strKkTlk = 'KakaoTalk';
    
    private String strOpenStatus = 'Open';
    private String strCloseStatus = 'Closed';
    private String strVeriStatus = 'Need Verification';
    private String strSentActivityStatus = 'Sent';
   
    private String CallCenterSupervisor ='Call Center Supervisor';
    public List<DM_Request__c> dmRequestList = new List<DM_Request__c>();
   
    global Id jobId;
    
    global Map<String, Schema.RecordTypeInfo> taskRecordTypeMap;
    
    global UtilCampaignTaskGenerationByAccount(List<Campaign> cpList) 
    {   
        if(userinfo.getUserType() != 'PowerPartner')
        {
            usr = [select id, Name,userRole.Name from user  where userRole.Name =: CallCenterSupervisor limit 1];
        }
        //usr_th = [select id, Name,userRole.Name from user where Username like'%siripan.chantanawilas@daimler.com%'];
        GroupMember gpMemObj=[Select userOrGroupId from groupMember where GroupId IN (Select Id from Group where DeveloperName='Thailand_Supervisor')];
        usr_th=[select Id,Name,userRole.Name from user where Id=:gpMemObj.userOrGroupId];
        loggedinUser=[select id,Market__c from user where Id= :userinfo.getUserId()];
        //usr = [Select Id, Name,Alias from user where Alias =:alias limit 1]; 
        CCCQueue = [Select Id from Group where Name = 'CCC Manager KR' and Type = 'Queue'];
        obuserList = [select UserOrGroupId from GroupMember where GroupId =:CCCQueue.Id];
        //intUser = [SELECT Id FROM User WHERE Profile.Name = 'IntegrationAPI' AND isActive = true  LIMIT 1];
        //fulfillmentSpUser = [SELECT Id FROM User WHERE UserRole.Name like '%Fulfillment Specialist%' AND isActive = true LIMIT 1];

        for(Campaign cp : cpList) {
            cpIdList.add(cp.Id);
            cpUpdateList.add(new Campaign(id = cp.Id, Create_Task__c = false));
        }

        // Initiate Mis
        mis = new MisunderstoodTaskGeneration(cpList, false);
system.debug('&******************'+cpList);
        
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    system.debug('hello naren');
      return Database.getQueryLocator(
            [select id, ContactId, Contact.AccountId, Contact.Name, Contact.MobilePhone, Contact.Email, LeadId, Task_Generated__c, CampaignId, Campaign.Content_Preview__c,
                    Campaign.Execution_Type__c, Campaign.Name, Contact.DUP_Number__c, Campaign.Template_Name__c, Campaign.DM_Material__c, Campaign.Flow_URL__c,
                    Campaign.Template__r.Subject__c, Campaign.Template__r.Template_ID__c,
                    Campaign.Parent.Task_De_dup_Range__c,
                    Campaign.Parent.ParentId, Campaign.EndDate,Campaign.StartDate,
                    Campaign.Previous_Campaign_Execution__c,
                    Campaign.Template__c, Status, Campaign.OwnerId, Campaign.MD__c,Campaign.Campaign_Code__c, Campaign.OBSMSTemplate__c, 
                    Campaign.OBSMSTemplate__r.Message_Detail__c, Campaign.OBSMSTemplate__r.Template_ID__c, Campaign.Questionnaire__c
            from CampaignMember
            where CampaignId in :cpIdList and Task_Generated__c = false]); //FOR UPDATE]);
    } 
    
    global void execute(Database.BatchableContext BC, List<CampaignMember> scope) {
    system.debug('&*********scope'+scope);
        List<Task> taskList = new List<Task>();
        taskRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Savepoint sp = Database.setSavepoint();
        try {            
            for(CampaignMember cpm : scope) {
                taskList.addAll(generateTask(cpm,taskRecordTypeMap));
                cpm.Task_Generated__c = true;
            }
            
            /*Map<String, Task> upSMSTaskList = new Map<String, Task>();
            Map<String, Task> upMMSTaskList = new Map<String, Task>();
            Map<String, Task> upEDMTaskList = new Map<String, Task>();
            Map<String, Task> upDMTaskList = new Map<String, Task>();
            Map<String, Task> upKkTlkTaskList = new Map<String, Task>();
            List<Task> upOtherTaskList = new List<Task>();
            for(task tk : taskList){
                if(tk.Subject == strSMS){
                    upSMSTaskList.put(tk.UniqueCampaignMobile__c, tk);
                }
                else if(tk.Subject == mms){
                    upMMSTaskList.put(tk.UniqueCampaignMobile__c, tk);
                }
                else if(tk.Subject == streDM){
                    upEDMTaskList.put(tk.UniqueCampaignEmail__c, tk);
                }
                else if(tk.Subject == strDM){
                    upDMTaskList.put(tk.UniqueCampaignEmail__c, tk);
                }else if(tk.Subject == strKkTlk){
                    upKkTlkTaskList.put(tk.UniqueCampaignEmail__c, tk);
                } else{
                    upOtherTaskList.add(tk);
                }
            }
            taskList = upOtherTaskList;
            taskList.addAll(upSMSTaskList.Values());
            taskList.addAll(upMMSTaskList.Values());
            taskList.addAll(upEDMTaskList.Values());
            taskList.addAll(upDMTaskList.Values());
            taskList.addAll(upKkTlkTaskList.Values());*/
             system.debug( '   Size is *$*$*   ' + taskList.size());
            
            update scope;
            if(dmRequestList.size() > 0) insert dmRequestList;     
            
            // No need to consider duplicate Campaign Task of the same CAC Campaign
            // So if it is caused this reason, we need to append the campaign execution to 
            // task UniqueCampaignGenerateTask__c
            Database.SaveResult[] srs = Database.insert(taskList, false);
            system.debug('srs>>>' + srs);
            mis.processMisunderstoodTasks(srs, taskList);
        } 
        catch(exception ex) {
            Database.rollback(sp);
            System.debug('create task failed : ' + ex.getTypeName());
            throw ex;
        }
    }
    
    
    private List<Task> generateTask(CampaignMember cpm, Map<String, Schema.RecordTypeInfo> taskRecordTypeMap) {
        List<Task> taskList = new List<Task>();        
        String uniqueTaskField = '';
        if (cpm.Campaign.Parent.Task_De_dup_Range__c == 'By Campaign Execution'
                && cpm.Campaign.Previous_Campaign_Execution__c == null) {
            uniqueTaskField = 
                String.valueOf(cpm.Campaign.ParentId) + 
                String.valueOf(cpm.ContactId) + 
                cpm.Campaign.Execution_Type__c;
        }
        else if (cpm.Campaign.Parent.Task_De_dup_Range__c == 'By CAC Campaign') {
            uniqueTaskField = 
                String.valueOf(cpm.Campaign.Parent.ParentId) + 
                String.valueOf(cpm.ContactId) + 
                cpm.Campaign.Execution_Type__c;
        }

        if(cpm.Campaign.Execution_Type__c == strOBCall) 
        {        
            system.debug('*$*$*$* OB Task Task Loop');
            //for(GroupMember u : obuserList) {
                Task tsk = new Task();
                //SB2017 Sushma Bharti
                //'IF' condition added for MY for blank subject for auto created tasks
                if(cpm.Campaign.MD__c!=Label.MarketMY){
                tsk.Subject= strOBCall;
                } 
                else{
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
                } 
                tsk.RecordTypeId = taskRecordTypeMap.get('OB Task').getRecordTypeId();
                if(cpm.Campaign.MD__c=='TH'){
                tsk.RecordTypeId = taskRecordTypeMap.get('OB Call').getRecordTypeId();
                }
				//SB2018
				else if(cpm.Campaign.MD__c==Label.MarketMY){
				    tsk.RecordTypeId = taskRecordTypeMap.get('OB Call').getRecordTypeId();
				    if(cpm.Campaign.Enddate!=null){
						tsk.ActivityDate = cpm.Campaign.Enddate;       
					}          
					else if(cpm.Campaign.StartDate!=null){                                                                          
						tsk.ActivityDate = cpm.Campaign.StartDate;       
					}
					else{
							tsk.ActivityDate = date.today();
					}                                                                              
				}  
                tsk.Status = strOpenStatus;
                tsk.DUP_Number__c = (cpm.ContactId == null ? ' ' : cpm.Contact.DUP_Number__c); 
                tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
                tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
                tsk.Campaign_Member_ID__c = String.valueOf(cpm.Id); 
                tsk.Campaign_Name__c = cpm.Campaign.Name; 
                tsk.Activity_Status__c = 'not started';
                if(loggedinUser.Market__c == 'KR')
                {
                    tsk.ActivityDate = cpm.Campaign.EndDate;
                }
				//SB2018
			    else if(loggedinUser.Market__c==Label.MarketMY){
				    if(cpm.Campaign.Enddate!=null){
						tsk.ActivityDate = cpm.Campaign.Enddate;       
					}          
					else if(cpm.Campaign.StartDate!=null){                                                                          
						tsk.ActivityDate = cpm.Campaign.StartDate;       
					}
					else{
							tsk.ActivityDate = date.today();
					}                                                                              
				} 
                else
                {
                    tsk.ActivityDate = date.today();
                }
                tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
                if(userinfo.getUserType()=='PowerPartner')
                {
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                }
                else
                {
                    if(loggedinUser.Market__c=='TH'){
                   
                       tsk.OwnerId =usr_th[0].Id;
                    }
                    else{
                    if(loggedinUser.Market__c==Label.MarketMY || loggedinUser.Market__c=='KR'){
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                    }
                    else{
                    tsk.OwnerId = usr.Id;}
                    }
                }
                taskList.add(tsk);
                system.debug(tsk.OwnerId + '   *$*$*$*$* Task Creation   ' + tsk);
            
            //} Flow_URL__c = cpm.Campaign.Flow_URL__c, removed as part of SFDCJP-1765
        } 
        else if(loggedinUser.Market__c=='KR' && cpm.Campaign.Execution_Type__c == 'Survey') 
        {        
            system.debug('*$*$*$* Survey Task Task Loop');
            Task tsk = new Task();
            tsk.Subject= 'Survey';
            tsk.RecordTypeId = taskRecordTypeMap.get('Survey').getRecordTypeId();
            tsk.Status = strOpenStatus;
            tsk.DUP_Number__c = (cpm.ContactId == null ? ' ' : cpm.Contact.DUP_Number__c); 
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            tsk.Campaign_Member_ID__c = String.valueOf(cpm.Id); 
            tsk.Campaign_Name__c = cpm.Campaign.Name; 
            tsk.Activity_Status__c = 'not started';
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            tsk.OwnerId = cpm.Campaign.OwnerId;
            tsk.Survey__c = cpm.Campaign.Questionnaire__c;
            taskList.add(tsk);
            system.debug(tsk.OwnerId + '   *$*$*$*$* Survey Task Creation   ' + tsk);
        } 
        else if (cpm.Campaign.Execution_Type__c == strSMS && cpm.Contact.MobilePhone != null && cpm.Contact.MobilePhone != '') 
        {
            system.debug('*$*$*$* SMS Task Loop');
            Task tsk = new Task();
            //SB2017 Sushma Bharti
            //'IF' condition added for MY for blank subject for auto created tasks
            if(cpm.Campaign.MD__c!='MY'){
            tsk.Subject= strSMS;
            } 
                else{
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
                } 
            tsk.RecordTypeId = taskRecordTypeMap.get('SMS').getRecordTypeId();
            if(userinfo.getUserType()=='PowerPartner')
            {
                tsk.OwnerId = cpm.Campaign.OwnerId;
            }
            else
            {
                if(loggedinUser.Market__c=='KR')
                {
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                }
                tsk.OwnerId = usr.Id;
            }
            tsk.Activity_Status__c = strVeriStatus;
            tsk.Phone__c = cpm.Contact.MobilePhone;
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.UniqueCampaignMobile__c = cpm.CampaignId + '-' + cpm.Contact.MobilePhone;
            if(cpm.Campaign.MD__c == 'KR')
            {
                tsk.SMS_Content__c = cpm.Campaign.OBSMSTemplate__r.Message_Detail__c;
                tsk.SMSTemplateID__c = cpm.Campaign.OBSMSTemplate__c;
            }
            else
            {
                tsk.SMS_Content__c = cpm.Campaign.Content_Preview__c;
                tsk.SMSTemplateID__c = cpm.Campaign.Template__c;
            }
            
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            taskList.add(tsk);
        } 
        else if (cpm.Campaign.Execution_Type__c == mms && cpm.Contact.MobilePhone != null && cpm.Contact.MobilePhone != '') 
        {
            system.debug('*$*$*$* MMS Task Loop');
           Task tsk = new Task();
            //SB2017 Sushma Bharti
            //'IF' condition added for MY for blank subject for auto created tasks
            if(cpm.Campaign.MD__c!='MY'){
            tsk.Subject= mms;
            } 
                else{
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
                }  
            tsk.RecordTypeId = taskRecordTypeMap.get(mms).getRecordTypeId();
            if(userinfo.getUserType()=='PowerPartner')
            {
                tsk.OwnerId = cpm.Campaign.OwnerId;
            }
            else
            {
                if(loggedinUser.Market__c=='KR')
                {
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                }
                tsk.OwnerId = usr.Id;
            }
            tsk.Activity_Status__c = strVeriStatus;
            tsk.Phone__c = cpm.Contact.MobilePhone;
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.UniqueCampaignMobile__c = cpm.CampaignId + '-' + cpm.Contact.MobilePhone;
            if(cpm.Campaign.MD__c == 'KR')
            {
                tsk.SMSTemplateID__c = cpm.Campaign.OBSMSTemplate__c;
                tsk.eDM_Template__c = cpm.Campaign.OBSMSTemplate__r.Template_ID__c;
            }
            else
            {
                tsk.SMSTemplateID__c = cpm.Campaign.Template__c;
                tsk.eDM_Template__c = cpm.Campaign.Template__r.Template_ID__c;
            }
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            taskList.add(tsk);
        }
        else if (cpm.Campaign.Execution_Type__c == strKkTlk && cpm.Contact.MobilePhone != null && cpm.Contact.MobilePhone != '') 
        {
            system.debug('*$*$*$* KaKaoTalk Task Loop');
            Task tsk = new Task();
            //SB2017 Sushma Bharti
            //'IF' condition added for MY for blank subject for auto created tasks
            if(cpm.Campaign.MD__c!='MY')
            {
            tsk.Subject= strKkTlk;
            } 
            else
            {
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
            } 
            tsk.RecordTypeId = taskRecordTypeMap.get('KakaoTalk').getRecordTypeId();
            tsk.OwnerId = cpm.Campaign.OwnerId;
            tsk.Activity_Status__c = strVeriStatus;
            tsk.Phone__c = cpm.Contact.MobilePhone;
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.UniqueCampaignMobile__c = cpm.CampaignId + '-' + cpm.Contact.MobilePhone;
            if(cpm.Campaign.MD__c == 'KR')
            {
                tsk.SMS_Content__c = cpm.Campaign.OBSMSTemplate__r.Message_Detail__c;
                tsk.SMSTemplateID__c = cpm.Campaign.OBSMSTemplate__c;
            }
            else
            {
                tsk.SMS_Content__c = cpm.Campaign.Content_Preview__c;
                tsk.SMSTemplateID__c = cpm.Campaign.Template__c;
            }
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            taskList.add(tsk);
        } 
        else if (cpm.Campaign.Execution_Type__c == streDM) 
        {
            system.debug('*$*$*$* DM Task Loop');
            Task tsk = new Task();
            //SB2017 Sushma Bharti
            //'IF' condition added for MY for blank subject for auto created tasks
            if(cpm.Campaign.MD__c!='MY'){
            tsk.Subject= streDM; 
            } 
                else{
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
                } 
            tsk.RecordTypeId = taskRecordTypeMap.get('eDM').getRecordTypeId();
            if(userinfo.getUserType()=='PowerPartner')
            {
                tsk.OwnerId = cpm.Campaign.OwnerId;
            }
            else
            {
                if(loggedinUser.Market__c=='KR')
                {
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                }
                tsk.OwnerId = usr.Id;
            }
            tsk.Status = strCloseStatus;
            tsk.Campaign_eDM_Template_Subject__c = cpm.Campaign.Template__r.Subject__c;
            tsk.Campaign_eDM_Template_ID__c = cpm.Campaign.Template__r.Template_ID__c;                                 
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            tsk.Campaign_Member_ID__c = String.valueOf(cpm.Id); 
            tsk.Campaign_Name__c = cpm.Campaign.Name;
            tsk.UniqueCampaignEmail__c = cpm.CampaignId + '-' + cpm.Contact.Email;
            tsk.Email_Address__c = cpm.Contact.Email;
            tsk.Activity_Status__c = strSentActivityStatus;
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.eDM_Template__c = cpm.Campaign.Template_Name__c;
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            taskList.add(tsk);
        } 
        else if (cpm.Campaign.Execution_Type__c == strDM) 
        {
            system.debug('*$*$*$* Another DM Task Loop');
           Task tsk = new Task();
            //SB2017 Sushma Bharti
            //'IF' condition added for MY for blank subject for auto created tasks
            if(cpm.Campaign.MD__c!='MY'){
            tsk.Subject = strDM; 
            } 
                else{
                tsk.Subject= cpm.Campaign.Execution_Type__c+' '+cpm.Campaign.Campaign_Code__c+' '+cpm.Contact.Name;
                } 
            tsk.RecordTypeId = taskRecordTypeMap.get('DM').getRecordTypeId();
            if(userinfo.getUserType()=='PowerPartner')
            {
                tsk.OwnerId = cpm.Campaign.OwnerId;
            }
            else
            {
                if(loggedinUser.Market__c=='KR')
                {
                    tsk.OwnerId = cpm.Campaign.OwnerId;
                }
                tsk.OwnerId = usr.Id;
            }
            tsk.Status = strOpenStatus;
            tsk.WhoId = (cpm.ContactId == null ? cpm.LeadId : cpm.ContactId);
            tsk.WhatId = (cpm.ContactId == null ? null : cpm.CampaignId);
            tsk.Campaign_Member_ID__c = String.valueOf(cpm.Id); 
            tsk.Campaign_Name__c = cpm.Campaign.Name;
            if(loggedinUser.Market__c == 'KR')
            {
                tsk.ActivityDate = cpm.Campaign.EndDate;
            }
            else
            {
                tsk.ActivityDate = date.today();
            }
            tsk.UniqueCampaignGenerateTask__c = uniqueTaskField;
            
            if(cpm.Contact.AccountId <> null && cpm.ContactId <> null)
                     dmRequestList.add(new DM_Request__c(
                     Campaign__c = cpm.CampaignId, 
                     Customer_Name__c = cpm.Contact.AccountId,
                     Expected_DM_Material1__c = cpm.Campaign.DM_Material__c,
                     Status1__c = cpm.Status
                    )
                );
        } 
        system.debug('dhanam123'+taskList);
        return taskList;
    }
    
    
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