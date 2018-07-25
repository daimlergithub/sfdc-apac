@isTest
public class DownloadCaseAttachmentsControllerTest {
	
    public static Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id recordTypeFSInquiry_Id=Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS Inquiry').getRecordTypeId();
    public static void testData()
    {
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Market__c='TH',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(u);
    }
    public static testMethod void downloadAttachmentTest()
    {
        testData();
        user u=[select id, name from user where Email='testUser@testorg.com' and isActive=true limit 1];
        System.runAs(u)
        {
            Account personAcc = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
      		insert personAcc;
        
        	Case c1 = new Case(Subject='testing',accountid=personAcc.id,Recordtypeid=recordTypeFSInquiry_Id,MD__c='TH',COS_Ticket_Number__c='T56498');
        	insert c1;
            
            ApexPages.StandardController controller=new ApexPages.StandardController(c1);
            DownloadCaseAttachmentsController downloadAttController=new DownloadCaseAttachmentsController(controller);
        }
    }
}