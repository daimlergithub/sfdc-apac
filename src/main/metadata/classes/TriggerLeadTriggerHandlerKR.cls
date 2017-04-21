/*
    Type:       Trigger HAndler class for Lead object
    Created By : Kiran
    Created Date : 10/12/2016
*/
public class TriggerLeadTriggerHandlerKR
    implements TriggerHandlerIf
{
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
        System.debug('Handletrigger----->1');
        if(isBefore && isInsert)
        {
            LeadHelperJP.updateAssignedDealer(trigger.new);
        }
        if(isBefore && isUpdate){
            set<id> dealerIds = new set<id>();
            for(Lead__C leds : (List<Lead__c>)trigger.new){
                dealerIds.add(Leds.Assigned_Dealer__c);
            }            
             LeadHelper.UpdateLeadOwnerFromDealerLeadGateKeeper(dealerIds,Trigger.new,(Map<Id,Lead__c>)trigger.oldMap);
        }       
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated){
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
             LeadHelperKR.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            LeadUtil.isCreated = false;
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated){
            system.debug('Isafter is working');
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadSharingforDealerJP.LeadSharingforDealer(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
             LeadHelperKR.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            LeadUtil.isCreated = false;
        }
        if((isUpdate || isInsert) && usr.Profile.Name != 'IntegrationAPI'){
            system.debug('LeadSharingforDealerJP >>> :');
            Set<Id> ids = new set<Id>();
            for(Lead__C leds : (List<Lead__c>)trigger.new){
                ids.add(leds.id);
            }
            LeadSharingforDealerJP.LeadSharing_Dealer(trigger.new);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }

}