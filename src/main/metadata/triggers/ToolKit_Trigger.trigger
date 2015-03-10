trigger ToolKit_Trigger on Tool_Kit__c (after insert, after update, after delete) {


    if (!UtilCustomSettings.isEnabled('ToolKitAfterInsertUpdateDelete')) {
        return;
    }
    
    Map<Id, Id> tkVandorMap = new Map<Id, Id>();
    Set<Id> vandorIds = new Set<Id>();
    Map<Id, Id> vandorContactMap = new Map<Id, Id>();
    List<Tool_Kit__Share> tkShares = new List<Tool_Kit__Share>();
    List<Task> taskList = new List<Task>();
    Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
    Id eventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
    
    // When new or update tool kit, share it to Vendor
    if (trigger.isInsert || trigger.isUpdate) {
        for(Tool_Kit__c tkNew : Trigger.new) {
            if (tkNew.RecordTypeId == eventTK || tkNew.Vendor_Employee__c == null || (trigger.isUpdate && tkNew.Vendor_Employee__c == trigger.oldMap.get(tkNew.id).Vendor_Employee__c)) {
                continue;
            }
            tkVandorMap.put(tkNew.Id, tkNew.Vendor_Employee__c);
            vandorIds.add(tkNew.Vendor_Employee__c);
        }
    }
    
    // Get contact Ids
    for (User u : [select Id, ContactId from User where isActive = true and Id in :vandorIds]) {
        vandorContactMap.put(u.Id, u.ContactId);
    }
    
    // Create sharing records and Tasks
    for (Id tkId : tkVandorMap.keySet()) {
        // Create Tool Kit sharing records
        Tool_Kit__Share share = new Tool_Kit__Share();
        share.AccessLevel = 'Edit';
        share.ParentId = tkId;
        share.RowCause = Schema.Tool_Kit__Share.RowCause.Manual;
        share.UserOrGroupId = tkVandorMap.get(tkId);
        tkShares.add(share);
        
        // Create notification Tasks
        taskList.add(new Task(
            Subject= 'You have new kit production needs', 
            RecordTypeId = taskRecordTypeMap.get('General Task').getRecordTypeId(),
            OwnerId = tkVandorMap.get(tkId),
            Status = 'open',
            WhoId = vandorContactMap.get(tkVandorMap.get(tkId)),
            WhatId = tkId,
            ActivityDate = date.today()));
    }
    
    // Insert sharing records
    if (tkShares.size() > 0) {
        try {
            insert tkShares;
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Tool Kit to Vendor: ' + e);
        }
    }
    
    // Insert notification Tasks
    if(taskList.size() > 0){
        try {
            insert taskList;
        }
        catch(Exception ex) {
            System.debug('DMLException Exception occured when creating Task for Vendor: ' + ex.getMessage());
        }
    }
    
    // When delete or update tool kit, delete old shared records from Vendor
    Map<Id, Id> tkVandorMapDel = new Map<Id, Id>();
    Set<Id> tkIdsDel = new Set<Id>();
    Set<Id> vendorIdsDel = new Set<Id>();
    List<Tool_Kit__Share> tkSharesDel = new List<Tool_Kit__Share>();
    
    // Get the shared Tool Kits
    if (trigger.isUpdate || trigger.isDelete) {
        for(Tool_Kit__c tkOld : Trigger.old) {
            if (tkOld.RecordTypeId == eventTK || tkOld.Vendor_Employee__c == null || (trigger.isUpdate && tkOld.Vendor_Employee__c == trigger.newMap.get(tkOld.id).Vendor_Employee__c)) {
                continue;
            }
            tkVandorMapDel.put(tkOld.Id, tkOld.Vendor_Employee__c);
            tkIdsDel.add(tkOld.Id);
            vendorIdsDel.add(tkOld.Vendor_Employee__c);
        }
    }
    
    // Get the old shared records
    for (Tool_Kit__Share tks : [select Id, ParentId, UserOrGroupId from Tool_Kit__Share where ParentId in :tkIdsDel and UserOrGroupId in :vendorIdsDel]) {
        if (tkVandorMapDel.get(tks.ParentId) == tks.UserOrGroupId) {
            tkSharesDel.add(tks);
        }
    }
    
    // Delete the old shared records
    if (tkSharesDel.size() > 0) {
        try {
            delete tkSharesDel;
        } catch (DMLException ex) {
            System.debug('DMLException Exception occured when deleting shared Tool Kit from Vendor: ' + ex.getMessage());
        }
    }

}