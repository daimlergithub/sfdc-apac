@isTest
public class ShareALLRecordsToNewUserBatchTHTest {
    /*Private static Profile profileObj;
    Private static Account dealerAccount;
    Private static User userObj;
    Private static Contact c1;
    public static void createTestData()
    {
        Trigger__c TriggerUser=new Trigger__c(Name='UserTriggerTH',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
        insert TriggerUser;
        profileObj = [select id from profile where Name='System Administrator' limit 1];
        dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealerAccount;
        Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',AccountId=dealerAccount.Id);
        insert c1;
        userObj = new User(ContactId=c1.Id,LastName='User',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusr@daimler.com',Market__c = 'TH',isActive=true);
        insert userObj;
        
    }
    
    static testMethod void testBatchClass()
    {
        Test.startTest();
        createTestData();
        User userObj2 = new User(ContactId=c1.Id,LastName='User2',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser02@testing.com',UserName='admusr2@daimler.com',Market__c = 'TH',isActive=true);
        insert userObj2;
        Test.stopTest();
    }*/
}