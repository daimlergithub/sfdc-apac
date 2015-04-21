/*
    Type:       Trigger 
    ---------------------------------------------------------------
    History:
    
    2014-02-18 Created by Justin Yu
    2015-04-21 Gerhard Henning (NTTData)  Moved code to CampaignMemberAfterTriggerHandler
*/
public class CampaignMemberAfterTriggerHandler
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        Set<String> memberIds = new Set<String>();
        for(CampaignMember member : (List<CampaignMember>)trigger.new){
            if(trigger.isInsert){
                memberIds.add(member.Id);
            }
            if(trigger.isUpdate && member.Status != ((Map<Id,CampaignMember>)trigger.oldMap).get(member.Id).Status){
                memberIds.add(member.Id);
            }
        }
        
        CampaignMember[] members = [select Status, Campaign_Execution_Type__c, ContactId, CampaignId, Campaign.ParentId, Campaign.Parent.ParentId 
                                    from CampaignMember where Id in :memberIds];
        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(members);
    }
}