public with sharing class CampaignSharingWrapService {
    private static Set<String> campaignSMTypes = new Set<String>{'S_M_Event_BMBS_Campaign', 'S_M_Media_BMBS_Campaign'};
    private static String smPermissionSetting = 'AS_Retail_Campaign';
    private static Set<String> campaignASTypes = new Set<String>{'AS_BMBS_Campaign'};
    private static String asPermissionSetting = 'S_M_Retail_Campaign';
    
    public CampaignSharingWrapService() {
    }

    public List<SharingWrapper> wrapCampaigns(List<Participating_Dealer__c> dealers) {
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        wrappers.addAll(wrapSMCampaigns(dealers));
        wrappers.addAll(wrapASCampaigns(dealers));
        return wrappers;
    }

    public List<SharingWrapper> wrapSMCampaigns(List<Participating_Dealer__c> dealers) {
        return wrapCampaignsFromDealer(dealers, campaignSMTypes, smPermissionSetting);
    }

    public List<SharingWrapper> wrapASCampaigns(List<Participating_Dealer__c> dealers) {
        return wrapCampaignsFromDealer(dealers, campaignASTypes, asPermissionSetting);
    } 
    
    public List<SharingWrapper> wrapCampaignsFromDealer(List<Participating_Dealer__c> dealers, Set<String> campaignTypeNames, String permissionSetting) {
        List<RecordType> campaignTypes = [select Id from RecordType where SObjectType = 'Campaign' and DeveloperName = :campaignTypeNames];
        dealers = [select Id, Dealer__c, Campaign__c, Campaign__r.RecordTypeId from Participating_Dealer__c where Id in :dealers and Campaign__r.RecordTypeId in :campaignTypes and Dealer__c != null];

        UserService userService = new UserService();
        Map<Id, Set<Id>> campaign2Users = userService.mapCampaign2DealerCampaignUsers(dealers, permissionSetting);
        return SharingWrapperService.wrapSharings(campaign2Users, 'Manual', 'Read');
    }
}