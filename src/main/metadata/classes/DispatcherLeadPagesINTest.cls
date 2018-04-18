/**
** Class: DispatcherLeadPagesINTest  
** Description: Test Class for two DispatcherLead classes
** Created By: Prem Kumar
** Date: 11/04/2018
**/
@IsTest
public class DispatcherLeadPagesINTest {
    
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    
    @TestSetup
    public static void initData(){
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        User usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert usr;
        Account companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
        Opportunity oppAfterSales = TestUtils.createGenericOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN');
        Opportunity oppSales = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
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
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('id', oppty.Id);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        DispatcherLeadEditControllerIN dispatchCtrl = new DispatcherLeadEditControllerIN(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage3() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: salesLeadRecordTypeId limit 1];
        List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(1);
        List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppty, carModelList);
        ApexPages.currentPage().getParameters().put('id', ledDetList[0].Id);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        DispatcherLeadDetailsEditCtrlIN dispatchCtrl = new DispatcherLeadDetailsEditCtrlIN(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage4() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
        List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(1);
        List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppty, carModelList);
        ApexPages.currentPage().getParameters().put('id', ledDetList[0].Id);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        DispatcherLeadDetailsEditCtrlIN dispatchCtrl = new DispatcherLeadDetailsEditCtrlIN(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage5() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: salesLeadRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('retURL', acc.Id);
        ApexPages.currentPage().getParameters().put('RecordType', salesLeadRecordTypeId);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        //dispatchCtrl.myMethod();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage6() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('retURL', acc.Id);
        ApexPages.currentPage().getParameters().put('RecordType', afterSalesLeadRecordTypeId);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        //dispatchCtrl.myMethod();
        test.stopTest();
    }
    
    @IsTest
    private static void goToRecordTypePage7() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, AccountId, Name, recordTypeId From Opportunity Where recordTypeId =: afterSalesLeadRecordTypeId limit 1];
        ApexPages.currentPage().getParameters().put('retURL', '');
        ApexPages.currentPage().getParameters().put('accid', '');
        ApexPages.currentPage().getParameters().put('RecordType', afterSalesLeadRecordTypeId);
        ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
        NewSalesLeadController dispatchCtrl = new NewSalesLeadController(objStdCtrl);
        dispatchCtrl.opp = oppty;
        dispatchCtrl.goToRecordTypePage();
        //dispatchCtrl.myMethod();
        test.stopTest();
    }
    
}