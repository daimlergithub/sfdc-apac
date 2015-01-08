/*
    Type:       Utility for Retail Campaign trigger
    Purpose:    1.  Release1.2 Qulification Process
    User Story: Release1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2014-06-05
*/
public class RetailCampaignHelper {

    public static void updateParentCampaignStatus(Set<Id> campaignIds) {
        List<Campaign> ParentCampaigns = new List<Campaign>();
        
        for(Campaign cam : [select Id, Status from Campaign where Id in :campaignIds]) {
            cam.Status = 'Closed';
            ParentCampaigns.add(cam);
        }
        
        try {
            update ParentCampaigns;
        }
        catch(Exception ex) {
            System.debug('Exception message is :' + ex.getMessage());
        }
    }
    
    public static void updateParentCampaignQuarter(Set<Id> campaignIds) {
        List<Campaign> ParentCampaigns = new List<Campaign>();
        
        for(Campaign cam : [select Id, BP_Quarter__c from Campaign where Id in :campaignIds]) {
            cam.BP_Quarter__c = cam.BP_Quarter__c >=0 ? cam.BP_Quarter__c + 1 : 1;
            ParentCampaigns.add(cam);
        }
        
        try {
            update ParentCampaigns;
        }
        catch(Exception ex) {
            System.debug('Exception message is :' + ex.getMessage());
        }
    }
    public static Task generateTask(User user ,Retail_Campaign__c rc,String strSubject) {
    Map<String, Schema.RecordTypeInfo> RecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
    return   new Task(
                Subject= strSubject, 
                RecordTypeId = RecordTypeMap.get('General Task').getRecordTypeId(),
                OwnerId = user.ContactId,
                Status = 'open',
                WhoId = user.id,
                WhatId = rc.id,
                ActivityDate = rc.Y_Apply_Deadline__c.addDays(-3));
    }
    
    // Added by Cyril.[To generate High Priority Task]
    public static Task generateHighPrioTask(User user ,Retail_Campaign__c rc,String strSubject) {
    Map<String, Schema.RecordTypeInfo> RecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
    return   new Task(
                Subject= strSubject, 
                RecordTypeId = RecordTypeMap.get('General Task').getRecordTypeId(),
                OwnerId = user.ContactId,
                Status = 'open',
                Priority = '高',
                WhoId = user.id,
                WhatId = rc.id,
                ActivityDate = rc.Y_Apply_Deadline__c.addDays(-3));
    }
}