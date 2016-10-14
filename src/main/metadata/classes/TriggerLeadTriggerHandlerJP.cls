/*
    Type:       Trigger HAndler class for Lead object
    Created By : Narasimha 
    Created Date : 1/20/2016
*/
public class TriggerLeadTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];   
        System.debug('Handletrigger----->');
        if(isBefore && isUpdate)
        {
            LeadHelperJP.updateCustomerStage(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, (Map<Id,Lead__C>)Trigger.NewMap);
            
        }
     
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI'){
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI'){
            system.debug('Isafter is');
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }

}