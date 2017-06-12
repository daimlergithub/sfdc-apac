/*
    Type:       Utility for TaskBeforeInsertUpdate, TaskAfterUpdate
    Purpose:    1. Auto create multiple QC records when task.QC Quantity is updated with a number.
                2. Auto create QC records when task.Generate QC is changed to true.
                3. Auto update task's campaign name when this task related to an campaign
                4. Auto create a SMS task record when a task insert.
    User Story: US-QC-015, US-QC-002, US-QC-001, US-SMSS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-28
    2. 17-July-2013 Sinow Zhang (NTTData) When a task ucid is not null, update interactionIds from Avato. US-CTI-001
    ---------------------------------------------------------------
    modified date : 24-feb-2017
    modified method : UpdateLinkedLeads
    issue : SFDCJP-1725
    name : Lokesh m
    desc : updating Task_Update_Flag__c field in lead__c object related to this task.
*/
public class TaskHelper {
    // Get Task record type ids
    private static String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
    private static String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    private static String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    private static String SMS_TASK_RECORDTYPEID = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static String SalesLeadRectypeID= Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    private static String AfterSalesLeadRectypeID= Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    
    // Get QC__c record type ids
    private static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
    private static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    
    //
    private static String OBTaskRecordTypeId1 = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    private static String WelcomeCallRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
    private static String MMSTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
    private static String GeneralTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
    private static String mbdaTaskRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('MBDA Survey').getRecordTypeId();
  public static string closedString='closed'; 
  public static string validString='valid';
   private static string leadTabId = System.Label.LeadId;
    
    private static Map<String, String> srRecordTypeSubjects = new Map<String, String>{'1st Survey Result'=>'1st Survey Call', '2nd Survey Result'=>'2nd Survey Call', 'Welcome Call + 1st Survey Result'=>'Welcome Call + 1st Survey Call', 'Welcome Call Result'=>'Welcome Call'};
  /**
  *@Description : Updates Accounts if they are blacklisted based on Activity status of Tasks.
  *@Date : 4/11/2015
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */     
   public static void TaskFailBlacklist(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
     
     
        set<Id> setTaskIds = new set<Id>();
        for(Task tk : tasks)
        {
            if(isInsert && tk.Activity_Status__c == 'Fail-Blacklist')
            {
                setTaskIds.add(tk.Id);
            }
            if(isUpdate && tk.Activity_Status__c == 'Fail-Blacklist' && taskOldMap.get(tk.Id).Activity_Status__c != 'Fail-Blacklist')
            {
                setTaskIds.add(tk.Id);
            }
        }
        if(setTaskIds!=null && !setTaskIds.Isempty())
        {
            List<Task> lstTask = [SELECT Id, WhoId FROM Task WHERE Id in :setTaskIds];
            Set<Id> conIds = new Set<Id>();
            if(lstTask!=null && !lstTask.Isempty())
            {
                for(Task tks : lstTask)
                {
                    if (tks.WhoId != null)
                    {
                        conIds.add(tks.WhoId);
                    }                
                }
                if (conIds.size() > 0)
                {
                    List<Account> accs = [SELECT Id, Is_Blacklist__c FROM Account WHERE PersonContactId=:conIds And Is_Blacklist__c != true];
                    if(accs!=null && !accs.IsEmpty())
                    {
                        for(Account acc : accs)
                        {
                            acc.Is_Blacklist__c = true;
                        }
                        if (accs!=null && !accs.IsEmpty())
                        {
                            update accs;
                        } 
                    }
                }
            }
        }      
   }
   
   /**
  *@Description : Fetches related Campaign members based on whoId and whatId and updates the campaignMember status
  based on task.Activity status and priority.
  *@Date : 4/11/2015
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
     
       
     
        if(isInsert)
            UtilTask.updateCampaignMemberStatus(tasks);
        if(isUpdate)
        {
             List<Task> lstTaskUpdate = new List<Task>();
             for (Task newTask : tasks)
             {
                if (newTask.Activity_Status__c != taskOldMap.get(newTask.Id).Activity_Status__c)
                {
                    lstTaskUpdate.add(newTask);
                }
             }
             UtilTask.updateCampaignMemberStatus(lstTaskUpdate);
        }   
   }
   
   /**
  *@Description : Updates Tasks record type based on Subject.
  *@Date : 4/11/2015
  *@param:List of Tasks.new.
  *@return:This mehtod does not return any value.

  */
   public static void recordTypeUpdate_Generaltask(List<Task> tasks)
   {
       
     
       Set<String> contactIds = new Set<String>();
       Set<String> templateIds = new Set<String>();
       Set<Id> relatedOrderIds = new Set<Id>();
       List<User> assignedUsers = [select Id from User where Profile.Name = 'CAC SSI SV' and IsActive = true limit 1];
       Id assignedUserId = null;
       if(assignedUsers!=null && !assignedUsers.IsEmpty())
       {
           assignedUserId = assignedUsers[0].Id;
       }    
       for(Task t : tasks) {            
            // By Justin -- for replace the content merge fields
            if(t.RecordTypeId == SMS_TASK_RECORDTYPEID || t.RecordTypeId == MMSTaskRecordTypeId){
                contactIds.add(t.WhoId);
                templateIds.add(t.SMSTemplateID__c);
            }
            if(t.Subject == 'Your annual plan has been approved' || 
            t.Subject == 'Submit your annual plan needs to be adjusted to' || 
            t.Subject == 'Your project has been approved' || 
            t.Subject == 'After adjusting your project needs to resubmit' || 
            t.Subject == 'Withdraw your application as it has been approved by activity' || 
            t.Subject == 'Withdraw your application as it has been rejected by activity' || 
            t.Subject == 'Your feedback has been approved' || 
            t.Subject == 'Your feedback needs to be adjusted to resubmit' || 
            t.Subject == 'Your Toolbox application has been approved' || 
            t.Subject == 'Your Toolbox applications need to be adjusted to resubmit' || 
            t.Subject == 'Your Toolbox revocation request has been approved' || 
            t.Subject == 'Your Toolbox revocation request has been rejected' || 
            t.Subject == 'Your Toolbox feedback has been approved' || 
            t.Subject == 'You need to adjust Toolbox feedback to resubmit' || 
            t.Subject == 'Toolbox has been produced' ){
                t.RecordTypeId = GeneralTaskRecordTypeId;
            }
            // Add By Chaos for MBDA START
            if(t.Subject == 'MBDA Survey Task Temp'){
                t.Subject = 'MBDA Survey Task';
                t.RecordTypeId = mbdaTaskRecordTypeId;
                t.OwnerId = assignedUserId;
                relatedOrderIds.add(t.WhatId);
            }
            // Add By Chaos for MBDA END
        }
        // Add By Chaos for MBDA START
        List<Account> orderList = 
            [Select (Select Id From Orders), (Select Id From Contacts) 
                From Account 
                where Id in (select accountId from Order where Id in :relatedOrderIds)];
        Map<Id, Id> OrderIdContactIdMap = new Map<Id, Id>();
        
        for(Account ac : orderList){
            for(Order ord : ac.Orders){
                OrderIdContactIdMap.put(ord.Id, ac.Contacts[0].Id);
            }
        }
        
        for(Task t : tasks) {  
            if(OrderIdContactIdMap.ContainsKey(t.WhatId)) {
                t.WhoId = OrderIdContactIdMap.get(t.WhatId);
            }
        }
        // Add By Chaos for MBDA END
        // By Justin --
        if(contactIds!=null && !contactIds.IsEmpty())
        {
            Map<String, Contact> contacts = new Map<String, Contact>([select Name, Account.Gender__c, SMSOptOut__c from Contact where Id in :contactIds]);
            if(!contacts.isEmpty())
            {
                // Prevents the sms task from saving when the SMS Opt Out of contact is checked
                preventTaskFromCreating(tasks, contacts);
                
                // Replaces the merge fields from templates before task saved
                replaceMergeFields(tasks, contacts);
            }
        }
        
        if(templateIds!=null && !templateIds.IsEmpty())
        {
            Map<String, Template__c> templates = new Map<String, Template__c>([select Type__c from Template__c where Id in :templateIds]);
            if(!templates.isEmpty())
            {
                // Checks the SMS Response Required field of task
                checkResponseRequired(tasks, templates);
            }
        }
        
   }
   
   //TODO - Not Used
   /*public static void createIb_ob_Qc_Records(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
       List<Task> taskforGenerateQC = new List<Task>();
       List<Task> taskforGenerateSSIQC = new List<Task>();
       List<Task> newTaskWithCase = new List<Task>();   
       Set<Id> taskOwnerIds = new Set<Id>();
       Map<Id, String> userIdNames = new Map<Id, String>();
       for(Task t : tasks)
       {   
            //When Generate QC is true, insert IB/OB QC records.
            if(t.Generate_QC__c && !taskOldMap.get(t.Id).Generate_QC__c && t.QC_ID__c == null)
            {
                taskforGenerateQC.add(t);
            }
            
            //When Activity Status is Successful, insert SSI QC records.
           /*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code  
           if(t.Activity_Status__c == 'Successful' && Trigger.oldMap.get(t.Id).Activity_Status__c != 'Successful' 
            && (t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId) && t.QC_ID__c == null) *--
            
            if(t.Activity_Status__c == 'Successful' && taskOldMap.get(t.Id).Activity_Status__c != 'Successful' 
            && t.RecordTypeId == SSITaskRecordTypeId && t.QC_ID__c == null) 
            {
                taskforGenerateSSIQC.add(t);
            }
            
            // By Shuang Li BRD-AS-CAC-007
            /*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
            if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId) && t.Status == closedString && Trigger.oldMap.get(t.Id).Status != closedString)
            *--
            
            if (t.RecordTypeId == SSITaskRecordTypeId && t.Status == closedString && taskOldMap.get(t.Id).Status != closedString) 
            {
                taskOwnerIds.add(t.OwnerId);
            }
            
            // By Sinow HLD-CAC-003
            /*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
            if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId || t.RecordTypeId == OBTaskRecordTypeId1 || t.RecordTypeId == WelcomeCallRecordTypeId) && t.Status == closedString && Trigger.oldMap.get(t.Id).Status != closedString) 
            *--
            
            if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == OBTaskRecordTypeId1 || t.RecordTypeId == WelcomeCallRecordTypeId) && t.Status == closedString && taskOldMap.get(t.Id).Status != closedString) 
            {
                t.SentTime__c = DateTime.now();
            }
        }
        
        if(taskOwnerIds!=null && !taskOwnerIds.IsEmpty())
        {
            for(User currentUser : [Select Id, Name From User Where Id in :taskOwnerIds])
            {
                userIdNames.put(currentUser.Id, currentUser.Name);
            }
        }
        
        // Create QC for IB/OB
        if(taskforGenerateQC!=null && !taskforGenerateQC.IsEmpty())
        {
            GenerateQCs(taskforGenerateQC);
        }
        
        // Create QC for SSI
        if(taskforGenerateSSIQC!=null && !taskforGenerateSSIQC.IsEmpty())
        {
            GenerateSSIQCs(taskforGenerateSSIQC);
        }
   }*/
   
   /**
  *@Description : Updates Task.SMS_Content__c .
  *@Date : 4/11/2015
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void Reply_TD_unsubscribeForeachSMScontent(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
     
       
        Map<Id, String> userIdNames = new Map<Id, String>();
        Set<Id> taskOwnerIds = new Set<Id>();
        for(Task t : tasks)
        {
            if (t.RecordTypeId == SSITaskRecordTypeId && t.Status == closedString && taskOldMap.get(t.Id).Status != closedString) 
            {
                taskOwnerIds.add(t.OwnerId);
            }
        }
        if(taskOwnerIds.size() > 0)
        {
            for(User currentUser : [Select Id, Name From User Where Id in :taskOwnerIds])
            {
                userIdNames.put(currentUser.Id, currentUser.Name);
            }
        }
        for(Task task : tasks)
        {
            if(!isUpdate || taskOldMap.get(task.Id).Activity_Status__c != 'Sent')
            {
                if(task.Subject == 'SMS'&& task.Activity_Status__c == 'Sent' && !String.isBlank(task.SMS_Content__c) && task.SMS_Content__c.indexOf('Reply TD unsubscribe') == -1)
                {
                    task.SMS_Content__c = task.SMS_Content__c + ' Reply TD unsubscribe';
                }
            }
            // By Shuang Li BRD-AS-CAC-007
            /*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
            if (Trigger.isUpdate && (task.RecordTypeId == SSITaskRecordTypeId || task.RecordTypeId == SMARTSSITaskRecordTypeId) && task.Status == closedString 
                && userIdNames.containsKey(task.OwnerId) && Trigger.oldMap.get(task.Id).Status != closedString) 
            */
        
            if (Trigger.isUpdate && task.RecordTypeId == SSITaskRecordTypeId && task.Status == closedString 
                && userIdNames.containsKey(task.OwnerId) && taskOldMap.get(task.Id).Status != closedString) 
            {
                task.Executed_CSR__c = userIdNames.get(task.OwnerId);
            }
        }   
   }
   
   /**
  *@Description : Based on WhatID(Case,Campaign ,Campaign Leads) of tasks Updates the campaign Names.
  *@Date : 4/11/2015
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void FillintheCampaignNameBasedontheRelatedtoObject(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
       
     
        Set<String> caseIds = new Set<String>();
        Set<String> campaignIds = new Set<String>();
        Set<String> campaignLeadIds = new Set<String>();
        
        for(Task task : tasks)
        {
            if((isInsert || (isUpdate && task.WhatId != taskOldMap.get(task.Id).WhatId)) && task.WhatId != null)
            {
                String relatedId = task.WhatId;
                if(relatedId.startsWith('500'))
                {
                    caseIds.add(task.WhatId);
                }
                else if(relatedId.startsWith('701'))
                {
                    campaignIds.add(task.WhatId);
                }
                else if(relatedId.startsWith('a0c'))
                {
                    campaignLeadIds.add(task.WhatId);
                }
            }
        }
    
        if(caseIds.size() + campaignIds.size() + campaignLeadIds.size() > 0){
            copyCampaignNameFromRelatedToObject(caseIds, campaignIds, campaignLeadIds, tasks);
        }
        if(caseIds!=null && !caseIds.IsEmpty()){
            copyIBCallTypeFromCase(caseIds, tasks);
        }   
   }
   
   /**
  *@Description : Creates an SMS task in Update/Insert if record type is IB Call , Call Type is Inbound and if status, phone number are valid. 
  *@Date : 4/11/2015
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   /* This moethod is not used for Japan hence commented.
   public static void SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   
     
   {
     
       List<Task> taskforGenerateQC = new List<Task>();
       Map<String, Task> taskMapForSMS = new Map<String, Task>();
       Map<Id, String> caseIdInteractionIds = new Map<Id,String>();
       
       if(isInsert)
       {
            for(Task t : tasks)
            {
                if(t.Task_RecordType_Name__c == 'IB Call' && t.CallType  == 'Inbound' && t.Phone__c != null
                && t.IB_Status__c == validString && t.UCID__c != null){
                    String phone = t.Phone__c;
                    if(phone.startsWith('1') && phone.length() == 11){
                        system.debug('--------Create sms task in Insert-');
                        //taskMapForSMS.put(t.Id, t);
                    }
                }
            }
        }

        if(isUpdate)
        {
            //US-DPCR-005
            for(Task t : tasks)
            {
                if(t.InteractionIds__c != null && t.InteractionIds__c != '' && t.WhatId != null && String.valueOf(t.WhatId).startsWith('500') && t.Status == closedString)
                {
                    caseIdInteractionIds.put(t.whatId, t.InteractionIds__c);
                } 
                
                // Modified By Justin -- Creates a sms task after an IB call hungs   
                if(t.Task_RecordType_Name__c == 'IB Call' && t.CallType  == 'Inbound' && t.Phone__c != null
                && ((t.IB_Status__c == validString && t.UCID__c != null && taskOldMap.get(t.Id).UCID__c == null)
                || (t.UCID__c != null && t.IB_Status__c == validString && taskOldMap.get(t.Id).IB_Status__c != validString))){
                    String phone = t.Phone__c;
                    if(phone.startsWith('1') && phone.length() == 11){
                        system.debug('--------Create sms task in update-');
                        taskMapForSMS.put(t.Id, t);
                    }
                }
            }
            
            for(Task t : tasks) {
              //When QC Quantity is changed, insert IB/OB QC records.
              if(t.QC_Quantity__c > 0 && (taskOldMap.get(t.Id).QC_Quantity__c == 0 || taskOldMap.get(t.Id).QC_Quantity__c == null)) {
                  taskforGenerateQC.add(t);
          }
        }
        
        
    }
    
    if(taskforGenerateQC!=null && !taskforGenerateQC.IsEmpty()) {
        GenerateMultipleQCs(taskforGenerateQC); 
    }
    
    if(caseIdInteractionIds.keySet().size() > 0) {
        UpdateCaseVoiceRecordlink(caseIdInteractionIds);
    }
    
    //US-CTI-001
    if(isInsert || isUpdate) {
        Map<Id, String> taskIdUCIds = new Map<Id, String>();
        
        for(Task t : tasks) {
            if(isInsert && t.UCID__c != null && t.UCID__c != '' && (t.whatId != null || t.whoId != null)) {
                taskIdUCIds.put(t.Id, t.UCID__c);
            }
            if(isUpdate && t.UCID__c != null && t.UCID__c != '' && t.UCID__c != taskOldMap.get(t.ID).UCID__c && (t.whatId != null || t.whoId != null)) {
                taskIdUCIds.put(t.Id, t.UCID__c);
            }
        }
        
        if(taskIdUCIds.keySet().size() > 0) {
            TaskHelper.updateInteractionIds(taskIdUCIds);
        }
    }
    
    // US-SMSS-001 -- Moves here from before trigger by Justin -- create a sms task when an IB call hungs up.
    if(taskMapForSMS.size() > 0) {
        createSMSTaskAfterIBCall(taskMapForSMS.values());
    }
    
     
      // 2014-3-17 Added by Justin Yu -- Set the Compelted Time field on QC.
     
    Set<String> qcIds = new Set<String>();
    for(Task task : tasks){
        if(task.Activity_Status__c == 'Successful' && (!isUpdate || taskOldMap.get(task.Id).Activity_Status__c != 'Successful')){
            qcIds.add(task.QC_ID__c);
        }
    }
    
    if(qcIds.size() > 0){
        List<QC__c> qcs = [select Completed_Time__c from QC__c where Id in :qcIds];
        for(QC__c qc : qcs){
            if(qc.Completed_Time__c == null){
                qc.Completed_Time__c = System.now();
            }
        }
        update qcs;
    }
    
     
    // * 2014-04-11 Added by Justin Yu -- Set the Last Communication Modified Time field on QC.
      
    Set<String> qcIdsInTask = new Set<String>();
    for(Task task : tasks){
        if((task.RecordTypeId == IBTaskRecordTypeId || task.RecordTypeId == OBTaskRecordTypeId || task.RecordTypeId == SSITaskRecordTypeId ||
           task.RecordTypeId == WelcomeCallRecordTypeId) 
           && (!isUpdate || task.isClosed && !taskOldMap.get(task.Id).isClosed)){
            qcIdsInTask.add(task.QC_ID__c);
        }
    }
    
    if(qcIdsInTask.size() > 0)
    {
        List<QC__c> updatedQCs = [select Last_Communication_Modified_Time__c from QC__c where Id in :qcIdsInTask];
        for(QC__c qc : updatedQCs){
            qc.Last_Communication_Modified_Time__c = System.now();
        }
        update updatedQCs;
    }
   } */
    /**
     * By Justin - replaces the merge fields.
     */
    
    /**
  *@Description : Updates the Salutation to Contact Name based on Gender.
  *@Date : 4/11/2015
  *@param: Contact and String(Content)
  *@return:String (Contact name updated with Salutation)

  */ 
     
    public static String replaceMergeField(Contact contact, String content){
        String nameMergeField = '{CONTACT_NAME}';
        String salutationMergeField = '{CONTACT_SALUTATION}';
        
        if(contact.Name != null){
            content = content.replace(nameMergeField, contact.Name);
        }
        
        String salutation;
        if(contact.Account.Gender__c == 'Male'){
            salutation = 'MR';
        }
        else if(contact.Account.Gender__c == 'Female'){
            salutation = 'Ms';
        }
        else{
            salutation = 'His Excellency';
        }
        content = content.replace(salutationMergeField, salutation);
        
        return content;
    }
    
    /**
     * By Justin - replaces the merge fields from templates before task saved.
     */
     
    /**
  *@Description : Updates the Salutation to Contact Name based on Gender.
  *@Date : 4/11/2015
  *@param: List of new Tasks, Map of contacts.
  *@return: It does not return anything.

  */  
     
    public static void replaceMergeFields(List<Task> tasks, Map<String, Contact> contacts){
        for(Task task : tasks){
            Contact contact = contacts.get(task.WhoId);
            if(task.SMS_Content__c != null && contact != null){
                task.SMS_Content__c = replaceMergeField(contact, task.SMS_Content__c);
            }
        }
    }
    
    
     
     /**
  *@Description : Checks the SMS Response Required of task
  *@Date : 4/11/2015
  *@param: List of new Tasks, Map of templates.
  *@return: It does not return anything.

  */  
     
    public static void checkResponseRequired(List<Task> tasks, Map<String, Template__c> templates){
        for(Task task : tasks){
            Template__c template = templates.get(task.SMSTemplateID__c);
            if(template != null && template.Type__c == 'Upstream & Downstream'){ 
			
            }
        }
    }
    
   
     
     /**
  *@Description : Prevents the sms task from saving when the SMS Opt Out of contact is checked.
  *@Date : 4/11/2015
  *@param: List of new Tasks, Map of contacts.
  *@return: It does not return anything.

  */  
    public static void preventTaskFromCreating(List<Task> tasks, Map<String, Contact> contacts){
        for(Task task : tasks){
            Contact contact = contacts.get(task.WhoId);
            if(contact != null && contact.SMSOptOut__c){
                task.addError('You can not create a sms/mms task for SMS Opt Out is checked.');
            }
        }
    }
    
    //TODO - Not Used
    /*public static void GenerateQCs(List<Task> updateTasks) {        
        //new qc list for insert
        List<QC__c> newQCs = new List<QC__c>();
        QC__c qc;
        
        //connect task ids which to generate qc
        Set<Id> taskIds = New Set<Id>();
        
        for(Task t : updateTasks) {   
            qc = new QC__c();
            qc.CSR_Name__c = t.OwnerId;
            qc.Status__c = 'New';
            qc.Task_ID__c = t.Id;
            if(t.recordTypeId == IBTaskRecordTypeId) {
                qc.RecordTypeId = IBQCRecordTypeId;
                newQCs.add(qc);
            }
            if(t.recordTypeId == OBTaskRecordTypeId) {
                qc.RecordTypeId = OBQCRecordTypeId;
                newQCs.add(qc);
            }
            taskIds.add(t.Id);
        }
        if(newQCs!=null && !newQCs.IsEmpty()) {
            UtilSobject.insertSobjects(newQCs);
        }
        UpdateQCLink(taskIds, updateTasks);
    }
    
    public static void GenerateSSIQCs(List<Task> updateTasks) {

    }*/
    
     
     /**
  *@Description : Generates Qc based on details in Task Object.
  *@Date : 4/11/2015
  *@param: List of  Tasks.
  *@return: It does not return anything.

  */  
    
    public static void GenerateMultipleQCs(List<Task> updateTasks) {
        List<QC__c> QCForInsert = new List<QC__c>();
        QC__c qc;
        for(Task t : updateTasks) {
            for(Integer i=0; i<t.QC_Quantity__c; i++) {
                qc = new QC__c();
                qc.CSR_Name__c = t.OwnerId;
                qc.Status__c = 'New';
                qc.Calibration__c = true;
                qc.Task_ID__c = t.Id;
                if(t.recordTypeId == IBTaskRecordTypeId) {
                    qc.RecordTypeId = IBQCRecordTypeId;
                    QCForInsert.add(qc);
                }
                if(t.recordTypeId == OBTaskRecordTypeId) {
                    qc.RecordTypeId = OBQCRecordTypeId;
                    QCForInsert.add(qc);
                }
            }
        }
        if(QCForInsert!=null && !QCForInsert.IsEmpty()) {
            UtilSobject.insertSobjects(QCForInsert);
        }
    }
    
    /**
  *@Description : Based on WhatID(Case,Campaign ,Campaign Leads) of tasks Updates the campaign Names.
  *@Date : 4/11/2015
  *@param:Set of CaseIds, CampaignIds,CampaignLeadIds and List of Tasks.
  *@return:This mehtod does not return any value.

  */
    
    public static void copyCampaignNameFromRelatedToObject(Set<String> caseIds, Set<String> campaignIds, Set<String> campaignLeadIds, List<Task> tasks){
        Map<String, Case> cases = new Map<String, Case>();
        Map<String, Campaign> campaigns = new Map<String, Campaign>();
        Map<String, Campaign_Lead__c> campaignLeads = new Map<String, Campaign_Lead__c>();
        
        if(caseIds.size() > 0){ 
            cases = new Map<String, Case>([select Id, Campaign__r.Name from Case where Id in :caseIds]);
        }
        if(campaignIds.size() > 0){ 
            campaigns = new Map<String, Campaign>([select Id, Name from Campaign where Id in :campaignIds]);
        }
        if(campaignLeadIds.size() > 0){  
            campaignLeads = new Map<String, Campaign_Lead__c>([select Id, Campaign__r.Name from Campaign_Lead__c where Id in :campaignLeadIds]);
        }   

        for(Task task : tasks){
            String relatedId = task.WhatId;
            if(relatedId.startsWith('500')){
                task.Campaign_Name__c = cases.get(relatedId).Campaign__r.Name;
            }
            else if(relatedId.startsWith('701')){
                task.Campaign_Name__c = campaigns.get(relatedId).Name;
            }
            else if(relatedId.startsWith('a0c')){
                task.Campaign_Name__c = campaignLeads.get(relatedId).Campaign__r.Name;
            }
        }
    }
    
    
    /**
  *@Description : Copies IBCall Type to Task from case .
  *@Date : 4/11/2015
  *@param:Set of CaseIds,List of Tasks.
  *@return:This mehtod does not return any value.

  */
    
    public static void copyIBCallTypeFromCase(Set<String> caseIds, List<Task> tasks) {
        Map<String, Case> cases = new Map<String, Case>([select Id, RecordType.Name from Case where Id in :caseIds]);
        
        for(Task t : tasks) {
            if(cases.containsKey(t.WhatId) && t.RecordTypeId == IBTaskRecordTypeId && t.CallType == 'Inbound') {
                t.IB_Call_Type__c = cases.get(t.WhatId).RecordType.Name;
            }
        }
    }
    
    //TODO - Not Used
    /*private static void UpdateQCLink(Set<Id> taskIds, List<Task> tasks) {
        //map task id and new generate qc id
        Map<Id, Id> taskIdqcIdMap = new Map<Id, Id>();
        
        taskIds.remove(null);
        for(QC__c newQc : [select Id, Task_ID__c from QC__c where Task_ID__c in :taskIds and Task_ID__c != null and Task_ID__c != '' 
                           and (RecordTypeId = :IBQCRecordTypeId or RecordTypeId = :OBQCRecordTypeId or RecordTypeId = :SSIQCRecordTypeId) 
                           and CreatedDate > :Date.Today().addDays(-30) limit 10000]) {
            taskIdqcIdMap.put(newQc.Task_ID__c, newQc.Id);
        }
            
        for(Task t : tasks) {
            if(taskIdqcIdMap.containsKey(t.Id)) {
                t.QC_ID__c = taskIdqcIdMap.get(t.Id);
            }
        }
    }*/
    
    // Creat new SMS Task 
    // --- Modified by Justin on 2013-12-10
    
    /**
  *@Description : Creates New SMS task after IB call.
  *@Date : 4/11/2015
  *@param:List of Tasks.
  *@return:This mehtod does not return any value.

  */
    public static void createSMSTaskAfterIBCall(List<Task> tasks) {
        Template__c ivrTemplates = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR'];
        Template__c smartTemplate = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR Smart'];
        Template__c mbTemplate = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR MB'];
        
        Set<String> contactIds = new Set<String>();
        for(Task t : tasks) {
            contactIds.add(t.WhoId);
        }
        Map<ID, Contact> contacts = new Map<ID, Contact>([select SMSOptOut__c from Contact where Id in :contactIds]); 
         
        List<task> smsTasks = new List<Task>();      
        for(Task t : tasks) {
            Contact contact = contacts.get(t.WhoId);
            if(contact != null && contacts.get(t.WhoId).SMSOptOut__c){
                continue;
            }
            Task smsTask = new Task();
            smsTask.Subject = 'SMS'; 
            smsTask.Status = closedString;    
            smsTask.Activity_Status__c = 'Sent';      
            smsTask.RecordTypeId = SMS_TASK_RECORDTYPEID;
            smsTask.Related_Task_Id__c = t.Id;
            smsTask.WhatId = t.WhatId;
            smsTask.WhoId = t.WhoId;
            smsTask.OwnerId = t.OwnerId;
            smsTask.IB_Status__c = t.IB_Status__c;
            smsTask.Phone__c = t.Phone__c;
            if(t.Called__c == '4291'){
                smsTask.SMSTemplateID__c = smartTemplate.Id;
                smsTask.SMS_Content__c = smartTemplate.Message_Detail__c;
            }
            else if(t.Called__c == '4290' || t.Called__c == '4292'){
                smsTask.SMSTemplateID__c = mbTemplate.Id;
                smsTask.SMS_Content__c = mbTemplate.Message_Detail__c;
            }
            else{
                smsTask.SMSTemplateID__c = ivrTemplates.Id;
                smsTask.SMS_Content__c = ivrTemplates.Message_Detail__c;
            }
            smsTasks.add(smsTask);
        }
        
        if(smsTasks!=null && !smsTasks.IsEmpty()) {
            UtilSobject.insertSobjects(smsTasks);
        }
    }
    
    /**
  *@Description : updates Case Voice recordlink. 
  *@Date : 4/11/2015
  *@param: Map of CaseInteractionIds.
  *@return:This mehtod does not return any value.

  */
    
    public static void UpdateCaseVoiceRecordlink(Map<Id, String> caseIdInteractionIds) {
        List<Case> caseForUpdate = new List<Case>();
        
        List<App_Setting__c> appSettings = [select Name, Value__c from App_Setting__c where Name = 'Voice Recording Location'];
    
        for(Case c : [select Id, Voice_Record_Link__c from Case where Id in :caseIdInteractionIds.keySet()]) {
            if(c.Voice_Record_Link__c != null && c.Voice_Record_Link__c != '' && appSettings!=null && appSettings.size() == 1) {
                c.Voice_Record_Link__c = appSettings[0].Value__c + caseIdInteractionIds.get(c.Id);
                caseForUpdate.add(c);
            }
        }
        
        if(caseForUpdate!=null && !caseForUpdate.IsEmpty()) {
            UtilSobject.updateSobjects(caseForUpdate);
        }
    }
    
    //US-CTI-001
    
    
    /**
  *@Description : updates InteractionIds. 
  *@Date : 4/11/2015
  *@param: Map of Task ids and Ucids.
  *@return:This mehtod does not return any value.

  */
    @Future(CallOut=True)
    public static void updateInteractionIds(Map<Id, String> taskIdUCIds) {
        List<Task> tasks = new List<Task>();
        for(Task t : [select Id, CreatedDate, InteractionIds__c from Task where Id in :taskIdUCIds.keySet()]) {
            t.InteractionIds__c = AvatoHelper.getInteractionIds( taskIdUCIds.get(t.Id), t.CreatedDate); 
            tasks.add(t);
        }
        
        if(tasks!=null && !tasks.IsEmpty()) {
            UtilSobject.updateSobjects(tasks);
        }
    }
    // By Shuang Li BRD-AS-CAC-007---- strart
    /**
  *@Description : Updates SSITasks. 
  *@Date : 4/11/2015
  *@param: Set of UserIds.
  *@return:This mehtod does not return any value.

  */
    
    @future(CallOut=True)
    public static void autoUpdateSSITask(Set<Id> userIds){
        Profile CACSSISV = [select Id from Profile where Name = 'CAC SSI SV'];
        Id SSITaskRTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        List<Task> taskSSI = [SELECT ownerId FROM Task WHERE ownerId in :userIds AND RecordTypeId= :SSITaskRTId];

         if(taskSSI!=null && !taskSSI.IsEmpty()){
            User ssiSvUser = [Select id From User Where ProfileId = :CACSSISV.id and IsActive = true limit 1];
            for(Task tk : taskSSI){
                tk.ownerId = ssiSvUser.id;
            }
            try {
                    update taskSSI;
                }
                catch (DMLException e) {
                    trigger.new[0].addError(e.getDMLMessage(0));
                }
       }
    }
 // By Shuang Li BRD-AS-CAC-007---- end
    /**
  *@Description : Update Linked Leads. 
  *@Date : 11/14/2016
  *@param: List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.
----------------------------------------------------------
   @issue : SFDCJP-1725
   @modified date : 24-feb-2017
   @name : Lokesh m
   @desc : updating Task_Update_Flag__c field in lead__c object related to this task.
  */
    
    public static void UpdateLinkedLeads(List<Task> tasks,Map<Id,Task> taskOldMap,boolean isInsert,boolean isUpdate) {
    
        Set<ID> leadId = new Set<ID>();
        System.debug('@@@@@@@@@@'+leadId );
          List<Lead__c> lstLead = new List<Lead__c>();
         // set<Lead__c> updateLead = new set<Lead__c>();
          Map<Id,Lead__c> updateLead=new Map<Id,Lead__C>();
          Map<Id,Lead__c> updlead=new Map<Id,Lead__C>();
          List<Lead__c> mainlead= new List<Lead__c>();
         for(Task tsk : tasks){            
            if(tsk.WhatId != null){
              
                      leadId.add(tsk.WhatId);        
               
            }   
        }
         if(leadId != Null && !leadId.isEmpty()){
            lstLead = [Select Id,RecordTypeId,Task_Update_Flag__c,Next_Contact_Customer_Date__c,Contact_Date__c,Visited_Showroom_Date__c,Needs_Check_Date__c,Product_Proposal_Date__c, 
            Finance_Proposal_Date__c,Insurance_Proposal_Date__c,ServiceProgram_Proposal_Date__c,
            Simple_Estimation_Date__c,Test_Drive_Date__c,Trade_in_Date__c from Lead__c where Id =:leadId];
        }
        
        for(Task t : tasks)
        {
        if(t.WhatId != null){
               
                for(Lead__c le : lstLead)
                {
                
                if((t.Intention_Status__c=='Contact')  && (t.SentTime__c!=null) )
                {
                le.Next_Contact_Customer_Date__c=date.valueof(t.SentTime__c);
                updateLead.put(le.ID,le);
                updlead.put(le.ID,le);
                }
                }
                }
        }
        
       for(Task t1 : tasks)
        {
        for(Lead__c le1 : lstLead)
            {
                if(le1.id == t1.whatId)
                {
                    if(t1.intention_status__c=='Contact' && t1.Activity_Date__c!=NULL)
                    {
                        le1.Contact_Date__c =t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Visited' && t1.Activity_Date__c!=NULL)
                    {
                        le1.Visited_Showroom_Date__c = t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Needs Check' && t1.Activity_Date__c!=NULL)
                    {
                        le1.Needs_Check_Date__c = t1.Activity_Date__c;
                        mainLead.add(le1); 
                    }
                    else if(t1.intention_status__c=='Product Proposal' && t1.Activity_Date__c!=NULL && le1.RecordTypeID == SalesLeadRectypeID)
                    {
                        le1.Product_Proposal_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Finance Proposal' && t1.Activity_Date__c!=NULL && le1.RecordTypeID == SalesLeadRectypeID)
                    {
                        le1.Finance_Proposal_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Insurance Proposal' && t1.Activity_Date__c!=NULL)
                    {
                        le1.Insurance_Proposal_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Service Program Proposal' && t1.Activity_Date__c!=NULL)
                    {
                        le1.ServiceProgram_Proposal_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Simple Estimation' && t1.Activity_Date__c!=NULL && le1.RecordTypeID == SalesLeadRectypeID)
                    {
                        le1.Simple_Estimation_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1);
                    }
                    else if(t1.intention_status__c=='Test Drive' && t1.Activity_Date__c!=NULL && le1.RecordTypeID == SalesLeadRectypeID)
                    {
                        le1.Test_Drive_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1); 
                    }
                    else if(t1.intention_status__c=='Trade-In' && t1.Activity_Date__c!=NULL && le1.RecordTypeID == SalesLeadRectypeID)
                    {
                        le1.Trade_in_Date__c= t1.Activity_Date__c;
                        mainLead.add(le1); 
                    }
                    else if(t1.intention_status__c=='Trade-In' || t1.intention_status__c=='Test Drive' || t1.intention_status__c=='Simple Estimation' || t1.intention_status__c=='Finance Proposal' || t1.intention_status__c=='Product Proposal' && le1.RecordTypeID == AfterSalesLeadRectypeID)
                    
                     t1.addError('Please select appropriate activity for the Leads');
                }
           }
        }
        update mainLead;
        for(Lead__c led : lstLead){
            if(led.Task_Update_Flag__c == False){
                led.Task_Update_Flag__c = True;
                updateLead.put(led.id,led);
            }
            else if(led.Task_Update_Flag__c == True){
                led.Task_Update_Flag__c = False;
                updateLead.put(led.id,led);
            }
        } 
        system.debug('#####$$$$$$'+updateLead);
        if(updateLead != NULL && !updateLead.isEmpty())
        {
           // list<lead__c>wupdateLead = new list<lead__c>(updateLead);
            Update updateLead.Values();
        }
            
        if(updlead.size()>0){ 
          System.debug('updlead.size()>>>>>>>'+updlead.size());
            update  updlead.Values();  
        }          
    } 
}