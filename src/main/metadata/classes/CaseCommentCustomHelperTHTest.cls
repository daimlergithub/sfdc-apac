/*******************************************************************************************
* Class:                            CaseCommentCustomHelperTHTest
* Description:                      Test class for Case Comment Custom HelperTH
* ------------------------------------------------------------------------------------------
* Date          Name                        Modification Description
* 28/8/2018     Tejbir Singh       			Created   
===========================================================================================*/
@isTest
public class CaseCommentCustomHelperTHTest {

    public static User user1 = TestUtils.createAdminUser();
    public static User user2 = TestUtils.IntegrationAPIUser();
    public static Case caseObj;
    public static id fsinq =RecordTypeAccessService.getRecordTypeId('case','FS Inquiry');
    public static Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    public static void TestData()
    {
        Trigger__c tr = new Trigger__C(Name = 'CaseCommentCustomTriggerTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, update__c = true, Market__c = 'TH', Trigger_Handler__c = 'CaseCommentCustomTriggerHandlerTH', Trigger_Name__c = 'CaseCommentCustomTrigger');
        insert tr;
        Account personAcc = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-123456789',Market__c='TH',MD__c='TH');
      insert personAcc;
        caseObj = new Case(Subject='testing',accountid=personAcc.Id,Recordtypeid=fsinq,MD__c='TH',COS_Ticket_Number__c='T000347',Market__c='TH');
        insert caseObj;
        
    }
    
    public static testMethod void SendCaseCommentToCOSTest()
    {
        System.runAs(user2)
        {
            TestData();
            test.startTest();
            TriggerUtil.userCreate=false;
            CaseCommentCustomController.IsTriggerRunRequired=true;
            Case_Comment__c cc=new Case_Comment__c(Case__c=caseObj.Id,Role__c='CCC',Comment__c='Testing123');
            insert cc;
            test.stopTest();
        }
    }
    
}