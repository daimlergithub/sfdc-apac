/**
** Wrap service for leads to share.
** Assigned_Dealer__c
** 1. Share retail lead to all active campaign users of the linked dealer.
** 
** Created By: CC
** Date: 2014-6-18
**/
public class LeadSharingWrapService {
    private static Set<String> campaignProfileNames = new Set<String>{'Dealer Community Delegate Admin'};
    private static String leadRetailType = 'Retail_Sales_Leads';

    public LeadSharingWrapService() {
    }

    public List<SharingWrapper> wrapLeads(List<Lead__c> leads){
        leads = [select Id, Assigned_Dealer__c from Lead__c where Id in :leads and Assigned_Dealer__c != null and RecordType.developerName = :leadRetailType];
        
        Set<Id> profileIds = new Set<Id>();
        for(Profile profile : [select Id from Profile where Name in :campaignProfileNames]) {
            profileIds.add(profile.Id);
        }

        UserService userService = new UserService();
        Map<Id, Set<Id>> lead2Users = userService.mapLead2CampaignUsers(leads, profileIds);

        return SharingWrapperService.wrapSharings(lead2Users, Schema.Lead__Share.RowCause.Dealer_Campaign_Share__c, 'Edit');
    }
}