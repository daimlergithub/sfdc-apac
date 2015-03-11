/*
    Type:       Utility for LeadAfterUpdate
    Purpose:    1.Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
                2.Assigned lead to Dealer Lead Gate Keeper
                3.Share lead's contact to Dealer Sales Gate Keeper
                4.If a lead is created from Inquiry case, copy lead id to Case's lead.  US-IB-001
    User Story: US-DP-022, US-DP-023, US-DP-014, US-IB-001
    Used By:   
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-27
    3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
*/
public class LeadHelper
{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static List<QueueSobject> LeadGateKeeperQ = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType =: UtilConstant.LEAD and Queue.Name =: UtilConstant.DEALER_LEAD_GATE_KEEPER_QUEUE limit 1];
    private static final String SMSTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(UtilConstant.SMS).getRecordTypeId();
    private static final String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(UtilConstant.OB_TASK).getRecordTypeId();    
        
    // Insert the corresponding lead sharing records
    public static void insertLeadSharing(Map<Id, Id> UsedCarLeadDealerId, Map<Id, Id> newCarLeadDealerId)
    {
        Set<Id> existSharingLeadIds = new Set<Id>();
        Map<Id, Id> dealerStarElitOwners = new Map<Id, Id>();
        Map<Id, Id> dealerSmartAccountOwners = new Map<Id, Id>();
        Map<Id, Id> leadIdContactIds = new Map<Id, Id>();
        List<Lead__Share> SharesToInsert = new List<Lead__Share>();
        List<AccountShare> AccSharesToInsert = new List<AccountShare>();
        
        // Map account id and Star Elite Owner or Smart Owner
        for(Account acc : [select Id, Star_Elite_Account_Owner__c, Star_Elite_Account_Owner__r.isActive, Smart_Account_Owner__c, Smart_Account_Owner__r.isActive from Account where Id in :UsedCarLeadDealerId.values() or Id in :newCarLeadDealerId.values()])
        {
            if(acc.Star_Elite_Account_Owner__c != null && acc.Star_Elite_Account_Owner__r.isActive == true)
            {
                dealerStarElitOwners.put(acc.Id, acc.Star_Elite_Account_Owner__c);
            }
            
            if(acc.Smart_Account_Owner__c != null && acc.Smart_Account_Owner__r.isActive == true)
            {
                dealerSmartAccountOwners.put(acc.Id, acc.Smart_Account_Owner__c);
            }
        }
        
        // Get exist lead share record ids
        for(Lead__share ls : [select Id from Lead__share where ParentID in :UsedCarLeadDealerId.keySet() or ParentID in :newCarLeadDealerId.keySet()])
        {
            existSharingLeadIds.add(ls.Id);
        }
        
        // Get exist lead contact ids
        for(Lead__c lead : [select Id, Contact__c from Lead__c where Id in :UsedCarLeadDealerId.keySet() or Id in :newCarLeadDealerId.keySet()])
        {
            leadIdContactIds.put(lead.Id, lead.Contact__c);
        }
        
        // Create lead sharing records for Used car
        for(Id leadId : UsedCarLeadDealerId.keySet())
        {
            if(!existSharingLeadIds.contains(leadId) && dealerStarElitOwners.containsKey(UsedCarLeadDealerId.get(leadId)))
            {
                SharesToInsert.add(newLeadShare(leadId, dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
                AccSharesToInsert.add(newAccountShare(leadIdContactIds.get(leadId), dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
            }
        }
        
        // Create lead sharing records for new car 
        for(Id leadId : newCarLeadDealerId.keySet())
        {
            if(!existSharingLeadIds.contains(leadId) && dealerSmartAccountOwners.containsKey(newCarLeadDealerId.get(leadId)))
            {
                SharesToInsert.add(newLeadShare(leadId, dealerSmartAccountOwners.get(newCarLeadDealerId.get(leadId))));
                AccSharesToInsert.add(newAccountShare(leadIdContactIds.get(leadId), dealerSmartAccountOwners.get(newCarLeadDealerId.get(leadId))));
            }
        }
        
        if(SharesToInsert!=null && !SharesToInsert.isEmpty()) {
            UtilSobject.insertSobjects(SharesToInsert);
        }
        
        if(AccSharesToInsert!=null && !AccSharesToInsert.isEmpty()) {
            UtilSobject.insertSobjects(AccSharesToInsert);
        }
    }
    
    public static void UpdateLeadOwner(Set<Id> dealerIds, List<Lead__c> leadsForUpdate)
    {
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true])
        {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate)
        {
            if(lead.CAC_Lead_Status__c == 'Qualified')
            {
                if(dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c))
                {
                    if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                    {
                        lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    }
                }
                else  if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                {
                    if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                    lead.OwnerId = LeadGateKeeperQ[0].QueueId; 
                }
            }
        }
    }
    
    //US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
    public static void UpdateLeadOwnerFromContact(Set<Id> dealerIds, List<Lead__c> leadsForUpdate)
    {
        List<Lead__c> leadForUpdate = new List<Lead__c>();
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true])
        {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate) {
            if(lead.Assigned_Dealer__c != null && dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c))
            {
                if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                {
                    lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    leadForUpdate.add(lead);
                }
                if(lead.Dealer_LMS__c == 'Yes' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId)
				{
                    leadForUpdate.add(lead);
                }
            }
            else  if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
            {
                if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                lead.OwnerId = LeadGateKeeperQ[0].QueueId;
                leadForUpdate.add(lead);
            }
        }
        
        if(leadForUpdate!=null && !leadForUpdate.isEmpty()) { 
            UtilSobject.updateSobjects(leadForUpdate);
        }
    }
    
    public static void ShareToGateKeeper(Set<Id> dealerIds, List<Lead__c> leadsForUpdate) {
        List<AccountShare> SharesToInsert = new List<AccountShare>();
        
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]) {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate)
        {
            if(dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c))
            {
                if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                {
                    SharesToInsert.add(newAccountShare(lead.Contact__c, dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c)));
                }/*
                else if(lead.Dealer_LMS__c == 'Yes' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) {
                }
                else {
                    SharesToInsert.add(newAccountShare(lead.Contact__c,  LeadGateKeeperQ.QueueId));
                }*/
            }/*
            else {
                SharesToInsert.add(newAccountShare(lead.Contact__c, LeadGateKeeperQ.QueueId));
            }*/
        }
        
        if(SharesToInsert!=null && !SharesToInsert.IsEmpty())
        {
            UtilSobject.insertSobjects(SharesToInsert);
        }
    }
    
    //US-IB-001
    public static void UpdateCasesWithLeadId(Map<Id, Id> NewCaseLeadIds)
    {
        List<Case> caseForUpdate = new List<Case>();
        for(Case cas : [select Id, Lead__c from Case where Id in :NewCaseLeadIds.keySet()])
        {
            cas.Lead__c = NewCaseLeadIds.get(cas.Id);
            caseForUpdate.add(cas);
        }
        
        if(caseForUpdate!=null && !caseForUpdate.isEmpty())
        {
            UtilSobject.updateSobjects(caseForUpdate);
        }
    }
    
    public static void shareToAssignedDealer(Set<String> oldDealerIds, Set<String> leadIds)
    {
        
        // Get the old dealer owner ids
        Set<ID> oldDealerOwnerIds = new Set<ID>();
        for(Account dealer : [select OwnerId from Account where Id in :oldDealerIds])
        {
            oldDealerOwnerIds.add(dealer.OwnerId);
        }
        
        // Remove the sharing record for old dealer
        delete [select Id from Lead__Share where AccessLevel = 'Read' and ParentId in :leadIds and UserOrGroupId in :oldDealerOwnerIds];
        
        // Create the sharing record for new dealer
        List<Lead__c> leads = [select Id, Assigned_Dealer__r.OwnerId from Lead__c where Id in :leadIds and Assigned_Dealer__r.Owner.isActive = true];
        
        Set<ID> dealerOwnerIds = new Set<ID>();
        for(Lead__c item : leads){
            dealerOwnerIds.add(item.Assigned_Dealer__r.OwnerId);
        }
        
        Set<String> existentShares = new Set<String>();
        for(Lead__Share share : [select ParentId, UserOrGroupId from Lead__Share where ParentId in :leadIds and UserOrGroupId in :dealerOwnerIds]){
            existentShares.add(share.ParentId + '&' + share.UserOrGroupId);
        }
        
        List<Lead__Share> leadShares = new List<Lead__Share>();
        for(Lead__c lead : leads)
        {
            if(!existentShares.contains(lead.Id + '&' + lead.Assigned_Dealer__r.OwnerId))
            {
                leadShares.add(newLeadShare(lead.Id, lead.Assigned_Dealer__r.OwnerId));
            }
        }
        
        if(leadShares!=null && !leadShares.isEmpty())
        {
            insert leadShares;
        }
    }
    
    public static void beforeInsert_UpdateEvents(list<Lead__c> leadsnew,map<id,Lead__c> leadOldMap,boolean isInsert, boolean isUpdate)
    {
    	// Get all dealer ids of update leads
	    Set<Id> dealerIds = new Set<Id>();
	    // Get all dealers of update leads
	    List<Lead__c> leadsForUpdate = new List<Lead__c>();
	    Map<Id, Lead__c> ownerIdleads = new Map<Id, Lead__c>();
	    Set<Id> noPortalUserDealerIds = new Set<Id>();
	    Set<Id> existDealerIds = new Set<Id>();
	    
	    for(Lead__c lead : leadsnew)
	    {
	        existDealerIds.add(lead.ownerId);
	        if(isInsert && lead.Assigned_Dealer__c != null)
	        {
	            dealerIds.add(lead.Assigned_Dealer__c);
	            leadsForUpdate.add(lead);
	        }
	    }
	    
	    if(existDealerIds!=null && !existDealerIds.IsEmpty())
	    {
	        for(User u : [select id, profileId from User where id in :existDealerIds and Profile.Name !=: UtilConstant.DEALER_DELEGATE_ADMIN and Profile.Name !=: UtilConstant.DEALER_COMMUNITY_USER])
	        {
	            noPortalUserDealerIds.add(u.Id);
	        }
	    }
	    
	    for(Lead__c lead : leadsnew)
	    {
	        if(isUpdate)
	        {
	            if(lead.Assigned_Dealer__c != null && noPortalUserDealerIds.contains(lead.OwnerId))
	            {
	                dealerIds.add(lead.Assigned_Dealer__c);
	                leadsForUpdate.add(lead);
	            } 
	        }
	    }
	    
	    // Update lead's owner and share contact to lead's owner
	    if(leadsForUpdate!=null && !leadsForUpdate.IsEmpty())
	    {
	        UpdateLeadOwner(dealerIds, leadsForUpdate);
	    }
	
	    // Update CAC Lead Status to new for integrationAPI
	    // Sinow active this part code, Dec 18,2013, because EP will forward leads to Dealer with status qualified.
	    List<Profile> pList = [Select Name From Profile Where Id = :UserInfo.getProfileId() Limit 1];
	    if(!pList.isEmpty())
	    {
	        if(isInsert && pList[0].Name == UtilConstant.Ingretion_Profile)
	        {
	            for(Lead__c ld : leadsnew)
	            {
	                if(ld.Assigned_to_Dealer_Directly__c)
	                {
	                    ld.CAC_Lead_Status__c = 'Qualified';
	                }
	                else
	                {
	                    ld.CAC_Lead_Status__c = 'New';
	                }
	            }        
	        }
	    }
    }
    
    public static void afterInsert_UpdateEvents(list<Lead__c> leadsnew,map<id,Lead__c> leadOldMap,boolean isInsert, boolean isUpdate)
    {
    	// Map all lead ids and case Ids US-IB-001
	    Map<Id, Id> NewCaseLeadIds = new Map<Id, Id>();
	    // Map all lead ids and dealer Ids for use car
	    Map<Id, Id> UsedCarLeadDealerId = new Map<Id, Id>();
	    // Map all lead ids and dealer Ids for new car
	    Map<Id, Id> NewCarLeadDealerId = new Map<Id, Id>();
	    // Get all dealer ids of update leads for share to contact
	    Set<Id> dealerIds = new Set<Id>();
	    //------------------Added by bing---------------------
	    // Assigned dealer list 
	    List<String> assignedDealers = new List<String>();
	    //------------------Added by bing---------------------    
	    // Get all dealers of update leads for share to contact
	    List<Lead__c> leadsForUpdate = new List<Lead__c>();
	    // Share the lead to assigned dealer if "Need Assign To Dealer" field is "Need"
	    Set<String> oldDealerIds = new Set<String>();
	    Set<String> leadIdsForSharingToDealerOwner = new Set<String>();
	    for(Lead__c lead : leadsnew)
	    {
	        if(isInsert)
	        {
	            // By Justin, assgin account sharings to lead owner
	            if(lead.Need_Assign_To_Dealer__c == 'Need' && lead.OwnerId != null)
	            {
	                dealerIds.add(lead.Assigned_Dealer__c);
	                leadsForUpdate.add(lead);
	            }
	            
	            if(lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need')
	            {
	                leadIdsForSharingToDealerOwner.add(lead.Id);
	            }
	        }
	        
	        if(isUpdate)
	        {
	            if(lead.Lead_Type__c == 'Used Car' && lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need' && lead.Assigned_Dealer__c != leadOldMap.get(lead.Id).Assigned_Dealer__c)
	            {
	                UsedCarLeadDealerId.put(lead.Id, lead.Assigned_Dealer__c);
	            }
	            if(lead.Lead_Type__c == 'New Car' && lead.Assigned_Dealer__c != null && lead.Interested_Vehicle_Brand__c == 'Smart' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.Assigned_Dealer__c != leadOldMap.get(lead.Id).Assigned_Dealer__c)
	            {
	                NewCarLeadDealerId.put(lead.Id, lead.Assigned_Dealer__c);
	            }
	            
	            // By Justin, assgin account sharings to lead owner
	            if(lead.OwnerId != null && lead.OwnerId != leadOldMap.get(lead.Id).OwnerId)
	            {
	                dealerIds.add(lead.Assigned_Dealer__c);
	                leadsForUpdate.add(lead);
	            }
	            
	            if(lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need' && (lead.Need_Assign_To_Dealer__c != leadOldMap.get(lead.Id).Need_Assign_To_Dealer__c || lead.Assigned_Dealer__c != leadOldMap.get(lead.Id).Assigned_Dealer__c))
	            {
	                oldDealerIds.add(leadOldMap.get(lead.Id).Assigned_Dealer__c);
	                leadIdsForSharingToDealerOwner.add(lead.Id);
	            }
	        }
	    
	        //US-IB-001
	        if(isInsert && lead.Case__c != null)
	        {
	            NewCaseLeadIds.put(lead.Case__c, lead.Id);
	        }
	        
	    }
	
	        
	    if(UsedCarLeadDealerId.keySet().size() > 0 || NewCarLeadDealerId.keySet().size() > 0) {
	        LeadHelper.insertLeadSharing(UsedCarLeadDealerId, NewCarLeadDealerId);
	    }
	    
	    // Share contact to lead's owner
	    if(leadsForUpdate!=null && !leadsForUpdate.IsEmpty())
	    {
	        ShareToGateKeeper(dealerIds, leadsForUpdate);
	    }
	    
	    if(NewCaseLeadIds!=null && !NewCaseLeadIds.IsEmpty())
	    {
	        UpdateCasesWithLeadId(NewCaseLeadIds);
	    }
	    
	    if(leadIdsForSharingToDealerOwner!=null && !leadIdsForSharingToDealerOwner.IsEmpty())
	    {
	        oldDealerIds.remove(null);
	        shareToAssignedDealer(oldDealerIds, leadIdsForSharingToDealerOwner);
	    }
    }
    
    public static void ShareLeadsToCampaignUser(list<Lead__c> leadsnew,map<id,Lead__c> leadOldMap,map<id,Lead__c> leadNewMap,boolean isInsert, boolean isUpdate)
    {
    	if(isInsert)
    	{
	        LeadSharingWrapService wrapService = new LeadSharingWrapService();
	        SharingService.shareLeads(wrapService.wrapLeads(leadsnew));
	    } 
	    else if(isUpdate)
	    {
	        List<Lead__c> dealerChangedLeads = new List<Lead__c>();
	        for(Id leadId : leadNewMap.keySet())
	        {
	            if(leadOldMap.get(leadId).Assigned_Dealer__c != leadNewMap.get(leadId).Assigned_Dealer__c)
	            {
	                dealerChangedLeads.add(leadNewMap.get(leadId));    
	            }
	        }
	        delete [select Id from Lead__Share where parentId in :dealerChangedLeads and RowCause = :Schema.Lead__Share.RowCause.Dealer_Campaign_Share__c];
	        
	        LeadSharingWrapService wrapService = new LeadSharingWrapService();
	        SharingService.shareLeads(wrapService.wrapLeads(dealerChangedLeads));
	    }
    }
    
    public static void SendMessageToCustomerAndInstructor(list<Lead__c> leadsnew,map<id,Lead__c> leadOldMap,boolean isInsert, boolean isUpdate)
    {
    	/*Set<Id> relatedContactIds = new Set<Id>();
	    Set<Id> relatedUserIds = new Set<Id>();
	    set<Id> dealerIds = new Set<Id>();
	    List<Lead__c> mbdaLeads = new List<Lead__c>(); 
	    if(isInsert)
	    {
	        for(Lead__c tempLead : leadsnew)
	        {
	            if(tempLead.RecordTypeId == mbdaLeadRecordTypeId && (tempLead.Need_Contact__c == true || tempLead.Visit_Dealer__c == true))
	            {
	                relatedContactIds.add(tempLead.Contact__c);
	                relatedUserIds.add(tempLead.Instructor__c);
	                dealerIds.add(tempLead.Recommended_Dealer__c);
	                mbdaLeads.add(tempLead);
	            }
	        }
	    }
	    if(isUpdate) {
	        for(Lead__c tempLead : leadsnew) {
	           if(tempLead.RecordTypeId == mbdaLeadRecordTypeId && (tempLead.Need_Contact__c == true && tempLead.Need_Contact__c != leadOldMap.get(tempLead.Id).Need_Contact__c) || (tempLead.Visit_Dealer__c == true && tempLead.Visit_Dealer__c != leadOldMap.get(tempLead.Id).Visit_Dealer__c))
	           {
	               relatedContactIds.add(tempLead.Contact__c);
	               relatedUserIds.add(tempLead.Instructor__c);
	               dealerIds.add(tempLead.Recommended_Dealer__c);
	               mbdaLeads.add(tempLead);
	           }
	        }
	    }
	    
	    if(mbdaLeads!=null && !mbdaLeads.IsEmpty())
	    {
	        Map<Id, User> instructors = new Map<Id, User>([select Id, Name, MobilePhone, ContactId from User where Id in :relatedUserIds]);
	        Map<Id, Account> customers = new Map<Id, Account>([select Id, PersonContactId, Name, PersonMobilePhone from Account where Id in :relatedContactIds and IsPersonAccount = true]);
	        Map<Id, Account> dealers = new Map<Id, Account>([select Id, Name, Dealer_Address_CN__c from Account where Id in :dealerIds]);
	        User integrationUser = getEPIntegrationUser();
	        
	        List<Task> newSMSTasks = new List<Task>();
	        for(Lead__c tempLead : mbdaLeads)
	        {
	            // For customer
	            if(tempLead.Visit_Dealer__c)
	            {  
	                //Lead_Follow_Up_To_Customer_With_Dealer
	                newSMSTasks.add(createdNewSMSTaskForCustomer(tempLead, integrationUser, customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c), 'Lead_Follow_Up_To_Customer_With_Dealer'));
	            }
	            else if(tempLead.Need_Contact__c)
	            {  
	                //Lead_Follow_Up_To_Customer_Without_Dealer
	                newSMSTasks.add(createdNewSMSTaskForCustomer(tempLead, integrationUser, customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c), 'Lead_Follow_Up_To_Customer_Without_Dealer'));
	            }
	            // For Instructor
	            if(tempLead.Need_Contact__c)
	            {  
	                //Lead_Follow_Up_To_Instructor
	                newSMSTasks.add(createdNewSMSTaskForInstructor(tempLead, integrationUser, instructors.get(tempLead.Instructor__c), customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c)));
	            }
	        }
	        if(newSMSTasks!=null && !newSMSTasks.IsEmpty())
	        	insert newSMSTasks;
	    }*/
    }
    /**
     * Private classes
     */
    private static Lead__Share newLeadShare(String leadId, String userOrGroupId)
    {
        Lead__Share tempShare = new Lead__Share();
        tempShare.AccessLevel = 'Read';
        tempShare.ParentID = leadId;
        tempShare.RowCause = Schema.Lead__Share.RowCause.Manual;
        tempShare.UserOrGroupId = userOrGroupId;
        return tempShare;
    }
    
    private static AccountShare newAccountShare(String accountId, String userOrGroupId)
    {
        AccountShare tempShare = new AccountShare();
        tempShare.AccountAccessLevel = 'Read';
        tempShare.AccountId = accountId;
        tempShare.UserOrGroupId = userOrGroupId;
        tempShare.OpportunityAccessLevel = 'Read';
        return tempShare;
    }
    
    private static Task createdNewSMSTaskForInstructor(Lead__c tempLead, User  tempIntegrationUser, User tempInstructor, Account tempAccount, Account tempDealer)
    {
        Task newTask = new Task(RecordTypeId = SMSTaskRecordTypeId, Subject = 'SMS', Status = 'Closed', Activity_Status__c = 'Sent');
        newTask.SMS_Content__c = getSMSContentByTitle(tempLead, tempAccount, tempInstructor, tempDealer, 'Lead_Follow_Up_To_Instructor'); //Interested_Vehicle_Class__c
        newTask.OwnerId = tempIntegrationUser.Id;
        if(tempInstructor != null)
        {
            newTask.Phone__c = tempInstructor.MobilePhone;//tempLead.Referal_Referee_PhoneNumber__c;
            newTask.WhoId = tempInstructor.ContactId; // PersonContactId;
        }
        newTask.WhatId = tempLead.Id;
        return newTask;
    }
    
    private static Task createdNewSMSTaskForCustomer(Lead__c tempLead, User  tempIntegrationUser, Account tempCustomer, Account tempDealer, String tempTitle)
    {
        Task newTask = new Task(RecordTypeId = SMSTaskRecordTypeId, Subject = 'SMS', Status = 'Closed', Activity_Status__c = 'Sent');
        newTask.SMS_Content__c = getSMSContentByTitle(tempLead, tempCustomer, tempIntegrationUser, tempDealer, tempTitle); //Interested_Vehicle_Class__c
        newTask.OwnerId = tempIntegrationUser.Id;
        if(tempCustomer != null)
        {
            newTask.Phone__c = tempCustomer.PersonMobilePhone;//tempLead.Referal_Referee_PhoneNumber__c;
            newTask.WhoId = tempCustomer.PersonContactId;
        }
        newTask.WhatId = tempLead.Id;
        return newTask;
    }
    
    private static String getSMSContentByTitle(Lead__c tempLead, Account tempCustomer, User tempInstructor, Account tempDealer, String tempTitle)
    {
        String result = '';
        result = ReservationMessageTemplate.getSMSContent(tempLead, tempCustomer, tempInstructor, tempDealer, tempTitle);
        return result;
    }
    
    private static User getEPIntegrationUser()
    {
        User epUser;
        List<User> epUsers = [select Id, Name from User where Name = 'ep.user1' and Profile.Name = 'IntegrationAPI' and IsActive = true limit 1];
        if(epUsers!=null && !epUsers.IsEmpty())
        {
            epUser = epUsers[0];
        }
        return epUser;
    }
}