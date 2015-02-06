/*
    Type:       Trigger for Task
    Purpose:    Update queried campaign member status by WhatId and WhoId
    User Story: US-Cpn-026
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-07-12
*/
trigger TriggerTask on Task(after insert, after update) {
    if (!UtilCustomSettings.isEnabled('TriggerTask')) {
        return;
    }

    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerTask')) {
        return;
    }
    
    if (trigger.isAfter && trigger.isInsert) {
        // US-Cpn-026
        UtilTask.updateCampaignMemberStatus(trigger.new);
    }

    if (trigger.isAfter && trigger.isUpdate) {
        List<Task> tasks = new List<Task>();
        for (Task newTask : trigger.new) {
            Task oldTask = trigger.oldMap.get(newTask.Id);
            // US-Cpn-026
            if (oldTask.Activity_Status__c != newTask.Activity_Status__c) {
                tasks.add(newTask);
            }
        }

        // US-Cpn-026
        if (tasks.size() > 0) {
            UtilTask.updateCampaignMemberStatus(tasks);
        }
    }
}