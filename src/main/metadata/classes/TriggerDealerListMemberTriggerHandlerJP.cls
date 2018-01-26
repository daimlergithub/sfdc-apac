/*
    Type:       Trigger HAndler class for DealerListMember object
    
    Created Date : 1/24/2018
*/
public class TriggerDealerListMemberTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      if(isInsert && isAfter){
         System.debug('tn'+trigger.new);
         DealerListMemberHelperJP.afterInsertEvent(trigger.new);
      }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}