public with sharing class ParticipatingDealerHelper {
    
    public static void afterinsertUpdateDeleteEvents(list<Participating_Dealer__c> participatingDealerNew,list<Participating_Dealer__c> participatingDealerOld,map<id,Participating_Dealer__c> newMap,map<id,Participating_Dealer__c> oldMap,boolean isAfter,boolean isinsert,boolean isUpdate,boolean isDelete)
    {
        //Added community license switching mechanism
    	if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
    	{
	        if(isUpdate && isAfter)
	        {
	            List<Participating_Dealer__c> pdList = new List<Participating_Dealer__c>();
	            for(Participating_Dealer__c pd : participatingDealerNew) {
	                if(pd.Campaign_Package__c <> oldMap.get(pd.Id).Campaign_Package__c ||
	                    (pd.Campaign_Package__c <> null && 
	                    (pd.Session_Start_Date__c <> oldMap.get(pd.Id).Session_Start_Date__c ||
	                    pd.Session_End_Date__c <> oldMap.get(pd.Id).Session_End_Date__c))) {
	                    //insert new dealer offering items
	                    pdList.add(pd);
	                }
	            }
	            
	            if(pdList!=null && !pdList.IsEmpty())
	            {
	                List<Campaign_Package__c> cpPackageList = UtilDealerOffering.querycpPackageList(pdList);
	                UtilDealerOffering.DelDealerOfferingRecords(pdList);
	                UtilDealerOffering.InsertDealerOfferingRecords(pdList, cpPackageList);
	            }
	        }
	        
	        if(isDelete)
	        {
	            UtilDealerOffering.DelDealerOfferingRecords(participatingDealerOld);
	        }
	        
	        // Add Start Release1.2
	        // Get the Campaign Record Types
	        Id rtIdSmEvent = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
	        Id rtIdSmMedia = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media Central Campaign').getRecordTypeId();
	        Id rtIdAs = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
	        Id rtIdMbBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
	        Id rtIdSmartBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId();
	        
	        Set<Id> smCpnRtIds = new Set<Id>{rtIdSmEvent, rtIdSmMedia};
	        Set<Id> asCpnRtIds = new Set<Id>{rtIdAs};
	        Set<Id> bpCpnRtIds = new Set<Id>{rtIdMbBp, rtIdSmartBp};
	        Set<Id> cpnRtIds = new Set<Id>{rtIdSmEvent, rtIdSmMedia, rtIdAs, rtIdMbBp, rtIdSmartBp};
	        
	        String pSetAsRetail = 'AS_Retail_Campaign';
	        String pSetSmRetail = 'S_M_Retail_Campaign';
	        String pSetBp = 'Best_Practise';
	        
	        Id pIdDealerAdmin = UtilProfile.getProfileId('Dealer Delegate Admin');
	        Id pIdDealerUser = UtilProfile.getProfileId('Dealer Community User');
	        
	        // The values for sharing records
	        List<CampaignShare> cpnShares = new List<CampaignShare>();
	        Set<Id> cpnIds = new Set<Id>();
	        Set<Id> dealerIds = new Set<Id>();
	        Map<Id, Set<Id>> cpnDealerIds = new Map<Id, Set<Id>>();
	        Map<Id, String> cpnPermSetMap = new Map<Id, String>();
	        Map<Id, Id> dealerBrandownerMap = new Map<Id, Id>();
	        List<Task> taskList = new List<Task>();
	        Map<String, Schema.RecordTypeInfo> RecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
	        Set<Id> mbBpCampaignIds = new Set<Id>();
	        
	        // When new or update parecipating dealer, share it to related dealer
	        if (isInsert || isUpdate)
	        {
	            for(Participating_Dealer__c pdNew : participatingDealerNew)
	            {
	                if (isUpdate && pdNew.Campaign__c == oldMap.get(pdNew.id).Campaign__c && pdNew.Dealer__c == oldMap.get(pdNew.id).Dealer__c)
	                {
	                    continue;
	                }
	                
	                // Get campaign and dealer Ids
	                cpnIds.add(pdNew.Campaign__c);
	                if(!cpnDealerIds.containsKey(pdNew.Campaign__c))
	                {
	                    cpnDealerIds.put(pdNew.Campaign__c, new Set<Id>());
	                }
	                cpnDealerIds.get(pdNew.Campaign__c).add(pdNew.Dealer__c);
	            }
	            
	            for (Campaign cpn : [Select Id from Campaign where id in :cpnIds AND (Status <> 'Published' or RecordTypeId not in :cpnRtIds)])
	            {
	                cpnIds.remove(cpn.Id);
	                cpnDealerIds.remove(cpn.Id);
	            }
	            
	            for (Id id : cpnDealerIds.keySet())
	            {
	                dealerIds.addAll(cpnDealerIds.get(id));
	            }
	            
	            // Get profile ids via campaign record type
	            for (Campaign cpn : [Select Id, RecordTypeId from Campaign where id in :cpnIds])
	            {
	                if (smCpnRtIds.contains(cpn.RecordTypeId)) 
	                {
	                    cpnPermSetMap.put(cpn.Id, pSetSmRetail);
	                }
	                if (asCpnRtIds.contains(cpn.RecordTypeId)) 
	                {
	                    cpnPermSetMap.put(cpn.Id, pSetAsRetail);
	                }
	                if (bpCpnRtIds.contains(cpn.RecordTypeId)) 
	                {
	                    cpnPermSetMap.put(cpn.Id, pSetBp);
	                }
	                if (cpn.RecordTypeId == rtIdMbBp) 
	                {
	                    mbBpCampaignIds.add(cpn.Id);
	                }
	            }
	            
	            // Share campaigns to related dealer users
	            for (User u : [select Id, AccountId, ProfileId, ContactId, Contact.Permission_Set_Settings__c from User where AccountId in :dealerIds and isActive = true and (ProfileId = :pIdDealerAdmin or (ProfileId = :pIdDealerUser and Contact.Permission_Set_Settings__c includes(:pSetAsRetail, :pSetSmRetail, :pSetBp)))])
	            {
	                for (Id cpnId : cpnIds) 
	                {
	                    if (cpnDealerIds.get(cpnId) != null && cpnDealerIds.get(cpnId).contains(u.AccountId) && (u.ProfileId == pIdDealerAdmin || (u.ProfileId == pIdDealerUser && u.Contact.Permission_Set_Settings__c != null && u.Contact.Permission_Set_Settings__c.contains(cpnPermSetMap.get(cpnId)))))
	                    {
	                        CampaignShare share = new CampaignShare();
	                        share.CampaignAccessLevel = 'Read';
	                        share.CampaignId = cpnId;
	                        share.UserOrGroupId = u.id;
	                        cpnShares.add(share);
	                        taskList.add(new Task(
	                            Subject= 'You have new joint marketing activities to participate in.', 
	                            RecordTypeId = RecordTypeMap.get('General Task').getRecordTypeId(),
	                            OwnerId = u.id,
	                            Status = 'open',
	                            WhoId = u.ContactId,
	                            WhatId = cpnId,
	                            ActivityDate = date.today()));
	                    }
	                }
	            }
	            
	            for (Account d : [Select Id, Retail_MB_Owner__c from Account where id in :dealerIds])
	            {
	                if (d.Retail_MB_Owner__c != null)
	                {
	                    dealerBrandownerMap.put(d.Id, d.Retail_MB_Owner__c);
	                }
	            }
	            for (Id cpnId : mbBpCampaignIds)
	            {
	                if (cpnDealerIds.get(cpnId) != null)
	                {
	                    for (Id dealerId : cpnDealerIds.get(cpnId)) 
	                    {
	                        if (dealerBrandownerMap.get(dealerId) != null) 
	                        {
	                            CampaignShare share = new CampaignShare();
	                            share.CampaignAccessLevel = 'Read';
	                            share.CampaignId = cpnId;
	                            share.UserOrGroupId = dealerBrandownerMap.get(dealerId);
	                            cpnShares.add(share);
	                        }
	                    }
	                }
	            }
	            
	            // Insert sharing records
	            if (cpnShares!=null && !cpnShares.IsEmpty())
	            {
	                try {
	                    insert cpnShares;
	                } catch (DMLException e) {
	                    System.debug('DMLException Exception occured when sharing Campaign to Participating Dealer: ' + e);
	                }
	            }
	            if(taskList!=null && !taskList.IsEmpty())
	            {
	                try {
	                    insert taskList;
	                }
	                catch(Exception ex) {
	                    System.debug('Exception message is :' + ex.getMessage());
	                }
	            }
	        } 
	        
	        // The values for deleting shared records
	        List<CampaignShare> cpnOldShares = new List<CampaignShare>();
	        Set<Id> cpnOldIds = new Set<Id>();
	        Set<Id> dealerOldIds = new Set<Id>();
	        Set<Id> userIds = new Set<Id>();
	        Map<Id, Set<Id>> cpnDealerOldIds = new Map<Id, Set<Id>>();
	        Map<Id, String> cpnPermSetOldMap = new Map<Id, String>();
	        Map<Id, Id> userProfileMap = new Map<Id, Id>();
	        Map<Id, Set<String>> userPsetMap = new Map<Id, Set<String>>();
	        
	        // When delete or update parecipating dealer, delete old shared records from related dealer
	        if (isUpdate || isDelete) {
	            for(Participating_Dealer__c pdOld : participatingDealerOld) {
	                if (isUpdate && newMap.get(pdOld.id).Campaign__c == pdOld.Campaign__c && newMap.get(pdOld.id).Dealer__c == pdOld.Dealer__c) {
	                    continue;
	                }
	                
	                // Get campaign and dealer Ids
	                cpnOldIds.add(pdOld.Campaign__c);
	                dealerOldIds.add(pdOld.Dealer__c);
	                if(!cpnDealerOldIds.containsKey(pdOld.Campaign__c)) {
	                    cpnDealerOldIds.put(pdOld.Campaign__c, new Set<Id>());
	                }
	                cpnDealerOldIds.get(pdOld.Campaign__c).add(pdOld.Dealer__c);
	            }
	            
	            // Get profile ids via campaign record type
	            for (Campaign cpn : [Select Id, RecordTypeId from Campaign where id in :cpnOldIds and Status = 'Published' and RecordTypeId in :cpnRtIds]) {
	                if (smCpnRtIds.contains(cpn.RecordTypeId)) {
	                    cpnPermSetOldMap.put(cpn.Id, pSetSmRetail);
	                } else if (asCpnRtIds.contains(cpn.RecordTypeId)) {
	                    cpnPermSetOldMap.put(cpn.Id, pSetAsRetail);
	                } else if (bpCpnRtIds.contains(cpn.RecordTypeId)) {
	                    cpnPermSetOldMap.put(cpn.Id, pSetBp);
	                }
	            }
	            
	            // Get all related dealer users
	            for (User u : [select Id, ProfileId, Contact.Permission_Set_Settings__c from User where AccountId in :dealerOldIds and (ProfileId = :pIdDealerAdmin or (ProfileId = :pIdDealerUser and Contact.Permission_Set_Settings__c includes(:pSetAsRetail, :pSetSmRetail, :pSetBp)))])
	            {
	                userIds.add(u.Id);
	                userProfileMap.put(u.Id, u.ProfileId);
	                if (u.ProfileId == pIdDealerUser)
	                {
	                    userPsetMap.put(u.Id, new Set<String>());
	                    if (u.Contact.Permission_Set_Settings__c != null)
	                    {
	                        if (u.Contact.Permission_Set_Settings__c.contains(pSetAsRetail))
	                        {
	                            userPsetMap.get(u.Id).add(pSetAsRetail);
	                        }
	                        if (u.Contact.Permission_Set_Settings__c.contains(pSetSmRetail))
	                        {
	                            userPsetMap.get(u.Id).add(pSetSmRetail);
	                        }
	                        if (u.Contact.Permission_Set_Settings__c.contains(pSetBp))
	                        {
	                            userPsetMap.get(u.Id).add(pSetBp);
	                        }
	                    }
	                }
	            }
	            
	            // Get the old shared records
	            for (CampaignShare ds : [select Id, CampaignId, UserOrGroupId from CampaignShare where CampaignId in :cpnOldIds and UserOrGroupId in :userIds]) {
	                if (userProfileMap.get(ds.UserOrGroupId) == pIdDealerAdmin || userProfileMap.get(ds.UserOrGroupId) == pIdDealerUser && userPsetMap.get(ds.UserOrGroupId) != null && userPsetMap.get(ds.UserOrGroupId).contains(cpnPermSetOldMap.get(ds.CampaignId)))
	                {
	                    cpnOldShares.add(ds);
	                }
	            }
	            
	            // Delete the old shared recors
	            if (cpnOldShares!=null && !cpnOldShares.IsEmpty()) {
	                try {
	                    delete cpnOldShares;
	                } catch (DMLException e) {
	                    System.debug('DMLException Exception occured when deleting shared Campaigns from Participating Dealer: ' + e);
	                }
	            }
	        }
    	}
    }
    
    public static void GenerateCampaignParticipatingDealerHistoryLOG(list<Participating_Dealer__c> participatingDealerNew,list<Participating_Dealer__c> participatingDealerOld,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        Id cId;
        if(isDelete)
        {
            // Get Current Reocrd ID
            cId = participatingDealerOld[0].Id;
        }
        else
        {
            cId = participatingDealerNew[0].Id;
        }
        if(cId!=null)
        {
            Participating_Dealer__c co = [Select Id, Name, Campaign__c From Participating_Dealer__c Where Id = :cId];
            String type = 'Participating Dealer';
            String action = '';
            Id cm = co.Campaign__c;
            String objName = co.Name;
            Id us = Userinfo.getUserId();
            // LOG Generation Class initialize
            campaignHistoryLogGeneration chlg = new campaignHistoryLogGeneration();
            if(isInsert){
                // INSERT LOG
                action = 'Add participating dealer ' + String.valueof(cId);
            }
            if(isUpdate){
                // UPDATE LOG
                action = 'Update participating dealer to ' + String.valueof(cId);
            }
            if(isDelete){
                // DELETE LOG
                action = 'Delete participating dealer ' + String.valueof(cId);
            }
            chlg.logGeneration(type, action, cm, us, objName);
        }
    }
}