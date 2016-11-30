/*
    Type:       Utility for LeadAfterUpdate
    Purpose:    1.Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
                2.Assigned lead to Dealer Lead Gate Keeper
                3.ShFare lead's contact to Dealer Sales Gate Keeper
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
    //Existing AU Functionality Variables
    private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
    private static final String leadFleetRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Finance Lead').getRecordTypeId();
    private static final String leadSPRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Service Lead').getRecordTypeId();
    private static final String leadVehicleRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
    private static final String vanLeadRT = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Vans').getRecordTypeId();
    private static final String serviceContractRT = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    private static final String insuranceContractRT = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Insurance').getRecordTypeId();
    private static final String contractRT = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
    private static final String PersonalAccountRT = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final Map<Id, User> IntegrationUsers = new Map<Id, User>([select Id from User where Profile.Name = 'IntegrationAPI']);
    private static final String OrgWideEmailAddressId= [Select id from OrgWideEmailAddress where Address =: UtilCustomSettings.getOrgWideDefaultAddress(UtilConstant.ORGWIDE_EMAIL_ADDRESS)].Id;
    private static final String EmcOrgWideEmailAddressId = [Select id from OrgWideEmailAddress where Address =: UtilCustomSettings.getOrgWideDefaultAddress(UtilConstant.ORGWIDE_EMAIL_ADDRESS_EMC)].Id;
   private static boolean boolean_autoassignleads = false;
    private static Integer SLA_hot ;
    private static Integer SLA_Warm;
    private static Integer SLA_cold;
   
    private static   String Str_Business_Start_hour;
 private static   String Str_Business_End_hour;
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
                    if((lead.Dealer_LMS__c == 'Salesforce' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                    {
                        lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    }
                }
                else  if((lead.Dealer_LMS__c == 'Salesforce' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
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
                if((lead.Dealer_LMS__c == 'Salesforce' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                {
                    lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    leadForUpdate.add(lead);
                }
                if(lead.Dealer_LMS__c == 'LMS' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId)
                {
                    leadForUpdate.add(lead);
                }
            }
            else  if((lead.Dealer_LMS__c == 'Salesforce' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
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
                if((lead.Dealer_LMS__c == 'Salesforce' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId)
                {
                    SharesToInsert.add(newAccountShare(lead.Contact__c, dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c)));
                }/*
                else if(lead.Dealer_LMS__c == 'LMS' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) {
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
   
    /**
     * Private classes
     */
  @TestVisible
    private static Lead__Share newLeadShare(String leadId, String userOrGroupId)
    {
        Lead__Share tempShare = new Lead__Share();
        tempShare.AccessLevel = 'Read';
        tempShare.ParentID = leadId;
        tempShare.RowCause = Schema.Lead__Share.RowCause.Manual;
        tempShare.UserOrGroupId = userOrGroupId;
        return tempShare;
   }
   
  @TestVisible
    private static AccountShare newAccountShare(String accountId, String userOrGroupId)
    {
        AccountShare tempShare = new AccountShare();
        tempShare.AccountAccessLevel = 'Read';
        tempShare.AccountId = accountId;
        tempShare.UserOrGroupId = userOrGroupId;
        tempShare.OpportunityAccessLevel = 'Read';
        return tempShare;
    }

    @TestVisible
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

    @TestVisible
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

    @TestVisible
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
    //Existing AU Functionality Starts Here
   
public static void auAfter_Insert_Update_Events(List<Lead__c> listNewLeads,map<id,Lead__c> leadNewMap,map<Id,Lead__c> leadOldMap,boolean isInsert,boolean isUpdate)
    {
        system.debug('>>>>'+listNewLeads);
        List<Lead__c> preparedLeads = new List<Lead__c>();
        for(Lead__c lead : listNewLeads) {
            preparedLeads.add(lead);
        }
        if(!preparedLeads.isEmpty()) {
            checkrecord(preparedLeads);
        }
        // Added by Polaris Yu 2013-8-29
   
        // For User Story: US_AU-Lead-007; US_AU-Lead-021
        if(isInsert || isUpdate){
            // For qualified Leads, they will be automatically assigned
            // to the dealer sales gate keeper user
            autoAssignLeads(leadNewMap, leadOldMap,isInsert,isUpdate);       
        }
       
        //CR-000141 Send Immediate Notice and 24H and 72H Email for Service/Parts Lead.
        List<Lead__c> serviceLeadsForImmediateNotice = new List<Lead__c>();
        List<Lead__c> VehicleLeadsForImmediateNotice = new List<Lead__c>();
        List<Lead__c> serviceLeadsFor24H = new List<Lead__c>();
        List<Lead__c> serviceLeadsFor72H = new List<Lead__c>();
        Set<Id> serviceDealerIdsForImmediateNotice = new Set<Id>();
        Set<Id> serviceDealerIdsFor24H = new Set<Id>();
        Set<Id> serviceDealerIdsFor72H = new Set<Id>();
        set<id> vehicleDealerIdsForImmediateNotice = new Set<Id>();
        //CR-000141 Send Immediate Notice and 24H and 72H Email for Finance Lead.
        List<Lead__c> financeLeads = new List<Lead__c>();
        Set<Id> financeDealerIds = new Set<Id>();
   
        
        for(Lead__c lead : listNewLeads) {
         
           
            if(lead.Assigned_Dealer__c != null && lead.Business_Unit__c != null && lead.Sub_BusinessUnit__c != null && (isInsert || isUpdate))
               {
                   if(lead.RecordTypeId == leadVehicleRt)
                   {
                      if((isInsert && lead.CAC_Lead_Status__c == 'Qualified') || ((isUpdate && lead.CAC_Lead_Status__c != leadOldMap.get(lead.Id).CAC_Lead_Status__c) && lead.CAC_Lead_Status__c =='Qualified' ))

                      {
                         
                          VehicleLeadsForImmediateNotice.add(lead);
                          vehicleDealerIdsForImmediateNotice.add(lead.Assigned_Dealer__c);
                         
                      }
                  } 
                   
               }
            //TODO--commented LDCL_Lead_Id__c is not using
            If(lead.Assigned_Dealer__c != null && lead.Business_Unit__c != null && lead.Sub_BusinessUnit__c != null &&
              (isInsert || (isUpdate && lead.Assigned_Dealer__c != leadOldMap.get(lead.Id).Assigned_Dealer__c))
              //&& (lead.LDCL_Lead_Id__c == null || (lead.LDCL_Lead_Id__c != null
              && !IntegrationUsers.KeySet().contains(lead.LastModifiedById)
              //)
              //)
              )
              { 
                if(lead.RecordTypeId == leadSPRt)
                {
                    serviceLeadsForImmediateNotice.add(lead);
                    serviceDealerIdsForImmediateNotice.add(lead.Assigned_Dealer__c);
                }
               else if(lead.RecordTypeId == leadFinanceRT)
                {
                    financeLeads.add(lead);
                    financeDealerIds.add(lead.Assigned_Dealer__c);
                }
                 
                  
            }
            If(lead.Assigned_Dealer__c != null && lead.Business_Unit__c != null && lead.Sub_BusinessUnit__c != null &&
              isUpdate && lead.X24H_Untouched__c && lead.X24H_Untouched__c != leadOldMap.get(lead.Id).X24H_Untouched__c) {
                if(lead.RecordTypeId == leadSPRt || lead.RecordTypeId == leadVehicleRt) {
                    serviceLeadsFor24H.add(lead);
                    serviceDealerIdsFor24H.add(lead.Assigned_Dealer__c);
                }
                else if(lead.RecordTypeId == leadFinanceRT) {
                    financeLeads.add(lead);
                    financeDealerIds.add(lead.Assigned_Dealer__c);
                }
            }
            If(lead.Assigned_Dealer__c != null && lead.Business_Unit__c != null && lead.Sub_BusinessUnit__c != null &&
              isUpdate && lead.X72H_Untouched__c && lead.X72H_Untouched__c != leadOldMap.get(lead.Id).X72H_Untouched__c) {
                if(lead.RecordTypeId == leadSPRt || lead.RecordTypeId == leadVehicleRt) {
                    serviceLeadsFor72H.add(lead);
                    serviceDealerIdsFor72H.add(lead.Assigned_Dealer__c);
                }
                else if(lead.RecordTypeId == leadFinanceRT) {
                    financeLeads.add(lead);
                    financeDealerIds.add(lead.Assigned_Dealer__c);
                }
            }
        }
    //TODO commented this as part of SFDCAU-467,SFDCAU-493 Once Alan validates and confirms it will be uncommented.
        /*
        if(!serviceLeadsForImmediateNotice.isEmpty()) {
            sendServicePartsEmail(serviceLeadsForImmediateNotice, serviceDealerIdsForImmediateNotice, 'Immediate Notice');
        }
        if(!serviceLeadsFor24H.isEmpty()) {
            sendServicePartsEmail(serviceLeadsFor24H, serviceDealerIdsFor24H, '24H Untouched Notice');
        }
        if(!serviceLeadsFor72H.isEmpty()) {
            sendServicePartsEmail(serviceLeadsFor72H, serviceDealerIdsFor72H, '72H Untouched Notice');
        }
        */
        if(!financeLeads.isEmpty())
        {
            sendFinanceEmail(financeLeads, financeDealerIds);
        }
        if(!VehicleLeadsForImmediateNotice.isEmpty()){
             system.debug('++++++++++++++calls method here++++++++' +VehicleLeadsForImmediateNotice[0].id);
            //sendServicePartsEmail(VehicleLeadsForImmediateNotice, vehicleDealerIdsForImmediateNotice, 'Immediate Notice');
        } 
    }
   
    public static void auBefore_Insert_Update_Events(list<Lead__c> listNewLeads,map<id,Lead__c> mapLeadOldmap,boolean isInsert,boolean isUpdate)
    {
         if(isInsert || isUpdate)
         {
            // For Finance Leads, if Existing Contract is filled, Assigned Dealer will
            //    be auto filled as Contract Dealer
            autoFillAssignedDealer(listNewLeads);
         }
        // End of added part, Polaris Yu 2013-9-25
       
        //Update CRM1 Existing Contract No. lookup field via the CMS Contract Number
        //TODO-commented
        /*Set<String> CMSContractsRelationNames = new Set<String>();
        Map<String, Id> CMSNameContractIdMap = new Map<String, Id>();
        for(Lead__c lead : listNewLeads) {
            if((lead.RecordTypeId == leadFleetRt || lead.RecordTypeId == leadFinanceRt) && lead.CMS_Contract_Number__c != null && (isInsert || (isUpdate && lead.CMS_Contract_Number__c != mapLeadOldmap.get(lead.Id).CMS_Contract_Number__c))){
                CMSContractsRelationNames.add(lead.CMS_Contract_Number__c);
            }
        }
       
        for(Retail_Task__c con : [select ContractNumber__c, Id from Retail_Task__c where ContractNumber__c in :CMSContractsRelationNames]) {
            CMSNameContractIdMap.put(con.ContractNumber__c, con.Id);
       }
       
        for(Lead__c lead : listNewLeads) {
            if((lead.RecordTypeId == leadFleetRt || lead.RecordTypeId == leadFinanceRt) && lead.CMS_Contract_Number__c != null && (isInsert || (isUpdate && lead.CMS_Contract_Number__c != mapLeadOldmap.get(lead.Id).CMS_Contract_Number__c))){
                if(CMSNameContractIdMap.containsKey(lead.CMS_Contract_Number__c)) {
                    lead.Existing_Contract__c = CMSNameContractIdMap.get(lead.CMS_Contract_Number__c);
                }
                else {
                    lead.addError('System does not exist such a contract.');
                }
            }
        }*/
    }
   
    public static void checkrecord(List<Lead__c> leads){

        Map<Lead__c, Map<String, String>> leadEmail = new Map<Lead__c, Map<String, String>>();
        Set<Id> dealerId = new Set<Id>();
        Map<Lead__c, List<String>> leadContactEmails = new Map<Lead__c, List<String>>();

        List<Lead__c> mailEocLead = new List<Lead__c>();
        for(Lead__c lead : leads) {
            if(lead.Is_Finance_Send_Email_Before_20_Days__c || lead.Is_Finance_Send_Email_Before_15_Days__c ||
               lead.Is_Finance_Send_Email_Before_60_Days__c||lead.Is_Fleet_Send_Email_Before_15_Days__c ||
               lead.Is_Fleet_Send_Email_Before_20_Days__c ||lead.Is_Fleet_Send_Email_Before_60_Days__c||
               lead.Is_Fleet_Send_Email_Before_45_Days__c ) {
                  mailEocLead.add(lead);
            }
        }

        if(!mailEocLead.isEmpty()){
            //send171Email(mailEocLead);
        }
    }
   
    // For User Story: US_AU-Lead-007, US_AU-Lead-021
    // For qualified Vehicle Leads, Finance Leads and Service/Parts Leads,
    //    system will auto assign them to the gate keepers of the assigned
    //    dealers, and send email notifications to lead owners and
    //    proper contacts
    public static void autoAssignLeads(Map<Id, Lead__c> newMap, Map<Id, Lead__c> oldMap, boolean isInsert,boolean isUpdate){
        set<String> setNatureRequest = new set<string>{'Quote Request','Parts Enquiry','Parts Enquiries', 'Service Booking'};
            try{
                if (boolean_autoassignleads== false){
                    
                    boolean_autoassignleads= true;           
                    Set<Id> rtIdSet = new Set<Id>{leadFinanceRT,leadVehicleRt,leadSPRt};
                        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                    System.debug(' auto assign Leads >>>>>>>>>> ' + boolean_autoassignleads);
                    System.debug('auto assign Leads boolean value >>>>>>>>>> ' + newMap.size());
                    List<String> etNames = New List<String>{'Lead_Assignment_Notification_Individual','Lead_Assignment_Notification_Company ', 'Lead_Gate_Keeper_Notification_Individual','Lead_Gate_Keeper_Notification_Company','Leads_Immediate_Notice' };
                        
                        EmailTemplate etToOwner_Person,etToOwner_Company, etToAssignement_Company,etToAssignement_Person,etToImmediateNotice ;
                    Map<id,id> ldDlerIdMap= new Map<id,id>(); 
                    List<EmailTemplate> List_Email_Template = [SELECT Id, DeveloperName FROM EmailTemplate WHERE  DeveloperName IN : etNames] ;
                    for (EmailTemplate et: List_Email_Template){
                        if (et.DeveloperName =='Lead_Assignment_Notification_Individual'){
                            etToAssignement_Person= et;
                        }
                        else if(et.DeveloperName =='Lead_Assignment_Notification_Company'){
                            etToAssignement_Company= et;
                        }
                        else if(et.DeveloperName =='Lead_Gate_Keeper_Notification_Individual'){
                            etToOwner_Person= et;
                        }
                        else if(et.DeveloperName =='Lead_Gate_Keeper_Notification_Company'){
                            etToOwner_Company= et;
                        }
                        else if (et.DeveloperName =='Leads_Immediate_Notice')
                        {
                            etToImmediateNotice=et;
                        }
                    }
                    Map<id,lead__c> newleadmap = new Map<id,lead__c> ([SELECT id, CAC_Lead_Status__c,Nature_of_Request__c,Business_unit__c,Sub_BusinessUnit__c,RecordTypeId,Sales_Consultant__c,ownerid, Contact__c, Assigned_Dealer__c,Contact__r.recordtypeid FROM Lead__c Where id IN : newMap.keySet()]);
                    Map<id,id> ldsalesconsulatantIdMap = new Map<id,id>();
                    
                    for(Lead__c Lead : newleadmap.Values())
                    {
                        if (Lead.CAC_Lead_Status__c == 'Qualified'  ) 
                        {
                            if (Lead.Assigned_Dealer__c != null && (isInsert || (isUpdate && (Lead.CAC_Lead_Status__c!=oldMap.get(Lead.id).CAC_Lead_Status__c || Lead.Assigned_Dealer__c != oldMap.get(Lead.id).Assigned_Dealer__c)))) 
                            {
                                ldDlerIdMap.put(Lead.id, Lead.Assigned_Dealer__c);
                            }
                        }
                        else if (setNatureRequest.contains(Lead.Nature_of_Request__c) && Lead.Assigned_Dealer__c != null && (isInsert || (isUpdate && Lead.Nature_of_Request__c != oldmap.get(Lead.Id).Nature_of_Request__c)))
                        {
                            ldDlerIdMap.put(Lead.id, Lead.Assigned_Dealer__c);
                        }
                        if (Lead.Sales_Consultant__c != null && (oldMap.get(Lead.id)== NULL ||  oldMap.get(Lead.id).Sales_Consultant__c !=  Lead.Sales_Consultant__c)) 
                        {
                            ldsalesconsulatantIdMap.put(Lead.id,lead.Sales_Consultant__c );
                        }
                    }
                    System.debug('Map Size >>>>>>>>>>>>>' + ldDlerIdMap.size());
                    Set<ID> DealerIdSet = new Set<id>(ldDlerIdMap.values());
                    Map<id, Account> AccountMap = New Map<id,Account> ([SELECT Id, RecordTypeId,(Select id, Business_Unit__c, Sub_BusinessUnit__c,Dealer_Lead_Gate_Keeper__c From Contacts WHERE Dealer_Lead_Gate_Keeper__c= true) FROM Account WHERE Id IN: DealerIdSet]);
                    List<User> GateKeeperUsersList = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE ContactId IN (SELECT Id FROM Contact WHERE AccountId IN : DealerIdSet AND Dealer_Lead_Gate_Keeper__c = true)];
                    System.debug('Users Size >>>>>>>>>>>>>' + GateKeeperUsersList.size());
                    
                    //// SalesCOnsultant 
                    if (!ldsalesconsulatantIdMap.isEmpty()){
                        Set<Id> SalesConsultantIdSet = new Set<Id>();
                        SalesConsultantIdSet.addAll(ldsalesconsulatantIdMap.values());
                        List<Contact> SalesConsultantList = [SELECT id, Email, AccountId FROM Contact WHERE id IN: SalesConsultantIdSet and Email != null];
                        Map<id,id> S_Consulatnt_to_act_Map = new Map<id,Id>();
                        for(Contact Cn: SalesConsultantList){
                            S_Consulatnt_to_act_Map.put(cn.id,cn.AccountId);
                        }
                        Map<id,Account> ConsultantAccountMap = new Map<id,Account>([SELECT Id, RecordTypeId FROM Account Where Id IN: S_Consulatnt_to_act_Map.values()]);  
                        for (Id leadId: ldsalesconsulatantIdMap.keySet()){
                            
                            Id ContactId= ldsalesconsulatantIdMap.get(leadId);
                            Id AccountId = S_Consulatnt_to_act_Map.get(ContactId);
                            Id RecordTypeId = ConsultantAccountMap.get(AccountId).recordTypeId;
                            if (RecordTypeId == PersonalAccountRT){
                                Messaging.SingleEmailMessage mail= SingleEmailMessageWithparams(ContactId,etToAssignement_Person.Id,leadId ) ;
                                mailList.add(mail);
                            }
                            else{
                                Messaging.SingleEmailMessage mail= SingleEmailMessageWithparams(ContactId,etToAssignement_Company.Id,leadId ) ;
                                mailList.add(mail);
                            }
                        }
                    }
                    
                    // Gate keeper is true , Business unit is match and Offered Unit is match
                    Map<id, User> ContacttoUserMap= new Map<id, User>();
                    for(User usr: GateKeeperUsersList){
                        ContacttoUserMap.put(usr.contactId, usr);
                    }
                    
                    
                    // Mail notification to Gate keeper 
                    if(ContacttoUserMap!= Null && !ContacttoUserMap.isEmpty()){
                        List<Lead__c> updateleadslist= new List<lead__c>();
                        for(ID LeadId:ldDlerIdMap.keySet() ){
                            Lead__c lead = newleadmap.get (leadid);
                            ID AccId=ldDlerIdMap.get(LeadId);
                            Account Acct= AccountMap.get(AccId);
                            List<Contact> Cnts = AccountMap.get(AccId).contacts;
                            User usr = new user();
                            for ( Contact cnt : Cnts){
                                
                                if (cnt.business_unit__c != null && cnt.business_unit__c .Indexof(lead.Business_unit__c)> -1 && cnt.Sub_BusinessUnit__c != null && cnt.Sub_BusinessUnit__c.Indexof(lead.Sub_BusinessUnit__c) > -1){
                                    usr= ContacttoUserMap.get(cnt.id);
                                    System.debug('User name >>>>>>>>>>> ' + usr.id);
                                    break;
                                }
                            }
                            if (usr.id != Null ){
                                newleadmap.get(LeadId).ownerid= usr.id;
                                updateleadslist.add ( newleadmap.get(LeadId));
                                if (newleadmap.get(LeadId).contact__r.recordtypeid ==  PersonalAccountRT  && etToOwner_Person !=NULL){
                                    
                                    Messaging.SingleEmailMessage mail=SingleEmailMessageWithparams(usr.id,etToOwner_Person.Id,LeadId );
                                    mailList.add(mail);
                                }
                                else{
                                    if (etToOwner_Company!= NULL){
                                        
                                        Messaging.SingleEmailMessage mail=SingleEmailMessageWithparams(usr.id,etToOwner_Company.Id,LeadId );
                                        mailList.add(mail);
                                    }
                                }
                                
                            }
                            
                        }
                        
                        System.debug('Messaging Size ' + mailList.size());
                        if (mailList.size()>0){
                            Messaging.sendEmail(mailList);
                            update updateleadslist;
                        }
                    }     
                    
                    
                }
                
            }catch(Exception Ex){
                System.debug('Exception >>>>>>>> ' + ex.getMessage());
                System.debug('Caused By >>>>>>>>>>>>> ' + ex.getCause());
                System.debug(' Line Number >>>>>>>>>>' + Ex.getLineNumber());
            }
    }
    
    private static Messaging.SingleEmailMessage SingleEmailMessageWithparams(Id TargetObjectId, Id EmailTemplateId , Id WhatObjectId ){
         Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
         mail.setTargetObjectId(TargetObjectId);
         mail.setTemplateId(EmailTemplateId);
         mail.setOrgWideEmailAddressId(OrgWideEmailAddressId);
         mail.setWhatId(WhatObjectId);
        return mail;
    }
    
      //CR-000141 Send Immediate Notice and 24H and 72H Email for Service/Parts Lead.
    public static void sendServicePartsEmail (List<Lead__c> leadsForSend, Set<Id> DealerIds, String EmailType) {
    system.debug('ENtered Email Method');
        Map<Lead__c, List<String>> leadContactToEmails = new Map<Lead__c, List<String>>();
        Map<Lead__c, List<String>> leadContactCCEmails = new Map<Lead__c, List<String>>();
         List<Contact> MonkContacts = new List<Contact>();  
        
        EmailTemplate VehicleTemplate = [select id ,developername from EmailTemplate where developername = 'EMC_Qualified_Vehicle_Lead'];
        
        List<Contact> listContact = [select id, EOC_Recipient_Type__c, Email, AccountId, Lead_Escalation_Recipient_Type__c, Business_Unit__c, Sub_BusinessUnit__c from Contact where AccountId in :DealerIds
                                    and Lead_Escalation_Recipient_Type__c != null and Business_Unit__c != null and Sub_BusinessUnit__c != null and Email != null and contact.Inactive__c = false];
         //TODO                            
        /*List<MBAuP_Contact__c> MBAuPContacts = [select Id, Business_Unit__c, Dealer_Name__c, Email_Address__c, Lead_Escalation_Recipient_Type__c, EOC_Recipient_Type__c, First_Name__c, Sub_Business_Unit__c from MBAuP_Contact__c where Dealer_Name__c in :DealerIds
                                    and Lead_Escalation_Recipient_Type__c != null and Business_Unit__c != null and Sub_Business_Unit__c != null and Email_Address__c != null];*/
        
        for(Lead__c lead : leadsForSend) {
            List<String> TOemails = new List<String>();
            List<String> CCemails = new List<String>();
            
            for(Contact contact : listContact) {
                set<string> BusinessSet = new set<string>();
                if(contact.Business_Unit__c != null && contact.Business_Unit__c !=''){
                    for(String s:contact.Business_Unit__c.split(';')){
                        BusinessSet.add(s.toLowerCase());
                        system.debug('Busines'+s+'ggggggggggggg'+contact.Business_Unit__c);
                    }
                }
                set<string> Sub = new set<string>();
                if(contact.Sub_BusinessUnit__c != null && contact.Sub_BusinessUnit__c !=''){
                    for(String s:contact.Sub_BusinessUnit__c.split(';')){
                        Sub.add(s.toLowerCase());
                    }
                }
                system.debug('BusinessSet============='+BusinessSet);
                
                //modified by Shuang Li Defect0345 Start
                if(contact.AccountId == lead.Assigned_Dealer__c && BusinessSet.contains(lead.Business_Unit__c.toLowerCase()) && Sub.contains(lead.Sub_BusinessUnit__c.toLowerCase())) {
                //modified by Shuang Li Defect0345 End
                    if(contact.Lead_Escalation_Recipient_Type__c.contains(EmailType) && contact.Email != null) {
                        TOemails.add(contact.Email); 
                        system.debug('to email @@@@@@@@@@@@@@@@@@@'+TOemails.size());
                        system.debug('to email @@@@@@@@@@@@@@@@@@@'+TOemails[0]);
                    }
                    else if(contact.AccountId == lead.Assigned_Dealer__c && contact.Lead_Escalation_Recipient_Type__c.contains('CC Lead Escalation Recipient')) {
                        CCemails.add(contact.Email);
                    }
                }
            }
            //TODO
            /*
            for(MBAuP_Contact__c contact : MBAuPContacts) {
                if(contact.Dealer_Name__c == lead.Assigned_Dealer__c && contact.Business_Unit__c.contains(lead.Business_Unit__c) && contact.Sub_Business_Unit__c.contains(lead.Sub_BusinessUnit__c) && contact.Lead_Escalation_Recipient_Type__c.contains(EmailType)) {
                    TOemails.add(contact.Email_Address__c);
                }
                else if(contact.Dealer_Name__c == lead.Assigned_Dealer__c && contact.Lead_Escalation_Recipient_Type__c.contains('CC Lead Escalation Recipient')) {
                    CCemails.add(contact.Email_Address__c);
                }
            }*/
            if(!TOemails.isEmpty()) {
                leadContactToEmails.put(lead, TOemails);
            }
            if(!CCemails.isEmpty()) {
                leadContactCCEmails.put(lead, CCemails);
            }
        }        
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        //2014-2-19 Barney lai start
        Map<Id, Account> leadAccounts = new Map<Id, Account>();
        Set<Id> contactIds = new Set<Id>();
        for(Lead__c lead : leadContactToEmails.keyset()) {
            if(lead.Company_Account__c != null) {
                contactIds.add(lead.Company_Account__c);
            }
            else if(lead.contact__c != null) {
                contactIds.add(lead.contact__c);
            }
        }
        for(Account acc : [select Id, Salutation, Name from Account where id in :contactIds]) {
            for(Lead__c lead : leadContactToEmails.keyset()) {
                if(acc.id == lead.Company_Account__c) {
                    leadAccounts.put(lead.Id, acc);
                }
                else if(acc.id == lead.contact__c) {
                    leadAccounts.put(lead.Id, acc);
                }
            }
        }
        system.debug('leadContactToEmails'+leadContactToEmails);
        for(Lead__c lead : leadContactToEmails.keyset()) {
            Contact MonkContact = MonkCotact(leadContactToEmails.get(lead)[0]);
             MonkContacts.add(MonkContact);
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //message.setToAddresses(leadContactToEmails.get(lead));
            if(leadContactCCEmails.containsKey(lead)) {
                message.setCCAddresses(leadContactCCEmails.get(lead));
            }
            message.setWhatId(lead.id);
            message.setTemplateId(VehicleTemplate.Id);
            message.setTargetObjectId(MonkContact.id);
            message.setsaveAsActivity(false);
            if(EmailType == 'Immediate Notice')
            {
                message.setOrgWideEmailAddressId(EmcOrgWideEmailAddressId);
            }
            else
            {
                message.setOrgWideEmailAddressId(OrgWideEmailAddressId);
            }
            messages.add(message);
        }

        if(messages.size() > 0){
            try{
                Messaging.sendEmail(messages);
            }
            catch(Exception e){
                system.debug('Send ServiceParts Leads Immediate Notice/24H/72H Email Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
            }
            finally{
            if(!MonkContacts.isEmpty()){
                delete MonkContacts;
            }  
        }
    }
    }
   
    //CR-000141 Send Immediate Notice and 24H and 72H Email for Finance Lead.
    public static void sendFinanceEmail (List<Lead__c> leadsForSend, Set<Id> DealerIds) {
        Map<Lead__c, List<String>> leadContactToEmails = new Map<Lead__c, List<String>>();
        Map<Lead__c, List<String>> leadContactCCEmails = new Map<Lead__c, List<String>>();
        EmailTemplate financeTemplate = [select id ,developername from EmailTemplate where developername = 'Finance_Leads_Only'];
       
         List<Contact> listContact = [select id, EOC_Recipient_Type__c, Email, AccountId, Finance_Lead_Type__c, Lead_Escalation_Recipient_Type__c, Business_Unit__c, Sub_BusinessUnit__c
                                     from Contact where AccountId in :DealerIds and Lead_Escalation_Recipient_Type__c != null and contact.Inactive__c = false];
                  
        //Added contact Inactive check in the above query 3/6/2015(SFDCAU-164)
        //TODO
        /*List<MBAuP_Contact__c> MBAuPContacts = [select Id, Business_Unit__c, Dealer_Name__c, Finance_Lead_Type__c, Email_Address__c, Lead_Escalation_Recipient_Type__c, EOC_Recipient_Type__c, First_Name__c, Sub_Business_Unit__c
                                                from MBAuP_Contact__c where Dealer_Name__c in :DealerIds and Lead_Escalation_Recipient_Type__c != null];*/
       
        for(Lead__c lead : leadsForSend) {
            List<String> TOemails = new List<String>();
            List<String> CCemails = new List<String>();
           
            for(Contact contact : listContact) {
                //modified by SFDCAU-467 & SFDCAU-524 Defect Start
                if(contact.Email != null &&
                    contact.AccountId == lead.Assigned_Dealer__c  &&
                    contact.Finance_Lead_Type__c != null &&
                   lead.Nature_of_Request__c != null &&
                    contact.Finance_Lead_Type__c.contains(lead.Nature_of_Request__c) &&
                    contact.Business_Unit__c != null &&
                    contact.Sub_BusinessUnit__c != null &&
                    contact.Business_Unit__c.contains(lead.Business_Unit__c) &&
                    ((lead.Sub_BusinessUnit__c == 'Finance & Insurance' && (contact.Sub_BusinessUnit__c.contains('Finance') || contact.Sub_BusinessUnit__c.contains('Insurance'))) ||
                    contact.Sub_BusinessUnit__c.contains(lead.Sub_BusinessUnit__c))
                    )
                    {
                        if(lead.X24H_Untouched__c == false && lead.X72H_Untouched__c == false && contact.Lead_Escalation_Recipient_Type__c.contains('Immediate Notice'))
                        {
                            TOemails.add(contact.Email);
                        }
                        else if(lead.X24H_Untouched__c == true && lead.X72H_Untouched__c == false && contact.Lead_Escalation_Recipient_Type__c.contains('24H Untouched Notice'))
                        {
                            TOemails.add(contact.Email);
                        }
                        else if(lead.X72H_Untouched__c == true && contact.Lead_Escalation_Recipient_Type__c.contains('72H Untouched Notice'))
                        {
                            TOemails.add(contact.Email);
                        }
                    }
                else if(contact.AccountId == lead.Assigned_Dealer__c && contact.Lead_Escalation_Recipient_Type__c.contains('CC Lead Escalation Recipient')) {
                    CCemails.add(contact.Email);
                }
            }
             //modified by SFDCAU-467 & SFDCAU-524 Defect End
            if(!TOemails.isEmpty()) {
                leadContactToEmails.put(lead, TOemails);
            }
            if(!CCemails.isEmpty())
            {
                leadContactCCEmails.put(lead, CCemails);
            }
        }       
 
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<Contact> MonkContacts = new List<Contact>();
        for(Lead__c lead : leadContactToEmails.keyset())
        {
            Contact MonkContact = MonkCotact(leadContactToEmails.get(lead)[0]);
            MonkContacts.add(MonkContact);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            leadContactToEmails.get(lead).remove(0);
            message.setToAddresses(leadContactToEmails.get(lead));
            if(leadContactCCEmails.containsKey(lead))
            {
                message.setCCAddresses(leadContactCCEmails.get(lead));
            }
            message.setWhatId(lead.id);
            message.setTemplateId(financeTemplate.Id);
            message.setTargetObjectId(MonkContact.id);
            message.setsaveAsActivity(false);
            message.setOrgWideEmailAddressId(OrgWideEmailAddressId);
            messages.add(message);
        }

        if(!messages.isEmpty())
        {
            try
            {
                Messaging.sendEmail(messages);
            }
            catch(DMLException e){
                system.debug('Send Finance Leads Immediate Notice/24H/72H Email Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
            }
            finally
            {
                if(!MonkContacts.isEmpty())
                {
                    delete MonkContacts;
                }
            }   
        }
    }
   
    //modified by Bing CR-000171 Start
    public static void send171Email(List<Lead__c> leads){
      system.debug('send email'+leads);
        //get mail template
        Map<String,id> templateIds = new Map<String,id>();
        for (EmailTemplate m : [select id ,developername from EmailTemplate where developername in ( 'Finance_Leads_Only','Fleet_EOC_Template')]){
            templateIds.put(m.developername, m.id);
        }
       
        List<Contact> MonkContacts = new List<Contact>();
       
        try{
            //initial email information
            Map<id, Map<String,List<String>>> emailInfos =  initialEmail(leads);
            List<Messaging.Email> mailList = new List<Messaging.Email>();
           
            for(Lead__c lead : leads) {
                if (emailInfos.containskey(lead.id)){
                    if (emailInfos.get(lead.id).get('TO').size()<1){
                       continue;
                    }
                }
               
                //get monk contact
                Contact MonkContact = MonkCotact(emailInfos.get(lead.id).get('TO')[0]);
                MonkContacts.add(MonkContact);
                String temlateId = '';
                if(lead.RecordTypeId == leadFleetRt){
                    temlateId = templateIds.get('Fleet_EOC_Template');
                }
                if(lead.RecordTypeId == leadFinanceRT){
                    temlateId = templateIds.get('Finance_Leads_Only');
                }

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                emailInfos.get(lead.id).get('TO').remove(0);
                message.setToAddresses(emailInfos.get(lead.id).get('TO'));
                message.setCcAddresses(emailInfos.get(lead.id).get('CC'));
                message.setWhatId(lead.id);
                message.setTemplateId(temlateId);
                message.setTargetObjectId(MonkContact.id);
                message.setOrgWideEmailAddressId(OrgWideEmailAddressId);
                message.setsaveAsActivity(false);
                mailList.add(message);
            }
            Messaging.sendEmail(mailList);
        }catch(Exception e)
        {
             system.debug('There is something wrong with send Email'+ e);
        }finally
        {
            if(!MonkContacts.isEmpty()){
                delete MonkContacts;
            }    
        }
    }
   
  @TestVisible
    private static Contact MonkCotact(String mailAdd){
   
        String monkLastName = 'Contact' + Math.round(Math.random() * (1000 - 1)) + 1;
        String monkFirstName = 'monk';
        while(true){
            list<Contact> inDatabaseC = [select id from Contact where lastName=:monkLastName];
            if (inDatabaseC.size()<1) {
                Contact monkc = new Contact(FirstName=monkFirstName,lastName=monkLastName,Email=mailAdd);
                insert monkc;
                return monkc;
            }
            monkLastName = 'monkContact' + Math.round(Math.random() * (1000 - 1)) + 1;
        }
       
        return null;
    }
   
     /**
      * initial all mail information that should be send mail
      */
    public static  Map<id, Map<String,List<String>>> initialEmail(List<Lead__c> leads){
        //get Dealer id
        Set<id> dealerId = new Set<id>();
        for(Lead__c lead : leads) {
            if(lead.Assigned_Dealer__c != null) {
                dealerId.add(lead.Assigned_Dealer__c);
            }
        }
        //get dealer contact info
        Map<id,Account> contactMap = new Map<id,Account>(
                                     [Select Id , (Select Email, EOC_Recipient_Type__c From Contacts where Email != null and Inactive__c = false)
        
                                   From Account where Id in :dealerId]);
        //TODO 
        //get dealer mbContact info
        /*Map<id,Account> mBContactMap = new Map<id,Account>(
                                       [select id, (Select Email_Address__c, EOC_Recipient_Type__c From MBAuP_Contacts__r where Email_Address__c != null)
                                       From Account a where id in :dealerId]);*/

        //Clear up contact mail
        Map<id, Map<String,List<String>>> initialEmail = new Map<id, Map<String,List<String>>>();
        for(Lead__c lead : leads) {
            if(lead.Assigned_Dealer__c != null) {
                //TODO-commented mBContactMap is not used
                //Map<String,List<String>> mailInfos = getMailAddress(lead, mBContactMap, contactMap);
                Map<String,List<String>> mailInfos = getMailAddress(lead,contactMap);
                if(mailInfos.get('TO').size()>0){
                    initialEmail.put(lead.id ,mailInfos);
                }
            }
        }
       system.debug('initialEmail>>>>>>>>>>'+initialEmail);
        return initialEmail;
       
    }
   
    /**
       get contact Mailaddress
     */
    public static Map<String,List<String>> getMailAddress(Lead__c lead,Map<id,Account> contactMap){
        String keyword1 = '';
        String keyword2 = '';
        if(lead.Is_Finance_Send_Email_Before_60_Days__c||lead.Is_Fleet_Send_Email_Before_60_Days__c) {
            keyword1 = '60 Days Primary';
            keyword2 = '60 Days CC';
        }
        if(lead.Is_Finance_Send_Email_Before_20_Days__c||lead.Is_Fleet_Send_Email_Before_20_Days__c) {
            keyword1 = '20 Days Primary';
            keyword2 = '20 Days CC';
        }
        if(lead.Is_Finance_Send_Email_Before_15_Days__c||lead.Is_Fleet_Send_Email_Before_15_Days__c) {
            keyword1 = '15 Days Primary';
            keyword2 = '15 Days CC';
        }
        if(lead.Is_Fleet_Send_Email_Before_45_Days__c) {
            keyword1 = '45 Days Primary';
            keyword2 = '45 Days CC';
        }
        if(lead.Is_Finance_Send_Email_Before_150_Days__c||lead.Is_Fleet_Send_Email_Before_150_Days__c) {
            keyword1 = '150 Days Primary';
            keyword2 = '150 Days CC';
        }
        Set<String> toAdds = new Set<String>();
        Set<String> ccAdds = new Set<String>();
        Map<String,List<String>> mailAdds = new Map<String,List<String>>();
        //TODO
        //List<MBAuP_Contact__c> mBContacts = mBContactMap.get(lead.Assigned_Dealer__c).MBAuP_Contacts__r;
        List<Contact> contacts = ContactMap.get(lead.Assigned_Dealer__c).Contacts;
        /*for(MBAuP_Contact__c c : mBContacts){
            if(c.get('EOC_Recipient_Type__c')!=null){
                if(c.EOC_Recipient_Type__c.contains(keyword1)){
                    if( toAdds.contains(c.Email_Address__c)){
                        continue;
                    }else{
                        toAdds.add(c.Email_Address__c);
                    }
                }
                if(c.EOC_Recipient_Type__c.contains(keyword2)){
                    if(ccAdds.contains(c.Email_Address__c)){
                        continue;
                    }else{
                        ccAdds.add(c.Email_Address__c);
                    }
                }
            }
        }*/
        if(lead.recordtypeId == leadFinanceRT){
            for(Contact c : contacts){
                if(c.get('EOC_Recipient_Type__c')!=null){
                    if(c.EOC_Recipient_Type__c.contains(keyword1)){
                        if( toAdds.contains(c.Email)){
                            continue;
                        }else{
                            toAdds.add(c.Email);
                        }
                    }
                    if(c.EOC_Recipient_Type__c.contains(keyword2)){
                        if(ccAdds.contains(c.Email)){
                            continue;
                        }else{
                            ccAdds.add(c.Email);
                        }
                    }
                }
            }
        }
        mailAdds.put('TO',new List<String>(toAdds));
       mailAdds.put('CC',new List<String>(ccAdds));

        return mailAdds;
       
    }
   
    // US_AU-Lead-005 For Finance Leads, if Existing Contract is filled, Assigned Dealer will be auto filled as Contract Dealer
    public static void autoFillAssignedDealer(List<Lead__c> newLeads){
        Set<Lead__c> toBeDealtLds = new Set<Lead__c>();
        Set<Id> contrctIds = new Set<Id>();
        Map<Id, Id> ldContrctMap = new Map<Id, Id>();
        for(Lead__c lead : newLeads){
            if(lead.RecordTypeId == leadFinanceRT && lead.Existing_Contract__c != null && lead.Assigned_Dealer__c == null){
                toBeDealtLds.add(lead);
                contrctIds.add(lead.Existing_Contract__c);
                ldContrctMap.put(lead.Id, lead.Existing_Contract__c);
            }
        }

        if(toBeDealtLds.size() > 0){
            Map<Id, Retail_Task__c> contrctIdMap = new Map<Id, Retail_Task__c>([SELECT Id, Related_Dealer__c FROM Retail_Task__c WHERE Id IN: contrctIds AND Related_Dealer__c != null]);
            if(contrctIdMap.size() > 0){
                for(Lead__c lead : toBeDealtLds){
                    Id contrctId = ldContrctMap.get(lead.Id);
                    Id dealerId = contrctIdMap.get(contrctId).Related_Dealer__c;
                    Lead.Assigned_Dealer__c = dealerId;
                }
            }
        }
    }
   
    public static void auBeforeUpdateGenericVehicleRecordOnVehicleRelationship(List<Lead__c> newLeads,map<id,Lead__c> mapLeadOldmap,map<id,Lead__c> mapLeadNewmap)
    {
        map<id,id> mapAccountIdtoCurrentVehicleid=new map<id,id>();
       
        for(Lead__c objLead:newLeads)
        {
            if(objLead.Current_Vehicle__c!=null && mapLeadOldmap.get(objLead.Id).Current_Vehicle__c!=mapLeadNewmap.get(objLead.Id).Current_Vehicle__c && objLead.Contact__c!=null)
            {
                if(!mapAccountIdtoCurrentVehicleid.containsKey(objLead.Contact__c))
                    mapAccountIdtoCurrentVehicleid.put(objLead.Contact__c,objLead.Current_Vehicle__c);
            }
        }
       
        if(mapAccountIdtoCurrentVehicleid!=null && !mapAccountIdtoCurrentVehicleid.isEmpty())
        {
            List<Vehicle_Relationship__c> lstVR=[select id,Vehicle_ID__c,Contact__c,Car_Relation__c from Vehicle_Relationship__c where Contact__c=:mapAccountIdtoCurrentVehicleid.keyset()];
           
            if(lstVR!=null && !lstVR.isEmpty())
            {
                for(Vehicle_Relationship__c objVR:lstVR)
                {
                    objVR.Car_Relation__c='Current Vehicle';
                    if(mapAccountIdtoCurrentVehicleid.get(objVR.Contact__c)!=null)
                        objVR.Vehicle_ID__c=mapAccountIdtoCurrentVehicleid.get(objVR.Contact__c);
                }
               
                update lstVR;
            }          
            else
            {
                List<Vehicle_Relationship__c> insertNewVR= new List<Vehicle_Relationship__c>();
               
                for(Lead__c objLead:newLeads)
                {
                    Vehicle_Relationship__c objNew= new Vehicle_Relationship__c();
                    objNew.Car_Relation__c='Current Vehicle';
                    if(mapAccountIdtoCurrentVehicleid.get(objLead.Contact__c)!=null)
                    {
                        objNew.Vehicle_ID__c=mapAccountIdtoCurrentVehicleid.get(objLead.Contact__c);
                        objNew.Contact__c=objLead.Contact__c;
                    }
                    insertNewVR.add(objNew);
                }
               
                if(insertNewVR!=null && !insertNewVR.isEmpty())
                {
                    insert insertNewVR;
                }
           }
        }
    }
               
   
   //Email notification when Assigned Dealer is changed.
    public static void emailNotificationsToAssignedDealer(List<Lead__c> listNewLeads,map<id,Lead__c> leadNewMap,map<Id,Lead__c> leadOldMap,boolean isInsert,boolean isUpdate){
             system.debug('emailNotificationsToAssignedDealer');
          
       map<id,Lead__c> sendEmailMap=new map<id,Lead__c>();
      for(Lead__c lead :listNewLeads){
           
        if(lead.RecordTypeId == leadFleetRt && lead.Assigned_Dealer__c != null&& (isInsert || (isUpdate && lead.Assigned_Dealer__c != leadOldMap.get(lead.Id).Assigned_Dealer__c)))
       {         
                     sendEmailMap.put(lead.id,lead);
                     system.debug('sendEmailMap'+sendEmailMap);
       }
                } 
                Map<Id,List<String>> mapAccountIdAndEmail = new Map<Id,List<String>>(); 
                  if(!sendEmailMap.isEmpty())
                  {
                    EmailTemplate etToOwner = [SELECT Id,Body,Subject FROM EmailTemplate WHERE Name = 'Email notification when Assigned Dealer is changed' limit 1];
                    system.debug('etToOwner'+etToOwner);
                    List<Messaging.Email> mailList = new List<Messaging.Email>();
                    list<Lead__c>  accountOwnerids=[select id,Name,Assigned_Dealer__r.owner.Email,Assigned_Dealer__c from Lead__c where id in:sendEmailMap.keyset()];
                    if(accountOwnerids != null){
                        Set<Id> accountId = new Set<Id>();
                        for(Lead__c leadObj: accountOwnerids){
                            accountId.add(leadObj.Assigned_Dealer__c);
                        }
                        
                        List<Contact> contactlst = [Select Email,Id,AccountId FROM Contact where AccountId IN:accountId and Salutation = 'DRM MBFS'];
                        for(Contact contactObj :contactlst ){
                            if(!mapAccountIdAndEmail.containsKey(contactObj.AccountId))
                            {
                               mapAccountIdAndEmail.put(contactObj.AccountId,new List<String>());
                            }
                                mapAccountIdAndEmail.get(contactObj.AccountId).add(contactObj.Email);
                        }
                    }
                    String[] toAdresss = new String[]{};
                    if(!accountOwnerids.isEmpty())
                    {     
                     for(Lead__c lead :accountOwnerids)
                        {   
                        
                             // Send email notification to the new owner
                            //toAdresss.add(lead.Assigned_Dealer__r.owner.Email);
                           // toAdresss.addAll(mapAccountIdAndEmail.get(lead.Assigned_Dealer__c));
                            system.debug('lead.Assigned_Dealer__r.owner.Email'+lead.Assigned_Dealer__r.owner.Email);
                            String subject = etToOwner.subject.replace('{!Lead__c.Name}',lead.Name);
                            system.debug('subject'+subject);
                            String body = etToOwner.body.replace('{!Lead__c.Name}',lead.Name);
                            system.debug('body'+body);
                            Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
                            //mail.setToAddresses(toAdresss);
                            mail.setSaveAsActivity(false);
                            //system.debug('lead.Assigned_Dealer__r.ownerid'+lead.Assigned_Dealer__r.ownerid);    
                           // mail.setTargetObjectId(lead.Assigned_Dealer__r.ownerid);
                           // mail.setTemplateId(etToOwner.Id);
                            //mail.setSubject(subject);
                            //mail.setPlainTextBody(body);
                         /*  if (!Test.isRunningTest())
                               {
                                 mail.setOrgWideEmailAddressId(OrgWideEmailAddressId);
                                }*/
                           
                           // mail.setWhatId(lead.Id);
                            //mailList.add(mail);
                            toAdresss.clear();
                      }
        }      
          
                  if(!mailList.isEmpty())
        {
            try
           {  system.debug('mailList'+mailList);
                
             Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);
             if (results[0].success) {

               System.debug('The email was sent successfully.');
             }   
            }
            catch(DMLException e){
                system.debug('Email notification when Assigned Dealer is changed Email Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
            }
           
        }                                                
    }  
                     
    //Existing Au functionality ends here
    }
    
    
    //Email notification when Lead is created or updated with Buisness Unit Cars/Vans.
    public static void sendEmailNotificationsToAssignedDealer(List<Lead__c> listNewLeads,map<id,Lead__c> leadNewMap,map<Id,Lead__c> leadOldMap,boolean isInsert,boolean isUpdate)
    {        
        map<id,string> leadMailMap = new map<id,string>();
        List<string> toAddress = new List<string>();
        List<Account> acclist = new List<Account>();
        List<Contact> MonkContacts = new List<Contact>();
        set<id> accid = new set<id>();
        List<Messaging.Email> mailList = new List<Messaging.Email>();
        for(Lead__c lead :listNewLeads)
        {          
            if(lead.RecordTypeId == leadVehicleRt && lead.Email__c != null && lead.Email__c != '' &&
               (lead.Business_Unit__c == 'Cars' || lead.Business_Unit__c == 'Vans') && (isInsert || (isUpdate && lead.Business_Unit__c != leadOldMap.get(lead.Id).Business_Unit__c)))
            {         
                leadMailMap.put(lead.id,lead.Email__c);
            }                   
        }
        
        EmailTemplate etassigneddealer = [SELECT Id,Body,Subject FROM EmailTemplate WHERE Name = 'Brochure Request/Test Drive Request Email CARS' limit 1];         
        if(!leadMailMap.isEmpty() && leadMailMap != null)
        {
            for(Lead__c leds : listNewLeads)
            {                
                Contact MonkContact = MonkCotact(leadMailMap.get(leds.Id));                                          
                Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
                //mail.setToAddresses(toAddress);
                mail.setTargetObjectId(MonkContact.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(leds.Id);
                mail.setTemplateId(etassigneddealer.Id);
                mailList.add(mail);
                MonkContacts.add(MonkContact);                    
                                                
            }
            system.debug('mailList>>>>>>' + mailList);
            try
            {                  
                Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);
                if (results[0].success) 
                {
                    
                    System.debug('The email was sent successfully.');
                }   
            }       
            catch(Exception e)
            {
                system.debug('Email notification when Assigned Dealer is changed Email Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
            }
            finally
            {
                if(!MonkContacts.isEmpty())
                {
                    delete MonkContacts;
                }
            }
        }
    }
    public static void leadPriorityScore(List<Lead__c> leadlist)
    {
        utilPriorityScore.getEnquiryTypeScore();        
        utilVehicleClass.getVehicleclass();
        set<id> accids = new set<id>();
        List<Account> accountlist = new List<Account>();
        List<Vehicle_Relationship__c> vehrellist = new List<Vehicle_Relationship__c>();
        List<Retail_Task__c> contractList = new List<Retail_Task__c>();
        map<string,Decimal> enquiryMap = utilPriorityScore.enquiryTypeMap;
        map<string,Decimal> purchaseMap = utilPriorityScore.purchaseIntentMap;
        map<string,Decimal> behaviouralMap = utilPriorityScore.behaviouralGroupMap;
        map<string,Decimal> contractMap = utilPriorityScore.contractRecordTypeMap;
        map<string,Decimal> testDriveMap = utilPriorityScore.requestTestDriveMap;
        map<string,Decimal> vechClassMap = utilVehicleClass.vehicleClassMap;
        map<id,Decimal> accvehlmap = new map<id,Decimal>();
        map<string,string> leadRequestMap = utilPriorityScore.natureOfRequestMap;
        map<string,string> carMap = utilPriorityScore.leadCarsMap;
        map<string,string> vanMap = utilPriorityScore.leadVanMap;
        map<string,Decimal> numberOfMbMap = utilPriorityScore.noOfMBsMap;
        Map<string, Decimal> highestClassMap = new Map<string, Decimal>();
        Map<string, Decimal> vehicleClassMap = new Map<string, Decimal>();
        map<string,Decimal> prospectenquiryMap = utilPriorityScore.prospectenquiryTypeMap;
        map<string,Decimal> prospectpurchaseMap = utilPriorityScore.prospectpurchaseIntentMap;
        map<string,Decimal> prosleadMap = utilPriorityScore.prospectLeadMap;
        map<id,string> accountPCStatusMap = new map<id,string>();
        map<id,string> accountCVStatusMap = new map<id,string>();
        map<id,string> accountVANStatusMap = new map<id,string>();
        map<id,string> behaviourMap = new map<id,string>();
        set<id> rtids = new set<id>();
        
        
        for(Lead__c led : leadlist)
        {                        
            if(led.Contact__c != null)
            {
                accids.add(led.Contact__c);
            }
            else if(led.Company_Account__c != null)
            {
                accids.add(led.Company_Account__c);
            }
        }
        if(!accids.isEmpty() && accids != null)
        {
            vehrellist = [select id,Car_Relation__c,Contact__c,Status__c,Vehicle_ID__c,Vehicle_ID__r.Class__c from Vehicle_Relationship__c where Contact__c IN :accids];
            contractList = [select id,Account__c,RecordType.Developername from Retail_Task__c where Account__c IN :accids];
            accountlist = [select id,PC_Status__c,CV_Status__c,VAN_Status__c,Behavioural_Group__c from Account where ID IN :accids];            
        }
        
        for(Lead__c le : leadlist)
        {
            for(Account acc: accountlist)
            {
                if((le.Contact__c != null && le.Contact__c == acc.id) || (le.Company_Account__c != null && le.Company_Account__c == acc.id))
                {                    
                    accountPCStatusMap.put(acc.Id, acc.PC_Status__c);
                    accountCVStatusMap.put(acc.Id, acc.CV_Status__c);
                    accountVANStatusMap.put(acc.Id, acc.VAN_Status__c);
                    if(acc.Behavioural_Group__c != null && acc.Behavioural_Group__c != '')
                    {
                        behaviourMap.put(acc.Id, acc.Behavioural_Group__c);
                    }                    
                }
            }
        }
        
        for(Lead__c led : leadlist)
        {                               
             if((led.RecordTypeId == leadVehicleRt) && (leadRequestMap.containsKey(led.Nature_of_Request__c)) && (carMap.containsKey(led.Business_Unit__c)))
             {
                CustomLogUtil.CustomLoggingEntry('Lead Priority Score ' +leadlist.size() );
                 if(!accountPCStatusMap.isEmpty() && accountPCStatusMap != null && !accountCVStatusMap.isEmpty() && accountCVStatusMap != null &&
                    !accountVANStatusMap.isEmpty() && accountVANStatusMap != null && (accountPCStatusMap.get(led.Contact__c) == 'Customer' 
                    || accountCVStatusMap.get(led.Contact__c) == 'Customer' || accountVANStatusMap.get(led.Contact__c) == 'Customer'))                
                 {
                    Decimal Count = 0 ;
                    Decimal numberOfMBs = 0;
                    Decimal enquirytype = 0;
                    Decimal purchasetime = 0;
                    Decimal behavgroup = 0;
                    Decimal priorityScore = 0;
                    Decimal vechClassScore = 0;
                    Decimal contractScore = 0;
                    Decimal numberOfMBScore =0;
                    Decimal mbVechInterestScore = 0;
                    Decimal serviceScore = 0;
                    Decimal insuranceScore = 0;
                    Decimal maxvalue = 0;
                    Decimal maxClassvalue = 0; 
                    string vehicleclass; 
                    String value;
                    string maxkey;
                    string vehicleInterest;
                    string vehiclerelationClass;
                    List<string> vehiclerelationClasslist = new List<string>();
                    List<string> vehicleInterestList = new List<string>();
                    List<string> servicecontractlist = new List<string>();
                    List<string> insuranceContractList = new List<string>();
                    List<string> financecontractList = new List<string>();
                    if(!vehrellist.isEmpty() && vehrellist != null)
                    {
                        for(Vehicle_Relationship__c vrel : vehrellist)
                        {
                            if(vrel.Contact__c != null && ((led.Contact__c!= null && (led.Contact__c == vrel.Contact__c))
                              || (led.Company_Account__c != null && (led.Company_Account__c == vrel.Contact__c))) && vrel.Car_Relation__c == 'Owner')
                            {
                                Count++;
                                accvehlmap.put(vrel.Contact__c, Count);
                            }
                            if(vrel.Contact__c != null && ((led.Contact__c!= null && (led.Contact__c == vrel.Contact__c))
                              || (led.Company_Account__c != null && (led.Company_Account__c == vrel.Contact__c))) && vrel.Car_Relation__c == 'Owner'
                              && vrel.Status__c == 'Currently Owned')
                            {
                                vehiclerelationClasslist.add(vrel.Vehicle_ID__r.Class__c);
                            }
                        }
                    }
                     system.debug('vehiclerelationClasslist>>>>>' + vehiclerelationClasslist);
                    if(!contractList.isEmpty() && contractList != null)
                    {
                        for(Retail_Task__c rtask : contractList)
                        {
                            if(rtask.Account__c != null && ((led.Contact__c != null && led.Contact__c == rtask.Account__c)
                                || (led.Company_Account__c != null && led.Company_Account__c == rtask.Account__c)))
                            {
                                if(rtask.RecordTypeId == serviceContractRT)
                                {
                                    servicecontractlist.add(rtask.RecordType.DeveloperName);
                                }
                                else if(rtask.RecordTypeId == insuranceContractRT)
                                {
                                    insuranceContractList.add(rtask.RecordType.DeveloperName);
                                }
                                else if(rtask.RecordTypeId == contractRT)
                                {
                                    financecontractList.add(rtask.RecordType.DeveloperName);
                                }
                            }
                        }
                    }
                    if(led.Contact__c != null)
                    {
                        numberOfMBs = accvehlmap.get(led.Contact__c);                
                    }
                    else if(led.Company_Account__c != null)
                    {
                        numberOfMBs = accvehlmap.get(led.Company_Account__c);                    
                    }
                    if(numberOfMbMap != null && numberOfMbMap.containsKey(string.valueOf(numberOfMBs)))
                    {
                        numberOfMBScore = numberOfMbMap.get(string.valueOf(numberOfMBs));
                    }
                    else if(numberOfMBs > 3)
                    {
                        numberOfMBScore = 4;
                    }
                    if(led.Nature_of_Request__c != null && led.Nature_of_Request__c != '' && enquiryMap.containsKey(led.Nature_of_Request__c))
                    {
                        enquirytype = enquiryMap.get(led.Nature_of_Request__c);
                    }
                    
                    if(led.Purchase_Time__c != null && led.Purchase_Time__c != '' && purchaseMap.containsKey(led.Purchase_Time__c))
                    {
                        purchasetime = purchaseMap.get(led.Purchase_Time__c);
                    }
                    
                    if(!behaviourMap.isEmpty() && behaviourMap != null)
                    {
                        if(led.Contact__c != null)
                        {                            
                            behavgroup = behaviouralMap.get(behaviourMap.get(led.Contact__c));
                        }
                        else if(led.Company_Account__c != null)
                        {
                            behavgroup = behaviouralMap.get(behaviourMap.get(led.Company_Account__c));
                        }
                    }
                     
                    if(vehiclerelationClasslist != null && !vehiclerelationClasslist.isEmpty())
                    {                        
                        for(integer i=0 ; i<vehiclerelationClasslist.size() ; i++)
                        {
                            if(vechClassMap.containsKey(vehiclerelationClasslist[i]))
                            {
                                vehicleClassMap.put(vehiclerelationClasslist[i], vechClassMap.get(vehiclerelationClasslist[i]));
                            }
                        }
                        if(!vehicleClassMap.isEmpty() && vehicleClassMap != null)
                        {
                            vehicleclass = vehicleClassMap.keySet().iterator().next();
                            maxClassvalue = vehicleClassMap.get(vehicleclass);
                            for(string vec : vehicleClassMap.keySet())
                            {
                                Decimal currscore = vehicleClassMap.get(vec);
                                if(maxClassvalue >= currscore)
                                {
                                    vehicleClassMap.remove(vec);
                                }
                                else if(maxvalue < currscore) 
                                {
                                    vehicleClassMap.remove(vehicleclass);
                                    maxClassvalue = vehicleClassMap.get(vec);
                                    vehicleclass = vec;
                                }
                            }                            
                        }
                        system.debug('maxClassvalue' + maxClassvalue);
                        vechClassScore = maxClassvalue;
                    }
                     
                    if(led.MB_Vehicle_Interest__c != Null && led.MB_Vehicle_Interest__c != '')
                    {
                        vehicleInterest = led.MB_Vehicle_Interest__c;
                        vehicleInterestList = vehicleInterest.split(';');
                        for(integer i=0 ; i<vehicleInterestList.size() ;i++)
                        {
                            if(vechClassMap.containsKey(vehicleInterestList[i]))
                            {
                                highestClassMap.put(vehicleInterestList[i],vechClassMap.get(vehicleInterestList[i]));
                            }
                        }
                        if(!highestClassMap.isEmpty() && highestClassMap != null)
                        {
                            maxkey= highestClassMap.keySet().iterator().next();
                            maxvalue = highestClassMap.get(maxkey);
                            for(string key : highestClassMap.keySet())
                            {
                                Decimal currValue = highestClassMap.get(key);
                                if(maxvalue >= currValue)
                                {
                                    highestClassMap.remove(key);
                                } 
                                else if(maxvalue < currValue) 
                                {
                                    highestClassMap.remove(maxKey);
                                    maxvalue = highestClassMap.get(key);
                                    maxKey = key;
                                }
                            }
                        }
                        system.debug('maxvalue>>' + maxvalue);
                        mbVechInterestScore = maxvalue ;
                    }
                    
                    if(!servicecontractlist.isEmpty() && servicecontractlist != null && servicecontractlist.size() > 0)
                    {
                        value =  'Yes';
                        serviceScore = contractMap.get(value);
                    }
                    else
                    {
                        value =  'No';
                        serviceScore = contractMap.get(value);                    
                    }
                     if(!insuranceContractList.isEmpty() && insuranceContractList != null && insuranceContractList.size() > 0)
                    {
                        value =  'Yes';
                        contractScore = contractMap.get(value);
                    }
                    else
                    {
                        value =  'No';
                        contractScore = contractMap.get(value);                    
                    }
                     if(!financecontractList.isEmpty() && financecontractList != null && financecontractList.size() > 0)
                    {
                        value =  'Yes';
                        insuranceScore = contractMap.get(value);
                    }
                    else
                    {
                        value =  'No';
                        insuranceScore = contractMap.get(value);                    
                    }
                    system.debug('mbVechInterestScore>>>' +mbVechInterestScore + 'enquirytype>>' + enquirytype + 'purchasetime>>>' + purchasetime );
                    system.debug('behavgroup>:>:>:>' +behavgroup + 'numberOfMBScore>>>>' + numberOfMBScore + 'contractScore>>>>' + contractScore );
                    system.debug('serviceScore????' +serviceScore + 'insuranceScore??????' + insuranceScore + 'vechClassScore????' + vechClassScore );
                     priorityScore = enquirytype + purchasetime + behavgroup + numberOfMBScore + vechClassScore + contractScore + 
                                    mbVechInterestScore + serviceScore + insuranceScore;
                    
                    led.Priority_Score__c = priorityScore;
                        
                    if(Integer.valueOf(led.Priority_Score__c) > 38)
                    {
                        led.Lead_Priority__c = 'Hot';
                    }
                    else if(Integer.valueOf(led.Priority_Score__c) >=30 && Integer.valueOf(led.Priority_Score__c) < 38)
                    {
                        led.Lead_Priority__c = 'Warm';
                    }
                    else if(Integer.valueOf(led.Priority_Score__c) < 30)
                    {
                        led.Lead_Priority__c = 'Cold';
                    }
                }
         
                 if(!accountPCStatusMap.isEmpty() && accountPCStatusMap != null && !accountCVStatusMap.isEmpty() && accountCVStatusMap != null &&
                    !accountVANStatusMap.isEmpty() && accountVANStatusMap != null && accountPCStatusMap.get(led.Contact__c) == 'Prospect' 
                    && accountCVStatusMap.get(led.Contact__c) == 'Prospect' && accountVANStatusMap.get(led.Contact__c) == 'Prospect')  
                {
                    Decimal enquirytype = 0;
                    Decimal purchasetime = 0;
                    Decimal priorityScore = 0;
                    Decimal mbVechInterestScore = 0;
                    Decimal prospectleadscore = 0;
                    string prospect = '';
                    Decimal maxvalue = 0;
                    String value;
                    string maxkey;
                    string vehicleInterest; 
                    List<string> vehicleInterestList = new List<string>();  
                    List<string> servicecontractlist = new List<string>();
                    List<string> insuranceContractList = new List<string>();
                    List<string> financecontractList = new List<string>();
                    
                    if(!accountPCStatusMap.isEmpty() && accountPCStatusMap != null && !accountCVStatusMap.isEmpty() && accountCVStatusMap != null &&
                        !accountVANStatusMap.isEmpty() && accountVANStatusMap != null && accountPCStatusMap.get(led.Contact__c) == 'Prospect' 
                        && accountCVStatusMap.get(led.Contact__c) == 'Prospect' && accountVANStatusMap.get(led.Contact__c) == 'Prospect')
                    {
                        prospect = 'Yes';
                        prospectleadscore = prosleadMap.get(prospect);
                    }
                    system.debug('    prosleadMa    ' + prospectleadscore);
                    if(led.Nature_of_Request__c != null && led.Nature_of_Request__c != '' && prospectenquiryMap.containsKey(led.Nature_of_Request__c) 
                       && prospectenquiryMap.get(led.Nature_of_Request__c) != null)
                    {
                        enquirytype = prospectenquiryMap.get(led.Nature_of_Request__c);
                    }
                    
                    if(led.Purchase_Time__c != null && led.Purchase_Time__c != '' && prospectpurchaseMap.containsKey(led.Purchase_Time__c) 
                       && prospectpurchaseMap.get(led.Purchase_Time__c) != null)
                    {
                        purchasetime = prospectpurchaseMap.get(led.Purchase_Time__c);
                    }
                    
                    if(led.MB_Vehicle_Interest__c != Null && led.MB_Vehicle_Interest__c != '' )
                    {
                        vehicleInterest = led.MB_Vehicle_Interest__c;
                        vehicleInterestList = vehicleInterest.split(';');
                        for(integer i=0 ; i<vehicleInterestList.size() ;i++)
                        {
                            if(vechClassMap.containsKey(vehicleInterestList[i]))
                            {
                                highestClassMap.put(vehicleInterestList[i],vechClassMap.get(vehicleInterestList[i]));
                            }
                        }
                        if(!highestClassMap.isEmpty() && highestClassMap != null)
                        {
                            maxkey= highestClassMap.keySet().iterator().next();
                            maxvalue = highestClassMap.get(maxkey);
                            for(string key : highestClassMap.keySet())
                            {
                                Decimal currValue = highestClassMap.get(key);
                                if(maxvalue >= currValue)
                                {
                                    highestClassMap.remove(key);
                                } 
                                else if(maxvalue < currValue) 
                                {
                                    highestClassMap.remove(maxKey);
                                    maxvalue = highestClassMap.get(key);
                                    maxKey = key;
                                }
                            }
                        }
                        system.debug('maxKey>>' + maxKey);
                        system.debug('maxvalue>>' + maxvalue);
                        mbVechInterestScore = maxvalue ;
                    }
                    CustomLogUtil.CustomLoggingEntry('mbVechInterestScore' +mbVechInterestScore + 'enquirytype' + enquirytype + 'purchasetime' + purchasetime + 'prospectleadscore' + prospectleadscore);
                    system.debug('mbVechInterestScore>>' +mbVechInterestScore + 'enquirytype>><<' + enquirytype + 'purcha>>>>>setime' + purchasetime + 'prospectlea:?>?>?>>?dscore' + prospectleadscore);
                    priorityScore = enquirytype + purchasetime + mbVechInterestScore + prospectleadscore;
                                   
                    led.Priority_Score__c = priorityScore;
                    
                    if(Integer.valueOf(led.Priority_Score__c) >= 38)
                    {
                        led.Lead_Priority__c = 'Hot';
                    }
                    else if(Integer.valueOf(led.Priority_Score__c) >=30 && Integer.valueOf(led.Priority_Score__c) < 38)
                    {
                        led.Lead_Priority__c = 'Warm';
                    }
                    else if(Integer.valueOf(led.Priority_Score__c) < 30)
                    {
                        led.Lead_Priority__c = 'Cold';
                    }
                }
             }
            if((led.RecordTypeId == leadVehicleRt) && (leadRequestMap.containsKey(led.Nature_of_Request__c)) && (vanMap.containsKey(led.Business_Unit__c)))
            {
                led.Lead_Priority__c = 'Hot';
            }
        }
    }
    
    /*
    Requirment : If a dealer is creating a lead then update the dealer_assignment_Date__c as current date
    */
    public static void updateDealerAssignmentDate(List<Lead__C> leadList){
        Set<Id> dealerIdSet = new Set<Id>();
        list<Lead__c> updateLeadList = new List<Lead__c>();
        Map<Id,Contact> dealerIdContactID = new Map<Id,Contact>();
        //List<Lead__c> leadList = [SELECT Id,Assigned_dealer__C, OwnerId FROM Lead__c WHERE CAC_lead_status__c = 'Qualified' AND Assigned_dealer__c != NULL AND Dealer_assignment_date__c = null];
        for(Lead__c curLead : leadList){
            if(curLead.Assigned_dealer__c != NULL && curLead.Dealer_assignment_date__c == null)
            dealerIdSet.add(curLead.Assigned_Dealer__c);
        }
        System.debug('DealerIdSet===='+dealeridSet);
        List<Contact> conlistWithDealerId = [SELECT Id FROM Contact WHERE AccountId IN: dealerIdSet];
        list<id> conId = new list<Id>();
        for(contact c : conlistWithDealerId){
            conId.add(c.id);
        }
        List<user> userList = [SELECT id,contactid,contact.Dealer_Lead_Gate_Keeper__c from user where contactId IN: conId ];
        System.debug('conlistWithDealerIds'+conlistWithDealerId);
        for(Lead__c curLead : leadList){
            for(user curuser : userList ){
                if(curLead.OwnerId == curuser.Id && curuser.Contact.Dealer_Lead_Gate_Keeper__c == true){
                    curLead.Dealer_Assignment_Date__c = System.now();
                    updateLeadList.add(curLead);
                    System.debug('Leadwithdealer'+curLead.id);
                }
            }
        }
        try{
            if(!updateLeadList.isEmpty())
                update updateLeadList;
        }
        catch(Exception ex){
            System.debug('Exception >>>>>>>> ' + ex.getMessage());
            System.debug('Caused By >>>>>>>>>>>>> ' + ex.getCause());
            System.debug(' Line Number >>>>>>>>>>' + Ex.getLineNumber());
        }
    }
    /* Calculation of Dealer Due Date*/

    public Static void DueDateForAssignedDealer(List<Lead__C> list_leads_new)
    {
        
          valuesofDuedateValuesfromCustomMetaData( );
        
        for (Lead__c Lead: list_leads_new)
        {
            Integer SLADuration=0;
           
            if ((lead.Assigned_Dealer__c!= null && Lead.Dealer_Assignment_Date__c != null ) && lead.Lead_Priority__c != null) {
               
                Datetime Localtime = datetime.valueOfGMT(Lead.Dealer_Assignment_Date__c.format('YYYY-MM-dd HH:mm:ss'));
                 if (lead.Lead_Priority__c == 'Hot'){
                     SLADuration= SLA_hot;
                    }
                if (lead.Lead_Priority__c == 'Warm'){
                    SLADuration= SLA_Warm;
                    }
                if (lead.Lead_Priority__c== 'Cold'){
                    SLADuration= SLA_cold;
                    }
                if (SLADuration > 0){
                 
                 lead.Dealer_Due_Date__c=   GetDueTimeofLead(Localtime,SLADuration);
             
 }
                else{
                    System.debug('SLA Duration for priority values is not configured correctly.');
                }
            }
            
            if(lead.Consultant_Assignment_Date__c!=null &&  lead.Lead_Priority__c != null){
                Datetime Localtime = datetime.valueOfGMT(lead.Consultant_Assignment_Date__c.format('YYYY-MM-dd HH:mm:ss'));
                  if (lead.Lead_Priority__c == 'Hot'){
                     SLADuration= SLA_hot;
                    }
                if (lead.Lead_Priority__c == 'Warm'){
                    SLADuration= SLA_Warm;
                    }
                if (lead.Lead_Priority__c== 'Cold'){
                    SLADuration= SLA_cold;
                    }
                if (SLADuration > 0){
                 
                 lead.Consultant_Due_Date__c=   GetDueTimeofLead(Localtime,SLADuration);
             
 }
            }
        }
       
    }
    
     public Static Long DifferenceMinutesbetweenStartEndtime(datetime Starttime,datetime Endtime )
    {
            Long long_startdate= Starttime.getTime();
            Long long_enddate = Endtime.getTime();
            Long milliseconds = long_startdate - long_enddate;
            Long seconds = milliseconds / 1000;
            Long minutes = seconds / 60;
            return minutes;
    }
    public Static void valuesofDuedateValuesfromCustomMetaData()
            {
                try
                    {
                        List<Due_Date_Overdue__mdt> List_Overdue = [SELECT Lead_Priority__c,MasterLabel,Business_Hour_End_time__c, Business_Hour_start_time__c ,SLA_Duration__c FROM Due_Date_Overdue__mdt];
        
                        for( Due_Date_Overdue__mdt Overdue: List_Overdue){
                        if (Overdue.Lead_Priority__c == 'Hot' && Overdue.MasterLabel.contains('Hot')){
                            SLA_hot=  Integer.valueof(Overdue.SLA_Duration__c );
                        }
                        if (Overdue.Lead_Priority__c == 'Warm' && Overdue.MasterLabel.contains('Warm')){
                            SLA_Warm=  Integer.valueof(Overdue.SLA_Duration__c) ;
                        }
                        if (Overdue.Lead_Priority__c== 'Cold' && Overdue.MasterLabel.contains('Cold')){
                            SLA_cold=  Integer.valueof(Overdue.SLA_Duration__c );
                        }
                        if (Overdue.MasterLabel.contains('Business') ){
                            Str_Business_Start_hour = Overdue.Business_Hour_start_time__c;
                            Str_Business_End_hour = Overdue.Business_Hour_End_time__c;
                        }
                }
   
             }
                    Catch(Exception ex){
                            System.debug('Excpetion follwing Cause ' + ex.getMessage());
                    }
        }
    public Static Datetime GetDueTimeofLead(Datetime StartTime, Integer SLADuration)
            {
                Datetime DueDateandTime;
                try
                    { 
                            integer remainingMinutes =  SLADuration * 60;
                            
                            Datetime today_working_hour_start_time =Converttimeinto24hrFormat(StartTime,Str_Business_Start_hour);
                        
                            Datetime today_working_hour_end_time=Converttimeinto24hrFormat(StartTime,Str_Business_End_hour) ;
                           SYSTEM.debug('today_working_hour_start_time >>>>>>>>>> ' +  today_working_hour_start_time );
                    SYSTEM.debug('today_working_hour_end_time >>>>>>>>>> ' +  today_working_hour_end_time );
                            //Calculate the total business time in minutes
                            Integer daily_business_minutes =integer.valueof(DifferenceMinutesbetweenStartEndtime(today_working_hour_end_time,today_working_hour_start_time));  
                            // This condition for today remaing time from assign the lead 
                            if (Starttime.format('EEEE') !='Sunday' && (today_working_hour_start_time <=  StartTime &&  StartTime < = today_working_hour_end_time)) 
                                {
                                    Integer todayminutes =integer.valueof(DifferenceMinutesbetweenStartEndtime(today_working_hour_end_time,StartTime));
                                    Integer afterremainminues =    remainingMinutes-todayminutes;
                                     
                                    if ( afterremainminues <= 0) 
                                    {
                                        DueDateandTime= StartTime.addminutes(remainingMinutes);
                                    }
                                    remainingMinutes = afterremainminues;
                                }
                                // condition for assign time before the start time of the business hour 
                            if (StartTime > = today_working_hour_start_time)
                            {
                                today_working_hour_start_time = today_working_hour_start_time.addDays(1);
                                today_working_hour_end_time = today_working_hour_end_time.addDays(1); 
                            }
                      
                         While(DueDateandTime == null)
                            { 
                                if (today_working_hour_start_time.format('EEEE') !='Sunday' )
                                    {
                                        Integer afterremainminues = remainingMinutes - daily_business_minutes;

                                        if ( afterremainminues <= 0) 
                                            {
                                                DueDateandTime =today_working_hour_start_time.addminutes(remainingMinutes);
                                             
                                            }
                                    remainingMinutes = afterremainminues;
                                    }
                                    today_working_hour_start_time = today_working_hour_start_time.addDays(1);
                                    today_working_hour_end_time = today_working_hour_end_time.addDays(1);
                             
                            } 
                    
   
                }
                    catch(Exception Ex)
                    {
                        System.debug('Error Following Reason : ' + Ex .getMessage() + ' Line Caused to Error : ' + Ex.getLineNumber());
                    }
               System.debug('Due Time : Lead : ' +  DueDateandTime);
                
           
               return datetime.valueOf(DueDateandTime.format('yyyy-MM-dd HH:mm:ss','GMT'));
         }        

        public Static Datetime Converttimeinto24hrFormat(datetime dateandtime1 , String time_str1)
         {
            integer hour = Integer.valueOf(time_str1.substring(0,time_str1.indexOf(':')));
            integer minute = integer.valueOf(time_str1.substring(time_str1.indexOf(':')+1 ,time_str1.indexOf(':')+3));
            if (time_str1.contains('PM')  && hour != 12) {
                hour+=12;
            }
            return  datetime.valueOfGMT(dateandtime1.format('yyyy-MM-dd','GMT') + ' ' +  hour + ':' + minute + ':00' );
            
        } 
    
    /* To Prevent Dealers to create duplicate Leads */
    
    public static void leaddeDuplication(List<Lead__c> deDupleadList)
    {
        set<id> newLedaccId = new set<id>();
        List<Lead__c> olddeDupleadList = new List<Lead__c>();
        for(Lead__c dedupLeads : deDupleadList)
        {
            if(dedupLeads.Assigned_Dealer__c != null && dedupLeads.CAC_Lead_Status__c != 'Closed' && dedupLeads.CAC_Lead_Status__c != 'Lost')
            {
                if(dedupLeads.Contact__c != null)
                {
                    newLedaccId.add(dedupLeads.Contact__c);
                }
                else if(dedupLeads.Company_Account__c != null)
                {
                    newLedaccId.add(dedupLeads.Company_Account__c);
                }
            }            
        }
        if(!newLedaccId.isEmpty() && newLedaccId !=null)
        {
            olddeDupleadList = [select id, name, business_unit__c, Nature_of_Request__c, Purchase_Time__c, MB_Vehicle_Interest__c,
                                Test_Drive_Date__c, Assigned_Dealer__c, Contact__c,Company_Account__c,Preferred_Drop_off_Time__c,
                                Vehicle_Registration_No__c, VIN__c from Lead__c where Contact__c =:newLedaccId OR Company_Account__c =:newLedaccId];
        }
        
        for(Lead__c olddedupLeads : olddeDupleadList)
        {
            for(Lead__c newleds : deDupleadList)
            {
                if((newleds.Contact__c != null || newleds.Company_Account__c != null) && 
                   (olddedupLeads.Contact__c == newleds.Contact__c || olddedupLeads.Company_Account__c == newleds.Company_Account__c)
                  && newleds.Assigned_Dealer__c == olddedupLeads.Assigned_Dealer__c)
                {
                    if(newleds.Nature_of_Request__c == 'Brochure Request' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c &&
                      newleds.Purchase_Time__c == olddedupLeads.Purchase_Time__c && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c &&
                      newleds.Business_Unit__c == olddedupLeads.Business_Unit__c)
                        
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                    else if(newleds.Nature_of_Request__c == 'Test Drive Request' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c &&
                           newleds.Test_Drive_Date__c == olddedupLeads.Test_Drive_Date__c && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c
                           && newleds.Business_Unit__c == olddedupLeads.Business_Unit__c)                          
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                    else if(newleds.Nature_of_Request__c == 'Parts Enquiry' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c
                           && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c && newleds.Business_Unit__c == olddedupLeads.Business_Unit__c
                           && newleds.VIN__c == olddedupLeads.VIN__c)
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);                
                    }
                    else if(newleds.Nature_of_Request__c == 'Service Booking' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c
                           && newleds.Vehicle_Registration_No__c == olddedupLeads.Vehicle_Registration_No__c && newleds.Preferred_Drop_off_Time__c == olddedupLeads.Preferred_Drop_off_Time__c)
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                    else if(newleds.Nature_of_Request__c == 'Request a Quote' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c
                           && newleds.Purchase_Time__c == olddedupLeads.Purchase_Time__c && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c 
                            && newleds.Business_Unit__c == olddedupLeads.Business_Unit__c)
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                    else if(newleds.Nature_of_Request__c == 'Corporate Programme' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c
                           && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c && newleds.Business_Unit__c == olddedupLeads.Business_Unit__c)
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                    else if(newleds.Nature_of_Request__c == 'Fleet Programme' && newleds.Nature_of_Request__c == olddedupLeads.Nature_of_Request__c
                           && newleds.MB_Vehicle_Interest__c == olddedupLeads.MB_Vehicle_Interest__c && newleds.Business_Unit__c == olddedupLeads.Business_Unit__c)
                    {
                        newleds.adderror('Lead is already Exist    ' + olddedupLeads.Name);
                    }
                }
            }
        }
    }   
    public static void shareAccountwithAssignDealer(List<Lead__c> assignLeadList)
    {
        set<id> dleadId = new set<id>();
        map<id,id> delaccmap = new map<id,id>();
        set<string> assigndlrgroup = new set<string>();
        List<group> assgroupList = new List<group>();
        map<string,id> assgroupMap = new map<string,id>();
        List<sobject> assshareList = new List<sobject>();
        List<Lead__c> leaddrList = new List<Lead__c>();
        for(Lead__c drled : assignLeadList)
        {
            if(drled.Assigned_Dealer__c != null && drled.CAC_Lead_Status__c == 'Qualified' && (drled.Contact__c != null || drled.Company_Account__c != null))
            {
                dleadId.add(drled.Id);
            }
        }
        if(!dleadId.isEmpty() && dleadId != null)
        {
            leaddrList = [select id,Assigned_Dealer__c,CAC_Lead_Status__c,Contact__c,Company_Account__c,Assigned_Dealer__r.Name from Lead__c where id =:dleadId];
        }
        if(!leaddrList.isEmpty() && leaddrList != null)
        {
            for(Lead__c dleds : leaddrList)
            {
                if(dleds.Contact__c != null && dleds.Company_Account__c == null)
                {
                    delaccmap.put(dleds.Id, dleds.Contact__c);
                }
                if(dleds.Company_Account__c != null && dleds.Contact__c == null)
                {
                    delaccmap.put(dleds.Id, dleds.Company_Account__c);
                }
                if(dleds.Assigned_Dealer__c != null)
                {
                    assigndlrgroup.add(dleds.Assigned_Dealer__r.Name);
                }
            }
        }
        if(!assigndlrgroup.isEmpty() && assigndlrgroup != null)
        {
            assgroupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:assigndlrgroup];
        }
        if(!assgroupList.isEmpty() && assgroupList !=null)
        {
            for(Group assg : assgroupList)
            {
                assgroupMap.put(assg.Name, assg.id);
            }
        }
        if(!leaddrList.isEmpty() && leaddrList != null)
        {
            for(Lead__c shrleds : leaddrList)
            {
                if(!assgroupMap.isEmpty() && assgroupMap.get(shrleds.Assigned_Dealer__r.Name) != null)
                {
                    AccountShare assaccShare = new AccountShare();
                    assaccShare.AccountId =delaccmap.get(shrleds.Id);
                    assaccShare.UserOrGroupId = assgroupMap.get(shrleds.Assigned_Dealer__r.Name);
                    assaccShare.AccountAccessLevel = 'Edit';
                    assaccShare.OpportunityAccessLevel = 'None';
                    assaccShare.CaseAccessLevel = 'None';
                    assshareList.add(assaccShare);
                }
            }
        }
        if(!assshareList.isEmpty() && assshareList != null)
        {
            insert assshareList;
        }
    }
}