/*
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
*/
trigger TaskAfterInsertUpdate on Task (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('TaskAfterInsertUpdate')) {
        return;
    }

    List<Task> taskforGenerateQC = new List<Task>();
    Set<String> taskForSMSIds = new Set<String>();
    Map<String, Task> taskMapForSMS = new Map<String, Task>();
    Map<Id, String> caseIdInteractionIds = new Map<Id,String>();
    
    // Survey Successful, update account call message\generate wc task\update call times.
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){        
        TaskTriggerHandler.updateAccountCallMessage(Trigger.newMap, Trigger.oldMap);
        TaskTriggerHandler.autoUpdateTaskAfterLogInserted(Trigger.new[0]);

        if(Trigger.isInsert){
            TaskTriggerHandler.autoUpdateAccountOBTaskMessage(Trigger.new);
            
            for(Task t : Trigger.new) {
                if(t.Task_RecordType_Name__c == 'IB Call' && t.CallType  == 'Inbound' && t.Phone__c != null
                && t.IB_Status__c == 'valid' && t.UCID__c != null){
                    String phone = t.Phone__c;
                    if(phone.startsWith('1') && phone.length() == 11){
                        system.debug('--------Create sms task in Insert-');
                        //taskMapForSMS.put(t.Id, t);
                    }
                }
            }
        }

        if(Trigger.isUpdate){
            TaskTriggerHandler.autoUpdateSSISurveyStatus(Trigger.new[0], Trigger.old[0]);
            TaskTriggerHandler.generateWelcomeCall(Trigger.new[0], Trigger.old[0]);
            
            //US-DPCR-005
            for(Task t : Trigger.new) {
                if(t.InteractionIds__c != null && t.InteractionIds__c != '' && t.WhatId != null && String.valueOf(t.WhatId).startsWith('500') && t.Status == 'Closed') {
                    caseIdInteractionIds.put(t.whatId, t.InteractionIds__c);
                } 
                
                // Modified By Justin -- Creates a sms task after an IB call hungs   
                if(t.Task_RecordType_Name__c == 'IB Call' && t.CallType  == 'Inbound' && t.Phone__c != null
                && ((t.IB_Status__c == 'valid' && t.UCID__c != null && trigger.oldMap.get(t.Id).UCID__c == null)
                || (t.UCID__c != null && t.IB_Status__c == 'valid' && trigger.oldMap.get(t.Id).IB_Status__c != 'valid'))){
                    String phone = t.Phone__c;
                    if(phone.startsWith('1') && phone.length() == 11){
                        system.debug('--------Create sms task in update-');
                        taskMapForSMS.put(t.Id, t);
                    }
                }
            }
        }
    }
    
    for(Task t : Trigger.new) {
        //When QC Quantity is changed, insert IB/OB QC records.
        if(t.QC_Quantity__c > 0 && (Trigger.oldMap.get(t.Id).QC_Quantity__c == 0 || Trigger.oldMap.get(t.Id).QC_Quantity__c == null)) {
            taskforGenerateQC.add(t);
        }
    }
    
    if(taskforGenerateQC.size() > 0) {
        TaskHelper.GenerateMultipleQCs(taskforGenerateQC); 
    }
    
    if(caseIdInteractionIds.keySet().size() > 0) {
        TaskHelper.UpdateCaseVoiceRecordlink(caseIdInteractionIds);
    }
    
    //US-CTI-001
    if(Trigger.isInsert || Trigger.isUpdate) {
        Map<Id, String> taskIdUCIds = new Map<Id, String>();
        
        for(Task t : Trigger.new) {
            if(Trigger.isInsert && t.UCID__c != null && t.UCID__c != '' && (t.whatId != null || t.whoId != null)) {
                taskIdUCIds.put(t.Id, t.UCID__c);
            }
            if(Trigger.isUpdate && t.UCID__c != null && t.UCID__c != '' && t.UCID__c != Trigger.oldMap.get(t.ID).UCID__c && (t.whatId != null || t.whoId != null)) {
                taskIdUCIds.put(t.Id, t.UCID__c);
            }
        }
        
        if(taskIdUCIds.keySet().size() > 0) {
            TaskHelper.updateInteractionIds(taskIdUCIds);
        }
    }
    
    // US-SMSS-001 -- Moves here from before trigger by Justin -- create a sms task when an IB call hungs up.
    if(taskMapForSMS.size() > 0) {
        TaskHelper.createSMSTaskAfterIBCall(taskMapForSMS.values());
    }
    
    /**
     * 2014-3-17 Added by Justin Yu -- Set the Compelted Time field on QC.
     */
    Set<String> qcIds = new Set<String>();
    for(Task task : trigger.new){
        if(task.Activity_Status__c == 'Successful' && (!Trigger.isUpdate || Trigger.oldMap.get(task.Id).Activity_Status__c != 'Successful')){
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
    
    /**
     * 2014-04-11 Added by Justin Yu -- Set the Last Communication Modified Time field on QC.
     */
    String ibCallRecordTypeId = '01290000000rXmdAAE';
    String obCallRecordTypeId = '01290000000rXmeAAE';
    String ssiRecordTypeId = '01290000000rXmhAAE';
    String welcomeCallRecordTypeId = '01290000000rXmiAAE';
    String smartSSIRecordTypeId = '012N0000000CuGAIA0';
    
    Set<String> qcIdsInTask = new Set<String>();
    for(Task task : trigger.new){
        if((task.RecordTypeId == ibCallRecordTypeId || task.RecordTypeId == obCallRecordTypeId || task.RecordTypeId == ssiRecordTypeId ||
           task.RecordTypeId == welcomeCallRecordTypeId || task.RecordTypeId == smartSSIRecordTypeId) 
           && (!trigger.isUpdate || task.isClosed && !trigger.oldMap.get(task.Id).isClosed)){
            qcIdsInTask.add(task.QC_ID__c);
        }
    }
    
    if(qcIdsInTask.size() > 0){
        List<QC__c> updatedQCs = [select Last_Communication_Modified_Time__c from QC__c where Id in :qcIdsInTask];
        for(QC__c qc : updatedQCs){
            qc.Last_Communication_Modified_Time__c = System.now();
        }
        update updatedQCs;
    }
}