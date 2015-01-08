/***
** Service class to share different SObjects.
** 
** Created By: CC
** Date: 2014-06-11
**/
public class SharingService {

    public static void shareRetailCampaigns(List<SharingWrapper> sharings) {
        shareSObjects('Retail_Campaign__Share', sharings);
    }

    public static void shareCampaigns(List<SharingWrapper> sharings){
        shareSObjects('CampaignShare', sharings);
    }

    public static void shareToolKits(List<SharingWrapper> sharings){
        shareSObjects('Tool_Kit__Share', sharings);
    }
    
    public static void shareLeads(List<SharingWrapper> sharings){
        shareSObjects('Lead__Share', sharings);
    }
    
    public static void shareRetailTasks(List<SharingWrapper> sharings){
        shareSObjects('Retail_Task__Share', sharings);
    }

    public static void shareVehicleRelationships(List<SharingWrapper> sharings) {
        shareSObjects('Vehicle_Relationship__Share', sharings);
    }

    public static void shareVehicles(List<SharingWrapper> sharings) {
        shareSObjects('Vehicle__Share', sharings);
    }

    public static void shareAccountLinks(List<SharingWrapper> sharings) {
        shareSObjects('Account_Link__Share', sharings);
    }

    private static void shareSObjects(String sharingSObjectType, List<SharingWrapper> sharings){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sharingSObjectType);
        if (targetType == null) {
            // throw an exception
            return;
        } else {
            List<SObject> targetShares = new List<SObject>();
            for(SharingWrapper targetShareWrapper : sharings) {
                for(Id userId : targetShareWrapper.UserOrGroups2AccessLevel.keySet()){
                    SObject targetShare = targetType.newSObject();
                    if(sharingSObjectType.equalsIgnoreCase('CampaignShare')) {
                        targetShare.put('CampaignId', targetShareWrapper.ParentId);
                        targetShare.put('CampaignAccessLevel', targetShareWrapper.UserOrGroups2AccessLevel.get(userId));
                    } else {
                        targetShare.put('ParentId', targetShareWrapper.ParentId);
                        targetShare.put('AccessLevel', targetShareWrapper.UserOrGroups2AccessLevel.get(userId));
                        targetShare.put('RowCause', targetShareWrapper.RowCause);
                    }
                    targetShare.put('UserOrGroupId', userId);
                    targetShares.add(targetShare);
                }
            }
            System.debug('**-' + targetShares);
            Database.insert(targetShares, false);
        }
    }
}