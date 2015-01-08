/*
    Type:       Trigger 
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
trigger CampaignMemberAfterTrigger on CampaignMember (after insert, after update) {
    
    Set<String> memberIds = new Set<String>();
    for(CampaignMember member : trigger.new){
    	if(trigger.isInsert){
    		memberIds.add(member.Id);
    	}
    	if(trigger.isUpdate && member.Status != trigger.oldMap.get(member.Id).Status){
    		memberIds.add(member.Id);
    	}
    }
    
    CampaignMember[] members = [select Status, Campaign_Execution_Type__c, ContactId, CampaignId, Campaign.ParentId, Campaign.Parent.ParentId 
    							from CampaignMember where Id in :memberIds];
    CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(members);
}