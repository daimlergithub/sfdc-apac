/*
    Type:       Utility methods for triggers
    ---------------------------------------------------------------
    History:
    
    1. HNG Created on 2015-04-09
*/
public class TriggerUtil 
{
    //User variable
    public static Boolean userCreate = false;
    public static User usr = new User();
    
     
    public static Boolean isTriggerEnabled(Trigger__c aTriggerInfo) 
    {
        if (aTriggerInfo != null) {
            return aTriggerInfo.enabled__c;
        }
        else {
            return false;
        }
    }
    
    public static void handleTrigger(String aTriggerName)
    {
        system.debug('Handle Trigger...' +aTriggerName);
        if(!userCreate){
            usr = [select id,profileid,profile.Name,Market__c from user where id=:userinfo.getuserid()];
            userCreate = true;
        }
        Trigger__c triggerInfo = getTriggerInfo(aTriggerName,usr);
        system.debug('Handle Trigger1...' +usr);
        if (isTriggerEnabled(triggerInfo) ) {
            TriggerHandlerIf triggerHandler = getTriggerHandler(triggerInfo, aTriggerName);
            
            if (triggerHandler != null) {
                if(usr.profile.Name!='IntegrationAPI')
                    triggerHandler.handleTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete, trigger.isAfter);
                else
                    triggerHandler.handleIntegrationTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete);
            }
        }
    }
    
    public static Trigger__c getTriggerInfo(String aTriggerName, User user) 
    {
        system.debug('User Info...' +user);
        system.debug('Entered Info...' +Trigger__c.getAll().values());
        if (aTriggerName != null) {
            for (Trigger__c triggerInfo : Trigger__c.getAll().values()) {

                system.debug('Entered Handler...' +triggerInfo);
                if (aTriggerName.equals(triggerInfo.Trigger_Name__c) && ((user.Market__c.equals(triggerInfo.Market__c)) || (usr.profile.Name.equals('IntegrationAPI')))) {

                    system.debug('Entered Handler...');
                    if (trigger.isAfter && !triggerInfo.after__c) {
                        continue;
                    }
                    if (trigger.isBefore && !triggerInfo.before__c) {
                        continue;
                    }
                    if (trigger.isInsert && !triggerInfo.insert__c) {
                        continue;
                    }
                    if (trigger.isUpdate && !triggerInfo.update__c) {
                        continue;
                    }
                    if (trigger.isDelete && !triggerInfo.delete__c) {
                        continue;
                    }
                    return triggerInfo;
                }
            }
        }
        
        // If no corresonding data, just return null
        return null;
    }
    
    public static TriggerHandlerIf getTriggerHandler(Trigger__c aTriggerInfo, String aTriggerName)
    {
        String triggerHandlerName;
        if (aTriggerInfo != null && aTriggerInfo.Trigger_Handler__c != null) {
            triggerHandlerName = aTriggerInfo.Trigger_Handler__c;
        }
        /*else {
            triggerHandlerName = getDefaultTriggerHandlerName(aTriggerName);

        }*/
        
        Type triggerHandlerType = Type.forName(triggerHandlerName);
            
        if (triggerHandlerType == null) {
            throw new IllegalArgumentException('Trigger handler class ' + triggerHandlerName + ' not found. Please check custom setting Trigger for trigger name ' + aTriggerName);
        }
            
        return (TriggerHandlerIf)triggerHandlerType.newInstance();
    }
    
    private static String getDefaultTriggerHandlerName(String aTriggerName)
    {
        if (aTriggerName.endsWith('Trigger')) {
            return aTriggerName + 'Handler';
        }
        else {
            return aTriggerName + 'TriggerHandler';
        }
    }
}