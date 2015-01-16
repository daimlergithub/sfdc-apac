/**
    Type:       Utility for UserBeforeInsertUpdate    
    Purpose:    1. Update Contact Portal user to True
                2. If 'Dealer Lead Gate Keeper' is checked, the profile selected must be 'Dealer-Lead Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin' 
                   If 'Dealer Complaint Gate Keeper' is checked, the profile selected must be 'Dealer-Complaint Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin'
    User Story: US-DP-007, US-DP-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    23-April-2013 Sinow Zhang (NTTData)  Created
    08-May-2014   Cyril Huang (NttData)  Modified
    06-11-2014    zhongyang.si(NttData)  Modified
*/
public with sharing class UserHelper {
    public Static final String ErrorMessageFirstPart = 'You have reached the max no. of license ';
    public Static final String ErrorMessageSecondPart = ', cannot enabled any new contact as dealer portal user';
    public Static final String ErrorMessageGateKeeper = 'The user profile selected does not match with the contact role selected in the contact record.';
    public Static final String ErrorMessageContactSelect = 'Your contact must have to check with one of below: Dealer Lead Gate Keeper, Dealer Complaint Gate Keeper, Dealer Complaint User, Dealer Marketing Manager.';
    
    public Static Profile DealerComplaintUser = [select Id from Profile where Name = 'Dealer Community User'];
    public Static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Community Delegate Admin'];
    
    //validate No of Dealer Portal Licanses
    public static void ValidateUser(User newUser) {
        Contact con = [select Id, AccountId, Account.No_of_Dealer_Portal_Licenses__c, Dealer_Lead_Gate_Keeper__c, Dealer_Complaint_Gate_Keeper__c, Dealer_Complaint_User__c, Dealer_Marketing_Manager__c from Contact where Id = :newUser.ContactId];
        List<Contact> contacts = [select Id from Contact where Portal_user__c = true and Id != :newUser.ContactId and AccountId = :con.AccountId];

        if(contacts.size() >= con.Account.No_of_Dealer_Portal_Licenses__c) {
            newUser.addError(ErrorMessageFirstPart + con.Account.No_of_Dealer_Portal_Licenses__c + ErrorMessageSecondPart);
        }
        else {
            //if(!con.Dealer_Lead_Gate_Keeper__c && !con.Dealer_Complaint_Gate_Keeper__c && !con.Dealer_Complaint_User__c && !con.Dealer_Marketing_Manager__c) {
                //newUser.addError(ErrorMessageContactSelect);
            //}
            //Update portal user of contact to true
            updateContact(newUser.ContactId, true);
        }
    }
    
    //Update Contact Portal User when portal user is enabled or disabled
    @future
    public static void updateContact(Id contactId, boolean flag) {
        List<Contact> cons =  [select Id, Portal_user__c from Contact where Id = :contactId];
        if(cons.size() > 0) {
            cons[0].Portal_user__c = flag;
            try {
                update cons[0];
            }
            catch(Exception ex) {
                system.debug(ex);
            }
        }
    }

    // share the data to the new user, used in Apex Trigger UserAfterInsertUpdate
    public static void ShareAllDataToNewUser(Id accountId, Id newUserId, Id profileId) {
        // Fetch the existing users
        Set<Id> existUserIds = new Set<Id>();
        for(User existUser : [select Id from User where AccountId = :accountId and isActive = true]) {
            existUserIds.add(existUser.Id);
        }

        if (existUserIds.size() == 0) {
            return;
        }
        ShareAllDataToNewUserFuture(newUserId, existUserIds, profileId);
        //ShareAllDataToNewUserBatch(newUserId, existUserIds);
    }

    public static void ShareAllDataToNewUserBatch(Id accountId, ID newUserId) {
        // Fetch the existing users
        Set<Id> existUserIds = new Set<Id>();
        for(User existUser : [select Id from User where AccountId = :accountId and isActive = true]) {
            existUserIds.add(existUser.Id);
        }

        if (existUserIds.size() == 0) {
            return;
        }

        Integer batchSize = 2000;
        Database.executeBatch(new ShareDataToNewUserBatch(newUserId,existUserIds,'Account'), batchSize);
        Database.executeBatch(new ShareDataToNewUserBatch(newUserId,existUserIds,'Vehicle'), batchSize);
        Database.executeBatch(new ShareDataToNewUserBatch(newUserId,existUserIds,'VehicleRelation'), batchSize);
    }

    @future
    public static void ShareAllDataToNewUserFuture(Id newUserId, Set<Id> existUserIds, Id profileId) {
        //ShareVehicleToNewUser(newUserId, existUserIds);

        //ShareVehicleRelationToNewUser(newUserId, existUserIds);

        User newUser = [select Id, Contact.Permission_Set_Settings__c from User where Id = :newUserId];

        if(profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('Complaint_Management')) {
            ShareCaseToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('Leads_Management')) {
            ShareLeadsToNewUser(newUserId, existUserIds);
            ShareRetailLeadsToNewUser(newUserId, existUserIds);
        }

        //if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('Complaint_Management') || newUser.Contact.Permission_Set_Settings__c.contains('Leads_Management')){
            //ShareAccountLinkToNewUser(newUserId, existUserIds);
            //ShareRetailTaskToNewUser(newUserId, existUserIds);
        //}

        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('Tool_Kit')) {
            ShareToolKitToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('AS_Retail_Campaign') || newUser.Contact.Permission_Set_Settings__c.contains('Segmentation_execution_Retail_Lead')) {
            ShareAsRecordsToNewUser(newUserId, existUserIds);
            ShareAsCampaignToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('AS_Yearly_TA')) {
            ShareAsYearlyTAToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('S_M_Retail_Campaign') || newUser.Contact.Permission_Set_Settings__c.contains('Segmentation_execution_Retail_Lead')) {
            ShareSmRecordsToNewUser(newUserId, existUserIds);
            ShareSmCampaignToNewUser(newUserId, existUserIds);
        }
        
        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('S_M_Yearly_TA')) {
            ShareSmYearlyTAToNewUser(newUserId, existUserIds);
        }
        
        if (profileId == DealerDelegatedAdmin.Id || newUser.Contact.Permission_Set_Settings__c.contains('Best_Practise')) {
            ShareRetailBestPracticeToNewUser(newUserId, existUserIds);
            ShareBestPracticeToNewUser(newUserId, existUserIds);
        }
    }

    public static void ShareVehicleToNewUser(Id newUserId, Set<Id> existUserIds) {
        // Share all the related Vehicle Records to new Dealer Portal user
        List<Vehicle__Share> shares = new List<Vehicle__Share>();
        for(Vehicle__c vehicle : [SELECT id FROM vehicle__c WHERE id in (select ParentId from Vehicle__Share where UserOrGroupId in :existUserIds)]) {
            Vehicle__Share share = new Vehicle__Share();
            share.AccessLevel = 'Read';
            share.ParentID = vehicle.Id;
            //share.RowCause = Schema.Vehicle__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }     
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Vehicles to new Dealer user: ' + e);
        }
    }

    public static void ShareVehicleRelationToNewUser(Id newUserId, Set<Id> existUserIds) {
        // Share all the related VehicleRelationship Records to new Dealer Portal user
        List<Vehicle_Relationship__Share> shares = new List<Vehicle_Relationship__Share>();
        for(Vehicle_Relationship__c vehicleRs : [SELECT id FROM vehicle_relationship__c WHERE id in (select ParentId from Vehicle_Relationship__Share where UserOrGroupId in :existUserIds)]) {
            Vehicle_Relationship__Share share = new Vehicle_Relationship__Share();
            share.AccessLevel = 'Read';
            share.ParentID = vehicleRs.Id;
            //share.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing VehicleRelationShips to new Dealer user: ' + e.getDMLMessage(0));
        }
    }

    public static void ShareAccountLinkToNewUser(Id newUserId, Set<Id> existUserIds) {
        // Share all the related Account Link Records to new Dealer Portal user
        List<Account_Link__Share> shares = new List<Account_Link__Share>();
        for(Account_Link__c accountLink : [SELECT id FROM Account_Link__c WHERE id in (SELECT ParentId FROM Account_Link__Share WHERE UserOrGroupId IN :existUserIds)]) {
            Account_Link__Share share = new Account_Link__Share();
            share.AccessLevel = 'Read';
            share.ParentID = accountLink.Id;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }

        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Account Link to new Dealer user: ' + e.getDMLMessage(0));
        }
    }

    public static void ShareRetailTaskToNewUser(Id newUserId, Set<Id> existUserIds) {
        // Share all the related Retail Task Records to new Dealer Portal user
        List<Retail_Task__Share> shares = new List<Retail_Task__Share>();
        for(Retail_Task__c retailTask : [SELECT id FROM Retail_Task__c WHERE id in (SELECT ParentId FROM Retail_Task__Share WHERE UserOrGroupId IN :existUserIds)]) {
            Retail_Task__Share share = new Retail_Task__Share();
            share.AccessLevel = 'Read';
            share.ParentID = retailTask.Id;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }

        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Retail Task to new Dealer user: ' + e.getDMLMessage(0));
        }
    }

    public static void ShareCaseToNewUser(Id newUserId, Set<Id> existUserIds) {
        // Share all the related Case records to new Dealer Portal user
        Set<Id> caseIds = new Set<Id>();
        List<caseTeamMember> caseTeamMembers = new List<caseTeamMember>();
        Id teamRoleId = [select Id from CaseTeamRole where Name = 'Dealer' limit 1].id;
        for(Case cas : [select Id from Case where OwnerId in :existUserIds]) {
            caseIds.add(cas.Id);
        }
        for(caseTeamMember cas : [select ParentId from caseTeamMember where MemberId in :existUserIds]) {
            caseIds.add(cas.ParentId);
        }
        for (Id id : caseIds) {
            caseTeamMember share = new caseTeamMember();
            share.ParentID = id;
            share.MemberId = newUserId;
            share.TeamRoleId = teamRoleId;
            caseTeamMembers.add(share);
        }
        
        try {
            DataBase.insert(caseTeamMembers, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Cases to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
   
    public static void ShareLeadsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
        
        List<Lead__Share> shares = new List<Lead__Share>();
        for(Lead__c lead : [Select Id from Lead__c Where Id in (select ParentId from Lead__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Lead__Share share = new Lead__Share();
            share.AccessLevel = 'Edit';
            share.ParentID = lead.Id;
            //share.RowCause = Schema.Lead__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Leads to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
        
    public static void ShareRetailLeadsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId());
        
        List<Lead__Share> shares = new List<Lead__Share>();
        for(Lead__c lead : [Select Id from Lead__c Where Id in (select ParentId from Lead__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Lead__Share share = new Lead__Share();
            share.AccessLevel = 'Edit';
            share.ParentID = lead.Id;
            //share.RowCause = Schema.Lead__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Retail Sale Leads to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
     
    public static void ShareAsRecordsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share ();
            share.AccessLevel = 'Edit';
            share.ParentID = record.Id;
            //share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing AS Records to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareAsYearlyTAToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share ();
            share.AccessLevel = 'Edit';
            share.ParentID = record.Id;
            //share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing AS Records to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareSmYearlyTAToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = 'Edit';
            share.ParentID = record.Id;
            //share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing S&M Records to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareSmRecordsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = 'Edit';
            share.ParentID = record.Id;
            //share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing S&M Records to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareRetailBestPracticeToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail smart Best Practice').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = 'Edit';
            share.ParentID = record.Id;
            //share.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing S&M Records to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareAsCampaignToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS BMBS Campaign').getRecordTypeId());
        
        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = 'Read';
            share.CampaignId = cpn.Id;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing AS Campaigns to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareSmCampaignToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event BMBS Campaign').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media BMBS Campaign').getRecordTypeId());
        
        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = 'Read';
            share.CampaignId = cpn.Id;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing S&M Campaigns to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareBestPracticeToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId());

        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = 'Read';
            share.CampaignId = cpn.Id;
            share.UserOrGroupId = newUserId;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing S&M Campaigns to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
    
    public static void ShareToolKitToNewUser(Id newUserId, Set<Id> existUserIds) {
        List<Tool_Kit__Share> shares = new List<Tool_Kit__Share>();
        for(Tool_Kit__c tk : [Select Id from Tool_Kit__c Where Id in (select ParentId from Tool_Kit__Share where UserOrGroupId in :existUserIds)]) {
            Tool_Kit__Share share = new Tool_Kit__Share();
            share.AccessLevel  = 'Edit';
            share.ParentId = tk.Id;
            share.UserOrGroupId = newUserId;
            //share.RowCause = Schema.Tool_Kit__Share.RowCause.Manual;
            shares.add(share);
        }
        
        try {
            DataBase.insert(shares, false);
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Tool Kits to new Dealer user: ' + e.getDMLMessage(0));
        }
    }
 
    public static void AssignPermissionSetForPortalUser(Set<Id> userIds) {
        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
        Map<String, Id> permissionSetNameIdMap = new Map<String, Id>();
        
        for(PermissionSet ps : [SELECT Id, Name FROM PermissionSet WHERE label like 'Dealer%']) {
            permissionSetNameIdMap.put(ps.Name, ps.Id);
        }
        
        for(User u : [SELECT Id, ContactId, contact.Permission_Set_Settings__c
                       FROM  User WHERE Id in :userIds]) {
            for(String permissionSetName : permissionSetNameIdMap.keySet()){
                if (u.contact.Permission_Set_Settings__c != null && u.contact.Permission_Set_Settings__c.contains(permissionSetName)) {
                    permissionSetAssignments.add(new PermissionSetAssignment(PermissionSetId = permissionSetNameIdMap.get(permissionSetName), AssigneeId = u.Id));
                }
            }
        }
        
        try{
            delete [select Id from PermissionSetAssignment where AssigneeId in :userIds and  permissionSet.label like 'Dealer%'];
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when deleting the permission set: ' + e.getDMLMessage(0));
        }
         
        List<User> users = [select Id, Active_Permission_Set__c from User where Id in :userIds];
        for(User u : users) {
            u.Active_Permission_Set__c = false;
        }
        
        try{
            update users;
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when updating the user information: ' + e.getDMLMessage(0));
        }
    
        try {
            if(permissionSetAssignments.size() > 0) {
                insert permissionSetAssignments;
            }
        }catch (DMLException e) {
            System.debug('DMLException Exception occured when inserting the new permission set: ' + e.getDMLMessage(0));
        }
    }
}