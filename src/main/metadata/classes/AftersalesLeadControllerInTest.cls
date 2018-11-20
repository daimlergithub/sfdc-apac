/**
** Class: AftersalesLeadControllerInTest 
** Description: Test Class for AftersalesLeadController
** Created By: Prem Kumar
** Date: 10/04/2018
**/
@IsTest
public class AftersalesLeadControllerInTest {
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    public static Opportunity oppty;
    public static Profile p1;
    public static User usr;
    public static Account companyAcc;
    public static Opportunity oppAfterSales;
    
    @TestSetup
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            oppAfterSales = TestUtils.createGenericOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN');
        }
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            oppty = [Select Id, Name, AccountId From Opportunity Where AccountId =: acc.Id];
            System.debug('oppty===>' + oppty);
            ApexPages.currentPage().getParameters().put('recordType','AfterSales Lead');
            ApexPages.currentPage().getParameters().put('accID', acc.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadController asLeadCtrl = new AfterSalesLeadController(objStdCtrl);
            
            asLeadCtrl.opp = oppty;
            asLeadCtrl.opp.Type_of_Sale__c = 'Government';
            asLeadCtrl.AddCompRecord();
            asLeadCtrl.AddIntRecord();
            asLeadCtrl.Cancel();
            asLeadCtrl.PreferredChk();
            asLeadCtrl.PreferredChkComp();
            asLeadCtrl.UpdateModInfo();
            asLeadCtrl.Vehrel();
            asLeadCtrl.saveOpp();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveOpportunity2() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            oppty = [Select Id, Name, AccountId From Opportunity Where AccountId =: acc.Id];
            System.debug('oppty===>' + oppty);
            ApexPages.currentPage().getParameters().put('recordType','AfterSales Lead');
            ApexPages.currentPage().getParameters().put('accID', acc.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadController asLeadCtrl = new AfterSalesLeadController(objStdCtrl);
            
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(7);
            list<Lead_Details__c> ldList = TestUtils.createBulkLeadDetails(oppty, carModelList);
            for(Lead_Details__c ld : ldList){
                ld.Preferred__c = true;
                asLeadCtrl.allVehicles.add(ld);
            }
            asLeadCtrl.PreferredChk();
            asLeadCtrl.PreferredChkComp();
            asLeadCtrl.UpdateModInfo();
            asLeadCtrl.saveOpp();
        }
        test.stopTest();
    }
     @IsTest
    private static void testSaveOpportunity3() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('Turkey', 'Asia/Kolkata', 'TR');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            oppty = [Select Id, Name, AccountId,closedate From Opportunity Where AccountId =: acc.Id];
            System.debug('oppty===>' + oppty);
            ApexPages.currentPage().getParameters().put('recordType','AfterSales Lead');
            ApexPages.currentPage().getParameters().put('accID', acc.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadController asLeadCtrl = new AfterSalesLeadController(objStdCtrl);
            
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(7);
            list<Lead_Details__c> ldList = TestUtils.createBulkLeadDetails(oppty, carModelList);
            for(Lead_Details__c ld : ldList){
                ld.Preferred__c = true;
                asLeadCtrl.allVehicles.add(ld);
            }
            asLeadCtrl.PreferredChk();
            asLeadCtrl.PreferredChkComp();
            asLeadCtrl.UpdateModInfo();
            asLeadCtrl.opp.Name = oppty.Name;
            asLeadCtrl.opp.closedate = oppty.CloseDate;
            asLeadCtrl.saveOpp();
        }
        test.stopTest();
    }
    
}