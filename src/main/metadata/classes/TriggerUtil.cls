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
    
    public static Boolean isTriggerEnabled(String aTriggerName) 
    {
        return isTriggerEnabled(getTriggerInfo(aTriggerName,usr));
    }
    public static Boolean isTriggerEnabled(List<Trigger__c> aTriggerInfoLst) 
    {
        if (!aTriggerInfoLst.isEmpty() && aTriggerInfoLst.size() > 0) 
    {
      for (Trigger__c triggerCust : aTriggerInfoLst)
      {
        if(triggerCust != null)
        {
          return triggerCust.enabled__c;
        }
        else 
        {
          return false;
        }
      } 
        }
    return false;
    }
    
    public static void handleTrigger(String aTriggerName)
    {
        system.debug('*$*$*$* handleTrigger method Count');
        Trigger__c triggerVal = new Trigger__c();
        if(!userCreate)
        {
            usr = [select id,profileid,profile.Name,Market__c from user where id=:userinfo.getuserid()];
            userCreate = true;
        }
        List<Trigger__c> triggerInfolst = new List<Trigger__c>(getTriggerInfo(aTriggerName,usr));
        system.debug('*$*$*$* List Value after return in Handler Method  ' + triggerInfolst);
        if(!triggerInfolst.isEmpty() && triggerInfolst.size() == 1 && usr.profile.Name !='IntegrationAPI' )
        {
            triggerVal = triggerInfolst[0];
            if (isTriggerEnabled(triggerInfolst)) 
            {
                TriggerHandlerIf triggerHandler = getTriggerHandler(triggerVal, aTriggerName);
                system.debug('Trigger Handler...' +triggerHandler);
                if (triggerHandler != null) 
                {
                    triggerHandler.handleTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete,trigger.isAfter);
                    //triggerHandler.handleIntegrationTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore,trigger.isdelete,trigger.isAfter);
					//commented as part of SFDCJP-2176                  

                }
            }
        }
        else
        {
            for(Trigger__c triggerInfo : triggerInfolst)
            {
                if (isTriggerEnabled(triggerInfolst)) 
                {
                    TriggerHandlerIf triggerHandler = getTriggerHandler(triggerInfo, aTriggerName);
                    
                    system.debug('Trigger Handler...' +triggerHandler);
                    if (triggerHandler != null) 
                    {
                        if( Test.isRunningTest())
                        {
                            triggerHandler.handleTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete,trigger.isAfter);
                            triggerHandler.handleIntegrationTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete,trigger.isAfter);                    
                        }
                        else if(usr.profile.Name =='IntegrationAPI')               
                            triggerHandler.handleIntegrationTrigger(trigger.isinsert,trigger.isupdate,trigger.isbefore, trigger.isdelete,trigger.isAfter);
                    }
                                
                }
            }
        }
    }
    public static List<Trigger__c> getTriggerInfo(String aTriggerName, User user) 
    {
    List<Trigger__c> triggerInfoList = new List<Trigger__c>();
        system.debug('   *$*$*$* aTriggerName  ' + aTriggerName);
        if (aTriggerName != null) {
            String profileName = user.profile.Name;
            for (Trigger__c triggerInfo : Trigger__c.getAll().values()) {
                if ((aTriggerName.equals(triggerInfo.Trigger_Name__c) && (user.Market__c!=null && user.Market__c.equals(triggerInfo.Market__c))) || (profileName.equals('IntegrationAPI')&& aTriggerName.equals(triggerInfo.Trigger_Name__c)) ||(Test.isRunningTest() && aTriggerName.equals(triggerInfo.Trigger_Name__c)))                
                {
                    system.debug('This method was called  ' + profileName);
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
                    triggerInfoList.add(triggerInfo);
                    system.debug(triggerInfoList + '   *$*$*$*  triggerInfo  ' + triggerInfo);
                }
            }
            system.debug('   *$*$*$*  Set Value before Return  ' + triggerInfoList);
            return triggerInfoList;
        }
        
        // If no corresonding data, just return null
        return null;
    }
    
    public static TriggerHandlerIf getTriggerHandler(Trigger__c aTriggerInfo, String aTriggerName)
    {
        String triggerHandlerName;
        if (aTriggerInfo != null && aTriggerInfo.Trigger_Handler__c != null) {
            triggerHandlerName = aTriggerInfo.Trigger_Handler__c;
            system.debug('*$*$*$*  triggerHandlerName  ' + triggerHandlerName);
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