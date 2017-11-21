/**
** Wrap service for tool kit to share
** Dealer_Name__c
** 1. shares toolkit records to all active campaign users of the linked dealer.
** 2. shares toolkit records to third parry user (Vendor_Employee__c),  if the lookup field to third party user is 
**    filled in.
** 
** Updated By: CC
** Date: 2014-06-22
** Description: Added logic for sharing data to 3rd party users.
**
** Created By: CC
** Date: 2014-06-19
**/
public with sharing class TookKitSharingWrapService {
    private static String permissionSetting = 'S_M_Retail_Campaign';
    
    public TookKitSharingWrapService() {
    }

    public List<SharingWrapper> wrapToolKits(List<Tool_Kit__c> toolKits){
        toolKits = [select Id, Dealer_Name__c, Brand__c, Dealer_Name__r.Retail_MB_Owner__c, Dealer_Name__r.Retail_smart_Owner__c, Dealer_Name__r.Retail_AMG_Owner__c, Dealer_Name__r.Retail_Star_Elite_Owner__c from Tool_Kit__c where Id in :toolKits and Dealer_Name__c != null];
        
        UserService userService = new UserService();
        Map<Id, Set<Id>> toolKit2Users = userService.mapToolKit2CampaignUsers(toolKits, permissionSetting);

        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        wrappers.addAll(SharingWrapperService.wrapSharings(toolKit2Users, Schema.Tool_Kit__Share.RowCause.Dealer_Campaign_Share__c, 'Edit'));
        
        wrappers.addAll(wrapBrandToolKits(toolkits));
        
        return wrappers;
    }

    // Shares retail campaigns to brand owner.
    public List<SharingWrapper> wrapBrandToolKits(List<Tool_Kit__c> toolKits) {
        Map<Id, Set<Id>> campaign2Users = new Map<Id, Set<Id>>();
        for(Tool_Kit__c toolKit : toolKits) {
            if(toolKit.Brand__c == 'MB') {
                campaign2Users.put(toolKit.Id, new Set<Id>{toolKit.Dealer_Name__r.Retail_MB_Owner__c});
            } else if(toolKit.Brand__c == 'AMG') {
                campaign2Users.put(toolKit.Id, new Set<Id>{toolKit.Dealer_Name__r.Retail_AMG_Owner__c});
            } else if(toolKit.Brand__c == 'smart') {
                campaign2Users.put(toolKit.Id, new Set<Id>{toolKit.Dealer_Name__r.Retail_smart_Owner__c});
            } else if(toolKit.Brand__c == 'StarElite') {
                campaign2Users.put(toolKit.Id, new Set<Id>{toolKit.Dealer_Name__r.Retail_Star_Elite_Owner__c});
            } 
        }

        return SharingWrapperService.wrapSharings(campaign2Users, Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c, 'Edit');
    }

    public List<SharingWrapper> wrapToolKitsFor3rdPartyUsers(List<Tool_Kit__c> toolKits){
        Map<Id, Set<Id>> toolKit2Users = new Map<Id, Set<Id>>();
        for(Tool_Kit__c toolKit : [select Id, Vendor_Employee__c from Tool_Kit__c where Id in :toolKits and Vendor_Employee__c != null]) {
            toolKit2Users.put(toolKit.Id, new Set<Id>{toolKit.Vendor_Employee__c});
        }
        
        return SharingWrapperService.wrapSharings(toolKit2Users, Schema.Tool_Kit__Share.RowCause.Third_Party_User_Share__c, 'Edit');
    }
}