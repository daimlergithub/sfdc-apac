/**
** Utility for LeadAfterUpdate
** 1. Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
** 2. Assigned lead to Dealer Lead Gate Keeper
** 3. Share lead's contact to Dealer Sales Gate Keeper
** 4. If a lead is created from Inquiry case, copy lead id to Case's lead.
** Created By: Sinow
** Date: 2013-4-27
**/

public class LeadHelper
{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static List<QueueSobject> LeadGateKeeperQ = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType =: UtilConstant.LEAD and Queue.Name =: UtilConstant.DEALER_LEAD_GATE_KEEPER_QUEUE limit 1];
    private static final String SMSTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(UtilConstant.SMS).getRecordTypeId();
    private static final String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(UtilConstant.OB_TASK).getRecordTypeId(); 
   
        /**      
      * @Description Leads sharing record are created nad inserted for both smart and star elite account owner.
      * @author  
@@ -170,56 +167,6 @@ public class LeadHelper
         }
     }
     /**      
    * @Description Lead owner is updated to gate keeper id or to dealer owner, if not exist.
    * @author  
    * @Date 10/19/2016(mm/dd/yy)
               * @param  Set of dealerIds
               * @param  List of sObject Lead__c for update
               * @return 
                * @see   UpdateLeadOwner
               */ 
   public static void UpdateLeadOwnerFromDealerLeadGateKeeper(Set<Id> dealerIds, List<Lead__c> leadsForUpdate,Map<Id,Lead__c> oldValLead){
       List<Lead__c> leadForUpdate = new List<Lead__c>();        
       Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();       
       for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true])
       {
           dealerIdGateKeeperIds.put(u.AccountId, u.Id);
       }        
       for(Lead__c lead : leadsForUpdate) {
            if(lead.Assigned_Dealer__c != oldValLead.get(lead.id).Assigned_Dealer__c){
               if(lead.RecordTypeId == salesRecordTypeId)
               {
                   lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                   leadForUpdate.add(lead);
               } 
               if(lead.RecordTypeId == afterSalesRecordTypeId)
               {
                   lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                   leadForUpdate.add(lead);
               }               
           }
           else{  
               if(lead.RecordTypeId == salesRecordTypeId)
               {
                   if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                   lead.OwnerId = LeadGateKeeperQ[0].QueueId;
                   leadForUpdate.add(lead);
               }
               if(lead.RecordTypeId == afterSalesRecordTypeId)
               {
                   if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                   lead.OwnerId = LeadGateKeeperQ[0].QueueId;
                   leadForUpdate.add(lead);
               }
           }
       }       
   }
   /** 	
       /**      
     * @Description Leads sharing record are created nad inserted for both smart and star elite account owner.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Map of UsedcarLeadDealer
                 * @param  Map of newCarLeadDealerId
                * @return 
                 * @see   insertLeadSharing
                */    
    public static void insertLeadSharing(Map<Id, Id> UsedCarLeadDealerId, Map<Id, Id> newCarLeadDealerId)
    {
        Set<Id> existSharingLeadIds = new Set<Id>();
        Map<Id, Id> dealerStarElitOwners = new Map<Id, Id>();
        Map<Id, Id> dealerSmartAccountOwners = new Map<Id, Id>();
        Map<Id, Id> leadIdContactIds = new Map<Id, Id>();
        List<Lead__Share> SharesToInsert = new List<Lead__Share>();
        List<AccountShare> AccSharesToInsert = new List<AccountShare>();
        
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
        
        for(Lead__share ls : [select Id from Lead__share where ParentID in :UsedCarLeadDealerId.keySet() or ParentID in :newCarLeadDealerId.keySet()])
        {
            existSharingLeadIds.add(ls.Id);
        }
        
        for(Lead__c lead : [select Id, Contact__c from Lead__c where Id in :UsedCarLeadDealerId.keySet() or Id in :newCarLeadDealerId.keySet()])
        {
            leadIdContactIds.put(lead.Id, lead.Contact__c);
        }
        
        for(Id leadId : UsedCarLeadDealerId.keySet())
        {
            if(!existSharingLeadIds.contains(leadId) && dealerStarElitOwners.containsKey(UsedCarLeadDealerId.get(leadId)))
            {
                SharesToInsert.add(newLeadShare(leadId, dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
                AccSharesToInsert.add(newAccountShare(leadIdContactIds.get(leadId), dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
            }
        }
        
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
       /**      
     * @Description Lead owner is updated to gate keeper id or to dealer owner, if not exist.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Set of dealerIds
                * @param  List of sObject Lead__c for update
                * @return 
                 * @see   UpdateLeadOwner
                */    
    
    public static void UpdateLeadOwner(Set<Id> dealerIds, List<Lead__c> leadsForUpdate)
    {
        
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true])
        {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
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
     /**      
     * @Description Lead owner is updated to gate keeper id or to dealer owner, if not exist, from contact
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Set of dealerIds
                * @param  List of sObject Lead__c for update
                * @return 
                 * @see   UpdateLeadOwnerFromContact
                */ 
    public static void UpdateLeadOwnerFromContact(Set<Id> dealerIds, List<Lead__c> leadsForUpdate)
    {
        List<Lead__c> leadForUpdate = new List<Lead__c>();
        
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
       
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true])
        {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        
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
    /**      
     * @Description Lead owner is updated to gate keeper id or to dealer owner, if not exist and shared to gatekeeper.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Set of dealerIds
                * @param  List of sObject Lead__c for update
                * @return 
                 * @see   ShareToGateKeeper
                */ 
    public static void ShareToGateKeeper(Set<Id> dealerIds, List<Lead__c> leadsForUpdate) {
        List<AccountShare> SharesToInsert = new List<AccountShare>();
        
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]) {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        
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
    
   /**      
     * @Description Cases are updated with lead Id's
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Map of NewCaseLeadIds
                * @return 
                 * @see  UpdateCasesWithLeadId
                */ 
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
     /**      
     * @Description leads are shared to assigned dealer, by removing the sharing record for old and creating the record for new dealer.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  Set of String of oldDealerIds
                * @param  Set of String of leadIds
                * @return lead shares are inserted.
                 * @see  shareToAssignedDealer
                */
    public static void shareToAssignedDealer(Set<String> oldDealerIds, Set<String> leadIds)
    {
        
        Set<ID> oldDealerOwnerIds = new Set<ID>();
        for(Account dealer : [select OwnerId from Account where Id in :oldDealerIds])
        {
            oldDealerOwnerIds.add(dealer.OwnerId);
        }
        
        delete [select Id from Lead__Share where AccessLevel = 'Read' and ParentId in :leadIds and UserOrGroupId in :oldDealerOwnerIds];
        
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
    /**      
     * @Description By accumulating the leads for update, the lead's owner is being updated and the lead contact is being shared.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  list of new leads
                * @param  map of old leads
                * @param  boolean isInsert, isUpdate
                * @return 
                 * @see  beforeInsert_UpdateEvents
                */
    public static void beforeInsert_UpdateEvents(list<Lead__c> leadsnew,map<id,Lead__c> leadOldMap,boolean isInsert, boolean isUpdate)
    {
        // Get all dealer ids of update leads
        Set<Id> dealerIds = new Set<Id>();
        // Get all dealers of update leads
        List<Lead__c> leadsForUpdate = new List<Lead__c>();
        
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
    /**      
     * @Description account sharing is assigned to the lead owner and the leads contact is shared to the lead owner.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  list of new leads
                * @param  map of old leads
                * @param  boolean isInsert, isUpdate
                * @return 
                 * @see  afterInsert_UpdateEvents
                */
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
        // Get all dealers of update leads for share to contact
        List<Lead__c> leadsForUpdate = new List<Lead__c>();
        // Share the lead to assigned dealer if "Need Assign To Dealer" field is "Need"
        Set<String> oldDealerIds = new Set<String>();
        Set<String> leadIdsForSharingToDealerOwner = new Set<String>();
        for(Lead__c lead : leadsnew)
        {
            if(isInsert)
            {
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
        
            
            if(isInsert && lead.Case__c != null)
            {
                NewCaseLeadIds.put(lead.Case__c, lead.Id);
            }
            
        }
    
            
        if(UsedCarLeadDealerId.keySet().size() > 0 || NewCarLeadDealerId.keySet().size() > 0) {
            LeadHelper.insertLeadSharing(UsedCarLeadDealerId, NewCarLeadDealerId);
        }
        
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
    /**      
     * @Description Share retail lead to all active campaign users of the linked dealer.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  list of new leads
                * @param  map of old leads
                * @param  map of new leads
                * @param  boolean isInsert, isUpdate
                * @return 
                 * @see   LeadSharingWrapService
                */
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
     /**      
     * @Description Temporary lead share
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  String of leadId
                * @param  string of user or groupId
                * @return temporary share
                 * @see   Lead__Share newLeadShare
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
    /**      
     * @Description Temporary account share
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  String of accountId
                * @param  string of user or groupId
                * @return temporary share
                 * @see   AccountShare newAccountShare
                */
    private static AccountShare newAccountShare(String accountId, String userOrGroupId)
    {
        AccountShare tempShare = new AccountShare();
        tempShare.AccountAccessLevel = 'Read';
        tempShare.AccountId = accountId;
        tempShare.UserOrGroupId = userOrGroupId;
        tempShare.OpportunityAccessLevel = 'Read';
        return tempShare;
    }
    /**      
     * @Description to create new task for instructor, mentioning the sms content.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  temporary lead
                * @param  temporary instructor
                * @param  temporary user
                * @param  temporary account
                * @param  temporary dealer
                * @return task
                 * @see   ask createdNewSMSTaskForInstructor
                */
    @TestVisible private static Task createdNewSMSTaskForInstructor(Lead__c tempLead, User  tempIntegrationUser, User tempInstructor, Account tempAccount, Account tempDealer)
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
    /**      
     * @Description to create new task for instructor, mentioning the sms content.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  temporary lead
                * @param  temporary customer
                * @param  temporary user
                * @param  temporary account
                * @param  temporary title
                * @return task
                 * @see   createdNewSMSTaskForCustomer
                */
    @TestVisible private static Task createdNewSMSTaskForCustomer(Lead__c tempLead, User  tempIntegrationUser, Account tempCustomer, Account tempDealer, String tempTitle)
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
    /**      
     * @Description to get the epUser.
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @return epUser
                 * @see   getEPIntegrationUser
                */
    @TestVisible private static User getEPIntegrationUser()
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