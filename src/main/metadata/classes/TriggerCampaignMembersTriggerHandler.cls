/*
    Type:       Trigger
    Purpose:    Campaign Member  
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignMembersTriggerHandler
*/
public class TriggerCampaignMembersTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        /*if(isInsert && isAfter)
        {
            campaignMemberHelperKR.setCreateTaskFieldFalseOrTrueOnCampaign(trigger.new);
        }*/
         if(isBefore && isInsert)
        {
            campaignMemberHelperKR.updatecustomstatus(trigger.new,(Map<Id,CampaignMember>)Trigger.OldMap);
        }
        if(trigger.isBefore && trigger.isUpdate){
           CampaignMemberHelperBase.updateCampaignMembermarket(Trigger.New);
		   campaignMemberHelperKR.updatecustomstatus(trigger.new,(Map<Id,CampaignMember>)Trigger.OldMap);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}