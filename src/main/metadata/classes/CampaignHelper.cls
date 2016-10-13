/*
    Type:       helper class 
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
public class CampaignHelper {
    
    private static String pending ='Pending';
    public static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();    // Campaign Record Type MAP
    public static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
    public static string CacCampaign ='CAC Campaign';
    
    
    public static void copyTopCampaignStatusValueToSavedCampaign(Set<String> campaignIds){
        
 /**
  *@Description : Copies Top Campaigns Status value to Saved Campaign.
  *@Date : 3/11/2015
  *@param:Set of Campaign Ids.
  *@return:This mehtod does not return any value.
  */
        
        Set<String> topCampaignIds = new Set<String>();
        List<Campaign> campaigns = [select ParentId, Parent.ParentId from Campaign where Id in:campaignIds];
        for(Campaign cam : campaigns){
            if(cam.ParentId != null){
                topCampaignIds.add(cam.Parent.ParentId);
            }
        }
        
        List<CampaignMemberStatus> savedStatus = new List<CampaignMemberStatus>();
        for(CampaignMemberStatus status : [select CampaignId, HasResponded, IsDefault, Label, SortOrder from CampaignMemberStatus 
                                            where CampaignId in :topCampaignIds]){
                                            
            
            for(Campaign cam : campaigns){
                if(cam.Parent.ParentId == status.CampaignId){
                    CampaignMemberStatus newStatus = status.clone();
                    newStatus.CampaignId = cam.Id;
                    savedStatus.add(newStatus);
                }
            }
        }
        
        CampaignMemberStatus[] statuses = [select IsDefault, HasResponded from CampaignMemberStatus where CampaignId in :campaignIds];
        for(CampaignMemberStatus status : statuses){
            status.IsDefault = false;
            status.HasResponded = false;
        }
        update statuses;
        delete statuses;
        
        if(!savedStatus.isEmpty()){
            insert savedStatus;
        }
    }
    
    
    /**
      *@Description : Updates Campaign Member status to Related Campaigns.
      *@Date : 3/11/2015
      *@param:List of Campaign Members.
      *@return:This mehtod does not return any value.   
      */
    public static void updateCampaignMemberStatusToRelatedCampaign(List<CampaignMember> members){  
        Set<String> topCampaignIds = new Set<String>();
        Set<String> obcallCampaignIds = new Set<String>();
        Set<String> unknownCampaignIds = new Set<String>();
        Map<String, String> statusMap = new Map<String, String>();
        
        for(CampaignMember member : members){
            statusMap.put(member.ContactId, member.Status);
            
            if(member.Campaign_Execution_Type__c == 'OB Call' && member.Campaign.ParentId != null){
                topCampaignIds.add(member.Campaign.Parent.ParentId);
                obcallCampaignIds.add(member.CampaignId);
            }
            else{
                unknownCampaignIds.add(member.CampaignId);
            }
        }
        
        for(Campaign camp : [select Id, Parent.ParentId from Campaign where Parent.ParentId = :unknownCampaignIds and Execution_Type__c = 'OB Call']){
            topCampaignIds.add(camp.Parent.ParentId);
            obcallCampaignIds.add(camp.Id);
        }
        for(Campaign camp : [select Id from Campaign where Parent.ParentId = :topCampaignIds and Execution_Type__c = 'OB Call']){
            obcallCampaignIds.add(camp.Id);
        }
        
        Set<String> campaignIds = new Set<String>();
        campaignIds.addAll(topCampaignIds);
        campaignIds.addAll(obcallCampaignIds);
        campaignIds.remove(null);
        
        List<CampaignMember> updatedMembers = new List<CampaignMember>();
        for(CampaignMember mem : [select Status, ContactId from CampaignMember where CampaignId in :campaignIds and ContactId in :statusMap.keySet()]){
            String status = statusMap.get(mem.ContactId) ;
            if(status != null){
                mem.Latest_Status__c = status;
            }
            updatedMembers.add(mem);
        }
        
        if(!updatedMembers.isEmpty()){
            update updatedMembers;
        }
    }
    
    /**
      *@Description : Actions which are performed as a part of After Insert/Update. This gets called from Campaign TriggerHandler
                      which gets invoked by Trigger on Campaign Object.
      *@Date : 3/11/2015
      *@param:List of campaign.New. Campaign.Oldmap and indicator for Update.
      *@return:This mehtod does not return any value.
    
      */
    public static void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate)
    {

        /* START Variable Definition    */
        Set<ID> cpIdSet = new Set<ID>(); // Campaign ID Set       
        List<Campaign> cpAccList = new List<Campaign>(); // Campaign Exection List by Contact 
        List<Campaign> cpLeadList = new List<Campaign>();  // Campaign Exection List by Lead 
        List<Campaign> cpVehicleList = new List<Campaign>(); // Campaign Exection List by Vehicle
        List<Campaign> cpCaseList = new List<Campaign>(); // Campaign Exection List by Case
        
        // Batch Job String Ids
        String cpAccIds = UtilConstant.Empty; // Campaign Id String
        String cpLeadIds = UtilConstant.Empty;
        String cpVehicleIds = UtilConstant.Empty;
        String cpCaseIds = UtilConstant.Empty;
        Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c=pending);
        Batch_Job__c leadJob = new Batch_Job__c(Batch_Type__c='Lead', Status__c=pending);
        Batch_Job__c vehJob = new Batch_Job__c(Batch_Type__c='Vehicle', Status__c=pending);
        Batch_Job__c caseJob = new Batch_Job__c(Batch_Type__c='Case', Status__c=pending);
        /* END Variable Definition  */
         System.debug('campaignNew>>>' + campaignNew);
        /* START Iterate Campaign to relevant campaign list */
        for(Campaign cp : campaignNew) {
            // All Activated Campaign Execution
            System.debug('campaignNew>>>' + campaignNew);
            if(cp.Create_Task__c && (isUpdate && !campaignOldMap.get(cp.Id).Create_Task__c) && 
                (cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId() || 
                cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId())) {
                
                if(cp.Task_Created_By__c == 'Contact') {
                    // Campaign Exection List by Contact 
                    cpAccList.add(cp); 
                    System.debug('cpAccList>>>' + cpAccList);
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
            } else if (isUpdate && cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) {
                // CAC Campaign List
                cpIdSet.add(cp.id);
                List<Campaign> childCmpList = new List<Campaign>(); 
                for(Campaign childCAC : [Select Id From Campaign Where ParentId=:cp.Id And isActive=false And RecordTypeId=:cpRecordTypeMap.get(CacCampaign).getRecordTypeId()]){
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
        
        if(!cpIdSet.isEmpty()) {
            for(Campaign cpExe : [select id, Create_Task__c from Campaign where ParentId in :cpIdSet ]) {
                cpExeList.add(new Campaign(id = cpExe.Id, Create_Task__c = true));
            }
        }

        if(!cpExeList.IsEmpty()) update cpExeList;
        /* END Campaign Excution create task update */
        
        System.debug('cpVehicleList >>>' + cpVehicleList);
             System.debug('cpAccList>>>' + cpAccList);
        /* START Batch Execution */
        if(!cpAccList.isEmpty()) {          
            database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpAccList), 200);
            accJob.Campaign_Set__c = cpAccIds;
            if(accJob!=Null){
            insert accJob;
            }
        }
        
        if(!cpLeadList.isEmpty()) {         
            //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
            leadJob.Campaign_Set__c = cpLeadIds;
            if(leadJob!=Null){
             insert leadJob;       
            }  
        }
        if(!cpVehicleList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpVehicleList), 200); 
            vehJob.Campaign_Set__c = cpVehicleIds;
            insert vehJob; 
        }
        if(!cpCaseList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200); 
            caseJob.Campaign_Set__c = cpCaseIds;
            insert caseJob; 
        }
        /* END Batch Execution */
    
    }
    
    
     /**
      *@Description : Actions which are performed as a part of Before Insert/Update. This gets called from Campaign TriggerHandler
      which gets invoked by Trigger on Campaign Object.
      *@Date : 3/11/2015
      *@param:List of campaign.New. Campaign.Oldmap.
      *@return:This mehtod does not return any value.
      */ 
    public static void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
      
        Id cmpExeReTpIdS = cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId();
        Id cmpExeReTpIdC = cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId();
        Set<Id> campaignIds = new Set<Id>();
        for(Campaign cp : campaignNew) {
            if (cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId())
            {
                 campaignIds.add(cp.Id);
            }
        }
        
        Map<Id, Integer> CampaignCMPExes = new Map<Id, Integer>();
        for(Campaign cmp : [Select Id, ParentId from Campaign Where ParentId in :campaignIds And (RecordTypeId=:cmpExeReTpIdS Or RecordTypeId=:cmpExeReTpIdC)])
        {
            if(!CampaignCMPExes.containsKey(cmp.ParentId))
            {
                 CampaignCMPExes.put(cmp.ParentId, 0);
            }
            CampaignCMPExes.put(cmp.ParentId, CampaignCMPExes.get(cmp.ParentId) + 1);
        }
        
        for(Campaign cp : campaignNew) {
            if ((cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) && (CampaignCMPExes.get(cp.Id) < 1))
            {
                
                    cp.addError('You can not activate a campaign without any execution.');
                                
            }
        }
    }
    /**
     * 2014-2-17 added by Justin for copying the status
     *  in the top level campaign to the OB campaign
     */
     
 /**
  *@Description : Actions which are performed as a part of After Insert. This gets called from Campaign TriggerHandler
  This method sends the campaigns with execution type = OB Call  to method copyTopCampaignStatusValueToSavedCampaign().
  which gets invoked by Trigger on Campaign Object.
  *@Date : 3/11/2015
  *@param:List of campaign.New. 
  *@return:This mehtod does not return any value.
  */
    public static void afterInsertEvents(list<Campaign> campaignNew)
    {
        Set<String> campaignIds = new Set<String>();
        for(Campaign campaign : campaignNew){
            if(campaign.Execution_Type__c == 'OB Call')
            {
                campaignIds.add(campaign.Id);
            }
        }
        if(campaignIds!=null && !campaignIds.isEmpty())
            copyTopCampaignStatusValueToSavedCampaign(campaignIds);
    }
    
 /**
  *@Description : Actions which are performed as a part of After Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method picks up the campaigns with SMS Task verified = true and updates it to flase if their parent campaign is a 
  repeated campaign.  
  *@Date : 3/11/2015
  *@param:List of campaign.New and Campaign.Old.
  *@return:This mehtod does not return any value.
  */
    public static void afterUpdateEvents(list<Campaign> campaignNew,list<Campaign> campaignOld)
    { 
        List<Id> cpSIds = new List<Id>();
        
        
        
        for(Integer j=0; j<campaignNew.size(); j++)
        {
            if(campaignNew[j].SMS_Task_Verified__c != campaignOld[j].SMS_Task_Verified__c && campaignNew[j].SMS_Task_Verified__c )
            {
                cpSIds.add(campaignNew[j].Id);
            }
        }
        if(!cpSIds.isEmpty())
        {
            List<Campaign> cpExes = [SELECT Id, SMS_Task_Verified__c, Parent.Repeated_Campaign__c FROM Campaign WHERE Id in :cpSIds AND Parent.Repeated_Campaign__c = true];
            if(cpExes!=null && !cpExes.isEmpty())
            {
                for(Campaign cpe : cpExes)
                {
                    cpe.SMS_Task_Verified__c = false;
                }
                update cpExes;
            }
        }
    }
    
 /**
  *@Description : Actions which are performed as a part of After Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object.
  This method updates the campaignshares. Shares campaign to Participating Dealers.
  *@Date : 3/11/2015
  *@param:List of campaign.New. Map Campaign.Oldmap.
  *@return:This mehtod does not return any value.
  */
    public static void afterInsertEvents_CampaignShare(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Id pIdDealerUser = null;
            Id pIdDealerAdmin = null;
            for (Profile pro : [select Id, Name from Profile where Name = 'Dealer Community User' or Name = 'Dealer Delegate Admin'])
            {
                if (pro.Name == 'Dealer Community User')
                {
                    pIdDealerUser = pro.Id;
                } else
                {
                    pIdDealerAdmin = pro.Id;
                }
            }
            
            Id rtIdMbBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            Id rtIdSmartBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId();
            Id rtIdSmEvent = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
            Id rtIdSmMedia = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media Central Campaign').getRecordTypeId();
            Id rtIdAs = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
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
            
            for(Campaign cpNew : campaignNew)
            {
                if (cpnRtIds.contains(cpNew.RecordTypeId) && cpNew.Status == 'Published' && campaignOldMap.get(cpNew.Id).Status != 'Published')
                {
                    cpnIds.add(cpNew.Id);
                    if (cpNew.RecordTypeId == rtIdAs)
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetAsRetail);
                    } 
                    else if (cpNew.RecordTypeId == rtIdSmEvent || cpNew.RecordTypeId == rtIdSmMedia)
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetSmRetail);
                    } 
                    else 
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetBp);
                    }
                    if (cpNew.RecordTypeId == rtIdMbBp)
                    {
                        mbBpCampaignIds.add(cpNew.Id);
                    }
                }
            }
            
            if (cpnIds.isEmpty()) {
                return;
            }
            
            for (Participating_Dealer__c pd : [Select Campaign__c, Dealer__c, Dealer__r.Retail_MB_Owner__c from Participating_Dealer__c Where Campaign__c In :cpnIds])
            {
                if (cpnDealerMap.get(pd.Campaign__c) == null)
                {
                    cpnDealerMap.put(pd.Campaign__c, new Set<Id>());
                }
                cpnDealerMap.get(pd.Campaign__c).add(pd.Dealer__c);
                dealerIds.add(pd.Dealer__c);
                if (pd.Dealer__r.Retail_MB_Owner__c != null)
                {
                    dealerBrandOwnerIds.put(pd.Dealer__c, pd.Dealer__r.Retail_MB_Owner__c);
                }
            }
            
            for (User u : [select Id, ProfileId, AccountId, ContactId, Contact.Permission_Set_Settings__c from User where AccountId in :dealerIds and isActive = true and (ProfileId = :pIdDealerAdmin or (ProfileId = :pIdDealerUser and Contact.Permission_Set_Settings__c includes(:pSetAsRetail, :pSetSmRetail, :pSetBp)))])
            {
                for (Id cpnId : cpnIds)
                {
                    if (cpnDealerMap.get(cpnId) != null && cpnDealerMap.get(cpnId).contains(u.AccountId) && (u.ProfileId == pIdDealerAdmin || (u.Contact.Permission_Set_Settings__c != null && u.Contact.Permission_Set_Settings__c.contains(cpnPermSetMap.get(cpnId)))))
                    {
                        CampaignShare share = new CampaignShare();
                        share.CampaignAccessLevel = UtilConstant.read_Access;
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
            
            for (Id cpnId : mbBpCampaignIds)
            {
                if (cpnDealerMap.get(cpnId) != null)
                {
                    for (Id dealerId : cpnDealerMap.get(cpnId))
                    {
                        if (dealerBrandOwnerIds.get(dealerId) != null)
                        {
                            CampaignShare share = new CampaignShare();
                            share.CampaignAccessLevel = UtilConstant.read_Access;
                            share.CampaignId = cpnId;
                            share.UserOrGroupId = dealerBrandOwnerIds.get(dealerId);
                            cpnShares.add(share);
                        }
                    }
                }
            }
            
            // Insert sharing records
            if (!cpnShares.isEmpty()) {
                try {
                    insert cpnShares;
                } catch (DMLException e) {
                    System.debug('DMLException Exception occured when sharing Campaign to Participating Dealer: ' + e);
                }
            }
            if(!taskList.isEmpty()){
                try {
                    insert taskList;
                }
                catch(Exception ex) {
                    System.debug('Exception message is :' + ex.getMessage());
                }
            }
        }
    }
}