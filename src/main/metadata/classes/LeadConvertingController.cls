/*
    Page Controller
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2014-05-14
*/
public class LeadConvertingController {
    
    private final String retailCampaignId = ApexPages.currentPage().getParameters().get('id');
    private final String leadRTname = ApexPages.currentPage().getParameters().get('rt');
    
    public LeadConvertingController(){
        ral = false;
        rsl = false;

        if(leadRTname == 'AS Retail Campaign') {
            leadRT = 'Aftersales Leads';
            ral = true;
        } else {
            leadRT = 'Retail Sales Leads';
            rsl = true;
        }
        leadRTId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Lead__c' and name = :leadRT].id;
        setRetailCampaignMemberInfos();
    }
    
    public Boolean ral { get; set; }
    public Boolean rsl { get; set; }
    public Id leadRTId { get; set; }
    public String leadRT { get; set; }
    public String contactId { get; set; }
    public String elementId { get; set; }
    public List<RetailCampaignMemberInfo> retailCampaignMemberInfos { get; set; }
    
    private void setRetailCampaignMemberInfos(){
        retailCampaignMemberInfos = new List<RetailCampaignMemberInfo>();
        Id dealerId = [select id,Dealer_Name__c from Retail_Campaign__c where id = :retailCampaignId].Dealer_Name__c;
        Integer i = 0;
        for(Retail_Campaign_Member__c item : [select Name, Contact__c, Contact__r.Name, Contact__r.RecordTypeId, Status__c
            from Retail_Campaign_Member__c where Retail_Campaign__c = :retailCampaignId and Status__c != 'Converted' limit 10000]){
            RetailCampaignMemberInfo retailCampaignMemberInfo = new RetailCampaignMemberInfo(item, leadRTId);
            if(item.Status__c == 'Show up' || item.Status__c == 'Order Placed') {
                retailCampaignMemberInfo.isConverted = true;
            }
            retailCampaignMemberInfo.dealerNameId = dealerId;
            retailCampaignMemberInfo.index = i;
            retailCampaignMemberInfos.add(retailCampaignMemberInfo);
            i++;
        }
    }
    
    
    /**
     * Inner Class
     */
    public class RetailCampaignMemberInfo{
        
        public RetailCampaignMemberInfo(Retail_Campaign_Member__c retailCampaignMember, Id leadRTId){
            this.retailCampaignMember = retailCampaignMember;
            lead = new Lead__c(RecordTypeId = leadRTId);
        }
        
        public Boolean isConverted { get; set; }
        public Retail_Campaign_Member__c retailCampaignMember { get; set; }
        public Lead__c lead { get; set; }
        public Id dealerNameId { get; set; }
        public Id VehicleRelId { get; set; }
        public Integer index { get; set; }
        public String VehicleRelName { get; set; }
    }
    
    public PageReference cancel() {
        return new PageReference('/' + retailCampaignId);
    }
    
    public PageReference converttolead() {
        List<Lead__c> tolead = new List<Lead__c>();
        List<Retail_Campaign_Member__c > retailCampaignMembers = new List<Retail_Campaign_Member__c>();
        Id idDealerAdmin = [select Id from Profile where Name = 'Dealer Community Delegate Admin'].id;
        Map<Id, Id> dealerLeadgateKeeperMap = new Map<Id, Id>();
        Map<Id, Id> dealerAdminMap = new Map<Id, Id>();
        Set<Id> dealerIds = new Set<Id>();
        List<Account> contacts = new List<Account>();
        String personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
        
        for (RetailCampaignMemberInfo rcmi : retailCampaignMemberInfos) {
            if(rcmi.isConverted == true && rcmi.dealerNameId != null) {
                dealerIds.add(rcmi.dealerNameId);
            }
        }
        
        for (User u : [select Id, AccountId from User where AccountId in :dealerIds and isActive = true and Contact.Dealer_Complaint_Gate_Keeper__c = true and Contact.Permission_Set_Settings__c includes ('Leads_Management')]) {
            dealerLeadgateKeeperMap.put(u.AccountId, u.Id);
        }
        
        for (User u : [select Id, AccountId from User where AccountId in :dealerIds and isActive = true and Profile.Name = 'Dealer Community Delegate Admin']) {
            dealerAdminMap.put(u.AccountId, u.Id);
        }
        
        for(RetailCampaignMemberInfo rcmi : retailCampaignMemberInfos) {
            if(rcmi.isConverted == true) {
                
                if(leadRTname == 'AS Retail Campaign') {
                    if((rcmi.lead.Lead_Type__c == '' || rcmi.lead.Lead_Type__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Lead Type'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: sales Lead type'));
                        }
                        return null;
                    }
                    if((rcmi.lead.Lead_Sub_Type__c == '' || rcmi.lead.Lead_Sub_Type__c == null) && (rcmi.lead.Lead_Type__c == 'Product' || rcmi.lead.Lead_Type__c == 'TA&C')) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Lead Sub Type'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: sales leads a subtype'));
                        }
                        return null;
                    }
                    if((rcmi.lead.Lead_Additional_Service__c == '' || rcmi.lead.Lead_Additional_Service__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Lead Additional Service'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: sales leads service'));
                        }
                        return null;
                    }
                    if((rcmi.lead.Collectioner_Notes__c == '' || rcmi.lead.Collectioner_Notes__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Collectioner Notes'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: collectors notes'));
                        }
                        return null;
                    }
                } else if(leadRTname != 'Segmentation Only') {
                    if((rcmi.lead.Lead_Desired_Service__c == '' || rcmi.lead.Lead_Desired_Service__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Lead Desired Service'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: Lead Desired Service'));
                        }
                        return null;
                    }
                    if((rcmi.lead.Retail_Purchase_Time__c == '' || rcmi.lead.Retail_Purchase_Time__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Purchase Time'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: Purchase Time'));
                        }
                        return null;
                    }
                    if((rcmi.lead.Lead_Type__c == '' || rcmi.lead.Lead_Type__c == null)) {
                        if(UserInfo.getLanguage() == 'English') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please fill the mandatory fields first: Lead Type'));
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry, please enter required fields: sales lead type'));
                        }
                        return null;
                    }
                }
                
                rcmi.lead.Assigned_Date_Time__c = date.today();
                if(rcmi.dealerNameId != null) {
                    rcmi.lead.Assigned_Dealer__c = rcmi.dealerNameId;
                    if (dealerLeadgateKeeperMap.get(rcmi.dealerNameId) != null) {
                        rcmi.lead.OwnerId = dealerLeadgateKeeperMap.get(rcmi.dealerNameId);
                    } else if (dealerAdminMap.get(rcmi.dealerNameId) != null) {
                        rcmi.lead.OwnerId = dealerAdminMap.get(rcmi.dealerNameId);
                    }
                }
                
                rcmi.lead.Contact__c = rcmi.retailCampaignMember.Contact__c;
                if(rcmi.retailCampaignMember.Contact__r.RecordTypeId == thirdPartyRTID) {
                    contacts.add(new Account(Id = rcmi.retailCampaignMember.Contact__c, RecordTypeId = personAccountRTId));
                }
                rcmi.lead.CAC_Lead_Status__c = 'New';
                rcmi.lead.Order_Placed_Date__c = date.today();
                rcmi.lead.Retail_Campaign_Name__c = retailCampaignId;
                if(rcmi.retailCampaignMember.Status__c == 'Order Placed') {
                    rcmi.lead.Dealer_Lead_Status__c = 'Order Placed';
                } else {
                    rcmi.lead.Dealer_Lead_Status__c = 'Assigned';
                }
                if(rcmi.VehicleRelId != null) {
                    rcmi.lead.VehicleRel_No__c = rcmi.VehicleRelId;
                }
                rcmi.retailCampaignMember.Status__c = 'Converted';
                retailCampaignMembers.add(rcmi.retailCampaignMember);
                tolead.add(rcmi.lead);
            }
        }
        
        Savepoint sp = Database.setSavepoint();
        try {
            if(tolead.size() > 0) {
                update contacts;
                upsert tolead;
            } else {
                Database.rollback(sp);
                if(UserInfo.getLanguage() == 'English') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No records choosed.'));
                } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Did not select any records.'));
                        }
                return null;
            }
            
            if(retailCampaignMembers.size() > 0) {
                update retailCampaignMembers;
            } else {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Update Retail Campaign Members Error, Please contact administrator.'));
                return null;
            }
        } catch (exception ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(0)));
            return null;
        }
        
        Integer ActualLeads = [select count() from Lead__c where Retail_Campaign_Name__c = :retailCampaignId];
        Retail_Campaign__c campaign = [select Actual_Lead__c from Retail_Campaign__c where Id = :retailCampaignId];
        campaign.Actual_Lead__c = ActualLeads;
        
        try {
            update campaign;
        } catch (exception ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDMLMessage(0)));
            return null;
        }
        return new PageReference('/' + retailCampaignId);
    }
    
    public PageReference vehicleLooking() {
        return null;
    }
}