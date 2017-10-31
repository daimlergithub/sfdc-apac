public class TriggerParticipateDealerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       if(Trigger.isInsert && Trigger.isAfter){
        
        ParticipateDealerHandlerJP.afterInsertEvent(Trigger.New);
        
        
        }
        if(Trigger.isUpdate && Trigger.isAfter){
        
        ParticipateDealerHandlerJP.afterUpdateEvent(Trigger.New,(Map<ID,Participating_Dealer__c >)trigger.oldMap);
        
        
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      if(Trigger.isInsert && Trigger.isAfter){
        
        ParticipateDealerHandlerJP.afterInsertEvent(Trigger.New);
        
        
        }
        if(Trigger.isUpdate && Trigger.isAfter){
        
        ParticipateDealerHandlerJP.afterUpdateEvent(Trigger.New,(Map<ID,Participating_Dealer__c >)trigger.oldMap);
        
        
        }
    }
}