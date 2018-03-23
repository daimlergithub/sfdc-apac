/*
    Type:       Trigger HAndler class for Lead object
    Created By : Kiran
    Created Date : 10/12/2016
*/
public class TriggerLeadTriggerHandlerKR
    implements TriggerHandlerIf
{
    public static boolean preventRecurssionafter = false;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        map<string,string> leadOwnerIds = new map<string,String>();
		user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
        System.debug('Handletrigger----->1');
        if(isBefore && isInsert)
        {
            
            set<id> dealerIds = new set<id>();
            set<Id> saleConIds = new set<Id>();
            for(Lead__C leds : (List<Lead__c>)trigger.new)
            {
                dealerIds.add(Leds.Assigned_Dealer__c);
                //SFDCKR-1060
                saleConIds.add(Leds.Sales_Consultant__c);
            } 
               //SFDCKR-1060
               LeadHelperJP.updateAssignedDealer(trigger.new, saleConIds);
               LeadHelper.UpdateLeadOwnerFromDealerLeadGateKeeper(dealerIds,Trigger.new,(Map<Id,Lead__c>)trigger.oldMap,isInsert, isUpdate, saleConIds);
               
        }        
        if(isBefore && isUpdate)
        {
            LeadHelperBase.updatemarket(Trigger.New);
            set<id> dealerIds = new set<id>();
            set<Id> saleConIds = new set<Id>();
            for(Lead__C leds : (List<Lead__c>)trigger.new)
            {
                dealerIds.add(Leds.Assigned_Dealer__c);
                //SFDCKR-1060
                saleConIds.add(Leds.Sales_Consultant__c);
            }            
             LeadHelper.UpdateLeadOwnerFromDealerLeadGateKeeper(dealerIds,Trigger.new,(Map<Id,Lead__c>)trigger.oldMap,isInsert, isUpdate, saleConIds);
            //LeadHelperKR.roleRestrictionForCCC(Trigger.New,(Map<Id,Lead__c>)trigger.oldMap,isUpdate,isDelete); 
        } 
                
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated)
        {
             if(preventRecurssionafter == false){
                set<id> dealerIds = new set<id>();
                
                for(Lead__C leds : (List<Lead__c>)trigger.new){
                    dealerIds.add(Leds.Assigned_Dealer__c);
                }  
                LeadHelper.assignLeadstoqueues(dealerIds, Trigger.new, (Map<Id,Lead__c>)trigger.oldMap, 'insert');
            }
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadHelperKR.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            LeadSharingforDealerJP.LeadSharing_Dealer(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadUtil.isCreated = false;
            LeadHelperKR.leadsharehierarchy(trigger.new);
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated)
        {
            system.debug('Isafter is working');
            if(preventRecurssionafter == false){
                set<id> dealerIds = new set<id>();
                
                for(Lead__C leds : (List<Lead__c>)trigger.new){
                    dealerIds.add(Leds.Assigned_Dealer__c);
                }  
                LeadHelper.assignLeadstoqueues(dealerIds, Trigger.new, (Map<Id,Lead__c>)trigger.oldMap, 'update');
            }
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            //LeadSharingforDealerJP.LeadSharingforDealer(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadSharingforDealerJP.LeadSharing_Dealer(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadHelperKR.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            LeadUtil.isCreated = false;
            LeadHelperKR.leadsharehierarchy(trigger.new);
			for(Lead__C leds : (List<Lead__c>)trigger.new)
            {
                for(Lead__C ledsold: (List<Lead__C>)trigger.old){
                if(leds.OwnerId!=ledsold.OwnerId)
                leadOwnerIds.put(Leds.Id,Leds.OwnerId);
				}
            }     
            LeadHelperKR.sendEmailToQueue(leadOwnerIds);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market

		Map<Id,Lead__C> oldMap=(Map<Id,Lead__C>)Trigger.oldMap;
        List<Lead__c> stouchLeads=new List<Lead__c>();
        Map<Id,Lead__C> stouchOldMap=new Map<Id,Lead__c>();
        if(isAfter && (isInsert || isUpdate)){
            //Leads Created from stouch
            for(Lead__c lead:(List<Lead__c>)trigger.new){
                if(lead.md__c=='KR' && lead.StouchLeadID__c!=null){
                    stouchLeads.add(lead);
                    if(isUpdate)
                        stouchOldMap.put(lead.Id, oldMap.get(lead.Id));
                }
            }
            if(!stouchLeads.isEmpty()){
                LeadHelperKR.leadsharehierarchy(stouchLeads);
            	LeadHelperKR.handleAfterInsertOrUpdate(stouchLeads,stouchOldMap);
            }
        }
    }

}