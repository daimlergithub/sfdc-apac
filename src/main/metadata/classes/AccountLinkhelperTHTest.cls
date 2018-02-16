@isTest
public Class AccountLinkhelperTHTest{
private static Account dealer;
private static Account dealer1;
public static Contact contactObj;
    private Static Address__c address=new Address__c();
   Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
 public  Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
 public  Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
 public  Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
static testMethod void testAccAssignment() {
 Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLinkTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerAccountlinkHandlerTH',Trigger_Name__c='TriggerAccountLink',update__c=true);
insert casetrigger;
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
    User user1 = new User(LastName='User',Market__c='TH',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'THTest123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
    User user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
     System.runAs (user1) {
         
         
        
     system.debug('****'+user1.market__c);
     dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='TH12345');
        insert dealer;
        
        
         Group test1 = new Group();
        test1.Name = dealer.Dealer_nd_Code__c;
        insert test1;
        Group test2 = new Group();
        test2.Name = dealer1.Dealer_nd_Code__c;
        insert test2;
   List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
    Account accObj1 = new Account(Md__c='TH',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+66-9885857857');
            insert accobj1;
         Account accObj2 = new Account(Md__c='TH',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+66-9885857857');
            insert accobj2;
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Md__c='TH',toRole__c=accobj1.id,fromrole__c=dealer.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
             Account_Link__c al2= new Account_Link__c(Name='new al',Md__c='TH',toRole__c=accobj1.id,fromrole__c=accobj2.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
          Account_Link__c al3= new Account_Link__c(Name='new al',Md__c='TH',toRole__c=accobj1.id,fromrole__c=accobj2.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
             Account_Link__c al4= new Account_Link__c(Name='new al',Md__c='TH',toRole__c=accobj1.id,fromrole__c=accobj1.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
           listcampaigns1.add(al1);
         listcampaigns1.add(al2);
         listcampaigns1.add(al3);
         listcampaigns1.add(al4);
           insert listcampaigns1;
           system.debug('****Cod'+al1.Retail_Dealer_CompanyCode__c);
            List<Account_Link__c> updatelst=new List<Account_Link__c>();
            al1.fromrole__c=dealer1.id;
         address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
         address.Customer__c=accobj1.id;
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '32703';
        //address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
        insert address;
         	
            updatelst.add(al1);
            update updatelst;
         al1.Retail_Address_Reference__c=address.id;
         update al1;
               
    
    }
    }
    
   

}