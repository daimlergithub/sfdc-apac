/*************************************************************************
Author: Tejbir Singh
Used for: Thailand Market
Description: Code coverage for CaseCommentCustomController class.
Date:14th Sept 2018
************************************************************************/
@isTest
public class CaseCommentCustomControllerTHTest {

    public static User user1 = TestUtils.createAdminUser();
    public static Case caseObj;
    public static id fsinq =RecordTypeAccessService.getRecordTypeId('case','FS Inquiry');
    public static Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static CaseCommentCustomController controller;
    public static CaseCommentCustomController controller2;
    public static void testData()
    {
        Account personAcc = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
      	insert personAcc;
        caseObj = new Case(Subject='testing',accountid=personAcc.Id,Recordtypeid=fsinq,MD__c='TH',COS_Ticket_Number__c='T000347');
        insert caseObj; 
        ApexPages.StandardController stdController=new ApexPages.StandardController(caseObj);
        controller=new CaseCommentCustomController(stdController);
    }
    
    public static testMethod void saveFile()
    {
        System.runAs(user1)
        {
            testData();
            controller.fileBody= Blob.valueOf('Image');
            controller.fileName='TestImage.jpg';
        	PageReference page=controller.saveCaseCommentWithAttachment();
            ApexPages.StandardController stdController2=new ApexPages.StandardController(caseObj);
        	controller2=new CaseCommentCustomController(stdController2);
            PageReference page2=controller2.saveCaseCommentWithAttachment();
            PageReference page3=controller2.back();
        }
        
    }
}