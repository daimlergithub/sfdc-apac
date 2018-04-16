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
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
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
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveOpportunity2() {
        test.startTest();
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
        test.stopTest();
    }
  
}