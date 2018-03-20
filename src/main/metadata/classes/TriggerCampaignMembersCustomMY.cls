public class TriggerCampaignMembersCustomMY implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
    CampaignMemberCustomHelperMY helper=new CampaignMemberCustomHelperMY();
    if(Trigger.isInsert){
		if(trigger.isbefore)
			CampaignMemberCustomHelperBase.updateCampaignMemberCustommarket(Trigger.new);        
        if(Trigger.isAfter){
			   helper.campaignMemberHelperBeforeInsert(Trigger.new);
               helper.CampaignmemberssharewithsubDealers(Trigger.new);
        }
    }
    if(Trigger.isDelete){
		helper.beforeDeleteOperation(Trigger.old);
    }
	if(trigger.isupdate){
		if(trigger.isbefore)
			CampaignMemberCustomHelperBase.updateCampaignMemberCustommarket(Trigger.new);        
	}
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
    
}