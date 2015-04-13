/*
    Type:       Trigger
    Purpose:    Task Fail Blacklist
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
    
    Type:       Trigger
    Purpose:    Auto create multiple QC records when task.QC Quantity is updated with a number.
    User Story: US-QC-015
    Used By:
    ---------------------------------------------------------------
    History:
    
    07-April-2013 Sinow Zhang (NTTData)  Created
    03-May-2013 Chris Huang (Breakingpoint) Updated add auto update account message after outbound call shut down
    17-June-2013 Chris Huang (Breakingpoint) Updated add auto update task call times after interaction log inserted.
    16-July-2013 Sinow Zhang (NTTData) Update related case's voice record link when InteractionIds not equals null. US-DPCR-005
    2014-03-17 updated by Justin Yu
    
    Type:       Trigger
    Purpose:    1. Auto create QC records when task.Generate QC is changed to true.
                2. Auto update task's campaign name when this task related to an campaign
                3. Auto create a SMS task record when a task insert.
    User Story: US-QC-002, US-QC-001, US-SMSS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Sinow Zhang (NTTData)  Created
    03-May-2013 Chris Huang (Breakingpoint) Update Add task fields auto update function   
    07-June-2013 Sinow Zhang (NTTData) Update Add task  ib call type field auto update function
    2014-03-04 updated by Justin Yu
    
     Type:       Trigger for Task
    Purpose:    Update queried campaign member status by WhatId and WhoId
    User Story: US-Cpn-026
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-07-12
*/
trigger TaskTrigger on Task (after update, after insert,before update, before insert) {
    
    
    if(trigger.isAfter && trigger.isInsert)
    {
        if(UtilCustomSettings.isEnabled('TaskFailBlacklistTrigger'))
            TaskHelper.TaskFailBlacklist(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
        //  
        if(UtilCustomSettings.isEnabled('TriggerTask'))
            TaskHelper.updateCampaignMemberStatus(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
        //  
        if(UtilCustomSettings.isEnabled('TaskAfterInsertUpdate'))
        {
            TaskTriggerHandler.updateAccountCallMessage(Trigger.newMap, Trigger.oldMap);
            TaskTriggerHandler.autoUpdateTaskAfterLogInserted(Trigger.new[0]);
            TaskTriggerHandler.autoUpdateAccountOBTaskMessage(Trigger.new);
            TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);     
        }   
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        if(UtilCustomSettings.isEnabled('TaskFailBlacklistTrigger'))
            TaskHelper.TaskFailBlacklist(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
        //
        if(UtilCustomSettings.isEnabled('TriggerTask'))
            TaskHelper.updateCampaignMemberStatus(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
        //  
        if(UtilCustomSettings.isEnabled('TaskAfterInsertUpdate'))
        {
            TaskTriggerHandler.updateAccountCallMessage(Trigger.newMap, Trigger.oldMap);
            TaskTriggerHandler.autoUpdateTaskAfterLogInserted(Trigger.new[0]);
            TaskTriggerHandler.autoUpdateSSISurveyStatus(Trigger.new[0], Trigger.old[0]);
            TaskTriggerHandler.generateWelcomeCall(Trigger.new[0], Trigger.old[0]);
            TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
        }   
    }
    if(trigger.isBefore && trigger.isInsert)
    {
         if (UtilCustomSettings.isEnabled('TaskBeforeInsertUpdate'))
         {
            // Update Activity Status after new records created
            TaskTriggerHandler.taskFieldsUpdate(Trigger.new, Trigger.oldMap);
            TaskHelper.Reply_TD_unsubscribeForeachSMScontent(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
            TaskHelper.FillintheCampaignNameBasedontheRelatedtoObject(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
         }
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
         if (UtilCustomSettings.isEnabled('TaskBeforeInsertUpdate'))
         {
            // Update Activity Status after new records created
            TaskTriggerHandler.taskFieldsUpdate(Trigger.new, Trigger.oldMap);
            TaskHelper.Reply_TD_unsubscribeForeachSMScontent(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
            TaskHelper.FillintheCampaignNameBasedontheRelatedtoObject(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
         }
    }
}