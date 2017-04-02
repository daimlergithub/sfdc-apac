/*
    Type:       Trigger Handler class for Retail Task object
    Created By : Venkataramana Cheedara
    Created Date : 10/20/2016
*/
public class RetailTaskTriggerHandlerKR 
    implements TriggerHandlerIf
{   
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   
        user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];   
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI'){
            System.debug('Is Insert called -----:::::');
            RetailTaskHelperJP.RetailTaskDetails(trigger.new, (Map<Id,Retail_Task__c>)Trigger.OldMap, isInsert, isUpdate);
           
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI' ){           
            RetailTaskHelperJP.RetailTaskDetails(trigger.new, (Map<Id,Retail_Task__c>)Trigger.OldMap, isInsert, isUpdate);            
        }
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI'){
            RetailTaskHelperJP.afterInsertEvent(trigger.new);
        }
    } 
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    } 
}