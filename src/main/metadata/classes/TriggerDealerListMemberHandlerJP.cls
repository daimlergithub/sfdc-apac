public class TriggerDealerListMemberHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       if(Trigger.isUpdate && Trigger.isAfter){
        
        DealerListMemberHelperJP.statusSyncWithCampaignMember (Trigger.New,(Map<ID,Dealer_List_Member__c>)trigger.oldMap);
        
        
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      if(Trigger.isUpdate && Trigger.isAfter){
        
        DealerListMemberHelperJP.statusSyncWithCampaignMember (Trigger.New,(Map<ID,Dealer_List_Member__c>)trigger.oldMap);
        
        
        }
    }
}