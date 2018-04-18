/**
** Class: OppHelperBaseInTest 
** Description: Test Class for OppHelperBase
** Created By: Prem Kumar
** Date: 16/04/2018
**/
@IsTest
public class OppHelperBaseInTest {
    
    public static string salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();  
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    public static String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN');
            insert dealerAcc;
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
            insert con;
            Account companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            Account personAcc = TestUtils.createGenericAccount(usr, '654321', personAccRecordTypeId, '9087654321');
            Address__c accAddress = TestUtils.createGenericAddressRecord(personAcc, '123456', 'IN', 'Pune', 'Maharashtra', 'India');
            List<Opportunity> oppAfterSalesList = TestUtils.createGenericBulkOpportunity(usr, personAcc, afterSalesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppSalesList = TestUtils.createGenericBulkOpportunity(usr, personAcc, salesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppAfterSalesWithPersonAccList = TestUtils.createGenericBulkOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppSalesWithPersonAccList = TestUtils.createGenericBulkOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN', 5);
            Opportunity genericOpp = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
        }
    }
    
    @IsTest
    private static void testOppHelperBaseMethods1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name, Primary_Address_Reference__c From Account Where recordTypeId =: companyAccRecordTypeId limit 1];
            Address__c accAddress = TestUtils.createGenericAddressRecord(acc, '123456', 'IN', 'Pune', 'Maharashtra', 'India');
            acc.Primary_Address_Reference__c = accAddress.Id;
            update acc;
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity limit 20];
            OppHelperBase oppObj = new OppHelperBase();
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
            for(Opportunity op : opptyList){
                oppMap.put(op.Id, op);
            }
            oppObj.updateOwnerwithDealer(opptyList, 'IN'); 
            for(Opportunity opp : opptyList){
                opp.TrackingNumber__c = 'asdf';
            }
            oppObj.CdmLeadcreate(opptyList, oppMap, 'IN');
            OppHelperBase.updatemarket(opptyList);
            OppHelperBase.getCommunityURL();
            OppHelperBase.CheckRetailCopy(opptyList, oppMap, true, true, 'IN');
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testOppHelperBaseMethods2() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity Where Name = 'Generic Opportunity' limit 1];
            OppHelperBase.updateRetailLookups(opptyList, 'IN');
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testOppHelperBaseMethods3() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity limit 20];
            OppHelperBase oppObj = new OppHelperBase();
            List<Account> accList = [Select Id, Name From Account limit 10];
            Set<Id> accIdSet = new Set<Id>();
            for(Account ac : accList){
                accIdSet.add(ac.Id);
            }
            Map<Id,Id> idMap = OppHelperBase.getAccountToDLGKUser(accIdSet);
            OppHelperBase.updateOwnership(accIdSet, opptyList, 'IN');
        }
        test.stopTest();
    }

}