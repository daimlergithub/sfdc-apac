public class TriggerSegmentationCritTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    
     if(trigger.isAfter && trigger.isInsert)
        {
    
    CampaignMembersCustomHelperJP.SegmentationSharingForDealer(Trigger.new);
    
    
    }
    
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    
    
    
    
    
    
    
    
    
    }
}