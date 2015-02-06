/*
    Type:       helper class 
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
public class CampaignHelper {
    
    public static void copyTopCampaignStatusValueToSavedCampaign(Set<String> campaignIds){
        
        Set<String> topCampaignIds = new Set<String>();
        List<Campaign> campaigns = [select ParentId, Parent.ParentId from Campaign where Id in:campaignIds];
        for(Campaign cam : campaigns){
            if(cam.ParentId != null){
                topCampaignIds.add(cam.Parent.ParentId);
            }
        }
        
        List<CampaignMemberStatus> savedStatus = new List<CampaignMemberStatus>();
        for(CampaignMemberStatus status : [select CampaignId, HasResponded, IsDefault, Label, SortOrder from CampaignMemberStatus 
                                            where CampaignId in :topCampaignIds]){
            for(Campaign cam : campaigns){
                if(cam.Parent.ParentId == status.CampaignId){
                    CampaignMemberStatus newStatus = status.clone();
                    newStatus.CampaignId = cam.Id;
                    savedStatus.add(newStatus);
                }
            }
        }
        
        CampaignMemberStatus[] statuses = [select IsDefault, HasResponded from CampaignMemberStatus where CampaignId in :campaignIds];
        for(CampaignMemberStatus status : statuses){
        	status.IsDefault = false;
        	status.HasResponded = false;
        }
        update statuses;
        delete statuses;
        
        if(savedStatus.size() > 0){
            insert savedStatus;
        }
    }
    
    public static void updateCampaignMemberStatusToRelatedCampaign(List<CampaignMember> members){
    	
    	Set<String> topCampaignIds = new Set<String>();
    	Set<String> obcallCampaignIds = new Set<String>();
    	Set<String> unknownCampaignIds = new Set<String>();
    	Map<String, String> statusMap = new Map<String, String>();
    	
    	for(CampaignMember member : members){
    		statusMap.put(member.ContactId, member.Status);
    		
    		if(member.Campaign_Execution_Type__c == 'OB Call' && member.Campaign.ParentId != null){
    			topCampaignIds.add(member.Campaign.Parent.ParentId);
    			obcallCampaignIds.add(member.CampaignId);
    		}
    		else{
    			unknownCampaignIds.add(member.CampaignId);
    		}
    	}
    	
    	for(Campaign camp : [select Id, Parent.ParentId from Campaign where Parent.ParentId = :unknownCampaignIds and Execution_Type__c = 'OB Call']){
    		topCampaignIds.add(camp.Parent.ParentId);
    		obcallCampaignIds.add(camp.Id);
    	}
    	for(Campaign camp : [select Id from Campaign where Parent.ParentId = :topCampaignIds and Execution_Type__c = 'OB Call']){
    		obcallCampaignIds.add(camp.Id);
    	}
    	
    	Set<String> campaignIds = new Set<String>();
    	campaignIds.addAll(topCampaignIds);
    	campaignIds.addAll(obcallCampaignIds);
    	campaignIds.remove(null);
    	
    	List<CampaignMember> updatedMembers = new List<CampaignMember>();
    	for(CampaignMember mem : [select Status, ContactId from CampaignMember where CampaignId in :campaignIds and ContactId in :statusMap.keySet()]){
    		String status = statusMap.get(mem.ContactId) ;
    		if(status != null){
    			mem.Latest_Status__c = status;
    		}
    		updatedMembers.add(mem);
    	}
    	
    	if(updatedMembers.size() > 0){
    		update updatedMembers;
    	}
    }
}