/*
    Type:       Utility for TriggerTask.trigger
    Purpose:    Update queried campaign member status by WhatId and WhoId
    User Story: US-Cpn-026
    Used By:    TriggerTask.trigger
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-07-12
*/
public class UtilTask {
    // Task Record Type Name
    private final static String TASK_RT_SMS = 'SMS';
    private final static String TASK_RT_EDM = 'eDM';
    private final static String TASK_RT_DM = 'DM';
    private final static String TASK_RT_OB = 'OB Task';

    // Campaign Member Status
    private final static String CM_STATUS_LEAD = 'Lead';
    private final static String CM_STATUS_PARTICIPATED = 'Participated';
    private final static String CM_STATUS_REGISTERED = 'Registered';
    private final static String CM_STATUS_RESPONDED = 'Responded';
    private final static String CM_STATUS_SENT = 'Sent';
    private final static String CM_STATUS_FAILED_NO_RESPONSE = 'Failed/No Response';
    private final static String CM_STATUS_DECLINE = 'Decline';
    private final static String CM_STATUS_RESPONDED1 = '응답함';
    private final static String CM_STATUS_SENT1 = '발송함';
    private final static String CM_STATUS_FAILED_NO_RESPONSE1 = '실패/응답 없음';
    private final static String CM_STATUS_DECLINE1 = '거절';

    // Campaign Member Status Priority Map
    private final static Map<String, Integer> CM_STATUS_PRIORITY = 
        new Map<String, Integer> {
            CM_STATUS_LEAD => 6,
            CM_STATUS_PARTICIPATED => 5,
            CM_STATUS_REGISTERED => 4,
            CM_STATUS_RESPONDED => 3,
            CM_STATUS_RESPONDED1 => 3,
            CM_STATUS_DECLINE => 2,
            CM_STATUS_SENT => 1,
            CM_STATUS_FAILED_NO_RESPONSE => 0,
            CM_STATUS_DECLINE1 => 2,
            CM_STATUS_SENT1 => 1,
            CM_STATUS_FAILED_NO_RESPONSE1 => 0
        };

    private final static Map<String, String> TASK_STATUS_TO_CM_STATUS = 
        new Map<String, String> {
            // SMS Task
            TASK_RT_SMS + 'Need Verification' => CM_STATUS_SENT,
            TASK_RT_SMS + 'Sent' => CM_STATUS_SENT,
            TASK_RT_SMS + 'Success' => CM_STATUS_RESPONDED,
            TASK_RT_SMS + 'Fail-Technical' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_SMS + 'Fail-Content' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_SMS + 'Fail-Blacklist' => CM_STATUS_FAILED_NO_RESPONSE,

            // eDM Task
            TASK_RT_EDM + 'Pending' => CM_STATUS_SENT,
            TASK_RT_EDM + 'Open' => CM_STATUS_RESPONDED,
            TASK_RT_EDM + 'Click' => CM_STATUS_RESPONDED,
            TASK_RT_EDM + 'Subscribe' => CM_STATUS_REGISTERED,
            TASK_RT_EDM + 'Unsubscribe' => CM_STATUS_DECLINE,
            TASK_RT_EDM + 'Hard Bounced' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_EDM + 'Soft Bounced' => CM_STATUS_FAILED_NO_RESPONSE,

            // DM Task
            TASK_RT_DM + 'Open' => CM_STATUS_SENT,
            TASK_RT_DM + 'Returned' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_DM + 'Sent' => CM_STATUS_SENT,
            TASK_RT_DM + 'Failed' => CM_STATUS_FAILED_NO_RESPONSE,

            // OB Task
            TASK_RT_OB + 'not started' => CM_STATUS_SENT,
            TASK_RT_OB + 'no answer' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'need call back' => CM_STATUS_SENT,
            TASK_RT_OB + 'busy' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'reject' => CM_STATUS_DECLINE,
            TASK_RT_OB + 'wrong number' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'no such person' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'invalid data' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'reservation' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'Successful' => CM_STATUS_RESPONDED,
            TASK_RT_OB + 'invalid call' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'Language Issue' => CM_STATUS_FAILED_NO_RESPONSE,
            TASK_RT_OB + 'not started' => CM_STATUS_SENT1,
            TASK_RT_OB + 'no answer' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'need call back' => CM_STATUS_SENT1,
            TASK_RT_OB + 'busy' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'reject' => CM_STATUS_DECLINE1,
            TASK_RT_OB + 'wrong number' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'no such person' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'invalid data' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'reservation' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'Successful' => CM_STATUS_RESPONDED1,
            TASK_RT_OB + 'invalid call' => CM_STATUS_FAILED_NO_RESPONSE1,
            TASK_RT_OB + 'Language Issue' => CM_STATUS_FAILED_NO_RESPONSE1
        };

    public static void updateCampaignMemberStatus(List<Task> tasks) {
        Set<Id> camIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Map<String, Task> taskMap = new Map<String, Task>();

        // Get TASK Record Type Map
        Map<Id, RecordType> taskRecordTypeMap = new Map<Id, RecordType>(
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Task']
        );

        for (Task task : tasks) {
            if (task.RecordTypeId == null) continue;
            String taskRecordTypeName = taskRecordTypeMap.get(task.RecordTypeId).Name;

            // We only need to process the task which status is in scope
            Set<String> taskStatusInScope = TASK_STATUS_TO_CM_STATUS.keySet();
            if (taskStatusInScope.contains(taskRecordTypeName + task.Activity_Status__c)) {
                camIds.add(task.WhatId);
                contactIds.add(task.WhoId);
                String taskWhatId = task.WhatId;
                String taskWhoId = task.WhoId;
                taskMap.put(taskWhatId + taskWhoId, task);
            }
        }

        // Get all matched Member by WhatId and WhoId of tasks
        // Status must in range that has priority, 
        // not including user custom status
        List<CampaignMember> members = 
            [SELECT Status, CampaignId, ContactId FROM CampaignMember
             WHERE CampaignId IN :camIds
             AND ContactId IN :contactIds
             AND Status__c IN :CM_STATUS_PRIORITY.keySet()];

        // If more than one task is related to a campaign member, 
        // the Campaign Member Status will be updated following the priority as below 
        // (only higher priority can overwrite lower priority)
        Map<String, Integer> relatedTasksAmountMap = new Map<String, Integer>();
        List<Task> tasklst;
        if(!Test.isRunningTest()){
            tasklst =[SELECT Id, WhatId, WhoId FROM Task 
                              WHERE WhatId IN :camIds
                              AND WhoId IN :contactIds
                              AND RecordType.Name IN :new List<String> {
                              TASK_RT_SMS, TASK_RT_EDM, TASK_RT_DM, TASK_RT_OB} limit 10000];
        }else{
            tasklst =[SELECT Id, WhatId, WhoId FROM Task 
                              WHERE WhatId IN :camIds
                              AND WhoId IN :contactIds
                              AND RecordType.Name IN :new List<String> {
                              TASK_RT_SMS, TASK_RT_EDM, TASK_RT_DM, TASK_RT_OB}  limit 10000];
        }
        for (Task task : tasklst) {
            String taskWhatId = task.WhatId;
            String taskWhoId = task.WhoId;

            Integer count = relatedTasksAmountMap.get(taskWhatId + taskWhoId);
            if (count == null) {
                relatedTasksAmountMap.put(taskWhatId + taskWhoId, 1);
            }
            else {
                relatedTasksAmountMap.put(taskWhatId + taskWhoId, ++count);
            }
        }
        System.debug('Debug Output:updateCampaignMemberStatus relatedTasksAmountMap======> {' + relatedTasksAmountMap + '}');

        // Update Campaign Members
        List<CampaignMember> membersNeedToUpdate = new List<CampaignMember>();
        for (CampaignMember member : members) {
            // Get Related Task and Task RecordType Name by taskMap and member
            String camId = member.CampaignId;
            String contactId = member.ContactId;

            // Get the realted task amount
            Integer relatedTasksAmount = relatedTasksAmountMap.get(camId + contactId);

            // System.debug('-----------taskMap---------->' + taskMap);
            // System.debug('-----------camId + contactId---------->' + (camId + contactId));

            // Get the related task in trigger.new
            Task task = taskMap.get(camId + contactId);
            if (task == null) continue;
            // Sometimes, didn't know why record type id is null
            if (task.RecordTypeId == null) continue;
            String taskRecordTypeName = taskRecordTypeMap.get(task.RecordTypeId).Name;

            // Get the Member Status that is needed to assign
            String needAssignedMemberStatus = 
                TASK_STATUS_TO_CM_STATUS.get(taskRecordTypeName + task.Activity_Status__c);

            // Compare the Member Status in DB and the Member Status need to assign
            Integer existMemberStatusPriority = CM_STATUS_PRIORITY.get(member.Status);
            Integer needAssignedMemberStatusPriority = 
                CM_STATUS_PRIORITY.get(needAssignedMemberStatus);

            // If more than one related task, 
            // and the Exist Member Status Priority is greeter than that need to assign
            // Just continue
            if (relatedTasksAmount > 1 && existMemberStatusPriority != null 
                    && existMemberStatusPriority >= needAssignedMemberStatusPriority) {
                continue;
            }

            member.Status = needAssignedMemberStatus;
            member.Status__c = needAssignedMemberStatus;
            membersNeedToUpdate.add(member);
        }

        try {
            System.debug('Debug Output membersNeedToUpdate======> {' + membersNeedToUpdate + '}');
            update membersNeedToUpdate;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('UtilTask.updateCampaignMemberStatus DML Exception: ' + e);
        }
    }
}