/**
** Class: CaseInlineVehicleControllerTestIN 
** Description: Test Class for CaseInlineVehicleController
** Created By: Prem Kumar
** Date: 23-August-2018
**/


@IsTest
public class FSOppInlineVehicleControllerTestIN {
    public static String salesLdRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static Opportunity opp;
    public static List<Car_Model__c> carModelList;
    public static List<Lead_Details__c> ledDetList;  
    
    @TestSetup
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            
            opp = new Opportunity();
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
            opp.Name = 'New Opp';
            opp.StageName = 'New';
            opp.Type_of_Sale__c = 'Corporate';
            opp.Lead_DataSource__c = 'Event';
            opp.Lead_Type__c = 'Activities';
            opp.Lead_Sub_Type__c = 'Test Drive';
            opp.CloseDate = Date.today();
            insert opp;
            carModelList = TestUtils.createBulkCarModel(7);
            ledDetList = testUtils.createBulkLeadDetails(opp, carModelList);
        }
    }
    
    // Create bulk Lead Details Records(India)
    public static List<Lead_Details__c> createBulkLeadDetails(Case opp, List<Car_Model__c> cmList){
        List<Lead_Details__c> ldList = new List<Lead_Details__c>();
        for(Car_Model__c cm : cmList){
            Lead_Details__c lDet = new Lead_Details__c();
            if(cm.Status__c == 'Own Sellable'){
                lDet.Car_Model__c = cm.Id;
                lDet.Related_Case__c = opp.Id;
                lDet.Brand__c = cm.Brand__c;
                lDet.Color__c = cm.Colour__c;
                lDet.Trim__c = cm.Trim__c;
                lDet.Mileage__c = '40';
                lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                ldList.add(lDet);
            }
            else if(cm.Status__c == 'Competitor'){
                lDet.Car_Model_Competitor__c = cm.Id;
                lDet.Related_Case__c = opp.Id;
                lDet.Brand__c = cm.Brand__c;
                lDet.Color__c = cm.Colour__c;
                lDet.Trim__c = cm.Trim__c;
                lDet.Mileage__c = '40';
                lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                ldList.add(lDet);
            } 
        }
        Lead_Details__c lDet1 = new Lead_Details__c();
        lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
        lDet1.Related_Case__c = opp.Id;
        lDet1.Trim__c = 'Medium';
        lDet1.Year_of_Manufacture__c = '1234';
        lDet1.Mileage__c = '40';
        lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
        ldList.add(lDet1);
        insert ldList;
        return ldList;
    }
    @IsTest
    private static void testcase1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Opportunity opp = [Select Id From Opportunity limit 1];
            List<Car_Model__c> cmlList = [Select Id, Name From Car_Model__c limit 14];
            List<Lead_Details__c> ldList = [Select Id, Name From Lead_Details__c Where Related_Lead__c =: opp.Id];
            ApexPages.currentPage().getParameters().put('recordType','Sales Lead');
            ApexPages.currentPage().getParameters().put('id', opp.Id);
            ApexPages.StandardController objsc = new ApexPages.StandardController(opp);
            FSOppInlineVehicleController fsOpp = new FSOppInlineVehicleController(objsc);
            
            fsOpp.AddIntRecord();
            fsOpp.AddCompRecord();
            fsOpp.UpdateModInfo();
            fsOpp.EditOptions();
            fsOpp.PreferredChk();
            fsOpp.PreferredChkComp();
            fsOpp.savecase();
            fsOpp.editTradeInDetails();
        }
        test.stopTest();
    }
}