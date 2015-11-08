public with sharing class RetailCampaignSharingWrapService {
    private static String editString = 'Edit';
    private static String smPermissionSetting = 'S_M_Retail_Campaign';
    private static String asPermissionSetting = 'AS_Retail_Campaign';
    private static Set<String> readOnlyBPStatus = new Set<String>{'Region Submit', 'Final Submit'};
    private static Set<String> editableBPStatus = new Set<String>{'Retail Submit'};

    public RetailCampaignSharingWrapService() {
    }

    public List<SharingWrapper> wrapRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        retailCampaigns = [select Id, RecordTypeId, Brand__c, Yearly_TA__c, Yearly_TA__r.RecordTypeId, Yearly_TA__r.Dealer_Name__c, Yearly_TA__r.Y_Dealer_Name__c, Yearly_TA__r.Brand__c, BP_Status__c, 
                            Dealer_Name__c, Dealer_Name__r.Retail_MB_Owner__c, Dealer_Name__r.Retail_smart_Owner__c, Dealer_Name__r.Retail_AS_Owner__c, Dealer_Name__r.Retail_AMG_Owner__c, Dealer_Name__r.Retail_Star_Elite_Owner__c,
                            Y_Dealer_Name__c, Y_Dealer_Name__r.Retail_MB_Owner__c, Y_Dealer_Name__r.Retail_smart_Owner__c, Y_Dealer_Name__r.Retail_AS_Owner__c, Y_Dealer_Name__r.Retail_AMG_Owner__c, Y_Dealer_Name__r.Retail_Star_Elite_Owner__c 
                            from Retail_Campaign__c where Id in :retailCampaigns];
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        Map<Id, RecordType> retailCampaignTypes = new Map<Id, RecordType>([select Id, DeveloperName from RecordType where SObjectType = 'Retail_Campaign__c']);
        List<Retail_Campaign__c> asRetailCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> smEventCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> smMediaCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> segmentationCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> smYearlyCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> asYearlyCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> monthlyCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> mbCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> smartCampiagns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> taCampiagns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> bestPracticeCampiagns = new List<Retail_Campaign__c>();

        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(retailCampaignTypes.get(retailCampaign.RecordTypeId) != null) {
                if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('AS_Retail_Campaign')) {
                    asRetailCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_Event')) {
                    smEventCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_Media')) {
                    smMediaCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Segmentation_Only')) {
                    segmentationCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Sales_Marketing')) {
                    smYearlyCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Aftersales')) {
                    asYearlyCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Monthly_TA')) {
                    monthlyCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_MB_Best_Practice')) {
                    mbCampaigns.add(retailCampaign);
                } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_smart_Best_Practice')) {
                    smartCampiagns.add(retailCampaign);
                }
            }
            // Additional logic for monthly target, need to share yearly target to dealers.
            if(retailCampaign.Yearly_TA__c != null && retailCampaignTypes.get(retailCampaign.Yearly_TA__r.RecordTypeId) != null) {
                if(retailCampaignTypes.get(retailCampaign.Yearly_TA__r.RecordTypeId).DeveloperName.equalsIgnoreCase('Sales_Marketing')) {
                    smYearlyCampaigns.add(retailCampaign.Yearly_TA__r);
                } else if(retailCampaignTypes.get(retailCampaign.Yearly_TA__r.RecordTypeId).DeveloperName.equalsIgnoreCase('Aftersales')) {
                    asYearlyCampaigns.add(retailCampaign.Yearly_TA__r);
                }
            }
        }

        if(!asRetailCampaigns.isEmpty()) {
            wrappers.addAll(wrapASRetailCampaigns(asRetailCampaigns));
        }
        if(!smEventCampaigns.isEmpty()) {
            wrappers.addAll(wrapSMEventRetailCampaigns(smEventCampaigns));
        }
        if(!smMediaCampaigns.isEmpty()) {
            wrappers.addAll(wrapSMMediaRetailCampaigns(smMediaCampaigns));
        }
        if(!segmentationCampaigns.isEmpty()) {
            wrappers.addAll(wrapSegmentationRetailCampaigns(segmentationCampaigns));
        }
        if(!smYearlyCampaigns.isEmpty()) {
            wrappers.addAll(wrapSMYearlyRetailCampaigns(smYearlyCampaigns));
        }
        if(!asYearlyCampaigns.isEmpty()) {
            wrappers.addAll(wrapASYearlyRetailCampaigns(asYearlyCampaigns));
        }
        if(!monthlyCampaigns.isEmpty()) {
            wrappers.addAll(wrapMonthlyRetailCampaigns(monthlyCampaigns));
        }
        if(!mbCampaigns.isEmpty()) {
            wrappers.addAll(wrapMBRetailCampaigns(mbCampaigns));
        }
        if(!smartCampiagns.isEmpty()) {
            wrappers.addAll(wrapSmartRetailCampaigns(smartCampiagns));
        }

        taCampiagns.addAll(asYearlyCampaigns);
        taCampiagns.addAll(monthlyCampaigns);
        wrappers.addAll(wrapBrandRetailCampaigns(taCampiagns));

        bestPracticeCampiagns.addAll(asRetailCampaigns);
        bestPracticeCampiagns.addAll(mbCampaigns);
        bestPracticeCampiagns.addAll(smartCampiagns);
        wrappers.addAll(wrapBrandRetailCampaignsByType(bestPracticeCampiagns, retailCampaignTypes));
        return wrappers;
    }

    public List<SharingWrapper> wrapSMEventRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaigns(retailCampaigns, smPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapSMMediaRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaigns(retailCampaigns, smPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapASRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaigns(retailCampaigns, asPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapSegmentationRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaigns(retailCampaigns, null, editString);
    }

    public List<SharingWrapper> wrapSMYearlyRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapYearlyRetailCampaigns(retailCampaigns, smPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapASYearlyRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapYearlyRetailCampaigns(retailCampaigns, asPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapMonthlyRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapYearlyRetailCampaigns(retailCampaigns, smPermissionSetting, editString);
    }

    public List<SharingWrapper> wrapMBRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaignsByBPStatus(retailCampaigns);
    }

    public List<SharingWrapper> wrapSmartRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        return wrapRetailCampaignsByBPStatus(retailCampaigns);
    }

    // Shares retail campaigns to brand owner.
    public List<SharingWrapper> wrapBrandRetailCampaigns(List<Retail_Campaign__c> retailCampaigns) {
        Map<Id, Set<Id>> campaign2Users = new Map<Id, Set<Id>>();
        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(retailCampaign.Brand__c == 'MB') {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Y_Dealer_Name__r.Retail_MB_Owner__c});
            } else if(retailCampaign.Brand__c == 'AMG') {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Y_Dealer_Name__r.Retail_AMG_Owner__c});
            } else if(retailCampaign.Brand__c == 'smart') {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Y_Dealer_Name__r.Retail_smart_Owner__c});
            } else if(retailCampaign.Brand__c == 'StarElite') {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Y_Dealer_Name__r.Retail_Star_Elite_Owner__c});
            }
        }

        return SharingWrapperService.wrapSharings(campaign2Users, Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c, editString);
    }

    // Shares retail campaigns to brand owner.
    public List<SharingWrapper> wrapBrandRetailCampaignsByType(List<Retail_Campaign__c> retailCampaigns, Map<Id, RecordType> retailCampaignTypes) {
        Map<Id, Set<Id>> campaign2Users = new Map<Id, Set<Id>>();
        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('AS_Retail_Campaign')) {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Dealer_Name__r.Retail_AS_Owner__c});
            } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_smart_Best_Practice')) {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Dealer_Name__r.Retail_smart_Owner__c});
            } else if(retailCampaignTypes.get(retailCampaign.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_MB_Best_Practice')) {
                campaign2Users.put(retailCampaign.Id, new Set<Id>{retailCampaign.Dealer_Name__r.Retail_MB_Owner__c});
            }
        }

        return SharingWrapperService.wrapSharings(campaign2Users, Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c, editString);
    }    

    private List<SharingWrapper> wrapYearlyRetailCampaigns(List<Retail_Campaign__c> retailCampaigns, String permissionSetting, String accessLevel) {
        UserService userService = new UserService();
        Map<Id, Set<Id>> campaign2Users = userService.mapYearlyRetailCampaign2CampaignDealers(retailCampaigns, permissionSetting);
        
        return SharingWrapperService.wrapSharings(campaign2Users, Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c, accessLevel);
    }

    private List<SharingWrapper> wrapRetailCampaignsByBPStatus(List<Retail_Campaign__c> retailCampaigns) {
        system.debug('**-' + retailCampaigns);
        List<Retail_Campaign__c> readOnlyRetailCampaigns = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> editableRetailCampaigns = new List<Retail_Campaign__c>();
        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(readOnlyBPStatus.contains(retailCampaign.BP_Status__c)) {
                readOnlyRetailCampaigns.add(retailCampaign);
            } else if(editableBPStatus.contains(retailCampaign.BP_Status__c)) {
                editableRetailCampaigns.add(retailCampaign);
            }
        }
        List<SharingWrapper> sharingWrappers = new List<SharingWrapper>();
        if(!readOnlyRetailCampaigns.isEmpty()) {
            sharingWrappers.addAll(wrapRetailCampaigns(retailCampaigns, null, 'Read')); 
        }
        if(!editableRetailCampaigns.isEmpty()) {
            sharingWrappers.addAll(wrapRetailCampaigns(retailCampaigns, null, editString));
        }
        system.debug('**-' + sharingWrappers);
        return sharingWrappers;
    }

    private List<SharingWrapper> wrapRetailCampaigns(List<Retail_Campaign__c> retailCampaigns, String permissionSetting, String accessLevel) {
        UserService userService = new UserService();
        Map<Id, Set<Id>> campaign2Users = userService.mapRetailCampaign2CampaignDealers(retailCampaigns, permissionSetting);
        
        return SharingWrapperService.wrapSharings(campaign2Users, Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c, accessLevel);
    }
}