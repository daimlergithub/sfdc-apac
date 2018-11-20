/**
** Class: DispatcherLeadPagesINTest 
** Description: Test Class for DispatcherLeadEditControllerIN, DispatcherLeadDetailsEditCtrlIN and NewSalesLeadController.
** Created By: Prem Kumar
** Date: 11/04/2018
**/
@IsTest
public class DispatcherLeadPagesINTest {
    
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static string fsLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    public static Profile p1;
    public static User usr;
    public static Account companyAcc;
    public static Opportunity oppSales;
    public static Opportunity oppAfterSales;
    public static Opportunity oppFs;
    
    @TestSetup
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            Account companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            Opportunity oppAfterSales = TestUtils.createGenericOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN');
            Opportunity oppSales = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
            
        }
    }
    
    @IsTest
    private static void goToRecordTypePage1() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: salesLeadRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('id', oppty.Id);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        DispatcherLeadEditControllerIN dispatchCtrl = new DispatcherLeadEditControllerIN(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage2() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('id', oppty.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            DispatcherLeadEditControllerIN dispatchCtrl = new DispatcherLeadEditControllerIN(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage3() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: salesLeadRecordTypeId limit 1];
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(1);
            List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppty, carModelList);
            ApexPages.currentPage().getParameters().put('id', ledDetList[0].Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            DispatcherLeadDetailsEditCtrlIN dispatchCtrl = new DispatcherLeadDetailsEditCtrlIN(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage4() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(1);
            List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppty, carModelList);
            ApexPages.currentPage().getParameters().put('id', ledDetList[0].Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            DispatcherLeadDetailsEditCtrlIN dispatchCtrl = new DispatcherLeadDetailsEditCtrlIN(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage5() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: salesLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('retURL', acc.Id);
            ApexPages.currentPage().getParameters().put('RecordType', salesLeadRecordTypeId);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage6() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('retURL', acc.Id);
            ApexPages.currentPage().getParameters().put('RecordType', afterSalesLeadRecordTypeId);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage7() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('retURL', '');
            ApexPages.currentPage().getParameters().put('accid', '');
            ApexPages.currentPage().getParameters().put('RecordType', afterSalesLeadRecordTypeId);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    @IsTest
    private static void goToRecordTypePage8() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('retURL', null);
            ApexPages.currentPage().getParameters().put('accid', null);
            ApexPages.currentPage().getParameters().put('RecordType', afterSalesLeadRecordTypeId);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void fsTest() {
        Profile p2 = [SELECT Id,Name FROM Profile WHERE Name='Base FS User'];
        User fsUser = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(fsUser);
        System.runAs(fsUser){
        PermissionSet ps = new PermissionSet(Name = 'Test', Label = 'Test');
        insert ps;
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = [select Id from CustomPermission where DeveloperName = 'AccessFSOppIN'][0].Id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = fsUser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        test.startTest();
        
            Account companyAccOne = TestUtils.createGenericAccount(fsUser, '123556', companyAccRecordTypeId, '1234567899');
            Opportunity oppFs = TestUtils.createGenericOpportunity(fsUser, companyAccOne, fsLeadRecordTypeId, 'IN');
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: fsLeadRecordTypeId limit 1];
            ApexPages.currentPage().getParameters().put('retURL', null);
            ApexPages.currentPage().getParameters().put('accid', null);
            ApexPages.currentPage().getParameters().put('RecordType', fsLeadRecordTypeId);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
            dispatchCtrl.opp = oppty;
            dispatchCtrl.goToRecordTypePage();
        }
        test.stopTest();
    }
	
}