/**
** Class: OpportunityInlineVehicleControllerINTest
** Description: Test Class for OpportunityInlineVehicleController
** Created By: Sravanthi Gudibandi
** Date: 12-April-2018
**/

@IsTest
public class OpportunityInlineVehicleControllerINTest {
    
    
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static String aftersalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
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
        Opportunity oppafterSales = TestUtils.createGenericOpportunity(usr, companyAcc, aftersalesLeadRecordTypeId, 'IN');
        List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(7);
        List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppSales, carModelList);
        List<Lead_Details__c> ledDetList1 = TestUtils.createBulkLeadDetails(oppafterSales, carModelList);
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
        Account acc = [Select Id, Name From Account limit 1];
        Opportunity oppty = [select Id,AccountID, Name From Opportunity limit 1];
        List<Car_Model__c> cmlList = [Select Id, Name From Car_Model__c limit 14];
        List<Lead_Details__c> ldList = [Select Id, Name From Lead_Details__c Where Related_Lead__c =: oppty.Id];
        ApexPages.currentPage().getParameters().put('recordType','Sales Lead');
        ApexPages.currentPage().getParameters().put('recordType','Aftersales Lead');
        ApexPages.currentPage().getParameters().put('id', oppty.Id);
        ApexPages.currentPage().getParameters().get('id');
        ApexPages.StandardController objsc = new ApexPages.StandardController(oppty);
        OpportunityInlineVehicleController  oivc= new OpportunityInlineVehicleController (objsc);
        test.stopTest();
        
    }
}