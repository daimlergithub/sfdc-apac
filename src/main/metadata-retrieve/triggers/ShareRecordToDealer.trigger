trigger ShareRecordToDealer on Retail_Campaign__c (before insert, after insert, after update) {
    // Copies record type name, status and dealer region to a "Monthly TA" campaign from its linked "Yearly TA"
    if(Trigger.isBefore && Trigger.isInsert) {
        User currentUser = [select Id, Contact.AccountId from User where Id = :UserInfo.getUserId()];
        Map<String, String> campaignName2Abbr = new Map<String, String>{'Sales & Marketing Yearly TA' => ' S&M', 'Aftersales Yearly TA' => ' AS'};
        
        String monthlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId();
        String smYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        String asYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
        
        Set<Id> yearlyCampaignIds = new Set<Id>();
        Set<Id> dealerIds = new Set<Id>();
        
        for(Retail_Campaign__c retailCampaign : Trigger.new) {
            if(retailCampaign.RecordTypeId == monthlyTARecordTypeId) {
                yearlyCampaignIds.add(retailCampaign.M_YearlyTA__c);
//                yearlyCampaignIds.add(retailCampaign.Yearly_TA__c);
            }
            if(retailCampaign.Dealer_Name__c == null && currentUser.Contact.AccountId != null) {
                retailCampaign.Dealer_Name__c = currentUser.Contact.AccountId;  
            }
            if(retailCampaign.RecordTypeId == smYearlyTARecordTypeId || retailCampaign.RecordTypeId == asYearlyTARecordTypeId) {
                dealerIds.add(retailCampaign.Y_Dealer_Name__c);
            }
        }

        Map<Id, Retail_Campaign__c> yearlyCampaigns = new Map<Id, Retail_Campaign__c>([select Id, RecordType.Name, Y_Status__c, Dealer_Region__c, Y_Dealer_Name__c from Retail_Campaign__c where Id in :yearlyCampaignIds]);
        Map<Id, Account> dealerAccounts = new Map<Id, Account>([select Id, Dealer_Region__c from Account where Id in:dealerIds]);
        for(Retail_Campaign__c retailCampaign : Trigger.new) {
            if(retailCampaign.RecordTypeId == monthlyTARecordTypeId) {
                Retail_Campaign__c yearlyCampaign = yearlyCampaigns.get(retailCampaign.M_YearlyTA__c);
                //Retail_Campaign__c yearlyCampaign = yearlyCampaigns.get(retailCampaign.Yearly_TA__c);
                if(yearlyCampaign != null) {
                    retailCampaign.Name += campaignName2Abbr.get(yearlyCampaign.RecordType.Name);
                    retailCampaign.Y_Status__c = yearlyCampaign.Y_Status__c;
                    retailCampaign.Dealer_Region__c = yearlyCampaign.Dealer_Region__c;
                    retailCampaign.Y_Dealer_Name__c = yearlyCampaign.Y_Dealer_Name__c;
                }
            }
            if(retailCampaign.RecordTypeId == smYearlyTARecordTypeId || retailCampaign.RecordTypeId == asYearlyTARecordTypeId) {
                Account dealerAccount = dealerAccounts.get(retailCampaign.Y_Dealer_Name__c);
                if(dealerAccount != null) {
                    retailCampaign.Dealer_Region__c = dealerAccount.Dealer_Region__c;
                }
            }
        }
    }
    
    // Shares retail campaigns to dealers.
    if(Trigger.isAfter && Trigger.isInsert) {
        RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
        SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(Trigger.new));
    }
    
    // Updates the status of "Monthly TA" campaigns when a "Yearly TA" campaign status changed.
    if(Trigger.isAfter && Trigger.isUpdate) {
        String aftersalesYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
        Set<Id> yearlyCampaignIds = new Set<Id>();
        for(Id yearlyCampaignId : Trigger.newMap.keySet()) {
            if(Trigger.newMap.get(yearlyCampaignId).Y_Status__c != Trigger.oldMap.get(yearlyCampaignId).Y_Status__c) {
                if(Trigger.newMap.get(yearlyCampaignId).RecordTypeId == aftersalesYearlyTARecordTypeId) {
                    yearlyCampaignIds.add(yearlyCampaignId);
                }
            }
        }
        Map<Id, Retail_Campaign__c> yearlyCampaigns = new Map<Id, Retail_Campaign__c>([select Id, Y_Status__c from Retail_Campaign__c where Id in :yearlyCampaignIds]);
        List<Retail_Campaign__c> monthlyCampaigns = [select Id, Y_Status__c, M_YearlyTA__c from Retail_Campaign__c where M_YearlyTA__c in :yearlyCampaignIds];
        if(!monthlyCampaigns.isEmpty()) {
            for(Retail_Campaign__c monthlyCampaign : monthlyCampaigns) {
                monthlyCampaign.Y_Status__c = yearlyCampaigns.get(monthlyCampaign.M_YearlyTA__c).Y_Status__c;
            }
            update monthlyCampaigns;
        }

        List<Retail_Campaign__c> changedRecords = new List<Retail_Campaign__c>();
        for(Id recordId : Trigger.newMap.keySet()) {
            if(Trigger.newMap.get(recordId).Dealer_Name__c != Trigger.oldMap.get(recordId).Dealer_Name__c 
                || Trigger.newMap.get(recordId).Y_Dealer_Name__c != Trigger.oldMap.get(recordId).Y_Dealer_Name__c 
                || Trigger.newMap.get(recordId).BP_Status__c != Trigger.oldMap.get(recordId).BP_Status__c) {
                changedRecords.add(Trigger.newMap.get(recordId));
            }
        }
        if(!changedRecords.isEmpty()) {
            delete [select Id from Retail_Campaign__Share where ParentId = :changedRecords and RowCause = :Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c];
            
            RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
            SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(changedRecords));
        }
    }
/*
    String smEventRetailCampaignRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
    String smMediaRetailCampaignRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
    String asRetailCampaignRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
    String segmentationOnlyRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Segmentation Only').getRecordTypeId();
    String salesAndMarketingYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
    String aftersalesYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
    String monthlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId();
    
    List<Task> newTasks = new List<Task>();
    
    List<Retail_Campaign__c> needBeSharedToSMCampaignUserRecords = new List<Retail_Campaign__c>();
    List<Retail_Campaign__c> needBeSharedToASUserRecords = new List<Retail_Campaign__c>();
    List<Retail_Campaign__c> segmentationOnlyRecords = new List<Retail_Campaign__c>();
    List<Retail_Campaign__c> aftersalesYearlyTARecords = new List<Retail_Campaign__c>();
    List<Retail_Campaign__c> monthlyTARecords = new List<Retail_Campaign__c>();
    
    Set<Id> needBeSharedToSMCampaignUserOwnerIds = new Set<Id>();
    Set<Id> needBeSharedToASUserOwnerIds = new Set<Id>();
    Set<Id> isSegmentationOnlyOwnerIds = new Set<Id>();
    set<Id> isAftersalesYearlyTAOwnerIds = new Set<Id>();
    set<Id> isMonthlyTAOwnerIds = new Set<Id>();
    
    // Category records according to RecordType.
    for(Retail_Campaign__c tempRecord : trigger.new) {
        if(needBeSharedToSMCampaignUser(tempRecord.RecordTypeId)) {
            needBeSharedToSMCampaignUserRecords.add(tempRecord);
            needBeSharedToSMCampaignUserOwnerIds.add(tempRecord.OwnerId);
            continue;
        }
        if(needBeSharedToASUser(tempRecord.RecordTypeId)) {
            needBeSharedToASUserRecords.add(tempRecord);
            needBeSharedToASUserOwnerIds.add(tempRecord.OwnerId);
            continue;
        }
        if(isSegmentationOnly(tempRecord.RecordTypeId)) {
            segmentationOnlyRecords.add(tempRecord);
            isSegmentationOnlyOwnerIds.add(tempRecord.OwnerId);
            continue;
        }
        if(isAftersalesYearlyTA(tempRecord.RecordTypeId)) {
            aftersalesYearlyTARecords.add(tempRecord);
            isAftersalesYearlyTAOwnerIds.add(tempRecord.OwnerId);
            continue;
        }
        if(isMonthlyTA(tempRecord.RecordTypeId)) {
            monthlyTARecords.add(tempRecord);
            isMonthlyTAOwnerIds.add(tempRecord.OwnerId);
            continue;
        }
    }
    
    insert newTasks;
    
    private Boolean needBeSharedToSMCampaignUser(Id tempRecordTypeId) {
        if(tempRecordTypeId == smEventRetailCampaignRecordTypeId) {
            return true;
        }   
        if(tempRecordTypeId == smMediaRetailCampaignRecordTypeId) {
            return true;
        }
        if(tempRecordTypeId == salesAndMarketingYearlyTARecordTypeId) {
            return true;
        }
        return false;
    }
    
    private Boolean needBeSharedToASUser(Id tempRecordTypeId) {
        if(tempRecordTypeId == asRetailCampaignRecordTypeId) {
            return true;
        }
        return false;
    }
    
    private Boolean isSegmentationOnly(Id tempRecordTypeId) {
        if(tempRecordTypeId == segmentationOnlyRecordTypeId) {
                return true;
        }
        return false;
    }
    
    private Boolean isAftersalesYearlyTA(Id tempRecordTypeId) {
        if(tempRecordTypeId == aftersalesYearlyTARecordTypeId) {
            return true;
        }
        return false;
    }
    
    private Boolean isMonthlyTA(Id tempRecordTypeId) {
        if(tempRecordTypeId == monthlyTARecordTypeId) {
            return true;
        }
        return false;
    }
*/    
    // Dealer Community AS Marketing User
}