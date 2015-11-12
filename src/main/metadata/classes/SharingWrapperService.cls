/**
* This class is for sharing records
*
* Created By: CC
* Date: 2014-06-12
*/

public class SharingWrapperService {

/**	
* @Description  This method is to share records
* @author  
* @Date (mm/dd/yy)
* @param  Passing row cause, list of Retail Tasks and access level.
* @return list of SharingWrapper
* @see   AccountLinkSharingWrapService, LeadSharingWrapService, RetailCampaignSharingWrapService, 
* 		 RetailTaskSharingWrapService, TookKitSharingWrapService, VehicleRelationshipSharingWrapService, 
*		 VehicleSharingWrapService
*/ 	 
	public static List<SharingWrapper> wrapSharings(Map<Id, Set<Id>> record2Users, String rowCause, String accessLevel){
		if(String.isBlank(accessLevel)){
			accessLevel = 'Read';
		}
		List<SharingWrapper> wrappers = new List<SharingWrapper>();
        for(Id recordId : record2Users.keySet()) {
        	if(record2Users.get(recordId) != null && !record2Users.get(recordId).isEmpty()) {
        		Map<Id, String> user2Access = new Map<Id, String>();
        		for(Id uid : record2Users.get(recordId)) {
        			user2Access.put(uid, accessLevel);
        		}
        		SharingWrapper wrapper = new SharingWrapper(recordId, user2Access, rowCause);
        		wrappers.add(wrapper);
        	}
        }
        return wrappers;
	}
}