/*
    Type:       Apex Class
    Purpose:    Define methods used in TriggerTask
    User Story: US-SSI-008, US-SSI-011, US-SSI-014, US-SSI-018
    Used By:    TriggerTask.trigger
    ---------------------------------------------------------------
    History:
    
    24-Apr-2013 Chris Huang (Breakingpoint)    Created
    10-mar-2014 shuang Li (NTTData) Update BRD-AS-CAC-007
    18-mar-2014 shuang Li (NTTData) Update US-smart_SSI-008
    2015-04-21 Gerhard Henning (NTTData)  Moved code to TaskTriggerHandler
*/

public class TaskTriggerHandler 
    implements TriggerHandlerIf
{ 
      
    private static final String WELAND1STSURVEY = 'Welcome Call + 1st Survey Call';
    private static final String X1STSURVEY = '1st Survey Call';
    private static final String X2NDSURVEY = '2nd Survey Call';  
    private static Id OBRTID;
    private static Id IBRTID; 
    private static Id SSIRTID;
    private static Id WCRTID;
    private static Id OBTRTID;
    
    public void handleTrigger()
    {  
        
        if(trigger.isBefore && trigger.isInsert)
        {
            TaskHelper.au_Before_Insert_Update_Events_Task(Trigger.new,trigger.isinsert,trigger.isupdate);
            TaskHelper.updateCommentWithTimeStamp(Trigger.new,trigger.isinsert,trigger.isupdate);
            TaskHelper.validateAccount(Trigger.new,trigger.isinsert,trigger.isupdate);
            TaskHelper.updateCompany(Trigger.new);
            TaskHelper.au_before_Insert_Events_Task(Trigger.new,trigger.isinsert);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TaskHelper.au_Before_Insert_Update_Events_Task(Trigger.new,trigger.isinsert,trigger.isupdate);
            TaskHelper.updateCommentWithTimeStamp(Trigger.new,trigger.isinsert,trigger.isupdate);
            TaskHelper.validateAccount(Trigger.new,trigger.isinsert,trigger.isupdate);
        }
    if(trigger.isAfter && trigger.isInsert)
        {
            TaskHelper.au_After_Insert_Update_Events_Task(trigger.new, trigger.isInsert, trigger.isUpdate);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            TaskHelper.au_After_Insert_Update_Events_Task(trigger.new, trigger.isInsert, trigger.isUpdate);
        }
    }
    
    private static void getRecordTypeId(){
        if(OBRTID == null){
            Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
            SSIRTID = rtMap.get(UtilConstant.SSI_TASK).getRecordTypeId();
            WCRTID = rtMap.get(UtilConstant.WELCOME_CALL).getRecordTypeId();
            IBRTID = rtMap.get(UtilConstant.IB_CALL).getRecordTypeId();
            OBRTID = rtMap.get(UtilConstant.OB_CALL).getRecordTypeId();
            OBTRTID = rtMap.get(UtilConstant.OB_TASK).getRecordTypeId();
        }
    }  
      
    public static void updateAccountCallMessage(Map<Id,Task> newMap, Map<Id,Task> oldMap){
        getRecordTypeId();
        
        Map<Id, Task> updateMap = new Map<Id, Task>();
        Set<Id> ssiTaskIds = new Set<Id>();
        for(Task t : newMap.values()){
            if((t.RecordTypeId == OBRTID && t.OB_Status__c == UtilConstant.SUCCESSFUL)
                || (t.RecordTypeId == IBRTID && t.IB_Status__c == UtilConstant.VALID)){
                if(t.AccountId != null && !updateMap.containsKey(t.AccountId)){
                    updateMap.put(t.AccountId, t);
                }                
            }
            if(t.RecordTypeId == OBRTID && t.Activity_Status__c == UtilConstant.SUCCESSFUL && t.whoId == null) {
                String ssiId = t.WhatId;
                if(ssiId.subString(0, 3) == 'a1J') {
                    ssiTaskIds.add(t.Related_Task_Id__c);
                }
            }
        }
        
        for(Task t : [select Id, End_call_time__c, RecordTypeId, AccountId,Caller__c from Task where Id in :ssiTaskIds]) {
            updateMap.put(t.AccountId, t);
        }
        
        if(!updateMap.isEmpty()){
            Map<Id, Account> accounts = new Map<Id, Account>([
                Select Id, PersonOtherPhone, Phone, PersonMobilePhone, PersonHomePhone, PersonAssistantPhone, Last_Successful_Call__c 
                From Account
                Where Id = :updateMap.keySet()]); 
            Map<Id, Account> updateAccounts = new Map<Id, Account>();
            for(Id key : accounts.keySet()){
                Task tk = updateMap.get(key);
                Account acc = accounts.get(key);
                if (tk.End_call_time__c != null && acc.Last_Successful_Call__c != tk.End_call_time__c) {
                    String pNumber = tk.RecordTypeId == OBRTID ? tk.Called__c : tk.Caller__c;
                    if(pNumber != null){
                        if(acc.Phone != null && pNumber.contains(acc.Phone)){
                            acc.Last_Successful_Call_Office_Phone__c = tk.End_call_time__c;
                        }else if(acc.PersonHomePhone != null && pNumber.contains(acc.PersonHomePhone)){
                            acc.Last_Successful_Call_Home_Phone__c = tk.End_call_time__c;
                        }else if(acc.PersonMobilePhone != null && pNumber.contains(acc.PersonMobilePhone)){
                            acc.Last_Successful_Call_Mobile__c = tk.End_call_time__c;
                        }else if(acc.PersonOtherPhone != null && pNumber.contains(acc.PersonOtherPhone)){
                            acc.Last_Successful_Call_Second_Mobile__c = tk.End_call_time__c;
                        }
                    }                
                    acc.Last_Successful_Call__c = tk.End_call_time__c;    
                    updateAccounts.put(acc.Id, acc);   
                }
            }   
            
            if(!updateAccounts.isEmpty()){
                update updateAccounts.values();
                updateLeadAndCampaignLead(updateAccounts);
            }
        }   
        
    }

    @testVisible private static void updateLeadAndCampaignLead(Map<Id, Account> accounts) {
        List<Lead__c> leads = [
            Select Successful_Call_Number__c, CreatedDate, Contact__c, Lead_DataSource__c, Last_Successful_Call__c, Lost_CAC_Date_Time__c, Purchased_CAC_Date_Time__c, CAC_Lead_Status__c
            From Lead__c 
            Where Contact__c In :accounts.keySet()];
        List<Lead__c> updateLeads = new List<Lead__c>();    
        List<Lead__c> updateOnlyLeads = new List<Lead__c>();   
        for (Lead__c ld : leads) {
            Account acc = accounts.get(ld.Contact__c);
            if (acc.Last_Successful_Call__c > ld.CreatedDate.addMinutes(10) || ((ld.Lead_DataSource__c != UtilConstant.OB_CALL && ld.Lead_DataSource__c != UtilConstant.IB_CALL))) {
                
                if (ld.CAC_Lead_Status__c == 'Purchased(Only Non BDC)' && (ld.Purchased_CAC_Date_Time__c == null || acc.Last_Successful_Call__c > ld.Purchased_CAC_Date_Time__c.addMinutes(10))) {
                    continue;
                }

                if (ld.CAC_Lead_Status__c == 'Lost(CAC)' && (ld.Lost_CAC_Date_Time__c == null || acc.Last_Successful_Call__c > ld.Lost_CAC_Date_Time__c.addMinutes(10))) {
                    continue;
                }

                if (ld.Successful_Call_Number__c == null) {
                    ld.Successful_Call_Number__c = (ld.Lead_DataSource__c == UtilConstant.OB_CALL || ld.Lead_DataSource__c == UtilConstant.IB_CALL) ? 1 : 0;
                }
                ld.Successful_Call_Number__c ++;
                ld.Last_Successful_Call__c = acc.Last_Successful_Call__c;
                updateLeads.add(ld);
            }else if (acc.Last_Successful_Call__c <= ld.CreatedDate.addMinutes(10)) {
                ld.Last_Successful_Call__c = acc.Last_Successful_Call__c;
                updateOnlyLeads.add(ld);
            }


        }

        if (updateOnlyLeads.size() > 0) {
            update updateOnlyLeads;
        }

        if (updateLeads.size() > 0) {
            update updateLeads;

            List<Campaign_Lead__c> cls = [
                Select Successful_Call_Number__c, CreatedDate, Lead__r.Contact__c, Lead__r.Lead_DataSource__c, Last_Successful_Call__c
                From Campaign_Lead__c 
                Where Lead__c In :updateLeads]; 
            List<Campaign_Lead__c> updateCampaignLeads = new List<Campaign_Lead__c>();   
            for (Campaign_Lead__c cl : cls) {
                Account acc = accounts.get(cl.Lead__r.Contact__c);
                if (acc.Last_Successful_Call__c > cl.CreatedDate.addMinutes(10) || (cl.Lead__r.Lead_DataSource__c != UtilConstant.OB_CALL && cl.Lead__r.Lead_DataSource__c != UtilConstant.IB_CALL) ) {
                    if (cl.Successful_Call_Number__c == null) {
                        cl.Successful_Call_Number__c = (cl.Lead__r.Lead_DataSource__c == UtilConstant.OB_CALL || cl.Lead__r.Lead_DataSource__c == UtilConstant.IB_CALL) ? 1 : 0;
                    }
                    cl.Successful_Call_Number__c ++;
                    cl.Last_Successful_Call__c = acc.Last_Successful_Call__c;
                    updateCampaignLeads.add(cl);
                }
            } 

            if (updateCampaignLeads.size() > 0) {
                update updateCampaignLeads;
            }
        }
    }
    
    public static void generateWelcomeCall(Task tk, Task old){
        getRecordTypeId();
        // By Shuang Li US-smart_SSI-008---- start
        if (tk.RecordTypeId == SSIRTID && tk.Subject == WELAND1STSURVEY && tk.AccountId !=null 
            && tk.Status == UtilConstant.CLOSED && old.Status != UtilConstant.CLOSED
            && (
                tk.Activity_Status__c == 'Phone Shut Down' ||
                tk.Activity_Status__c == 'Engaged' ||
                tk.Activity_Status__c == 'Voice Mail' ||
                tk.Activity_Status__c == 'Unanswered' ||
                tk.Activity_Status__c == 'Call Limitation' ||
                tk.Activity_Status__c == 'Insufficient Fund' ||
                tk.Activity_Status__c == 'Out of Service' 
            )){
        // By Shuang Li US-smart_SSI-008---- end
               doGenerateWC(tk);    
        }
    }
 
    @TestVisible private static void doGenerateWC(Task tk){
        Account acc = [
            Select Id, Name, PersonOtherPhone, Phone, PersonMobilePhone, PersonHomePhone, PersonAssistantPhone 
            From Account 
            Where Id=:tk.AccountId];
        String allDMSPhone = 
            acc.PersonOtherPhone + 
            acc.Phone + 
            acc.PersonMobilePhone + 
            acc.PersonHomePhone + 
            acc.PersonAssistantPhone;
        // By Shuang Li US-smart_SSI-008---- start
        SSI__c ssi;

        String allSSIPhone;
        if (tk.RecordTypeId == SSIRTID){
            ssi = [Select OfficePhone__c, HomeMobilePhone__c From SSI__c Where Id =: tk.WhatId];    
            allSSIPhone = ssi.OfficePhone__c + ssi.HomeMobilePhone__c;
        }
        // By Shuang Li US-smart_SSI-008---- end
        if(allDMSPhone.length() > allSSIPhone.length()){

            Integer wccount = [
                Select Count() 
                From Task 
                Where recordtypeid = :WCRTID And WhatId = :tk.WhatId And WhoId = :tk.WhoId];
            if(wccount == 0){
                profile profileId=[select Id,name from profile where Name='CAC OB TL'];
                User obsv = [Select Id, ProfileId From User 
                    where profileId=:profileId.Id And IsActive = true Limit 1];
                Task t = new Task(
                    recordtypeid = WCRTID,
                    Subject = 'Welcome Call',
                    WhatId = tk.AccountId,
                    WhoId = tk.WhoId,
                    PersonAssistantPhone__c = acc.PersonAssistantPhone,
                    PersonHomePhone__c = acc.PersonHomePhone,
                    PersonMobilePhone__c = acc.PersonMobilePhone,
                    Called__c = acc.Phone,
                    PersonOtherPhone__c = acc.PersonOtherPhone,
                    CustomerName__c = acc.Name,
                    OwnerId = obsv.Id,
                    Status = 'Open',
                    Welcome_Call_Source__c = 'Unsuccessful SSI'
                );
                insert t;
            }
        }
    }
    
    public static void taskFieldsUpdate(List<Task> tasks, Map<Id,Task> oldMap){
        getRecordTypeId();
        
        Map<String, Task> ctiTasks = getCTITasks(tasks);

        Set<Task> autoUpdateSSITasks = new Set<Task>();
        Set<Task> autoUpdateOBCalls = new Set<Task>();

        for (Task tk : tasks) {
             
            if (tk.RecordTypeId == IBRTID && tk.CallType == 'Inbound') {
                getCTIMessage(tk, ctiTasks);
                tk.Activity_Status__c = tk.IB_Status__c;
                tk.Phone__c = tk.Caller__c;
            }
            
            if (tk.RecordTypeId == OBRTID && tk.CallType == 'Outbound') {
                getCTIMessage(tk, ctiTasks);
                if(tk.SSI_Status__c == null) {
                    tk.Activity_Status__c = tk.OB_Status__c;
                }else {
                  tk.Activity_Status__c = tk.SSI_Status__c;
                }                
                tk.Phone__c = tk.Called__c;
            }
            // By Shuang Li US-smart_SSI-008---- start
            if ((tk.RecordTypeId == SSIRTID || tk.RecordTypeId == WCRTID) 
                && tk.Activity_Status__c == UtilConstant.SUCCESSFUL) {
                tk.Status = UtilConstant.CLOSED;
            }
            // By Shuang Li US-smart_SSI-008---- end
            
            // if (tk.RecordTypeId == SSIRTID && tk.Subject == WELAND1STSURVEY 
            //     && tk.Activity_Status__c != UtilConstant.SUCCESSFUL && tk.Activity_Status__c != null) {
            //     tk.Status = UtilConstant.CLOSED;            
            // }
            
            // By Shuang Li US-smart_SSI-008---- start
            if(tk.RecordTypeId == SSIRTID && tk.WhatId != null && tk.WhatId.getSObjectType().getDescribe().getName() == UtilConstant.SSI){
            // By Shuang Li US-smart_SSI-008---- end
                autoUpdateSSITasks.add(tk);             
            }
            
            if(tk.RecordTypeId == OBRTID){
                autoUpdateOBCalls.add(tk);
            }
        }  

        autoUpdateSSITask(autoUpdateSSITasks);
        autoUpdateOBCall(autoUpdateOBCalls);
    }

    private static Map<String, Task> getCTITasks(List<Task> tasks) {
        System.debug('-------------tasks---------->' + tasks);
        Map<String, Task> ctiTasks = new Map<String, Task>();
        List<String> objectIds = new List<String>();
        for(Task tk : tasks) {
            if (tk.CallObject != null && ( tasks[0].RecordTypeId == IBRTID || tasks[0].RecordTypeId == OBRTID)) {
                objectIds.add(tk.CallObject);
            }
        }

        if (objectIds.size() > 0) {
            for (List<Task> ctks : [
                    Select UCID__c, Caller__c, Called__c, Start_call_time__c, End_call_time__c, CallObject 
                    From Task 
                    Where RecordTypeId = :tasks[0].RecordTypeId And CreatedDate >= TODAY And CallObject In :objectIds And UCID__c != null]) {
                for (Task ctk : ctks) {
                    ctiTasks.put(ctk.CallObject, ctk);
                }
            }
            System.debug('-------------objectIds---------->' + objectIds);
            System.debug('-------------ctiTasks---------->' + ctiTasks);
            // Added by Chris Huang. Additional logic to get cti call message when call object are not the same.
            if (objectIds.size() == 1 && tasks[0].RecordTypeId == OBRTID && ctiTasks.isEmpty()) { //code changed from size() == 0 to isEmpty()
                List<Task> ctks = [
                    Select UCID__c, Caller__c, Called__c, Start_call_time__c, End_call_time__c, CallObject, CreatedDate 
                    From Task 
                    Where 
                        RecordTypeId = :tasks[0].RecordTypeId 
                        And CreatedDate = TODAY 
                        And UCID__c != null 
                        And CreatedById = :UserInfo.getUserId() 
                        And WhoId = null
                        And WhatId = null
                    Order By CreatedDate DESC 
                    Limit 1];
                System.debug('-------------ctks---------->' + ctks);
                if (ctks.size() == 1) {
                    Task ctk = ctks[0];   
                    Task tk = tasks[0];   
                    String pNumber = ctk.Called__c;   
                    Boolean isMatched = false;      
                    try {          
                        if(tk.WhatId.getSObjectType().getDescribe().getName() == UtilConstant.SSI){
                            SSI__c ssi = [Select HomeMobilePhone__c, OfficePhone__c From SSI__c Where Id = :tk.WhatId];
                            if ((ssi.HomeMobilePhone__c != null && pNumber.contains(ssi.HomeMobilePhone__c)) 
                                    || (ssi.OfficePhone__c != null && pNumber.contains(ssi.OfficePhone__c))) {
                                isMatched = true;
                            }
                        }else if (tk.WhoId != null && tk.WhoId.getSObjectType().getDescribe().getName() == 'Contact') {
                            Contact con = [Select AccountId From Contact Where Id = :tk.WhoId];
                            Account acc = [Select Phone, PersonHomePhone, PersonMobilePhone, PersonOtherPhone, PersonAssistantPhone From Account Where Id = :con.AccountId];
                            if((acc.Phone != null && pNumber.contains(acc.Phone)) 
                                || (acc.PersonHomePhone != null && pNumber.contains(acc.PersonHomePhone))
                                || (acc.PersonMobilePhone != null && pNumber.contains(acc.PersonMobilePhone))
                                || (acc.PersonOtherPhone != null && pNumber.contains(acc.PersonOtherPhone))
                                || (acc.PersonAssistantPhone != null && pNumber.contains(acc.PersonAssistantPhone))){
                                isMatched = true;
                            }
                        } 
                    } catch (Exception ex) {
                      System.debug('errormessage>>' + ex.getmessage());}
                    if (isMatched) {
                        ctiTasks.put(tk.CallObject, ctk);
                    }
                    
                }
            }
        }
        System.debug('-------------ctiTasks---------->' + ctiTasks);
        return ctiTasks;
    }

    private static void getCTIMessage (Task tk, Map<String, Task> ctiTasks) {
        if (tk.CallObject != null && ctiTasks.containsKey(tk.CallObject) && tk.UCID__c == null) {
            Task cti = ctiTasks.get(tk.CallObject);
            tk.UCID__c = cti.UCID__c;
            tk.Caller__c = cti.Caller__c;
            tk.Called__c = cti.Called__c;
            tk.Start_call_time__c = cti.Start_call_time__c;
            tk.End_call_time__c = cti.End_call_time__c;
        }
    }
    
    public static void autoUpdateTaskAfterLogInserted(Task tk){
        getRecordTypeId();
        
        if(tk.RecordTypeId == OBRTID && tk.Related_Task_Id__c != null && tk.Related_Task_Id__c.length() >= 15){   

            Integer obCallCount = 0;
            if (tk.WhoId != null) {
                obCallCount = [
                    Select Count() 
                    From Task 
                    Where RecordTypeId = :OBRTID And Related_Task_Id__c = :tk.Related_Task_Id__c And WhoId = :tk.WhoId And Start_call_time__c != null]; 
            // By Shuang Li US-smart_SSI-008---- start
            } else if (tk.WhatId != null && tk.WhatId.getSObjectType().getDescribe().getName() == UtilConstant.SSI) {
                obCallCount = [
                    Select Count() 
                    From Task 
                    Where RecordTypeId = :OBRTID And Related_Task_Id__c = :tk.Related_Task_Id__c And WhatId = :tk.WhatId And Start_call_time__c != null]; 
            } 
           
            List<Task> tasks = [
                Select Id, OB_Call_Times__c, UCID__c, Caller__c, Called__c, Start_call_time__c, End_call_time__c, Last_OB_Call__c, SSI_Status__c 
                From Task 
                Where Id = :tk.Related_Task_Id__c And ( RecordTypeId = :OBTRTID Or RecordTypeId =: WCRTID Or RecordTypeId =: SSIRTID)
            ];
            // By Shuang Li US-smart_SSI-008---- end
      
            if(tasks != null && tasks.size() > 0){
                Task t = tasks[0];
                if((tk.Start_call_time__c != null && t.Last_OB_Call__c != tk.Start_call_time__c) || t.SSI_Status__c != tk.SSI_Status__c){
                    if (obCallCount > 0) {
                        t.OB_Call_Times__c = obCallCount;
                    }                    
                    t.Last_OB_Call__c = tk.Start_call_time__c;
                    t.UCID__c = tk.UCID__c;
                    t.Caller__c = tk.Caller__c;
                    t.Called__c = tk.Called__c;
                    t.Start_call_time__c = tk.Start_call_time__c;
                    t.End_call_time__c = tk.End_call_time__c;
                    t.SSI_Status__c = tk.SSI_Status__c;
                    t.CallObject = tk.CallObject;
                    try{
                        update t;
                    }catch(DMLException ex){
            System.debug('errormessage>>' + ex.getmessage());
                    } 
                }           
            }
        }
    }
    
    private static void autoUpdateOBCall(Set<Task> tasks){
        Set<Id> accIds = new Set<Id>();
        Set<Id> ssiIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        for (Task tk : tasks) {
            if(tk.WhatId != null){
                if(tk.WhatId.getSObjectType().getDescribe().getName() == 'Account'){
                    accIds.add(tk.WhatId);
                }else if(tk.WhatId.getSObjectType().getDescribe().getName() == UtilConstant.SSI){
                    ssiIds.add(tk.WhatId);
                }else if (tk.WhoId != null && tk.WhoId.getSObjectType().getDescribe().getName() == 'Contact') {
                    conIds.add(tk.WhoId);
                } 
            }  
        }

        Map<Id, Contact> conMap = new Map<Id, Contact>();
        if (conIds.size() > 0 ) {
            conMap = new  Map<Id, Contact>([Select AccountId From Contact Where Id In :conIds]);
            for (Contact cont: conMap.values()) {
                if (cont != null && cont.AccountId != null) {
                    accIds.add(cont.AccountId);
                }                
            }
        }

        Map<Id, Account> accMap = new Map<Id, Account>();
        Map<Id, SSI__c> ssiMap = new Map<Id, SSI__c>();
        if (accIds.size() > 0) {
            accMap = new Map<Id, Account>([Select Newly_Task_Id__c From Account Where Id In :accIds]);
        }
        if (ssiIds.size() > 0) {
            ssiMap = new Map<Id, SSI__c>([Select Newly_Task_Id__c From SSI__c Where Id In :ssiIds]);
        }

        for (Task tk : tasks) {
            if(accMap.containsKey(tk.WhatId)){
                tk.Related_Task_Id__c = accMap.get(tk.WhatId).Newly_Task_Id__c;
            }else if (ssiMap.containsKey(tk.WhatId)) {
                tk.Related_Task_Id__c = ssiMap.get(tk.WhatId).Newly_Task_Id__c;
            }else if (conMap.containsKey(tk.WhoId)) {
                Id relatedAccount = conMap.get(tk.WhoId).AccountId;
                if (relatedAccount != null && accMap.containsKey(relatedAccount)) {
                    tk.Related_Task_Id__c = accMap.get(relatedAccount).Newly_Task_Id__c;
                }                
            }
            if(tk.Related_Task_Id__c != null && tk.Related_Task_Id__c.length() >= 15) {
                tk.Related_Task_Id__c = tk.Related_Task_Id__c.subString(0, 15);
            }

        }

        Set<String> relIds = new Set<String>();
        for (Task tk : tasks) {
            if(tk.Related_Task_Id__c != null && tk.Related_Task_Id__c.length() >= 15){
                relIds.add(tk.Related_Task_Id__c);
            }
        }    

        /* TODO FL Campaign_Survey_Result__c not available in Kernel
        Map<Id, Campaign_Survey_Result__c> csrMap = new Map<Id, Campaign_Survey_Result__c>();
        if (relIds.size() > 0) {
            for (Campaign_Survey_Result__c csr : [Select Id, TaskId__c From Campaign_Survey_Result__c Where TaskId__c In :relIds]) {
                csrMap.put(csr.TaskId__c, csr);
            }
        }
        for (Task tk : tasks) {
            if (csrMap.containsKey(tk.Related_Task_Id__c)) {
                tk.Survey_Result_Id__c = csrMap.get(tk.Related_Task_Id__c).Id;
            }
        }
        */

    }
    
    @TestVisible private static void autoUpdateSSITask(Set<Task> tasks){
        Set<Id> ssiIds = new Set<Id>();

        for (Task tk : tasks ) {
            if(tk.WhatId.getSObjectType().getDescribe().getName() == 'SSI__c'){
                    ssiIds.add(tk.WhatId);
                }
        }        

        if (ssiIds.size() > 0) {
            Map<Id, SSI__c> ssiMap = new Map<Id, SSI__c>([Select Name, DealerName__c, CustomerName__c From SSI__c Where Id In :ssiIds]);
            for (Task tk : tasks) {
                if (ssiMap.containsKey(tk.WhatId)) {
                    SSI__c ssi = ssiMap.get(tk.whatId);
                    tk.SSI_Number__c = ssi.Name;
                    tk.Dealer_Name__c = ssi.DealerName__c;
                    tk.CustomerName__c = ssi.CustomerName__c;
                }
            }
        }
    }
    
    public static void autoUpdateSSISurveyStatus(Task tk, Task old){
        getRecordTypeId();
        if(tk.RecordTypeId == SSIRTID && tk.Status == UtilConstant.CLOSED && old.Status != UtilConstant.CLOSED &&
            (tk.Subject == WELAND1STSURVEY || tk.Subject == X1STSURVEY || tk.Subject == X2NDSURVEY)){
            updateSSISurveyStatus(tk.WhatId, tk.Subject);   
        }
    }
    
    @testVisible private static void updateSSISurveyStatus(Id ssiId, String subject){
        if(ssiId!=null && ssiId.getSObjectType() == SSI__c.getSObjectType()){
            SSI__c ssi = [Select Id, Survey_Finished__c From SSI__c Where Id = :ssiId];
            ssi.Survey_Finished__c = subject == X2NDSURVEY?'2nd Survey':'1st Survey';
            try{
                update ssi;   
            }catch(Exception ex){
              System.debug('errormessage>>' + ex.getmessage());}
        }
    }

    public static void autoUpdateAccountOBTaskMessage(List<Task> tList){
        getRecordTypeId();
        Map<Id, Task> updateMap = new Map<Id, Task>();
        for(Task tk : tList)
        {
            if(tk.RecordTypeId == OBTRTID && tk.WhatId != null 
                    && tk.WhatId.getSObjectType().getDescribe().getName() == 'Account'){
                if(!updateMap.containsKey(tk.WhatId)){
                    updateMap.put(tk.WhatId, tk);
                }                
            }
        }
    
        if(!updateMap.isEmpty()){
            Map<Id, Account> accounts = new Map<Id, Account>([
                Select Id, Last_OB_Task_Create_Date__c 
                From Account
                Where Id = :updateMap.keySet()]);

            List<Account> updateAccounts = new List<Account>();

            for(Task tk : tList){
                if(tk.RecordTypeId == OBTRTID && tk.WhatId != null && accounts.containsKey(tk.WhatId)){
                    Account acc = accounts.get(tk.WhatId);
                    acc.Last_OB_Task_Create_Date__c = tk.CreatedDate.date();
                    updateAccounts.add(acc);
                }
            }

            if(updateAccounts.size() > 0 ){
                update updateAccounts;    
            }
        }
    }
}