/**
** Maps a record or crm code to users.
**
** Created By: CC
** Date: 2014-06-11
**/
public with sharing class UserService {
    public UserService() {
    }

    public Map<Id, Set<Id>> mapYearlyRetailCampaign2CampaignDealers(List<Retail_Campaign__c> retailCampaigns, String permissionSetting) {
        List<Id> accountIds = new List<Id>();
        Map<Id, Set<Id>> campaign2Dealers = new Map<Id, Set<Id>>();
        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(String.isNotBlank(retailCampaign.Y_Dealer_Name__c)) {
                if(!campaign2Dealers.containsKey(retailCampaign.Id)) {
                    campaign2Dealers.put(retailCampaign.Id, new Set<Id>{retailCampaign.Y_Dealer_Name__c});
                } else {
                    campaign2Dealers.get(retailCampaign.Id).add(retailCampaign.Y_Dealer_Name__c);
                }
                accountIds.add(retailCampaign.Y_Dealer_Name__c);
            }
        }
        
        Map<Id, Set<Id>> dealer2CampaignUsers = new Map<Id, Set<Id>>();
        for(User user : [select Id, Contact.AccountId, Profile.Name, Contact.Permission_Set_Settings__c from User where IsActive = true and Contact.AccountId in :accountIds and (Profile.Name = 'Dealer Community Delegate Admin' or Contact.Permission_Set_Settings__c includes (:permissionSetting))]) {
            if(!dealer2CampaignUsers.containsKey(user.Contact.AccountId)) {
                dealer2CampaignUsers.put(user.Contact.AccountId, new Set<Id>{user.Id});
            } else {
                dealer2CampaignUsers.get(user.Contact.AccountId).add(user.Id);
            }
        }
        return mapSObjects2Users(campaign2Dealers, dealer2CampaignUsers);
    }

    public Map<Id, Set<Id>> mapRetailCampaign2CampaignDealers(List<Retail_Campaign__c> retailCampaigns, String permissionSetting) {
        system.debug('**-' + retailCampaigns);
        List<Id> accountIds = new List<Id>();
        Map<Id, Set<Id>> campaign2Dealers = new Map<Id, Set<Id>>();
        for(Retail_Campaign__c retailCampaign : retailCampaigns) {
            if(String.isNotBlank(retailCampaign.Dealer_Name__c)) {
                if(!campaign2Dealers.containsKey(retailCampaign.Id)) {
                    campaign2Dealers.put(retailCampaign.Id, new Set<Id>{retailCampaign.Dealer_Name__c});
                } else {
                    campaign2Dealers.get(retailCampaign.Id).add(retailCampaign.Dealer_Name__c);
                }
                accountIds.add(retailCampaign.Dealer_Name__c);
            }
        }
        
        Map<Id, Set<Id>> dealer2CampaignUsers = new Map<Id, Set<Id>>();
        for(User user : [select Id, Contact.AccountId, ProfileId from User where IsActive = true and Contact.AccountId in :accountIds and (Profile.Name = 'Dealer Community Delegate Admin' or Contact.Permission_Set_Settings__c includes (:permissionSetting))]) {
            if(!dealer2CampaignUsers.containsKey(user.Contact.AccountId)) {
                dealer2CampaignUsers.put(user.Contact.AccountId, new Set<Id>{user.Id});
            } else {
                dealer2CampaignUsers.get(user.Contact.AccountId).add(user.Id);
            }
        }
        return mapSObjects2Users(campaign2Dealers, dealer2CampaignUsers);
    }

    public Map<Id, Set<Id>> mapCampaign2DealerCampaignUsers(List<Participating_Dealer__c> dealers, String permissionSetting) {
        List<Id> accountIds = new List<Id>();
        Map<Id, Set<Id>> campaign2Dealers = new Map<Id, Set<Id>>();
        for(Participating_Dealer__c dealer : dealers) {
            if(!campaign2Dealers.containsKey(dealer.Campaign__c)) {
                campaign2Dealers.put(dealer.Campaign__c, new Set<Id>{dealer.Dealer__c});
            } else {
                campaign2Dealers.get(dealer.Campaign__c).add(dealer.Dealer__c);
            }
            accountIds.add(dealer.Dealer__c);
        }
        
        Map<Id, Set<Id>> dealer2CampaignUsers = new Map<Id, Set<Id>>();
        for(User user : [select Id, Contact.AccountId from User where IsActive = true and Contact.AccountId in :accountIds and (Profile.Name = 'Dealer Community Delegate Admin' or Contact.Permission_Set_Settings__c includes (:permissionSetting))]) {
              if(!dealer2CampaignUsers.containsKey(user.Contact.AccountId)) {
                dealer2CampaignUsers.put(user.Contact.AccountId, new Set<Id>{user.Id});
            } else {
                dealer2CampaignUsers.get(user.Contact.AccountId).add(user.Id);
            }
        }
        return mapSObjects2Users(campaign2Dealers, dealer2CampaignUsers);
    }

    /**
    ** Maps a tool kit record to the dealer campaign users to share.
    **/
    public Map<Id, Set<Id>> mapToolKit2CampaignUsers(List<Tool_Kit__c> toolKits, String permissionSetting) {
        Map<Id, Id> toolKit2DealerAccount = new Map<Id, Id>();
        for(Tool_Kit__c toolKit : toolKits){
            toolKit2DealerAccount.put(toolKit.Id, toolKit.Dealer_Name__c);
        }

        Map<Id, Set<Id>> dealer2CampaignUsers = new Map<Id, Set<Id>>();
        for(User user : [select Id, Contact.AccountId from User where IsActive = true and Contact.AccountId in :toolKit2DealerAccount.values() and (Profile.Name = 'Dealer Community Delegate Admin' or Contact.Permission_Set_Settings__c includes (:permissionSetting))]) {
            if(!dealer2CampaignUsers.containsKey(user.Contact.AccountId)) {
                dealer2CampaignUsers.put(user.Contact.AccountId, new Set<Id>{user.Id});
            } else {
                dealer2CampaignUsers.get(user.Contact.AccountId).add(user.Id);
            }
        }

        return mapSObject2Users(toolKit2DealerAccount, dealer2CampaignUsers);
    }
    
    /**
    ** Maps a lead record to the dealer campaign users to share.
    **/
    public Map<Id, Set<Id>> mapLead2CampaignUsers(List<Lead__c> leads, Set<Id> profileIds) {
        Map<Id, Id> lead2DealerAccount = new Map<Id, Id>();
        for(Lead__c lead : leads){
            lead2DealerAccount.put(lead.Id, lead.Assigned_Dealer__c);
        }
        Map<Id, Set<Id>> dealer2CampaignUsers = new Map<Id, Set<Id>>();
        for(User user : [select Id, Contact.AccountId from User where IsActive = true and Contact.AccountId in :lead2DealerAccount.values() 
                        and (ProfileId in :profileIds or Contact.Permission_Set_Settings__c includes ('Complaint_Management')
                        or Contact.Permission_Set_Settings__c includes ('Leads_Management')
                        or Contact.Permission_Set_Settings__c includes ('AS_Retail_Campaign')
                        or Contact.Permission_Set_Settings__c includes ('S_M_Retail_Campaign')
                        )]) {
            if(!dealer2CampaignUsers.containsKey(user.Contact.AccountId)) {
                dealer2CampaignUsers.put(user.Contact.AccountId, new Set<Id>{user.Id});
            } else {
                dealer2CampaignUsers.get(user.Contact.AccountId).add(user.Id);
            }
        }
        return mapSObject2Users(lead2DealerAccount, dealer2CampaignUsers);
    }

    private Map<Id, Set<Id>> mapSObject2Users(Map<Id, Id> sObject2Dealer, Map<Id, Set<Id>> dealer2Users){
        Map<Id, Set<Id>> sObject2Users = new Map<Id, Set<Id>>();
        for(Id objId : sObject2Dealer.keySet()) {
            sObject2Users.put(objId, dealer2Users.get(sObject2Dealer.get(objId)));
        }
        return sObject2Users;
    }

    private Map<Id, Set<Id>> mapSObjects2Users(Map<Id, Set<Id>> sObject2Dealers, Map<Id, Set<Id>> dealer2Users){
        Map<Id, Set<Id>> sObject2Users = new Map<Id, Set<Id>>();
        for(Id objId : sObject2Dealers.keySet()) {
            for(Id dealerId : sObject2Dealers.get(objId)) {
                if(!sObject2Users.containsKey(objId)) {
                    sObject2Users.put(objId, dealer2Users.get(dealerId));
                } else {
                    sObject2Users.get(objId).addAll(dealer2Users.get(dealerId));
                } 
            }
        }
        return sObject2Users;
    }
    
    /**
    ** Maps a retail task record with contract record type to the dealers who has access to both related dealer and related vehicle.
    **/
    public Map<Id, Set<Id>> mapRetailTaskContract2Users(List<Retail_Task__c> contracts){
        Set<Id> dealerIds = new Set<Id>();
        Set<Id> vehicleIds = new Set<Id>();
        for(Retail_Task__c contract : contracts){
            vehicleIds.add(contract.Related_Vehicle__c);
            dealerIds.add(contract.Related_Dealer__c);
        }
        Map<Id, Set<Id>> vehicle2Users = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> dealer2Users = new Map<Id, Set<Id>>();
        for(Vehicle__Share vehicleShare : [select ParentId, UserOrGroupId from Vehicle__Share where ParentId in :vehicleIds]){
            if(!vehicle2Users.containsKey(vehicleShare.ParentId)) {
                vehicle2Users.put(vehicleShare.ParentId, new Set<Id>{vehicleShare.UserOrGroupId});
            } else {
                vehicle2Users.get(vehicleShare.ParentId).add(vehicleShare.UserOrGroupId);
            }
        }
        for(AccountShare dealerShare : [select AccountId, UserOrGroupId from AccountShare where AccountId in :dealerIds]){
            if(!dealer2Users.containsKey(dealerShare.AccountId)) {
                dealer2Users.put(dealerShare.AccountId, new Set<Id>{dealerShare.UserOrGroupId});
            } else {
                dealer2Users.get(dealerShare.AccountId).add(dealerShare.UserOrGroupId);
            }
        }
        Map<Id, Retail_Task__c> map_contracts = new Map<Id, Retail_Task__c>(contracts);
        Map<Id, Set<Id>> contract2Users = new Map<Id, Set<Id>>();
        for(Retail_Task__c contract : contracts){
            if(vehicle2Users.containsKey(contract.Related_Vehicle__c) && dealer2Users.containsKey(contract.Related_Dealer__c)){
                for(Id vehicleUserId : vehicle2Users.get(contract.Related_Vehicle__c)){
                    if(dealer2Users.get(contract.Related_Dealer__c).contains(vehicleUserId)){
                        if(contract2Users.containsKey(contract.Id)){
                            contract2Users.get(contract.Id).add(vehicleUserId);
                        } else {
                            contract2Users.put(contract.Id, new Set<Id>{vehicleUserId});
                        }
                    }
                } 
            }   
        }
        return contract2Users;
    } 

    /**
    ** Maps the crm code of a retail task record to dealers using the crm code.
    **/
    public Map<String, Set<Id>> mapCrmCode2Users(List<Retail_Task__c> retailTasks){
        Set<String> crmCodes = new Set<String>();
        for(Retail_Task__c retailTask : retailTasks) {
            crmCodes.add(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c);
        }
        return mapCrmCode2Users(crmCodes);
    }
    
    /**
    ** Maps the crm code of a vehicle relationship record to dealers using the crm code.
    **/
    public Map<String, Set<Id>> mapCrmCode2Users(List<Vehicle_Relationship__c> vehiclesRelationships){
        Set<String> crmCodes = new Set<String>();
        for(Vehicle_Relationship__c vehiclesRelationship : vehiclesRelationships) {
            crmCodes.add(vehiclesRelationship.Owner_Dealer__r.Dealer_DMS_CRM_Code__c);
        }
        return mapCrmCode2Users(crmCodes);
    }

    /**
    ** Maps the crm code of an account link record to dealers using the crm code.
    **/
    public Map<String, Set<Id>> mapCrmCode2Users(List<Account_Link__c> accountLinks){
        Set<String> crmCodes = new Set<String>();
        for(Account_Link__c accountLink : accountLinks) {                       
            crmCodes.add(AccountLinkHelper.nameParsing(accountLink.Name));
        }
        return mapCrmCode2Users(crmCodes);
    }

    /**
    ** Maps a crm code to dealer users using the crm code.
    **/
    private Map<String, Set<Id>> mapCrmCode2Users(Set<String> crmCodes){
        Map<String, Set<Id>> crmCode2Users = new Map<String, Set<Id>>();
        for(User u: [select Id, Contact.Account.Dealer_DMS_CRM_Code__c from User where IsActive = true and Contact.Account.Dealer_DMS_CRM_Code__c in :crmCodes and Profile.UserLicense.Name != 'Partner Community']) {
            if(crmCode2Users.get(u.Contact.Account.Dealer_DMS_CRM_Code__c) == null) {
                crmCode2Users.put(u.Contact.Account.Dealer_DMS_CRM_Code__c, new Set<Id>{u.Id});
            } else {
                crmCode2Users.get(u.Contact.Account.Dealer_DMS_CRM_Code__c).add(u.Id);
            }
        }
        return crmCode2Users;
    }
}