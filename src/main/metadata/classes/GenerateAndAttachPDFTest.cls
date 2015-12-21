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
        insert updatecustomsettings;

       objCase= new Case(); 
       objCase.subject='TestSubject';
       objCase.RecordtypeId=UtilRecordType.getRecordTypeIdByName(UtilConstant.sObjCase,UtilConstant.INQUIRY);
       insert objCase;
    }   
}