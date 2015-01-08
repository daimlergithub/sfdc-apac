/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-2-21 Created By Justin Yu
*/
public class InteractiveSMSController {
    
    public static String ibCallTask_RecordTypeId = '01290000000rXmdAAE';
    public static String smsTask_RecordTypeId = '01290000000rXmgAAE';
    private static Set<String> templateRecordTypeIds = new Set<String>{'01290000000rXmlAAE', '012N0000000CvrmIAC'};
    
    public InteractiveSMSController(){
        startTask = new Task();
        endTask = new Task();
        startTask.Activity_Date__c = System.today().addDays(-1); // As the start time
        endTask.Activity_Date__c = System.today(); // As the end time
        isExport = false;
    }
    
    public Task startTask { get; set; } // Uses the standard date field for displaying
    public Task endTask { get; set; } // Uses the standard date field for displaying
    public transient List<TaskInfo> taskInfos { get; set; }
    public Boolean isExport { get; set; }
    
    public void searchTaskInfos(){
        
        if(startTask.Activity_Date__c > endTask.Activity_Date__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.End_Time_Greater_Start_Time));
        }
        
        Datetime startTime = Datetime.newInstance(startTask.Activity_Date__c, Time.newInstance(0, 0, 0, 0));
        Datetime endTime = Datetime.newInstance(endTask.Activity_Date__c, Time.newInstance(23, 59, 59, 0));
        
        Map<String, SMSReplyHistory__c> firstReplyMap = getSMSReplies(startTime, endTime); // First SMS Task ID => First Replies
        if(firstReplyMap.size() == 0) return;
        Set<String> firstSMSTaskIds = firstReplyMap.keySet();
        Map<String, Task> firstSmsTaskMap = getFirstSmsTasks(firstSMSTaskIds); // IB Call Task ID => First SMS Task
        if(firstSmsTaskMap.size() == 0) return;
        Set<String> secondSMSTaskIds = new Set<String>();
        Map<String, Task> secondSmsTaskMap = getSecondSmsTasks(firstSMSTaskIds, secondSMSTaskIds); // First SMS Task ID => Second SMS Task
        Map<String, SMSReplyHistory__c> secondReplyMap = getSMSReplies(secondSMSTaskIds); // Second SMS Task ID = > Second Replies
        
        Set<String> whoIds = new Set<String>();
        Set<String> whatIds = new Set<String>();
        List<Task> ibCallTasks = new List<Task>();
        
        for(Task t : [Select Start_call_time__c, Subject, WhoId, WhatId, Phone__c, OwnerId, Owner.Name from Task 
                      where Id in :firstSmsTaskMap.keySet() and RecordTypeId = '01290000000rXmdAAE' order by Start_call_time__c desc]){
            if(t.WhatId != null && String.valueOf(t.WhatId).startsWith('500')){
                ibCallTasks.add(t);
                whoIds.add(t.WhoId);
                whatIds.add(t.WhatId);
            }
        }
        
        whoIds.remove(null);
        whatIds.remove(null);
        
        // Finds the account information
        Map<String, Account> personAccounts = new Map<String, Account>();
        for(Account acc : [select Name, PersonContactId, PersonHomePhone, PersonMobilePhone, Region__c, MB_Sub_Region__c, Smart_Sub_Region__c 
                            from Account where Id in (select AccountId from Contact where Id In :whoIds)]){
            personAccounts.put(acc.PersonContactId, acc);
        }
        
        // Finds the case information for each task
        Map<String, Case> cases = new Map<String, Case>([select CaseNumber, RecordType.Name, Vehicle_Class__c, Repeat_Complaint_Times__c, Case_Type__c, 
                                                         Case_Class__c, Case_SubType__c from Case where Id in :whatIds]);
        
        taskInfos = getTaskInfos(ibCallTasks, personAccounts, cases, firstSmsTaskMap, firstReplyMap, secondSmsTaskMap, secondReplyMap);
    }
    
    public PageReference exportData(){
        isExport = true;
        searchTaskInfos();
        return null;
    }
    
    private Map<String, SMSReplyHistory__c> getSMSReplies(Datetime startTime, Datetime endTime){
        Map<String, SMSReplyHistory__c> result = new Map<String, SMSReplyHistory__c>();
        List<SMSReplyHistory__c> replies = new List<SMSReplyHistory__c>();
        if(isExport){
            replies = [select TaskID__c, SMSCode__c, SMSContent__c, Template__c, Template__r.RecordTypeId
                        from SMSReplyHistory__c 
                        where RespondTime__c >= :startTime and RespondTime__c <= :endTime and IsFirstValid__c = true];
        }
        else{
            replies = [select TaskID__c, SMSCode__c, SMSContent__c, Template__c, Template__r.RecordTypeId
                        from SMSReplyHistory__c 
                        where RespondTime__c >= :startTime and RespondTime__c <= :endTime and IsFirstValid__c = true limit 100];
        }
        for(SMSReplyHistory__c reply : replies){
            if(reply.Template__c != null && templateRecordTypeIds.contains(reply.Template__r.RecordTypeId)){
                result.put(reply.TaskID__c, reply);
            }
        }
        result.remove(null);
        return result;
    }
    
    private Map<String, SMSReplyHistory__c> getSMSReplies(Set<String> taskIds){
        Map<String, SMSReplyHistory__c> result = new Map<String, SMSReplyHistory__c>();
        taskIds.remove(null);
        if(taskIds.size() > 0){
            for(SMSReplyHistory__c reply : [select TaskID__c, SMSCode__c, SMSContent__c from SMSReplyHistory__c where TaskID__c in :taskIds]){
                result.put(reply.TaskID__c, reply);
            }
        }
        result.remove(null);
        return result;
    }
    
    private Map<String, Task> getFirstSmsTasks(Set<String> ids){
        Map<String, Task> result = new Map<String, Task>();
        ids.remove(null);
        if(ids.size() > 0){
            for(Task t : [select Related_Task_Id__c, CreatedDate, Subject, Activity_Status__c from Task where Id in :ids]){
                result.put(t.Related_Task_Id__c, t);
            }
        }
        result.remove(null);
        return result;
    }
    
    private Map<String, Task> getSecondSmsTasks(Set<String> ids, Set<String> secondSMSTaskIds){
        Map<String, Task> result = new Map<String, Task>();
        ids.remove(null);
        if(ids.size() > 0){
            for(Task t : [select Related_Task_Id__c, CreatedDate, Subject, Activity_Status__c from Task where Related_Task_Id__c in :ids]){
                result.put(t.Related_Task_Id__c, t);
                secondSMSTaskIds.add(t.Id);
            }
        }
        return result;
    }
    
    private List<TaskInfo> getTaskInfos(List<Task> ibCallTasks, Map<String, Account> personAccounts, Map<String, Case> cases,
                                        Map<String, Task> firstSmsTasks, Map<String, SMSReplyHistory__c> firstReplies,
                                        Map<String, Task> secondSmsTasks, Map<String, SMSReplyHistory__c> secondReplies){
        List<TaskInfo> taskInfos = new List<TaskInfo>();
        for(Task task : ibCallTasks){
            TaskInfo taskInfo = new TaskInfo();
            taskInfo.ibCallTask = task;
            taskInfo.relatedAccount = personAccounts.get(task.WhoId);
            taskInfo.relatedCase = cases.get(task.WhatId);
            taskInfo.firstSMSTask = firstSmsTasks.get(task.Id);
            taskInfo.firstReply = firstReplies.get(taskInfo.firstSMSTask.Id);
            taskInfo.secondSMSTask = secondSmsTasks.get(taskInfo.firstSMSTask.Id);
            taskInfo.secondReply = taskInfo.secondSMSTask != null ? secondReplies.get(taskInfo.secondSMSTask.Id) : null;
            taskInfos.add(taskInfo);
        }
        return taskInfos;
    }
    
    /**
     * Innser Class
     */
    public class TaskInfo{
        public Task ibCallTask { get; set; }
        public Account relatedAccount { get; set; }
        public Case relatedCase { get; set; }
        public Task firstSMSTask { get; set; }
        public Task secondSMSTask { get; set; }
        public SMSReplyHistory__c firstReply { get; set; }
        public SMSReplyHistory__c secondReply { get; set; }
       
        public String startCallTime{
            get{
                if(ibCallTask.Start_Call_Time__c == null){ return ''; }
                return ibCallTask.Start_Call_Time__c.format('yyyy/MM/dd HH:mm:ss');
            }
        }
        
        public String firstSendTime{
            get{
                return firstSMSTask == null ? null : firstSMSTask.CreatedDate.format('yyyy/MM/dd HH:mm:ss');
            }
        }
        
        public String secondSendTime{
            get{
                return secondSMSTask == null ? null : secondSMSTask.CreatedDate.format('yyyy/MM/dd HH:mm:ss');
            }
        }
        
        public String accountPhone{
            get{
                if(relatedAccount == null){ return ''; }
                return relatedAccount.PersonMobilePhone == null ? relatedAccount.PersonHomePhone : relatedAccount.PersonMobilePhone;
            }
        }
    }
}