/**
** Execute GenerateAndAttachPDF
** Created By: Sneha Chail
** Created Date: 2015-11-25
**/
@isTest
Public class GenerateAndAttachPDFTest {
public static Case objCase;
 final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
 final static String vechmbid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
  // "GenerateAndAttachPDF" method would be called //
  public static testMethod void GenerateAndAttachPDFTest()
    {
     init();
     ApexPages.currentPage().getParameters().put(system.label.Id,objCase.id);     
     ApexPages.StandardController objSc = new ApexPages.StandardController(objCase);
     GenerateAndAttachPDF objCaseController = new GenerateAndAttachPDF(objSc);
     objCaseController.CustomerStatement=objCase.Customer_Statement__c;
     objCaseController.PRCommentForDealer=objCase.PR_Comment_for_Dealer__c;
     //Start test
     Test.startTest();
       objCaseController.GenerateAndAttachPDF();     
     //Stop Test
     Test.stopTest();
     Audit_Trail__c  audittrail=[Select Name,Name__c from Audit_Trail__c  where  Name__c=:objCase.Id];
     Attachment attchment=[Select id,ParentId  from Attachment Where ParentId =:objCase.Id];
     system.assert(audittrail!=Null);
     system.assert(attchment!=Null);
    }
    // creating record for Case
  public static void init()
    {  
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
       // Create Account
        Account objAccount=new Account();
        objAccount.MBK_Data_Source__c ='Campaign';
        objAccount.Mobile__c ='000-123-4567';
        //objAccount=(Account)UtilTestData.createSobject(new Account(),UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        objAccount=new Account(RecordTypeId=personRecordtypeid);
        // Create Vehicle 
        Vehicle__c objVehicle=new Vehicle__c();                    
        //objVehicle=(Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilTestData.VEHICLE_MB); 
        objVehicle=new Vehicle__c(RecordTypeId=vechmbid);
        objVehicle.Brand__c ='Mercedes-Benz';
        objVehicle.FirstRegistrationDate__c = date.today();
        objVehicle.Purchase_Month__c ='02';
        objVehicle.Model__c = 'R350L 4MATIC';
        objVehicle.Class__c = 'A-Class'; 
        objVehicle.Purchase_Year__c = '2004';
        objVehicle.RegistrationNo__c = '12345';
        // Create Vehicle Relationship
        Vehicle_Relationship__c objVehicleRelship= new Vehicle_Relationship__c();
        objVehicleRelship.Vehicle_ID__c = objVehicle.Id;
        objVehicleRelship.Contact__c = objAccount.Id;
        objVehicleRelship.Car_Relation__c='Owner';
        objVehicleRelship= (Vehicle_Relationship__c)UtilTestData.createSobject(objVehicleRelship,UtilTestData.VEHICLE_RELATIONSHIP);   
       
        objCase= new Case(); 
        objCase.subject='TestSubject';
        objCase.status='Open';
        objCase.Vehicle__c=objVehicle.Id;
        objCase.AccountId=objAccount.Id;
        objCase.Customer_Statement__c='Customer Statement testing for textboxarea';
        objCase.PR_Comment_for_Dealer__c='PR Comment for Dealer testing for textboxarea';
        objCase.RecordtypeId=UtilRecordType.getRecordTypeIdByName(UtilConstant.sObjCase,UtilConstant.INQUIRY);
        insert objCase;
    }  
}