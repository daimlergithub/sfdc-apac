/**
** Wrap service for leads to share.
** 1.  Share retail lead to all active campaign users of the linked dealer.
** 
** Created By: CC
** Date: 2014-6-15
**/

public with sharing class LeadSharingWrapService {
    private static Set<String> campaignProfileNames = new Set<String>{'Partner Community User'};
    private static String leadRetailType = 'Retail_Sales_Leads';
    private static List<Profile> profiles;
    private static List<Lead__c> listleads;
    public LeadSharingWrapService() {
    }
   /**      
     * @Description Gets all the required fields of retail lead then wraps those retail leads by record type.  
     * @author  
     * @Date 10/26/2015(mm/dd/yy)
                * @param  leads is a list having all the new records of leads object.
                * @return list of the leads which are shared to the actice campaign users.
                 * @see   SharingWrapperService
                */    

    public List<SharingWrapper> wrapLeads(List<Lead__c> leads){
        Set<Id> profileIds = new Set<Id>();
        listleads= [select Id, Assigned_Dealer__c from Lead__c where Id in :leads and Assigned_Dealer__c != null and RecordType.developerName = :leadRetailType];
        profiles= [select Id from Profile where Name in :campaignProfileNames];
        for(Profile profile :profiles) {
            profileIds.add(profile.Id);
        }

        UserService userService = new UserService();
        Map<Id, Set<Id>> lead2Users = userService.mapLead2CampaignUsers(listleads,profileIds);

        return SharingWrapperService.wrapSharings(lead2Users, Schema.Lead__Share.RowCause.Dealer_Campaign_Share__c, 'Edit');
    }
}