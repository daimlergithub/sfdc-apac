/*
    Type:       Apex Class
    Purpose:    Utility class to process misunderstood duplicate tasks
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    UtilCampaignTaskGenerationByAccount
                UtilCampaignTaskGenerationByCase
                UtilCampaignTaskGenerationByLeads
                UtilCampaignTaskGenerationByVehicle
    ---------------------------------------------------------------
    History:

    10-Oct-2013 Mouse Liu (Breakingpoint)    Created    
*/
public class MisunderstoodTaskGeneration {

    Id SMSRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    Id OBTASKRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    Id DMRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('DM').getRecordTypeId();
    Id EDMRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();

    // private Map<String, Campaign> taskUnique2CacCampaign = new Map<String, Campaign>();
    // private Map<Id, Campaign> whatId2CacCampaign = new Map<Id, Campaign>();
    public MisunderstoodTaskGeneration(List<Campaign> cams, Boolean isLead) {}
    // public MisunderstoodTaskGeneration(List<Campaign> cams, Boolean isLead) {
    //     // Populate the Task Unique Value List
    //     Set<Id> cacCampaignIds = new Set<Id>();
    //     if (isLead) {
    //         List<Campaign> camLeads = 
    //             [SELECT Id, ParentId 
    //              FROM Campaign 
    //              WHERE Id IN :cams];

    //         for (Campaign cp : camLeads) {
    //             cacCampaignIds.add(cp.ParentId);
    //         }

    //         for (Campaign_Lead__c cl : [SELECT Id, Campaign__r.ParentId, Campaign__c,
    //                                         Campaign__r.Parent.Task_De_dup_Range__c,
    //                                         (SELECT Id, UniqueCampaignGenerateTask__c FROM Tasks)
    //                                     FROM Campaign_Lead__c 
    //                                     WHERE Campaign__r.ParentId IN :cacCampaignIds]) {
    //             whatId2CacCampaign.put(cl.Id, cl.Campaign__r.Parent);
    //             for (Task ta : cl.Tasks) {
    //                 taskUnique2CacCampaign.put(ta.UniqueCampaignGenerateTask__c, 
    //                     cl.Campaign__r.Parent);
    //             }
    //         }
    //     }
    //     else {
    //         for (Campaign cp : [SELECT Id, ParentId FROM Campaign WHERE Id IN :cams]) {
    //             cacCampaignIds.add(cp.ParentId);
    //         }

    //         for (Campaign ca : [SELECT Id, ParentId, Parent.Task_De_dup_Range__c,
    //                                 (SELECT Id, UniqueCampaignGenerateTask__c FROM Tasks)
    //                             FROM Campaign WHERE ParentId IN :cacCampaignIds]) {
    //             whatId2CacCampaign.put(ca.Id, ca.Parent);
    //             for (Task ta : ca.Tasks) {
    //                 taskUnique2CacCampaign.put(ta.UniqueCampaignGenerateTask__c, ca.Parent);
    //             }
    //         }
    //     }
    // }

    public void processMisunderstoodTasks(Database.SaveResult[] srs, List<Task> taskList) {
        // Define misunderstood task list
        List<Task> missedTasks = new List<Task>();

        Set<String> misUniqueIds = new Set<String>();


        Map<String, Id> camSet = new Map<String, Id>();
        Map<String, Id> camLeadSet = new Map<String, Id>();

        Set<Id> misCamSet = new Set<Id>();
        Set<Id> misCamLeadSet = new Set<Id>();

        for (Integer i = 0; i < srs.size(); i++) {
            Database.SaveResult sr = srs[i];
            if (sr.isSuccess()) continue;
            if (sr.getErrors()[0].getStatusCode() == StatusCode.DUPLICATE_VALUE) {
                Task ta = taskList[i];
                if (ta.UniqueCampaignGenerateTask__c != null) {
                    misUniqueIds.add(ta.UniqueCampaignGenerateTask__c);
                }

                if (ta.WhatId != null) {
                    if (ta.WhatId.getSObjectType().getDescribe().getName() == 'Campaign') {
                        misCamSet.add(ta.WhatId);
                    }else {
                        misCamLeadSet.add(ta.WhatId);
                    }
                }
            }
        }

        if (misUniqueIds.size() > 0) {
            for (List<Task> tasks : [
                    SELECT Id, WhatId, What.Type, UniqueCampaignGenerateTask__c 
                    From Task 
                    Where (RecordTypeId = :OBTASKRT Or RecordTypeId = :SMSRT Or RecordTypeId = :EDMRT Or RecordTypeId = :DMRT) 
                        And (What.Type = 'Campaign' Or What.Type = 'Campaign_Lead__c') 
                        And UniqueCampaignGenerateTask__c In :misUniqueIds]) {
                for (Task ta : tasks) {
                    if (ta.What.Type == 'Campaign') {
                        camSet.put(ta.UniqueCampaignGenerateTask__c, ta.WhatId);
                    }else {
                        camLeadSet.put(ta.UniqueCampaignGenerateTask__c, ta.WhatId);
                    }
                 }
            }
        }

        Map<String, Campaign> taskUnique2CacCampaign = new Map<String, Campaign>();
        Map<Id, Campaign> taskCampaign = new Map<Id, Campaign>();

        if (camSet.size() > 0) {
            Map<Id, Campaign> camMap = new Map<Id, Campaign>([
                Select Id, ParentId, Parent.Task_De_dup_Range__c 
                From Campaign Where Id In :camSet.values()]);
            for (String key : camSet.keySet()) {
                Id camId = camSet.get(key);
                if (camMap.containsKey(camId) && camMap.get(camId).Parent != null) {
                    taskUnique2CacCampaign.put(key, camMap.get(camId).Parent);
                }
            }
        }

        if (misCamSet.size() > 0) {
            Map<Id, Campaign> misCamMap = new Map<Id, Campaign>([
                Select Id, ParentId, Parent.Task_De_dup_Range__c 
                From Campaign Where Id In :misCamSet]);

            for (Id misCamId : misCamSet) {
                taskCampaign.put(misCamId, misCamMap.get(misCamId).Parent);
            }
        }

        if (camLeadSet.size() > 0) {
            Map<Id, Campaign_Lead__c> camLeadMap = new Map<Id, Campaign_Lead__c>([
                Select Campaign__r.ParentId, Campaign__c, Campaign__r.Parent.Task_De_dup_Range__c 
                From Campaign_Lead__c Where Id In :camLeadSet.values()]);
            for (String key : camLeadSet.keySet()) {
                Id camLeadId = camLeadSet.get(key);
                if (camLeadMap.containsKey(camLeadId) && camLeadMap.get(camLeadId).Campaign__c != null && camLeadMap.get(camLeadId).Campaign__r.Parent != null) {
                    taskUnique2CacCampaign.put(key, camLeadMap.get(camLeadId).Campaign__r.Parent);
                }
            }
        }

        if (misCamLeadSet.size() > 0) {
            Map<Id, Campaign_Lead__c> misCamLeadMap = new Map<Id, Campaign_Lead__c>([
                Select Campaign__r.ParentId, Campaign__c, Campaign__r.Parent.Task_De_dup_Range__c 
                From Campaign_Lead__c Where Id In :misCamLeadSet]);

            for (Id misCamLeadId : misCamLeadSet) {
                taskCampaign.put(misCamLeadId, misCamLeadMap.get(misCamLeadId).Campaign__r.Parent);
            }
        }

        System.debug('--------taskUnique2CacCampaign-------->' + taskUnique2CacCampaign);
        System.debug('--------taskCampaign-------->' + taskCampaign);

        for (Integer i = 0; i < srs.size(); i++) {
            Database.SaveResult sr = srs[i];
            if (sr.isSuccess()) continue;
            if (sr.getErrors()[0].getStatusCode() == StatusCode.DUPLICATE_VALUE) {
                Task ta = taskList[i];
                if (taskUnique2CacCampaign.keySet().contains(ta.UniqueCampaignGenerateTask__c)) {
                    Campaign pa = taskUnique2CacCampaign.get(ta.UniqueCampaignGenerateTask__c);
                    Campaign dpa = taskCampaign.get(ta.WhatId);
                    System.debug('-------pa-------->' + pa);
                    System.debug('-------dpa-------->' + dpa);
                    if (pa.Task_De_dup_Range__c == 'By CAC Campaign' && pa == dpa) {
                        ta.UniqueCampaignGenerateTask__c += ta.WhatId;
                        missedTasks.add(ta);
                    }
                }
            }
        }

        System.debug('------missedTasks------->' + missedTasks);

        Database.insert(missedTasks, false);
        

    }
}