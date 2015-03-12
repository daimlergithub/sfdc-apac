/*
    Type:       Trigger
    Purpose:    Create Task when campaign is active and recordtype = Campaign Execution  
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    28-May-2013 Stephano Shi (Breakingpoint)    Created
    23-Sept-2013 Tony Li (Breakingpoint)    Created
*/
trigger TriggerCampaign on Campaign (after insert, after update, before update) {
    if (!UtilCustomSettings.isEnabled('TriggerCampaign')) {
        return;
    }

    Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();    // Campaign Record Type MAP
    Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
    
    if(trigger.isAfter) {
        /* START Variable Definition    */
        Set<ID> cpIdSet = new Set<ID>();                                                                                // Campaign ID Set       
        List<Campaign> cpAccList = new List<Campaign>();                                                                // Campaign Exection List by Contact 
        List<Campaign> cpLeadList = new List<Campaign>();                                                               // Campaign Exection List by Lead 
        List<Campaign> cpVehicleList = new List<Campaign>();                                                            // Campaign Exection List by Vehicle
        List<Campaign> cpCaseList = new List<Campaign>();                                                               // Campaign Exection List by Case
        
        // Batch Job String Ids
        String cpAccIds = '';                                                                                           // Campaign Id String
        String cpLeadIds = '';
        String cpVehicleIds = '';
        String cpCaseIds = '';
        Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c='Pending');
        Batch_Job__c leadJob = new Batch_Job__c(Batch_Type__c='Lead', Status__c='Pending');
        Batch_Job__c vehJob = new Batch_Job__c(Batch_Type__c='Vehicle', Status__c='Pending');
        Batch_Job__c caseJob = new Batch_Job__c(Batch_Type__c='Case', Status__c='Pending');
        /* END Variable Definition  */
        
        /* START Iterate Campaign to relevant campaign list */
        for(Campaign cp : trigger.new) {
            // All Activated Campaign Execution
            if(cp.Create_Task__c && (Trigger.isUpdate && !trigger.oldMap.get(cp.Id).Create_Task__c) && 
                (cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId() || 
                cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId())) {
                
                if(cp.Task_Created_By__c == 'Contact') {
                    // Campaign Exection List by Contact 
                    cpAccList.add(cp); 
                    // Batch Job Ids String
                    cpAccIds = cpAccIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Lead') {
                    // Campaign Exection List by Lead
                    cpLeadList.add(cp);
                    // Batch Job Ids String
                    cpLeadIds = cpLeadIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Vehicle') {
                    // Campaign Exection List by Vehicle
                    cpVehicleList.add(cp);
                    // Batch Job Ids String
                    cpVehicleIds = cpVehicleIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Case') {
                    // Campaign Exection List by Case
                    cpCaseList.add(cp);
                    // Batch Job Ids String
                    cpCaseIds = cpCaseIds + ';' + String.valueof(cp.Id);
                }
            } else if (Trigger.isUpdate && cp.isActive && !trigger.oldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()) {
                // CAC Campaign List
                cpIdSet.add(cp.id);
                List<Campaign> childCmpList = new List<Campaign>(); 
                for(Campaign childCAC : [Select Id From Campaign Where ParentId=:cp.Id And isActive=false And RecordTypeId=:cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()]){
                    childCAC.isActive = true;
                    childCmpList.add(childCAC);
                }
                
                try{
                    update childCmpList;
                }catch(DmlException ex){
                    cp.addError('You can not activate a campaign without any execution.');
                }

            }
        }
        /* END Iterate Campaign to relevant campaign list */
        
        /* START Campaign Excution create task update */
        List<Campaign> cpExeList = new List<Campaign>();
        
        if(cpIdSet.size() > 0) {
            for(Campaign cpExe : [select id, Create_Task__c from Campaign where ParentId in :cpIdSet ]) {
                cpExeList.add(new Campaign(id = cpExe.Id, Create_Task__c = true));
            }
        }

        if(cpExeList.size() > 0) update cpExeList;
        /* END Campaign Excution create task update */
        
        System.debug('cpVehicleList >>>' + cpVehicleList);
            
        /* START Batch Execution */
        if(cpAccList.size() > 0) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpAccList), 200);
            accJob.Campaign_Set__c = cpAccIds;
            insert accJob;
        }
        
        if(cpLeadList.size() > 0) {         
            //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
            leadJob.Campaign_Set__c = cpLeadIds;
            if(leadJob!=Null){
             insert leadJob;       
            }  
        }
        if(cpVehicleList.size() > 0) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpVehicleList), 200); 
            vehJob.Campaign_Set__c = cpVehicleIds;
            insert vehJob; 
        }
        if(cpCaseList.size() > 0) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200); 
            caseJob.Campaign_Set__c = cpCaseIds;
            insert caseJob; 
        }
        /* END Batch Execution */
    }   
    
    if(trigger.isBefore && trigger.isUpdate){
        List<Campaign> cmpExes = new List<Campaign>();
        Id cmpExeReTpIdS = cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId();
        Id cmpExeReTpIdC = cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId();
        Set<Id> campaignIds = new Set<Id>();
        for(Campaign cp : trigger.new) {
            if (cp.isActive && !trigger.oldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()) {
                 campaignIds.add(cp.Id);
            }
        }
        
        Map<Id, Integer> CampaignCMPExes = new Map<Id, Integer>();
        for(Campaign cmp : [Select Id, ParentId from Campaign Where ParentId in :campaignIds And (RecordTypeId=:cmpExeReTpIdS Or RecordTypeId=:cmpExeReTpIdC)]) {
            if(!CampaignCMPExes.containsKey(cmp.ParentId)) {
                 CampaignCMPExes.put(cmp.ParentId, 0);
            }
            CampaignCMPExes.put(cmp.ParentId, CampaignCMPExes.get(cmp.ParentId) + 1);
        }
        
        for(Campaign cp : trigger.new) {
            if (cp.isActive && !trigger.oldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()) {
                if(CampaignCMPExes.get(cp.Id) < 1){
                    cp.addError('You can not activate a campaign without any execution.');
                }                
            }
        }
    }
    if(trigger.isAfter && trigger.isUpdate){
        List<Id> cpSIds = new List<Id>();
        List<Task> taskSMS = new List<Task>();
        Id tkRecTpId = tkRecordTypeMap.get('SMS').getRecordTypeId();
        
        for(Integer j=0; j<trigger.new.size(); j++){
            if(trigger.new[j].SMS_Task_Verified__c != trigger.old[j].SMS_Task_Verified__c && trigger.new[j].SMS_Task_Verified__c == true){
                cpSIds.add(trigger.new[j].Id);
            }
        }

        List<Campaign> cpExes = [SELECT Id, SMS_Task_Verified__c, Parent.Repeated_Campaign__c FROM Campaign WHERE Id in :cpSIds AND Parent.Repeated_Campaign__c = true];
        for(Campaign cpe : cpExes){
            cpe.SMS_Task_Verified__c = false;
        }
        
        update cpExes;
    }
    
    /**
     * 2014-2-17 added by Justin for copying the status in the top level campaign to the OB campaign
     */
    if(trigger.isAfter && trigger.isInsert){
        
        Set<String> campaignIds = new Set<String>();
        for(Campaign campaign : trigger.new){
            if(campaign.Execution_Type__c == 'OB Call'){
                campaignIds.add(campaign.Id);
            }
        }
        
        CampaignHelper.copyTopCampaignStatusValueToSavedCampaign(campaignIds);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        Id pIdDealerUser = null;
        Id pIdDealerAdmin = null;
        for (Profile pro : [select Id, Name from Profile where Name = 'Dealer Community User' or Name = 'Dealer Community Delegate Admin']) {
            if (pro.Name == 'Dealer Community User') {
                pIdDealerUser = pro.Id;
            } else {
                pIdDealerAdmin = pro.Id;
            }
        }
        
        Id rtIdMbBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
        Id rtIdSmartBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId();
        Id rtIdSmEvent = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event BMBS Campaign').getRecordTypeId();
        Id rtIdSmMedia = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media BMBS Campaign').getRecordTypeId();
        Id rtIdAs = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS BMBS Campaign').getRecordTypeId();
        Set<Id> cpnRtIds = new Set<Id>{rtIdMbBp, rtIdSmartBp, rtIdSmEvent, rtIdSmMedia, rtIdAs};
        
        Set<Id> cpnIds = new Set<Id>();
        Set<Id> dealerIds = new Set<Id>();
        Map<Id, String> cpnPermSetMap = new Map<Id, String>();
        Map<Id, Set<Id>> cpnDealerMap = new Map<Id, Set<Id>>();
        List<CampaignShare> cpnShares = new List<CampaignShare>();
        List<Task> taskList = new List<Task>();
        Set<Id> mbBpCampaignIds = new Set<Id>();
        Map<Id, Id> dealerBrandOwnerIds = new Map<Id, Id>();
        String pSetAsRetail = 'AS_Retail_Campaign';
        String pSetSmRetail = 'S_M_Retail_Campaign';
        String pSetBp = 'Best_Practise';
        
        for(Campaign cpNew : trigger.new) {
            if (cpnRtIds.contains(cpNew.RecordTypeId) && cpNew.Status == 'Published' && trigger.oldMap.get(cpNew.Id).Status != 'Published') {
                cpnIds.add(cpNew.Id);
                if (cpNew.RecordTypeId == rtIdAs) {
                    cpnPermSetMap.put(cpNew.Id, pSetAsRetail);
                } else if (cpNew.RecordTypeId == rtIdSmEvent || cpNew.RecordTypeId == rtIdSmMedia) {
                    cpnPermSetMap.put(cpNew.Id, pSetSmRetail);
                } else {
                    cpnPermSetMap.put(cpNew.Id, pSetBp);
                }
                if (cpNew.RecordTypeId == rtIdMbBp) {
                    mbBpCampaignIds.add(cpNew.Id);
                }
            }
        }
        
        if (cpnIds.size() == 0) {
            return;
        }
        
        for (Participating_Dealer__c pd : [Select Campaign__c, Dealer__c, Dealer__r.Retail_MB_Owner__c from Participating_Dealer__c Where Campaign__c In :cpnIds]) {
            if (cpnDealerMap.get(pd.Campaign__c) == null) {
                cpnDealerMap.put(pd.Campaign__c, new Set<Id>());
            }
            cpnDealerMap.get(pd.Campaign__c).add(pd.Dealer__c);
            dealerIds.add(pd.Dealer__c);
            if (pd.Dealer__r.Retail_MB_Owner__c != null) {
                dealerBrandOwnerIds.put(pd.Dealer__c, pd.Dealer__r.Retail_MB_Owner__c);
            }
        }
        
        for (User u : [select Id, ProfileId, AccountId, ContactId, Contact.Permission_Set_Settings__c from User where AccountId in :dealerIds and isActive = true and (ProfileId = :pIdDealerAdmin or (ProfileId = :pIdDealerUser and Contact.Permission_Set_Settings__c includes(:pSetAsRetail, :pSetSmRetail, :pSetBp)))]) {
            for (Id cpnId : cpnIds) {
                if (cpnDealerMap.get(cpnId) != null && cpnDealerMap.get(cpnId).contains(u.AccountId) && (u.ProfileId == pIdDealerAdmin || (u.Contact.Permission_Set_Settings__c != null && u.Contact.Permission_Set_Settings__c.contains(cpnPermSetMap.get(cpnId))))) {
                    CampaignShare share = new CampaignShare();
                    share.CampaignAccessLevel = 'Read';
                    share.CampaignId = cpnId;
                    share.UserOrGroupId = u.id;
                    cpnShares.add(share);
                    taskList.add(new Task(
                        Subject= 'You have new joint marketing activities to participate in.', 
                        RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId(),
                        OwnerId = u.id,
                        Status = 'open',
                        WhoId = u.ContactId,
                        WhatId = cpnId,
                        ActivityDate = date.today()));
                }
            }
        }
        
        for (Id cpnId : mbBpCampaignIds) {
            if (cpnDealerMap.get(cpnId) != null) {
                for (Id dealerId : cpnDealerMap.get(cpnId)) {
                    if (dealerBrandOwnerIds.get(dealerId) != null) {
                        CampaignShare share = new CampaignShare();
                            share.CampaignAccessLevel = 'Read';
                            share.CampaignId = cpnId;
                            share.UserOrGroupId = dealerBrandOwnerIds.get(dealerId);
                            cpnShares.add(share);
                    }
                }
            }
        }
        
        // Insert sharing records
        if (cpnShares.size() > 0) {
            try {
                insert cpnShares;
            } catch (DMLException e) {
                System.debug('DMLException Exception occured when sharing Campaign to Participating Dealer: ' + e);
            }
        }
        if(taskList.size() > 0){
            try {
                insert taskList;
            }
            catch(Exception ex) {
                System.debug('Exception message is :' + ex.getMessage());
            }
        }
    }
}