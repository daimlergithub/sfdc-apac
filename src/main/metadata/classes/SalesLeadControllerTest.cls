/**
** Class: salesLeadControllerTest 
** Description: Test Class for salesLeadController
** Created By: Sravanthi Gudibandi
** Date: 10-April-2018
**/

@IsTest
public class SalesLeadControllerTest {
    
    
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
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
        Opportunity oppSales = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
        List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(7);
        List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppSales, carModelList);
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, Name From Opportunity Where AccountId =: acc.Id];
        List<Car_Model__c> cmlList = [Select Id, Name From Car_Model__c limit 14];
        List<Lead_Details__c> ldList = [Select Id, Name From Lead_Details__c Where Related_Lead__c =: oppty.Id];
        ApexPages.currentPage().getParameters().put('recordType','Sales Lead');
        ApexPages.currentPage().getParameters().put('accID', acc.Id);
        ApexPages.StandardController objsc = new ApexPages.StandardController(oppty);
        SalesLeadController slc = new SalesLeadController(objsc);
        PageReference pageRef = Page.SalesLeadPage;
        
        slc.AddIntRecord();
        slc.AddCompRecord();
        slc.UpdateModInfo();
        slc.Vehrel();
        slc.PreferredChk();
        slc.PreferredChkComp();
        slc.saveOpp();
        slc.Cancel();
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveOpportunity2() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id, Name From Opportunity Where AccountId =: acc.Id];
        ApexPages.currentPage().getParameters().put('recordType','Sales Lead');
        ApexPages.currentPage().getParameters().put('accID', acc.Id);
        ApexPages.StandardController objsc = new ApexPages.StandardController(oppty);
        SalesLeadController slc = new SalesLeadController(objsc);
        PageReference pageRef = Page.SalesLeadPage;
        
        List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(7);
        list<Lead_Details__c> ldList = TestUtils.createBulkLeadDetails(oppty, carModelList);
        for(Lead_Details__c ld : ldList){
            ld.Preferred__c = true;
            slc.allVehicles.add(ld);
        }
        slc.AddIntRecord();
        slc.AddCompRecord();
        slc.UpdateModInfo();
        slc.Vehrel();
        slc.PreferredChk();
        slc.PreferredChkComp();
        slc.saveOpp();
        slc.Cancel();
        test.stopTest();
    }
}