@isTest
public class UserTriggerHandlerINTest {
    Private static Profile adminProfileObj;
    Private static User adminUserObj;
    public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
    
    public static testmethod  void  InvokePermissionHandlerForUserCreationTest(){
        test.startTest();
        Group grpObj=new Group(Name='12345');
        insert grpObj;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'UserTriggerIN@InvokePermUser.com',
            Alias = 'Inbatman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            Market__c='IN',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        System.runAs(portalAccountOwner1){
            Trigger__c TriggerUser=new Trigger__c(Name='UserTriggerIN',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
            insert TriggerUser;
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='IN',Md__c='IN', Individual_Home_Phone__c='+61489654789', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
            insert dealer1;
            Contact dealerContact = new Contact(FirstName = 'Test',Market__c='IN',Md__c='IN', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
            insert dealerContact;
            Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='IN', Md__c='IN',Individual_Home_Phone__c='+61489654789', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1245');
            insert dealer;
            Account dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='IN',Md__c='IN', Individual_Home_Phone__c='+61425748965', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1245',DMS_Retailer_ID__c='TH100225');
            insert dealerAccount;
            Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',Market__c='IN',AccountId=dealerAccount.Id);
            insert c1;
            Profile profileObj = [select id from profile where Name='Thailand Dealer Delegate Admin' limit 1];
            User userObj = new User(ContactId=c1.Id,LastName='User',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='Inusr123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName=System.now().millisecond() + 'inusradmtrg@daimler.com',Market__c = 'IN',isActive=true);
            insert userObj;  
            userObj.Market__c='MY';
            update userObj;
        }
        test.stopTest();
    } 
}