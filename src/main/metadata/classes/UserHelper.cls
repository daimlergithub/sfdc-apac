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

    private static String read='Read';
    private static String edit='Edit';
    private static String systemAdministrator='System Administrator';
    

    public Static final String ErrorMessageFirstPart = 'You have reached the max no. of license ';
    public Static final String ErrorMessageSecondPart = ', cannot enabled any new contact as dealer portal user';
    public Static final String ErrorMessageGateKeeper = 'The user profile selected does not match with the contact role selected in the contact record.';
    public Static final String ErrorMessageContactSelect = 'Your contact must have to check with one of below: Dealer Lead Gate Keeper, Dealer Complaint Gate Keeper, Dealer Complaint User, Dealer Marketing Manager.';
    
    public Static id DealerComplaintUserId;
    public Static id DealerDelegatedAdminId;
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public Static id CACSSICSRId;
    public Static id CACSSIQCId;
    public Static id CACSSISVId;
    public Static id CACSSITLId;
    public Static id CACSSITRAINERId;
    
    
    /**    
     * @Description : validate No of Dealer Portal Licanses
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : list of new users
     * @return      : returns contactId and boolean flag.
     * @see         : UserTriggerHandler(UserHelper.ValidateUser)
    **/    
    
    public static void ValidateUser(list<user> usersList)
    {
        getPofileId();
        Set<Id> profileIds = new Set<Id>();
         profileIds.add(DealerComplaintUserId);
         profileIds.add(DealerDelegatedAdminId);
         User userObj=usersList[0];
         if(profileIds!=null && !profileIds.IsEmpty())
         {
         if(profileIds.contains(userObj.ProfileId) && userObj.ContactId!=null)
         {
                Contact con = [select Id, AccountId, Account.No_of_Dealer_Portal_Licenses__c, Dealer_Lead_Gate_Keeper__c, Dealer_Complaint_Gate_Keeper__c, Dealer_Complaint_User__c, Dealer_Marketing_Manager__c from Contact where Id = :userObj.ContactId];
                   List<Contact> contacts = [select Id from Contact where Portal_user__c = true and Id != :userObj.ContactId and AccountId = :con.AccountId];
           
                   if(contacts.size() >= con.Account.No_of_Dealer_Portal_Licenses__c) {
                       userObj.addError(ErrorMessageFirstPart + con.Account.No_of_Dealer_Portal_Licenses__c + ErrorMessageSecondPart);
                   }
                   else
                   {
                       //Update portal user of contact to true
                       updateContact(userObj.ContactId, true);
                   }
         }
         }
    }
    
    /**    
     * @Description : Update Contact Portal User when portal user is enabled or disabled
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : contactId and boolean flag
     * @return      : 
     * @see         : ValidateUser
    **/      
    
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
    
    
    /**    
     * @Description : share the data to the new user, used in Apex Trigger UserAfterInsertUpdate.Fetches the existing users.
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : accountId, UserId and ProfileId.
     * @return      : 
     * @see         : AfterInsert_UpdateMethod
    **/   

   
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
    
    /**    
     * @Description : share  all the data to new batch
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : accountId, newuserId.
     * @return      : 
     * @see         : AfterInsert_UpdateMethod
    **/   

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
        //if(!Test.isRunningTest()){
        Database.executeBatch(new ShareDataToNewUserBatch(newUserId,existUserIds,'Vehicle'), batchSize);
        Database.executeBatch(new ShareDataToNewUserBatch(newUserId,existUserIds,'VehicleRelation'), batchSize);
       // }
    }
    
    
    /**    
     * @Description : share the data to the new user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds and profileId.
     * @return      : 
     * @see         : ShareAllDataToNewUser
    **/   

    @future
    public static void ShareAllDataToNewUserFuture(Id newUserId, Set<Id> existUserIds, Id profileId) {
        getPofileId();
        User newUser = [select Id, Contact.Permission_Set_Settings__c from User where Id = :newUserId];

        if(profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('Complaint_Management')) {
            ShareCaseToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('Leads_Management')) {
            ShareLeadsToNewUser(newUserId, existUserIds);
            ShareRetailLeadsToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('Tool_Kit')) {
            ShareToolKitToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('AS_Retail_Campaign') || newUser.Contact.Permission_Set_Settings__c.contains('Segmentation_execution_Retail_Lead')) {
            ShareAsRecordsToNewUser(newUserId, existUserIds);
            ShareAsCampaignToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('AS_Yearly_TA')) {
            ShareAsYearlyTAToNewUser(newUserId, existUserIds);
        }

        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('S_M_Retail_Campaign') || newUser.Contact.Permission_Set_Settings__c.contains('Segmentation_execution_Retail_Lead')) {
            ShareSmRecordsToNewUser(newUserId, existUserIds);
            ShareSmCampaignToNewUser(newUserId, existUserIds);
        }
        
        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('S_M_Yearly_TA')) {
            ShareSmYearlyTAToNewUser(newUserId, existUserIds);
        }
        
        if (profileId == DealerDelegatedAdminId || newUser.Contact.Permission_Set_Settings__c.contains('Best_Practise')) {
            ShareRetailBestPracticeToNewUser(newUserId, existUserIds);
            ShareBestPracticeToNewUser(newUserId, existUserIds);
        }
    }
    
    
    /**    
     * @Description : share all the related Vehicle Records to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : 
    **/   

    public static void ShareVehicleToNewUser(Id newUserId, Set<Id> existUserIds) {      
        List<Vehicle__Share> shares = new List<Vehicle__Share>();
        for(Vehicle__c vehicle : [SELECT id FROM vehicle__c WHERE id in (select ParentId from Vehicle__Share where UserOrGroupId in :existUserIds)]) {
            Vehicle__Share share = new Vehicle__Share();
            share.AccessLevel = read;
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


/**    
     * @Description : Share all the related VehicleRelationship Records to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : 
    **/   

    public static void ShareVehicleRelationToNewUser(Id newUserId, Set<Id> existUserIds) {
       
        List<Vehicle_Relationship__Share> shares = new List<Vehicle_Relationship__Share>();
        for(Vehicle_Relationship__c vehicleRs : [SELECT id FROM vehicle_relationship__c WHERE id in (select ParentId from Vehicle_Relationship__Share where UserOrGroupId in :existUserIds)]) {
            Vehicle_Relationship__Share share = new Vehicle_Relationship__Share();
            share.AccessLevel = read;
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

/**    
     * @Description : Share all the related Account Link Records to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : 
    **/   
    
    public static void ShareAccountLinkToNewUser(Id newUserId, Set<Id> existUserIds) {
        
        List<Account_Link__Share> shares = new List<Account_Link__Share>();
        for(Account_Link__c accountLink : [SELECT id FROM Account_Link__c WHERE id in (SELECT ParentId FROM Account_Link__Share WHERE UserOrGroupId IN :existUserIds)]) {
            Account_Link__Share share = new Account_Link__Share();
            share.AccessLevel = read;
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
    
    /**    
     * @Description : Share all the related Retail Task Records to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : 
    **/   

    public static void ShareRetailTaskToNewUser(Id newUserId, Set<Id> existUserIds) {
        
        List<Retail_Task__Share> shares = new List<Retail_Task__Share>();
        for(Retail_Task__c retailTask : [SELECT id FROM Retail_Task__c WHERE id in (SELECT ParentId FROM Retail_Task__Share WHERE UserOrGroupId IN :existUserIds)]) {
            Retail_Task__Share share = new Retail_Task__Share();
            share.AccessLevel = read;
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
    
    /**    
     * @Description : Share all the related Case records to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   

    public static void ShareCaseToNewUser(Id newUserId, Set<Id> existUserIds) {
       
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
    
    
     /**    
     * @Description : Share all the Sales Leads and Aftersales Leads to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
   
    public static void ShareLeadsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
        
        List<Lead__Share> shares = new List<Lead__Share>();
        for(Lead__c lead : [Select Id from Lead__c Where Id in (select ParentId from Lead__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Lead__Share share = new Lead__Share();
            share.AccessLevel = edit;
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
        
     /**    
     * @Description : Share all the Retail Sales Leads to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
    
    public static void ShareRetailLeadsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId());
        
        List<Lead__Share> shares = new List<Lead__Share>();
        for(Lead__c lead : [Select Id from Lead__c Where Id in (select ParentId from Lead__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Lead__Share share = new Lead__Share();
            share.AccessLevel = edit;
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
    
    
     /**    
     * @Description : Share all the AS Retail Campaigns to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
     
    public static void ShareAsRecordsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share ();
            share.AccessLevel = edit;
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
    
    
     /**    
     * @Description : Share all the Aftersales Yearly TA and Monthly TA to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    public static void ShareAsYearlyTAToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share ();
            share.AccessLevel = edit;
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
    
    
     /**    
     * @Description : Share all the Sales & Marketing Yearly TA and Monthly TA to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
    public static void ShareSmYearlyTAToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = edit;
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
    
     /**    
     * @Description : Share all the S&M Event Retail Campaign and S&M Media Retail Campaign  to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
    public static void ShareSmRecordsToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = edit;
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
    
     /**    
     * @Description : Share all the Retail MB Best Practice and  Retail smart Best Practice to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
    public static void ShareRetailBestPracticeToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail smart Best Practice').getRecordTypeId());
        
        List<Retail_Campaign__Share> shares = new List<Retail_Campaign__Share>();
        for(Retail_Campaign__c record : [Select Id from Retail_Campaign__c Where Id in (select ParentId from Retail_Campaign__Share where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            Retail_Campaign__Share share = new Retail_Campaign__Share();
            share.AccessLevel = edit;
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
    
    /**    
     * @Description : Share all the RAS Central Campaigns to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/   
    
    public static void ShareAsCampaignToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId());
        
        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = read;
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
    
     /**    
     * @Description : Share all the S&M Event Central Campaigns and S&M Media Central Campaigns to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/  
    public static void ShareSmCampaignToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media Central Campaign').getRecordTypeId());
        
        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = read;
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
    
     /**    
     * @Description : Share all the MB Best Practices and smart Best Practices to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/ 
    public static void ShareBestPracticeToNewUser(Id newUserId, Set<Id> existUserIds) {
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId());
        recordTypes.add(Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId());

        List<CampaignShare> shares = new List<CampaignShare>();
        for(Campaign cpn : [Select Id from Campaign Where Id in (select CampaignId from CampaignShare where UserOrGroupId in :existUserIds) And RecordTypeId In :recordTypes]) {
            CampaignShare share = new CampaignShare();
            share.CampaignAccessLevel = read;
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
    
     /**    
     * @Description : Share  the ToolLit  to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId, existUserIds 
     * @return      : 
     * @see         : ShareAllDataToNewUserFuture
    **/ 
    public static void ShareToolKitToNewUser(Id newUserId, Set<Id> existUserIds) {
        List<Tool_Kit__Share> shares = new List<Tool_Kit__Share>();
        for(Tool_Kit__c tk : [Select Id from Tool_Kit__c Where Id in (select ParentId from Tool_Kit__Share where UserOrGroupId in :existUserIds)]) {
            Tool_Kit__Share share = new Tool_Kit__Share();
            share.AccessLevel  = edit;
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
    
     /**    
     * @Description : AssignPermissionSet  to new Dealer Portal user
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : newUserId
     * @return      : 
     * @see         : AfterInsert_UpdateMethod
    **/ 

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
    
    /**    
     * @Description : when the user inserts share the account, vehicle and vehicle relation to the user and verifies whether the user is a portal user or not.
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : new user list, old user map, and trigger boolean perameters isInsert,isUpdate.
     * @return      : 
     * @see         : UserTriggerHandler
    **/ 
    
    public static void AfterInsert_UpdateMethod(list<User> usersList,map<id,User> userOldMap,boolean isInsert,boolean isUpdate)
    {
        getPofileId();  
        Set<Id> profileIds = new Set<Id>();
        if(DealerComplaintUserId!=null)
        profileIds.add(DealerComplaintUserId);
        if(DealerDelegatedAdminId!=null) 
        profileIds.add(DealerDelegatedAdminId);
     
         Set<Id> SSIprofileIds = new Set<Id>();
         
         if(CACSSIQCId!=null)
         SSIprofileIds.add(CACSSIQCId);
         if(CACSSISVId!=null)   
         SSIprofileIds.add(CACSSISVId);
         if(CACSSITLId!=null)   
         SSIprofileIds.add(CACSSITLId);
         if(CACSSITRAINERId!=null)   
         SSIprofileIds.add(CACSSITRAINERId);
         if(CACSSICSRId!=null)  
         SSIprofileIds.add(CACSSICSRId); 

         if(isUpdate) {
             // if update user is a portal user
             if(profileIds.contains(usersList[0].ProfileId) && !usersList[0].IsPortalEnabled && userOldMap.get(usersList[0].Id).IsPortalEnabled) {
                 updateContact(usersList[0].ContactId, false);
             }
         }
     
         // [Start] Added by Cyril on 2014-05-08 (Release1.1b)
         if(isInsert) {
             if(profileIds.contains(usersList[0].ProfileId)) {
                 //when the user insert, share the account, vehicle and vehicle relation to the user
                 ShareAllDataToNewUserBatch(usersList[0].AccountId, usersList[0].Id);
             }
         }
         // [End] Added by Cyril on 2014-05-08 (Release1.1b)
     
         // By Shuang Li BRD-AS-CAC-007---- strart
         if(isUpdate) {
             Set<Id> userIds = new Set<Id>();
             Set<Id> userPermissionSetIds = new Set<Id>();
             for(User userNew : usersList) {
                 if(CACSSICSRId!=null && CACSSICSRId == userOldMap.get(userNew.Id).ProfileId && userNew.ProfileId != userOldMap.get(userNew.Id).ProfileId && SSIprofileIds!=null && !SSIprofileIds.contains(userNew.ProfileId)) {
                     userIds.add(userNew.Id);
                 }
                 if(userNew.Active_Permission_Set__c && userNew.Active_Permission_Set__c != userOldMap.get(userNew.Id).Active_Permission_Set__c) {
                     userPermissionSetIds.add(userNew.Id);
                 }
             }
             TaskHelper.autoUpdateSSITask(userIds);
     
             if(userPermissionSetIds!=null && !userPermissionSetIds.IsEmpty()) {
                 AssignPermissionSetForPortalUser(userPermissionSetIds);
                 ShareAllDataToNewUser(usersList[0].AccountId, usersList[0].Id, usersList[0].ProfileId);
             }
         }
    }
    
    /**    
     * @Description : gets all the profile ids by the profile names
     * @author      : Sinow Zhang 
     * @Date        : 23-April-2013
     * @param       : 
     * @return      : all the profile ids
     * @see         : ValidateUser,AfterInsert_UpdateMethod,ShareAllDataToNewUserFuture
    **/ 
    
    public static void getPofileId()
    {
        set<string> profleNames= new set<string>();
        profleNames.add(systemAdministrator);
        profleNames.add(systemAdministrator);
        profleNames.add('CAC SSI CSR');
        profleNames.add('CAC SSI QC');
        profleNames.add('CAC SSI SV');
        profleNames.add('CAC SSI TL');
        profleNames.add('CAC SSI Trainer');
        List<Profile> lstProfiles=[select id, name from Profile where name in:profleNames];
        if(lstProfiles!=null && !lstProfiles.IsEmpty())
        {
            for(Profile obj:lstProfiles)
            {
                if(obj.name==systemAdministrator)
                    DealerComplaintUserId=obj.Id;
                if(obj.name==systemAdministrator)
                    DealerDelegatedAdminId=obj.Id;
                if(obj.name=='CAC SSI CSR')
                    CACSSICSRId=obj.Id;
                if(obj.name=='CAC SSI QC')
                    CACSSIQCId=obj.Id;
                if(obj.name=='CAC SSI SV')
                    CACSSISVId=obj.Id;
                if(obj.name=='CAC SSI TL')
                    CACSSITLId=obj.Id;
                if(obj.name=='CAC SSI Trainer')
                    CACSSITRAINERId=obj.Id;
            }
        }
    }
    public static void createGroup(List<User> newUserList)
    {
    system.debug('#$#$#$#$#$#$#$#$# newUserList'+newUserList);
        set<id> userid = new set<id>();
        set<id> newuserid = new set<id>();
        set<string> dealername = new set<string>();
        List<Group> listgp=new List<Group>();
        List<Group> insertlistgp=new List<Group>();
         List<GroupMember> listGroupMember =new List<GroupMember>();  
         
        for(User pu:newUserList)
        {
        system.debug('#$#$#$#$ ContactId newUserList'+pu.ContactId);
          
            if(pu.ContactId !=null )
            {
                userid.add(pu.id);
            }
        }
        system.debug('#$#$#$#$ ContactId ne'+userid);
        List<User> users=[Select Id,Name,contactId,Contact.AccountId,Contact.Account.Name,Profile.userlicense.name from user where Id =:userid];
       system.debug('#$#$#$#$ users usersne'+users);
        for(User u:users)
        {
        system.debug(' Contact.AccountId ContactId newUserList'+u.Contact.AccountId);
    system.debug(' Contact.u.Profile.userlicense.name st'+u.Profile.userlicense.name);
            if(u.Profile.userlicense.name == 'Partner Community' && u.Contact.AccountId != null)
            {
                dealername.add(u.Contact.Account.Name);
            }
        }
        listgp=[select id,Name ,Developername from group where Name =:dealername];
        if(listgp.size()>0 && listgp!=null)
        {
            for(User Us:users)
            {
                for(Group gp:listgp)
                {
                    if(Us.Contact.Account.Name == gp.Name)
                    {
                        GroupMember gm= new GroupMember(); 
                        gm.GroupId=gp.id;
                        gm.UserOrGroupId = Us.id;
                        listGroupMember.add(gm);
                    }
                }
            }       
            
            insert listGroupMember;
        }
        else if(listgp.size()==0 )
        {
            for(User u : users)
            {
                Group g  = new group();
                if(dealername.contains(u.Contact.Account.Name))
                {
                    newuserid.add(u.Id);
                    g.name=u.Contact.Account.Name;
                    insertlistgp.add(g);
                }
            }
            insert insertlistgp;
            
             userhelper.addGroupmembers(insertlistgp,newuserid);
        }
         
    }
    public static void addGroupmembers(List<Group> listGroup,Set<Id> UsersID)
    {
        List<GroupMember> listGroupMember =new List<GroupMember>();
        List<User> partUserList = new List<User>();
            partUserList=[Select id from User where id=:UsersID];
        for(Group g:listGroup)
        {
            for(User u:partUserList)
            {
              GroupMember gm= new GroupMember(); 
              gm.GroupId=g.id;
              gm.UserOrGroupId = U.id;
              listGroupMember.add(gm); 
            }    
        }
        insert listGroupMember;
    }
    public Static void ApexShare(List<User> usrList){   
        system.debug('usrList '+usrList);
        Set<Id> userIds = new Set<Id>();
        Set<Id> ProfileIds = new Set<Id>();
        for(User u : usrList){
            ProfileIds.add(u.ProfileId);
        }
        Map<Id,Profile> profileMaps = new Map<Id,Profile>([Select id,Name from Profile where Id In : ProfileIds]);
        for(User u : usrList){
            Profile p = profileMaps.get(u.ProfileId);
            if(P != NULL && P.Name.Contains('Dealer')){
                userIds.add(u.id);
            }
        }
       
       Map<Id,User> userMap=new  Map<Id,User>([select Id,Name,Contact.AccountId from user where Id In : userIds]);
        set<Id> dealerAccountIds = new set<Id>();
        if(userMap.size() > 0){
            for(User u : userMap.Values()){
                dealerAccountIds.add(u.Contact.AccountId);
                userIds.add(u.id);
            }      
            UtilShare.DealerGroupCreation(dealerAccountIds,userIds); 
        } 
    }

     
    public Static void UserShareforDealers(List<User> usrList, map<id,User> UserOldMap, boolean isInsert, boolean isUpdate)
    {       
        // inserting new records
        Set<String> DealerGccode = new Set<String>();
        List<Account> DealeAcc=new List<Account>();  
        map<string,id> assgroupMap = new map<string,id>();
        list<string>assignlist=new list<string>();
        list<String> AccountNAme = new List<String>();
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
            List<User> userList = new List<User>();
            Set<Id> userAcc = new Set<Id>();
            Set<Id> usrConId = new Set<Id>();
            List<UserShare> shares = new List<UserShare>();
            for(User u : usrList)
            {
                if(u.ContactId != Null)
                {
                    System.debug('u.ContactId>>>>>'+u.ContactId);
                    usrConId.add(u.ContactId);
                }
            }
            if(!usrConId.isEmpty() && usrConId!= null)
            {
                userList = [select id,contactId,contact.accountId,Contact.Account.Dealer_GC_Code__c,Contact.Account.name from user where contactId IN:usrConId];
            }
            if(!userList.isEmpty() && userList != null)
            {
                System.debug('userList>>>>> '+userList);
                for(User ur : userList)
                {
                    if(ur.Contact.AccountId != null)
                    {
                        System.debug('ur.Contact.AccountId>>>>>>>'+ur.Contact.AccountId);
                        userAcc.add(ur.Contact.AccountId);
                        DealerGccode.add(ur.Contact.Account.Dealer_GC_Code__c);
                        System.debug('uconaccdcode>>>>>'+ur.Contact.Account.Dealer_GC_Code__c);
                        assignlist.add(ur.Contact.Account.name);
                    }
                }
                
            }
            
            DealeAcc=[Select id,name,Dealer_GC_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and Dealer_GC_Code__c =:DealerGccode];
            
            for(Account dealerac:DealeAcc)
            {
                userAcc.add(dealerac.ID);
                AccountNAme.add(dealerac.name);
            }
            list<Group>grplist=new list<Group>([select id ,Name ,Type from Group where Name IN:assignlist OR Name IN: AccountNAme]);
            for(Group assg:grplist)
            {
                system.debug('grplist>>>>>>>>'+grplist);
                assgroupMap.put(assg.Name, assg.id);
                system.debug('assg.Name'+assg.Name);
                
            }
            
            string inVar='Dealer';
            string tempInput = '%' + inVar + '%';
            Map<Id,User> userMap = new  Map<Id,User>([select Id,Name,Contact.AccountId,Profile.name from user where Contact.AccountId In : userAcc AND Profile.name like  : tempInput ]);        
            if(userMap.size() > 0){
                
                System.debug('userMap.Values()>>>>>>'+userMap.Values());
                for (User u : userList)
                {
                    for(User ur : userMap.Values())
                    {
                        for(id m:assgroupMap.values())
                        {
                            UserShare userShr = new UserShare();
                            userShr.UserId = u.id;
                            userShr.UserOrGroupId = m;
                            if(ur.Profile.name == 'Japan Dealer Company Manager' || ur.Profile.name == 'Japan Dealer Sales Manager' || ur.Profile.name == 'Japan Dealer Service Manager'){
                                
                                userShr.UserAccessLevel = 'Read';
                            }
                            else if(ur.Profile.name == 'Japan Dealer Sales Representative' || ur.Profile.name == 'Japan Dealer Service Advisor' ){
                                userShr.UserAccessLevel = 'Read';
                            }
                            shares.add(userShr);
                        }
                    }
                }   
            }
            // do the DML to create shares
            if (!shares.isEmpty() && shares != null)
            {
                String JSONStr = JSON.serialize(shares);
               //System.debug('Serialized list of invoices into JSON format: ' + JSONStr);
                usershare(JSONStr);
            }
        }                   
        else 
        {    
            List<UserShare> sharesToCreate = new List<UserShare>();
            List<ID> shareIdsToDelete = new List<ID>();
            List<ID> shareIdsToCreate = new List<ID>(); 
            set<Id> usersToDelete = new set<Id>();
            for (User Led : usrList) {
                User oldlead = UserOldMap.get(Led.id);                  
                if (Led.Contact.AccountId != Null && Led.Contact.AccountId != oldlead.Contact.AccountId) {
                    System.debug('Led.Contact.AccountId>>>>>>>>>'+Led.Contact.AccountId);
                    shareIdsToDelete.add(oldlead.Contact.AccountId);  
                    shareIdsToCreate.add(Led.Contact.AccountId);  
                }
            }
            string inVar='Dealer';
            string tempInput = '%' + inVar + '%';
            Map<Id,User> userMapUpdate = new  Map<Id,User>([select Id,Name,Contact.AccountId,Profile.name from user where Contact.AccountId In : shareIdsToCreate AND Profile.name like  : tempInput]);  
            List<User> TobeDeleted = new List<User>([select Id,Name,Contact.AccountId,Profile.name from user where Contact.AccountId In : shareIdsToDelete AND Profile.name like  : tempInput]);
            for(User ur : TobeDeleted){
                usersToDelete.add(ur.Id);
            }
            if(userMapUpdate.size() > 0){
                for (User u : usrList){
                    for(User ur : userMapUpdate.Values()){
                        UserShare userShr = new UserShare();
                        userShr.UserId = u.id;
                        userShr.UserOrGroupId = ur.id;
                        if(ur.Profile.name == 'Japan Dealer Company Manager' || ur.Profile.name == 'Japan Dealer Sales Manager' || ur.Profile.name == 'Japan Dealer Service Manager'){
                            userShr.UserAccessLevel = 'Read';
                        }
                        else if(ur.Profile.name == 'Japan Dealer Sales Representative' || ur.Profile.name == 'Japan Dealer Service Advisor' ){
                            userShr.UserAccessLevel = 'Read';
                        }
                        sharesToCreate.add(userShr);
                    }
                }   
            }
            if(!sharesToCreate.isEmpty() && sharesToCreate != null)
            {
                System.debug('upd>>>>');
                String JSONString = JSON.serialize(sharesToCreate);
                System.debug('Serialized list of invoices into JSON format: ' + JSONString);
                usershare(JSONString);
            }
            /*do the DML to delete shares
            if (!TobeDeleted.isEmpty())
                delete [select id from UserShare where UserOrGroupId IN :usersToDelete];
            // do the DML to create shares
            if (!sharesToCreate.isEmpty())
                insert sharesToCreate;*/
        }
    }
    @future
    public static void usershare(string str)
    {
        List<UserShare> usershareList = new List<UserShare>();
        usershareList = (List<UserShare>)JSON.deserialize(str, List<UserShare>.class);
        insert usershareList;
    }

    
    public static void grpCreationandUsergrpAlign(List<User> usrInList){
        List<Id> usrIds = new List<Id>();
        for(user usr: usrInList){
            usrIds.add(usr.id);
        }
        List<user> usrLst = new List<user>([select id, name, contact.Accountid, contact.Account.Dealer_ND_Code__c from user where IsPortalEnabled  = true and Market__c = 'KR' and isActive = true and contact.Account.Dealer_ND_Code__c != null and contact.Account.RecordType.Name = 'Dealer' and id in:usrIds]);

        Map<Id, set<Id>> accUsrmap = new map<id, set<Id>>();
        Map<string, set<user>> accDealerNdCodeUsrmap = new map<string, set<user>>();
        Map<string, id> accDealerNdCodeandAccMap = new map<string,id>();
        Map<Id, Account> accIdAccMap = new map<Id,Account>();
        List<Group> groupInsrtLst = new List<Group>();
        
        if(usrLst.size()>0){
            for(user usr: usrLst){          
                accDealerNdCodeandAccMap.put(usr.contact.Account.Dealer_ND_Code__c,usr.contact.Accountid);
                accIdAccMap.put(usr.contact.Accountid, usr.contact.Account);
                
                if(!accUsrmap.containsKey(usr.contact.Accountid)){
                    accUsrmap.put(usr.contact.Accountid, new set<Id>());
                }
                    accUsrmap.get(usr.contact.Accountid).add(usr.id);
                    
                if(!accDealerNdCodeUsrmap.containsKey(usr.contact.Account.Dealer_ND_Code__c)){
                    accDealerNdCodeUsrmap.put(usr.contact.Account.Dealer_ND_Code__c, new set<user>());
                }
                    accDealerNdCodeUsrmap.get(usr.contact.Account.Dealer_ND_Code__c).add(usr);
            }
            
            
            //This is the groups that was already created for that account
            List<Group> existingGroupandMemberLst = new List<Group>([select id, name,(select id, userorGroupId from GroupMembers) from group where name in: accDealerNdCodeUsrmap.keySet()]);
            Map<string, set<Id>> grpNameandGrpUserorGrpId = new map<string, set<Id>>();
            Map<string, group> grpNameandGrpMap = new map<string,group>();
            
            for(Group grp: existingGroupandMemberLst){
                grpNameandGrpMap.put(grp.Name, grp);
                grpNameandGrpUserorGrpId.put(grp.Name, new set<Id>());
                List<GroupMember> grpMemtemp = grp.GroupMembers;
                if(grpMemtemp.size()>0){
                    for(GroupMember grm: grp.GroupMembers){
                        grpNameandGrpUserorGrpId.get(grp.Name).add(grm.userorGroupId);
                    }
                }
            }
            
            List<Id> accWithNoGrps = new List<Id>();
            List<Id> accWithGrps = new List<Id>();
            for(string str: accDealerNdCodeUsrmap.keySet()){
                if(!grpNameandGrpMap.containsKey(str)){
                    accWithNoGrps.add(accDealerNdCodeandAccMap.get(str));
                }else{
                    accWithGrps.add(accDealerNdCodeandAccMap.get(str));
                }
            }
            
            
            List<string> newInsertedGroupNames = new List<string>();
            if(accWithNoGrps.size()>0){
                for(string aid: accWithNoGrps){
                    Account accMakingGrps = accIdAccMap.get(aid);
                    Group grp = new Group();
                    grp.Name = accMakingGrps.Dealer_ND_Code__c;
                    groupInsrtLst.add(grp);
                    newInsertedGroupNames.add(accMakingGrps.Dealer_ND_Code__c);
                }
                
                if(groupInsrtLst.size()>0){
                    insert groupInsrtLst;
                }
                
                List<Group> grpForGrpMem = new List<Group>([select id, name from Group where name in: newInsertedGroupNames]);
                List<GroupMember> grmInsrtLst = new List<GroupMember>();
                for(Group grp:grpForGrpMem){
                    set <User> usrTemp = accDealerNdCodeUsrmap.get(grp.Name);
                    if(usrTemp.size()>0){
                        for(user usr : usrTemp){
                            GroupMember grm = new GroupMember();
                            grm.GroupId = grp.id;
                            grm.userorGroupId = usr.Id;
                            grmInsrtLst.add(grm);
                        }
                    }
                }
                
                if(grmInsrtLst.size()>0){
                    insert grmInsrtLst;
                }
                
            }
            List<GroupMember> missingGrpMembers = new List<GroupMember>();
            if(accWithGrps.size()>0){
                for(string str: accWithGrps){
                    set<Id> usrTempLst = accUsrmap.get(str);
                    set<Id> usrTempLstGrp = grpNameandGrpUserorGrpId.get(accIdAccMap.get(str).Dealer_ND_Code__c);
                    usrTempLst.removeAll(usrTempLstGrp);
                    for(string id: usrTempLst){
                        GroupMember grm = new GroupMember();
                        grm.GroupId = grpNameandGrpMap.get(accIdAccMap.get(str).Dealer_ND_Code__c).id;
                        grm.userorGroupId = Id;
                        missingGrpMembers.add(grm);
                    }
                }
                
                if(missingGrpMembers.size()>0){
                    insert missingGrpMembers;
                }
                
            }
        }
    }

}