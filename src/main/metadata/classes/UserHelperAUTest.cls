@isTest
public class UserHelperAUTest {
 Private static Profile adminProfileObj;
    Private static User adminUserObj;
    public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
    
     public static void createtestdata(){
        
        Trigger__c TriggerUser=new Trigger__c(Name='UserTriggerAU',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandlerAU',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
        insert TriggerUser;
        adminProfileObj = [select id from profile where Name='System Administrator' limit 1];
         
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='UserTH',country='Australia',/*UserRoleId = role.id*/firstName='BCI',ProfileId=p.Id,Alias='ainTH123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',
		UserName=System.now().millisecond() + 'testadminAuUse1@Daimlest.com',Market__c = 'TH');
        insert u;
        adminUserObj = u;
         
         
    }
    
     public static testmethod  void  InvokePermissionHandlerForUserCreationTest(){
        test.startTest();
        createtestdata();
        Group grpObj=new Group(Name='12345');
        insert grpObj;
        
            Profile p1 = [select id from profile where Name='System Administrator' limit 1];
     profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
         Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='AU', Individual_Home_Phone__c='+61489654789', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='AU', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
         Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='AU',Individual_Home_Phone__c='+61489654789', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1245');
        insert dealer;
         
        Account dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='AU', Individual_Home_Phone__c='+61425748965', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1245',DMS_Retailer_ID__c='TH100225');
        insert dealerAccount;
        Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',AccountId=dealerAccount.Id);
        insert c1;
        
        System.runAs(adminUserObj)
        {
            Profile profileObj = [select id from profile where Name='Thailand Dealer Delegate Admin' limit 1];
            User userObj = new User(ContactId=c1.Id,LastName='User',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',
			UserName=System.now().millisecond() + 'testAdminAUUse1@Daitest.com',Market__c = 'AU',isActive=true);
            insert userObj;  
            userObj.Market__c='MY';
          update userObj;
        }
        test.stopTest();
    } 
 
    
}