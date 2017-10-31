/**
** Execute GenerateAndAttachPDF
** Created By: Sneha Chail
** Created Date: 2015-11-25
**/
@isTest
Public class GenerateAndAttachPDFTest {
public static Case objCase;

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
        objAccount=(Account)UtilTestData.createSobject(new Account(),UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        // Create Vehicle 
        Vehicle__c objVehicle=new Vehicle__c();                    
        objVehicle=(Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilTestData.VEHICLE_MB); 
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