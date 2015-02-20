/*
    Type:       Utility for QCAfterUpdate, CaseBeforeUpdate, CaseBeforeInsert
    Purpose:    1. Update case information.
                2. Auto track field history when Case record be changed.
                3. After add sub Complaint,the "Repeat Complaint Times" field of Parent Complaint plus 1
                4. If the Complaint is a promary complaint, sent a SMS to Customer.
    User Story: US-CC-002, US-CC-003, US-CC-004,US-CC-015, US-CC-023
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-05-17
    2. Chaos Edit on 2014-2-21  AS-Complaint_002(2014Release1.1)
*/
public class CaseHelper{
    // MB complaint tracking fields
    public static final List<String> COLS_MB_TRACKING = new List<String>{'Case_Type__c', 
                                        'Case_SubType__c',
                                        'Case_Dealer__c',
                                        'Subject', 
                                        'Vehicle_Relationship__c', 
                                        'Vehicle_Brand__c', 
                                        'Vehicle_Class__c', 
                                        'Vehicle_Model__c',
                                        'VIN_Code__c', 
                                        'Vehicle_Source__c', 
                                        'Dealer_Contact__c',
                                        'Dealer_Case_Type__c',
                                        'Dealer_Case_SubType__c',
                                        'Case_RepeatCause__c', 
                                        'Repeat_Complaint_Times__c', 
                                        'Final__c', 
                                        'Results_Response__c', 
                                        'Description',
                                        'OwnerId',
                                        'Case_Department__c',
                                        'Follow_Up_Inquiry__c', 
                                        'Complaint_Date__c', 
                                        'Case_Involvement_MPC__c', 
                                        'Case_Source__c', 
                                        'ParentId', 
                                        'AccountId', 
                                        'Region__c', 
                                        'Handling_Level__c', 
                                        'Data_Source__c',
                                        'Data_Subsource__c', 
                                        'Case_Status__c', 
                                        'Progress_Status__c', 
                                        'Escalate_Date_to_RO__c', 
                                        'Escalate_Date_to_CO__c', 
                                        'Suspended_Date__c', 
                                        'Suspended_Reason__c', 
                                        'Overdue__c', 
                                        'Overdue_Reason__c', 
                                        'X1st_FP_Position_Release_Date__c', 
                                        'X2nd_FP_Position_Release_Date__c', 
                                        'SFPositionDate__c', 
                                        'FFPositionDate__c', 
                                        'Release_Date__c', 
                                        'Resolved_Date__c', 
                                        'Contact_Person__c', 
                                        'Perferred_Contact_Number__c', 
                                        'Contact_Person_Tele__c', 
                                        'Perferred_Contact_Email__c', 
                                        'Customer_Background_Info__c', 
                                        'Government_Background__c', 
                                        'Car_Owner__c', 
                                        'Gender__c', 
                                        'Occupation__c', 
                                        'Title__c', 
                                        'Owner_Tele__c', 
                                        'Date_of_Birth__c', 
                                        'Address__c', 
                                        'Licence_Number__c', 
                                        'Other_Brand__c', 
                                        'Owned_MB_Vehicle__c', 
                                        'Vehicle_In_Workshop__c', 
                                        'Dealer_Provides_Transport__c', 
                                        'Customer_Requests_Transport__c', 
                                        'Selling_Dealer__c', 
                                        'Order_No__c', 
                                        'Last_Known_Sales_Person__c', 
                                        'Date_of_Warranty_Expiry__c', 
                                        'Last_Known_Mileage__c', 
                                        'Date_of_1st_Registration__c', 
                                        'US_VIN__c', 
                                        'EU_VIN__c', 
                                        'Defective_Item__c', 
                                        'Defective_SubItem__c', 
                                        'Car_Type__c', 
                                        'Engine_Number__c', 
                                        'Special_Goodwill__c', 
                                        'Goodwill_Category__c', 
                                        'Goodwill_Details__c', 
                                        'Goodwill_Cost__c',
                                        'Ref_No_Central__c',
                                        'Ref_No_Regional__c',
                                        'Dealer_Case_Category__c',
                                        'Dealer_Feedback__c'
                                        };

    // Chrysler complaint tracking fields   
    public static final List<String> COLS_CHRYSLER_TRACKING = new List<String>{
                                        'Case_Type__c', 
                                        'Case_SubType__c',
                                        'Case_Dealer__c',
                                        'Subject', 
                                        'Vehicle_Relationship__c', 
                                        'Vehicle_Brand__c', 
                                        'Vehicle_Class__c', 
                                        'Vehicle_Model__c',
                                        'Dealer_Case_Type__c',
                                        'Dealer_Case_SubType__c',
                                        'VIN_Code__c',  
                                        'Vehicle_Source__c', 
                                        'Dealer_Contact__c', 
                                        'Case_RepeatCause__c',  
                                        'Repeat_Complaint_Times__c', 
                                        'Results_Response__c', 
                                        'Problem1__c', 
                                        'Problem2__c', 
                                        'Problem3__c', 
                                        'Problem4__c', 
                                        'Service_Station__c', 
                                        'Final__c', 
                                        'Result__c', 
                                        'Description',
                                        'OwnerId',
                                        'Case_Department__c'
                                        };
    
    // MB complaint record type id
    public static Id C_MB_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    
    // Chrysler complaint record type id
    public static Id C_CHRYSLER_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    
    // Chrysler complaint record type id
    public static Id C_MBDA_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MBDA Complaint').getRecordTypeId();
    
    // Retail Campaign record type id
    public static Id RETAIL_CAMPAIGN_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Retail Campaign').getRecordTypeId();
    
    /**
     *  Inquiry record type id
     */    
    public static Id C_INQUIRY_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    
    // MB complaint record type id
    //public static EmailTemplate E_MAIL_TEMP = [select id,body from EmailTemplate where Name='Change Complaint Assignment To Dealer GateKeeper Notification'];                                  
    
    // BMBS Onsite Complaint Manager Profile
 //   public static Id P_BMBS_ONSITE_CM_ID = [select Id from Profile where Name = 'BMBS Onsite Complaint Manager' limit 1].id;                                
    
    // error message
    //public static final String ERR_MSG_HAVEPARENT = 'This Vehicle has a same Complaint, please add it as parent case';
    
    // SMS content
    public static final String SMS_MSG_1 = '感谢您的来电，您所反馈的情况梅赛德斯-奔驰客户服务热线已经收悉，相关负责人员将会进一步调查情况，尽快与您取得联系。【梅赛德斯-奔驰客服中心4008181188】';
   
    // Complaint is not a primary complaint reminder
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
   
    // FILED OBJECT MAP
    public static Map<String, Schema.SObjectField> FLDOBJ_MAP = schema.SObjectType.Case.fields.getMap();
    
    public static CaseTeamRole DealerRole = [select Id from CaseTeamRole where Name = 'Dealer' limit 1];
    public static CaseTeamRole CRMManagerRole = [select Id from CaseTeamRole where Name = 'CRM Manager' limit 1];
    public static Profile CURRENT_PROFILE = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
    public static List<User> REGIONAL_CRM_MGR_USERS = [select Id, UserRole.Name from User where UserRole.Name like 'Regional CRM Mgr%' and isActive = true];
    public static List<QueueSobject> CENTRAL_REGIONAL_CASE_QUEUES = [select Id, QueueId from QueueSobject where SobjectType = 'Case' and (Queue.Name like 'Central Office%' or Queue.Name like 'Regional Office%')];
    public static List<QueueSobject> BMBS_CENTRAL_CASE_QUEUES = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'Case' and Queue.Name like '%BMBS Central Office%'];
        
    public static void insertSobjects(List<Sobject> sos) {
        try {
            insert sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }

    public static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }
    
    public static void deleteSobjects(List<Sobject> sos) {
        try {
            delete sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }

    // set infomations about Vehicle
    public static Case setVehicleInfo(Case c, Vehicle_Relationship__c vr){
        
        If(vr.Vehicle_Brand__c != null && vr.Vehicle_Brand__c != '') {
            c.Vehicle_Brand__c = vr.Vehicle_Brand__c;
        }
        if(vr.Vehicle_Class__c != null && vr.Vehicle_Class__c != '') {
            c.Vehicle_Class__c = vr.Vehicle_Class__c;
        }
        if(vr.Vehicle_Model__c != null && vr.Vehicle_Model__c != '') {
            c.Vehicle_Model__c = vr.Vehicle_Model__c;
        }
        if(vr.Vehicle_ID__r.UsVIN__c != null && vr.Vehicle_ID__r.UsVIN__c != '') {
            c.VIN_Code__c = vr.Vehicle_ID__r.UsVIN__c;
        }
        c.Vehicle__c = vr.Vehicle_ID__c;
        If(vr.Vehicle_ID__r.UsVIN__c != null && vr.Vehicle_ID__r.UsVIN__c != '') {
            c.US_VIN__c = vr.Vehicle_ID__r.UsVIN__c;
        }
        if(vr.Vehicle_ID__r.EuroVIN__c != null && vr.Vehicle_ID__r.EuroVIN__c != '') {
            c.EU_VIN__c = vr.Vehicle_ID__r.EuroVIN__c;
        }
        if(vr.Vehicle_ID__r.Latest_Sales_Person__c != null && vr.Vehicle_ID__r.Latest_Sales_Person__c != '') {
            c.Last_Known_Sales_Person__c = vr.Vehicle_ID__r.Latest_Sales_Person__c;
        }
        if(vr.Vehicle_ID__r.Warranty_Start_Date__c != null) {
            c.Date_of_Warranty_Expiry__c = vr.Vehicle_ID__r.Warranty_Start_Date__c;
        }
        if(vr.Vehicle_ID__r.FirstRegistrationDate__c != null) {
            c.Date_of_1st_Registration__c = vr.Vehicle_ID__r.FirstRegistrationDate__c;
        }
        if(vr.Registration_Number__c != null && vr.Registration_Number__c != '') {
            c.Registration_Number__c = vr.Registration_Number__c;
        }
        return c;
    }
    
   // Creates new complaint Description for US-DPCR-004
    public static Complaint_Description__c newCaseDescription(Id caseId, String label, String newValue, String oldValue) {
        Complaint_Description__c cd = new Complaint_Description__c();
        cd.Case__c = caseId;
        cd.Created_By__c = UserInfo.getUserId();
        cd.Date_Time__c = System.now();
        cd.Action__c = 'Changed ' + label + ' from ' + oldValue + ' to ' + newValue;
        return cd;
    }
    
    // Creates new complaint historys for US-CC-002,US-CC-003.
    public static Complaint_Tracking__c newCaseHistory(Id caseId, String label, String newValue, String oldValue) {
        Complaint_Tracking__c ct = new Complaint_Tracking__c();
        ct.Case__c = caseId;
        ct.User__c = UserInfo.getUserId();
        ct.Action__c = 'Changed ' + label + ' from ' + oldValue + ' to ' + newValue;
        return ct;
    }
   
    // share Case For US-CC-023    
    public static void shareCase(Map<Id, Id> casesToShare, Map<String, String> vehicleToOwner) {
        List<CaseShare> shareCases = new List<CaseShare>();
        Map<Id, List<Id>> accountIdUserIds = new Map<Id, List<Id>>();
        Map<Id, Set<Id>> caseIdExistUserIds = new Map<Id, Set<Id>>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        
        for(User cus: [select id, AccountId from User 
                        where isActive=true 
                        and AccountId in :casesToShare.values() 
                        and (Profile.Name = 'Dealer Community Delegate Admin' 
                        or Contact.Permission_Set_Settings__c includes ('Complaint_Management'))]) {
            if(!accountIdUserIds.containsKey(cus.AccountId)) {
                accountIdUserIds.put(cus.AccountId, new List<Id>());
            }
            accountIdUserIds.get(cus.AccountId).add(cus.Id);
        }
        
        for(caseTeamMember cs : [select ParentId, MemberId from caseTeamMember where ParentId in :casesToShare.keySet()]) {
            if(!caseIdExistUserIds.containsKey(cs.ParentId)) {
                caseIdExistUserIds.put(cs.ParentId, new Set<Id>());
            }
            caseIdExistUserIds.get(cs.ParentId).add(cs.MemberId);
        }
        
        for(Id caseId : casesToShare.keySet()) {
            if(accountIdUserIds.containsKey(casesToShare.get(caseId))) {
                for(Id userId : accountIdUserIds.get(casesToShare.get(caseId))) {
                    if((caseIdExistUserIds.containsKey(caseId) && !caseIdExistUserIds.get(caseId).contains(userId)) || !caseIdExistUserIds.containsKey(caseId)) {
                        caseTeamMembers.add(new caseTeamMember(ParentId = caseId, MemberId = userId, TeamRoleId = DealerRole.Id));
                    }
                }
            }
        }
        
        if(caseTeamMembers.size() > 0) {
            insertSobjects(caseTeamMembers);
        }
        
        shareCaseVehicleToDealer(vehicleToOwner);
    }
    
    // ADD START AS-Complaint_002 CHAOS 2014/2/21
    public static void shareCaseWithoutshareVehicle(Map<id,Set<Id>> casesToShare) {
        List<CaseShare> shareCases = new List<CaseShare>();
        List<Id> allAccountIds = new List<Id>();
        Map<Id, List<Id>> accountIdUserIds = new Map<Id, List<Id>>();
        Map<Id, Set<Id>> caseIdExistUserIds = new Map<Id, Set<Id>>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        
        for(Id caseid : casesToShare.keySet()){
            allAccountIds.addAll(casesToShare.get(caseid));
        }
        
        for(User cus: [select id, AccountId from User 
                        where isActive=true 
                        and AccountId in :allAccountIds 
                        and (Profile.Name = 'Dealer Community Delegate Admin' 
                        or Contact.Permission_Set_Settings__c includes ('Complaint_Management'))]) {
            if(!accountIdUserIds.containsKey(cus.AccountId)) {
                accountIdUserIds.put(cus.AccountId, new List<Id>());
            }
            accountIdUserIds.get(cus.AccountId).add(cus.Id);
        }
        
        for(caseTeamMember cs : [select ParentId, MemberId from caseTeamMember where ParentId in :casesToShare.keySet()]) {
            if(!caseIdExistUserIds.containsKey(cs.ParentId)) {
                caseIdExistUserIds.put(cs.ParentId, new Set<Id>());
            }
            caseIdExistUserIds.get(cs.ParentId).add(cs.MemberId);
        }
        
        for(Id caseId : casesToShare.keySet()) {
            for (Id accountId : allAccountIds) {
                if(accountIdUserIds.containsKey(accountId)) {
                    for(Id userId : accountIdUserIds.get(accountId)) {
                        if((caseIdExistUserIds.containsKey(caseId) && !caseIdExistUserIds.get(caseId).contains(userId)) || !caseIdExistUserIds.containsKey(caseId)) {
                            caseTeamMembers.add(new caseTeamMember(ParentId = caseId, MemberId = userId, TeamRoleId = DealerRole.Id));
                        }
                    }
                }
            }
        }
        
        if(caseTeamMembers.size() > 0) {
            insertSobjects(caseTeamMembers);
        }
    }
    
    public static void deleteShareFromCase(Map<id,Set<Id>> casesToDeleteShare) {
        List<CaseShare> shareCases = new List<CaseShare>();
        Map<Id, List<Id>> accountIdUserIds = new Map<Id, List<Id>>();
        List<Id> allAccountIds = new List<Id>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        List<Case> cases = new List<Case>();
        
        for(Id caseid : casesToDeleteShare.keySet()){
            allAccountIds.addAll(casesToDeleteShare.get(caseid));
        }
        
        List<User> usrList = [select id, AccountId from User 
                                where isActive=true 
                                and AccountId in :allAccountIds 
                                and (Profile.Name = 'Dealer Community Delegate Admin' 
                        or Contact.Permission_Set_Settings__c includes ('Complaint_Management'))];
        
        for(CaseTeamMember ctm: [select id, ParentId from CaseTeamMember where MemberId in :usrList]){
            for(Id caseId : casesToDeleteShare.keySet()) {
                 if(ctm.ParentId == caseId){
                    caseTeamMembers.add(ctm);
                 }
            }
        }

        if(caseTeamMembers.size() > 0) {
            deleteSobjects(caseTeamMembers);
        }
    }
    
    public static Map<id,String> getComplaintGateKeeperEmail(Set<id> dealerAccounts){
        Map<id,String> accountAndKeeperEmail = new Map<id,String>(); 
        if (dealerAccounts.size() > 0) {
            for(User u : [select Id,AccountId, Email, ContactId from User 
                          where isActive = true and ContactId in 
                            (select Id from Contact where AccountId in :dealerAccounts 
                                                          and Dealer_Complaint_Gate_Keeper__c = true)]){
                if(!accountAndKeeperEmail.containsKey(u.AccountId)) {
                    accountAndKeeperEmail.put(u.AccountId, u.Email);
                }
            }
        }
        return accountAndKeeperEmail;
    }
    // ADD END AS-Complaint_002 CHAOS 2014/2/21
    
    // The complaint Case Owner will be auto changed to the Dealer's Complaint Gate keeper
    public static Map<id,User> getGateKeepers(List<Case> ids){
        Map<id,User> caseIdUser = new Map<id,User>(); 
        Set<id> dealerAccounts = new Set<id>();
        Map<id,List<User>> accountAndUser = new Map<id,List<User>>();
        Map<Id, Id> customerGateKeepers = new Map<Id, Id>();
        
        for(Case c : ids){
            if(c.Case_Dealer__c != null){
                dealerAccounts.add(c.Case_Dealer__c);
            }
        }
        
        for(User u : [select Id,AccountId, Email, ContactId from User 
                    where  isActive = true and ContactId in (select Id from Contact where AccountId in :dealerAccounts and Dealer_Complaint_Gate_Keeper__c = true)]){
            if(!accountAndUser.containsKey(u.AccountId)) {
                accountAndUser.put(u.AccountId, new List<User>());
            }
            accountAndUser.get(u.AccountId).add(u);
        }

        for(Case c : ids){
            if(null != accountAndUser.get(c.Case_Dealer__c)){
                User u = accountAndUser.get(c.Case_Dealer__c)[0];
                if(c.OwnerId != u.id){
                    caseIdUser.put(c.id, u);
                    if(null != c.AccountId){
                        customerGateKeepers.put(c.AccountId, u.Id);
                    }
                }
            }
        }

        if(customerGateKeepers.size() > 0) {
            shareCustomerToGateKeeper(customerGateKeepers);
        }
        shareCaseToRO(ids);
        
        return caseIdUser;
    }
   
    public static void shareCustomerToGateKeeper(Map<Id, Id> customerGateKeepers) {
        List<AccountShare> accShares = new List<AccountShare>();
        Map<Id, Set<Id>> accountIdExistUserIds = new Map<Id, Set<Id>>();

        for(AccountShare accShare : [select AccountId, UserOrGroupId from AccountShare where id in :customerGateKeepers.keyset()]) {
            if(!accountIdExistUserIds.containsKey(accShare.AccountId)) {
                accountIdExistUserIds.put(accShare.AccountId, new Set<Id>());
            }
            accountIdExistUserIds.get(accShare.AccountId).add(accShare.UserOrGroupId);
        }
        
        for(Id accId : customerGateKeepers.keyset()) {
            If(!accountIdExistUserIds.containsKey(accId) || (accountIdExistUserIds.containsKey(accId) && !accountIdExistUserIds.get(accId).contains(customerGateKeepers.get(accId)))) {
                accShares.add(new AccountShare(AccountId = accId, OpportunityAccessLevel = 'None', CaseAccessLevel = 'None', AccountAccessLevel = 'Read', UserOrGroupId = customerGateKeepers.get(accId)));
            }
        }
        
        if(accShares.size() > 0) {
            try {
                insert accShares;
            }
            catch(Exception ex) {
                System.debug('Exception message is :' + ex.getMessage());
            }
        }
    }
    
    public static void createSmsTasks(Set<Id> caseIds, Set<Id> accIds) {
        List<Task> SMSTasks = new List<Task>();
        Map<Id, Id> accountIdContactIds = new Map<Id, Id>();
        Task smsTask;
        
        for(Contact con : [select Id, AccountId from Contact where AccountId in :accIds]) {
            accountIdContactIds.put(con.AccountId, con.Id);
        }
        
        for(Case c : [select Id, AccountId, Account.PersonMobilePhone, Account.SMSOptOut__pc from Case where Id in :caseIds and Account.PersonMobilePhone != null])
        {
            if(c.Account.SMSOptOut__pc){
                continue;
            }
            smsTask = new Task();
            smsTask.Subject = 'SMS';
            smsTask.Status = 'Closed';
            smsTask.Activity_Status__c = 'Sent';
            smsTask.RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
            smsTask.WhatId = c.Id;
            if(accountIdContactIds.containsKey(c.AccountId)) {
                smsTask.WhoId = accountIdContactIds.get(c.AccountId);
            }
            smsTask.SMS_Content__c = SMS_MSG_1;
            smsTask.Phone__c = c.Account.PersonMobilePhone;
            SMSTasks.add(smsTask);
        }
        
        if(SMSTasks.size() > 0) {
            insertSobjects(SMSTasks);
        }
    }
    
    // creat a case description For US-CC-024
    public static void creatCaseDescription (List<case> casesForDescription) {
        List<Complaint_Description__c> CaseDescrptions = new List<Complaint_Description__c>();
        
        for(case c : casesForDescription) {
            CaseDescrptions.add(new Complaint_Description__c(Case__c = c.id, Created_By__c = c.CreatedbyId, Description__c = c.Description, Date_Time__c = system.now(), Action__c = 'Created'));
        }      
        if(CaseDescrptions.size() > 0) {
            insertSobjects(CaseDescrptions);
        }
    }
    
    public static void shareDealer(Map<Id, Id> casesForShare) {
        List<CaseShare> cs = new List<CaseShare>();
        Map<Id, Id> DealeridCaseid = new Map<Id, Id>();
        Map<Id, Id> UseridCaseid = new Map<Id, Id>();
        
        for(Case c : [select id, Case_Dealer__c from Case where id in :casesForShare.keyset()]) {
            DealeridCaseid.put(c.Case_Dealer__c, casesForShare.get(c.id));
        }
        
        for(Account a : [select id, OwnerId from Account where id in :DealeridCaseid.keyset()]) {
            UseridCaseid.put(a.OwnerId, DealeridCaseid.get(a.id));
        }
        
        for(Id i : UseridCaseid.keyset()) {
            cs.add(new CaseShare(CaseId = UseridCaseid.get(i), UserOrGroupId = i));
        }
        
        if(cs.size() > 0) {
            insertSobjects(cs);
        }
    }
    
    // Share Case to RO when a case escalate from RO to CO For US-CC-019    
    public static void shareCaseToRO(Map<Id, Id> casesToShare) {
        List<CaseShare> shareCases = new List<CaseShare>();
        Map<Id, Set<Id>> caseIdExistUserIds = new Map<Id, Set<Id>>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        
        for(caseTeamMember cs : [select ParentId, MemberId from caseTeamMember where ParentId in :casesToShare.keySet()]) {
            if(!caseIdExistUserIds.containsKey(cs.ParentId)) {
                caseIdExistUserIds.put(cs.ParentId, new Set<Id>());
            }
            caseIdExistUserIds.get(cs.ParentId).add(cs.MemberId);
        }
        
        for(Id caseId : casesToShare.keySet()) {
            if((caseIdExistUserIds.containsKey(caseId) && !caseIdExistUserIds.get(caseId).contains(casesToShare.get(caseId))) || !caseIdExistUserIds.containsKey(caseId)) {
                 caseTeamMembers.add(new caseTeamMember(ParentId = caseId, MemberId = casesToShare.get(caseId), TeamRoleId = CRMManagerRole.Id));
            }
        }
        
        if(caseTeamMembers.size() > 0) {
            insertSobjects(caseTeamMembers);
        }
    }
    
    //share to Ro when getGateKeeper
    public static void shareCaseToRO(List<Case> ids){
        Set<String> caseIdExistUserIds = new Set<String>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
    //    Set<String> shareIds = new Set<String>();
        Set<Id> shareCaseIds = new Set<Id>();

        Map<String,List<User>> regionalUsers = new Map<String,List<User>>();
        //regionalUsers.put('EAST',[select Id from User where UserRole.Name = 'Regional CRM Mgr (W)' and isActive = true]);
        //regionalUsers.put('SOUTH',[select Id from User where UserRole.Name = 'Regional CRM Mgr (S)' and isActive = true]);
        //regionalUsers.put('WEST',[select Id from User where UserRole.Name = 'Regional CRM Mgr (E)' and isActive = true]);
        //regionalUsers.put('NORTH',[select Id from User where UserRole.Name = 'Regional CRM Mgr (N)' and isActive = true]);
        for(User user : REGIONAL_CRM_MGR_USERS) {
            if(user.UserRole.Name == 'Regional CRM Mgr (E)') {
                if(!regionalUsers.containsKey('EAST')) {
                    regionalUsers.put('EAST', new List<User>());
                }
                regionalUsers.get('EAST').add(user);
            }
            if(user.UserRole.Name == 'Regional CRM Mgr (S)') {
                if(!regionalUsers.containsKey('SOUTH')) {
                    regionalUsers.put('SOUTH', new List<User>());
                }
                regionalUsers.get('SOUTH').add(user);
            }
            if(user.UserRole.Name == 'Regional CRM Mgr (W)') {
                if(!regionalUsers.containsKey('WEST')) {
                    regionalUsers.put('WEST', new List<User>());
                }
                regionalUsers.get('WEST').add(user);
            }
            if(user.UserRole.Name == 'Regional CRM Mgr (N)') {
                if(!regionalUsers.containsKey('NORTH')) {
                    regionalUsers.put('NORTH', new List<User>());
                }
                regionalUsers.get('NORTH').add(user);
            }
        }
        
        Set<Id> shareCaseIdsForOnSite = new Set<Id>();
        
        for(case c : ids){
            if(c.Share_to_Regional_Office__c){
                shareCaseIds.add(c.id);
            }
            shareCaseIdsForOnSite.add(c.Id);
        }
        
     /*   for(case c : [select id , Case_Dealer__r.Dealer_Region__c, Previous_Owner__c, Previous_Owner__r.ProfileId from case where id in :shareCaseIds]){
            if(!String.isblank(c.Case_Dealer__r.Dealer_Region__c)){
                for(User curId : regionalUsers.get(c.Case_Dealer__r.Dealer_Region__c)){
                    shareIds.add(c.id + '__' + curId.id);
                }
            }
        } */
        
     /*   for(case c : [select id , Case_Dealer__r.Dealer_Region__c, Previous_Owner__c, Previous_Owner__r.ProfileId from case where id in :shareCaseIdsForOnSite]){
            if(c.Previous_Owner__r.ProfileId == P_BMBS_ONSITE_CM_ID) {
                shareIds.add(c.id + '__' + c.Previous_Owner__c);
            }
        } */
        
        for(caseTeamMember cs : [select ParentId, MemberId from caseTeamMember where (ParentId in :shareCaseIds or ParentId in :shareCaseIdsForOnSite) and TeamRoleId = :CRMManagerRole.Id]) {
            caseIdExistUserIds.add(cs.ParentId + '__' + cs.MemberId);
        }
        
     /*   for(String flexid : shareIds){
            if(!caseIdExistUserIds.contains(flexid)){
                caseTeamMembers.add(new caseTeamMember(ParentId = flexid.split('__')[0], MemberId = flexid.split('__')[1], TeamRoleId = CRMManagerRole.Id));
            }
        } */

        if(caseTeamMembers.size() > 0) {
            insertSobjects(caseTeamMembers);
        }
    }

    public static void populateCarOwnerValuesToCase(Set<String> carOwnerIds, List<Case> cases){
        Map<String, Account> carOwners = new Map<String, Account>([select Id, PersonBirthdate, Gender__c, Occupation__c, Phone,
                                                                    Primary_Address__c, Province__c, City_CN__c, ZipCode__c
                                                                    from Account where Id in :carOwnerIds]);
        for(Case newcase : cases){
            Account carOwner = carOwners.get(newcase.Car_Owner__c);
            if(newcase.Date_of_Birth__c == null){
                newcase.Date_of_Birth__c = carOwner.PersonBirthdate;
            }
            if(String.isBlank(newcase.Gender__c)){
                newcase.Gender__c = carOwner.Gender__c;
            }
            if(String.isBlank(newcase.Occupation__c)){
                newcase.Occupation__c = carOwner.Occupation__c;
            }
            if(String.isBlank(newcase.Owner_Tele__c)){
                newcase.Owner_Tele__c = carOwner.Phone;
            }
            if(String.isBlank(newcase.Address__c)){
                String state = carOwner.Province__c == null ? '' : carOwner.Province__c;
                String city = carOwner.City_CN__c == null ? '' : carOwner.City_CN__c;
                String street = carOwner.Primary_Address__c == null ? '' : carOwner.Primary_Address__c;
                String zip = carOwner.ZipCode__c == null ? '' : carOwner.ZipCode__c;
                newcase.Address__c = state + '\n' + city + '\n' + street + '\n' + zip;
            }
        }
    }
    
    public static void updateVehicleRelatedFields(List<Case> cases, List<Id> vehicleIds)
    {
        Map<Id, Vehicle__c> vehiclesMap = New Map<Id, Vehicle__c>([select Id, EuroVIN__c, UsVIN__c, Warranty_Start_Date__c,
                                                                          EngineNumber__c, Latest_Sales_Person__c, CBU_CKD__c,
                                                                          Brand__c, Class__c, Model__c, CurrentMileage__c,
                                                                          FirstRegistrationDate__c from Vehicle__c where Id in :vehicleIds]);
        
        for(Case c : cases)
        {
            if(vehiclesMap.containsKey(c.Vehicle__c))
             {
                 if(c.EU_VIN__c == null || c.EU_VIN__c == '') { 
                     c.EU_VIN__c = vehiclesMap.get(c.Vehicle__c).EuroVIN__c;   
                 }   
                 if(c.US_VIN__c == null || c.US_VIN__c == '') { 
                     c.US_VIN__c = vehiclesMap.get(c.Vehicle__c).UsVIN__c;   
                 }
                 if(c.Date_of_Warranty_Expiry__c == null) { 
                     c.Date_of_Warranty_Expiry__c = vehiclesMap.get(c.Vehicle__c).Warranty_Start_Date__c;   
                 }
                 if(c.Engine_Number__c == null || c.Engine_Number__c == '') { 
                     c.Engine_Number__c = vehiclesMap.get(c.Vehicle__c).EngineNumber__c;   
                 }
                 if(c.Last_Known_Sales_Person__c == null || c.Last_Known_Sales_Person__c == '') { 
                     c.Last_Known_Sales_Person__c = vehiclesMap.get(c.Vehicle__c).Latest_Sales_Person__c;   
                 }
                 if(c.Car_Type__c == null || c.Car_Type__c == '') {
                     c.Car_Type__c = vehiclesMap.get(c.Vehicle__c).CBU_CKD__c;
                     If(vehiclesMap.get(c.Vehicle__c).CBU_CKD__c == 'CKD') {
                         c.Car_Type__c = 'PbP';
                     }
                 }
                 if(c.Vehicle_Brand__c == null || c.Vehicle_Brand__c == '') {
                     c.Vehicle_Brand__c = vehiclesMap.get(c.Vehicle__c).Brand__c;   
                 }
                 if(c.Vehicle_Class__c == null || c.Vehicle_Class__c == '') { 
                     c.Vehicle_Class__c = vehiclesMap.get(c.Vehicle__c).Class__c;   
                 }
                 if(c.Vehicle_Model__c == null || c.Vehicle_Model__c == '') { 
                     c.Vehicle_Model__c = vehiclesMap.get(c.Vehicle__c).Model__c;   
                 }
                 if(c.Last_Known_Mileage__c == null) { 
                     c.Last_Known_Mileage__c = vehiclesMap.get(c.Vehicle__c).CurrentMileage__c;   
                 }
                 if(c.Date_of_1st_Registration__c == null) { 
                     c.Date_of_1st_Registration__c = vehiclesMap.get(c.Vehicle__c).FirstRegistrationDate__c;   
                 }  
             }
        }
    }
    
    /**
     * Shares the vehicle in case to a dealer user after the case owner is changed to the dealer user.
     * By Justin Yu
     */
    private static void shareCaseVehicleToDealer(Map<String, String> vehicleToOwner){
        if(!vehicleToOwner.isEmpty()){
            Set<String> existentSharings = getExistentSharings(vehicleToOwner);
            List<Vehicle__Share> vehicleSharings = new List<Vehicle__Share>();
            
            for(String vehicleId : vehicleToOwner.keySet()){
                String dealerId = vehicleToOwner.get(vehicleId);
                if(!existentSharings.contains(getSharingIndex(vehicleId, dealerId))){
                    vehicleSharings.add(new Vehicle__Share(ParentId = vehicleId, UserOrGroupId = dealerId, AccessLevel = 'Read'));
                }
            }
            
            insertSobjects(vehicleSharings);
        }
    }
    
    /**
     * Gets the existent vehicle sharings.
     * By Justin Yu
     */
    private static Set<String> getExistentSharings(Map<String, String> vehicleToOwner){
        Set<String> result = new Set<String>();
        for(Vehicle__Share vShare : [select ParentId, UserOrGroupId from Vehicle__Share 
                                    where ParentId in :vehicleToOwner.keySet() 
                                    and UserOrGroupId in : vehicleToOwner.values()]){
            result.add(getSharingIndex(vShare.ParentId, vShare.UserOrGroupId));
        }
        return result;
    }
    
    /**
     * Maps a sharing to a record.
     * By Justin Yu
     */
    private static String getSharingIndex(String parentId, String userOrGroupId){
        return parentId + ';' + userOrGroupId;
    }
    // 2013-12-04 Created by lishuang: add for MB Complaint Case Close.
    public static void closeRelatedCase(List<Case> ids){
        Map<Id, Case> RelatedCase = new Map<Id, Case>();
        List<Case> updateCase = new List<Case>();
        for(Case caseNew : ids) {
            if(caseNew.ParentId != null){
               RelatedCase.put(caseNew.ParentId, caseNew);
            }else{
               RelatedCase.put(caseNew.id, caseNew);
            }
        }
        for(Case ca : [select Id, ParentId, status , Case_Dealer__c, Feedback_to_CAC_New__c from Case where ParentId in :RelatedCase.keySet() and status <> 'Closed' and Handling_Level__c = 'Dealer']) {
            if(ca.Case_Dealer__c == RelatedCase.get(ca.ParentId).Case_Dealer__c && ca.id != RelatedCase.get(ca.ParentId).id){
               ca.Status = 'Closed';
               ca.Feedback_to_CAC_New__c = RelatedCase.get(ca.ParentId).Feedback_to_CAC_New__c;
               updateCase.add(ca);
            }
        }
        if (updateCase.size() > 0){
           updateSobjects(updateCase);
        }
    }
    
    public static Map<id,id> getDealerSMManager(Map<id,String> dealerAccounts){
        Map<id,id> accountAndsmManager = new Map<id,id>(); 
        if (dealerAccounts.size() > 0) {
            for(User u : [select Id,AccountId, Email, ContactId, Contact.Permission_Set_Settings__c, Profile.Name from User 
                          where isActive = true and (Contact.Permission_Set_Settings__c = 'AS_Retail_Campaign' or Contact.Permission_Set_Settings__c = 'S_M_Retail_Campaign') and AccountId in :dealerAccounts.keySet()]){
                if(u.Contact.Permission_Set_Settings__c.contains('S_M_Retail_Campaign') && (dealerAccounts.get(u.AccountId) == 'S&M Event Retail Campaign' || dealerAccounts.get(u.AccountId) == 'S&M Media Retail Campaign')
                   || u.Contact.Permission_Set_Settings__c.contains('AS_Retail_Campaign') && dealerAccounts.get(u.AccountId) == 'AS Retail Campaign'){
                    if(!accountAndsmManager.containsKey(u.AccountId)) {
                        accountAndsmManager.put(u.AccountId, u.Id);
                    }
                }
            }
        }
        return accountAndsmManager;
    }
}