/**
** Class: CaseInlineVehicleControllerTestIN 
** Description: Test Class for CaseInlineVehicleController
** Created By: Namitha
** Date: 22-May-2018
**/


@IsTest
public class CaseInlineVehicleControllerTestIN {
  //public static String InquiryRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
  public static String ComplaintRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
  public static Case caserec;
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
           
      Case caserec = new Case();
            caserec.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
      caserec.status = 'Open';
      caserec.Subject = 'Test Case'+String.valueof(DateTime.now().getTime());
      insert caserec;
      system.debug('case id'+ caserec.id);
            carModelList = TestUtils.createBulkCarModel(7);
            ledDetList = createBulkLeadDetails(caserec, carModelList);
        }
    }
  
   // Create bulk Lead Details Records(India)
    public static List<Lead_Details__c> createBulkLeadDetails(Case caserec, List<Car_Model__c> cmList){
        List<Lead_Details__c> ldList = new List<Lead_Details__c>();
        for(Car_Model__c cm : cmList){
            Lead_Details__c lDet = new Lead_Details__c();
            if(cm.Status__c == 'Own Sellable'){
                lDet.Car_Model__c = cm.Id;
                lDet.Related_Case__c = caserec.Id;
                lDet.Brand__c = cm.Brand__c;
                lDet.Color__c = cm.Colour__c;
                lDet.Trim__c = cm.Trim__c;
                lDet.Mileage__c = '40';
                lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                ldList.add(lDet);
            }
            else if(cm.Status__c == 'Competitor'){
                lDet.Car_Model_Competitor__c = cm.Id;
                lDet.Related_Case__c = caserec.Id;
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
        lDet1.Related_Case__c = caserec.Id;
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
            Case casere = [Select Id From Case limit 1];
            //system.debug('case id in test'+ caserec.id);
            List<Car_Model__c> cmlList = [Select Id, Name From Car_Model__c limit 14];
            List<Lead_Details__c> ldList = [Select Id, Name From Lead_Details__c Where Related_Case__c =: casere.Id];
            ApexPages.currentPage().getParameters().put('recordType','Inquiry');
            ApexPages.currentPage().getParameters().put('id', casere.Id);
            ApexPages.StandardController objsc = new ApexPages.StandardController(casere);
            CaseInlineVehicleController slc = new CaseInlineVehicleController(objsc);
            //PageReference pageRef = Page.SalesLeadPage;
            
            slc.AddIntRecord();
            slc.AddCompRecord();
            slc.UpdateModInfo();
            slc.EditOptions();
            slc.PreferredChk();
            slc.PreferredChkComp();
            slc.savecase();
            //slc.Cancel();
        }
        test.stopTest();
    }
}