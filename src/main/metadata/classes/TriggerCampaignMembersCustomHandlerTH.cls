/*
    Type:       Trigger on Campaign Member
    Purpose:    To be added 
    Date: 2017-1-31
    User Story:
    Used By:    
    ---------------------------------------------------------------
*/

public class TriggerCampaignMembersCustomHandlerTH  implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
       if(isBefore && isInsert){
       campaignMemberHelperTH.beforeInsertevents(trigger.new);
       }
      if(Trigger.isBefore && Trigger.isUpdate){
          CampaignMemberHelperBase.updateCampaignMemberCustommarket(Trigger.New);
       }  
       
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}