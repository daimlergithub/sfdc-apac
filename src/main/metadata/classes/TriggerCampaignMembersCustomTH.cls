public class TriggerCampaignMembersCustomTH implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
    CampaignMemberCustomHelperTH helper=new CampaignMemberCustomHelperTH();
    if(Trigger.isInsert/*||Trigger.IsUpdate*/){
	
        helper.campaignMemberHelperBeforeInsert(Trigger.new);
        if(Trigger.isAfter){
               helper.CampaignmemberssharewithsubDealers(Trigger.new);
        }
         if(Trigger.isbefore){
               CampaignMemberCustomHelperTH.MapCampaignMemberfieldsbasedOnContact(Trigger.new);
        }
    }
    if(Trigger.isDelete){
    CampaignMemberCustomHelperTH.beforeDeleteOperation(Trigger.old);
    }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
    
}