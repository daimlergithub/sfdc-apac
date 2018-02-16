@isTest
public Class AccountLinkhelperTHTest{
private static Account dealer;
private static Account dealer1;
private Static Address__c address;
public static id contacttocontactid=RecordTypeAccessService.getRecordTypeId('Account_Link__c','Contact2Contact');//Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
public static id personaccountid=RecordTypeAccessService.getRecordTypeId('Account','Person Account');
Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
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
     dealer =  new Account(Dealer_Rollout_Status__c ='Done',Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='TH12345');
        insert dealer;
		List<Group> gr=new List<group>{new Group(Name = dealer.Dealer_nd_Code__c),new Group(Name = dealer1.Dealer_nd_Code__c)};
		insert gr;
		List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
		List<Account> acc=new List<Account>();
		acc.add(new Account(Md__c='TH',UCID__c='989898989',RecordTypeId = personaccountid,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+66-9885857857'));
		acc.add(new Account(Md__c='TH',RecordTypeId = personaccountid,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605', Individual_Home_Phone__c='+66-9885857857'));
        insert acc;
           listcampaigns1.add(new Account_Link__c(Name='new al',Md__c='TH',toRole__c=acc[0].id,fromrole__c=dealer.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
           RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female'));
           listcampaigns1.add(new Account_Link__c(Name='new al',Md__c='TH',toRole__c=acc[0].id,fromrole__c=acc[1].id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
           RecordTypeId=contacttocontactid,Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female'));
			listcampaigns1.add(new Account_Link__c(Name='new al',Md__c='TH',toRole__c=acc[0].id,fromrole__c=acc[1].id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=contacttocontactid,Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female'));
            listcampaigns1.add(new Account_Link__c(Name='new al',Md__c='TH',toRole__c=acc[0].id,fromrole__c=acc[0].id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=contacttocontactid,Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female'));
           insert listcampaigns1;
            List<Account_Link__c> updatelst=new List<Account_Link__c>();
           listcampaigns1[0].fromrole__c=dealer1.id;
       	address=new Address__c(Address_Type__c='Home',Province__c='Shanghai',City__c='bangalore',District__c='test2',Block__c='test3',Customer__c=acc[0].id,Address_Line_1__c='testaddress1',Address_Line_2__c='testaddress2',ZipCode__c = '32703',TitleOfHonor__c ='To Person',preferred__c=True,Opt_In_Hardcopy__c=True,MD__c='TH');
         insert address;
		updatelst.add(listcampaigns1[0]);
         update updatelst;
         listcampaigns1[0].Retail_Address_Reference__c=address.id;
         update listcampaigns1[0];
	new TriggerAccountlinkHandlerTH().handleIntegrationTrigger(true,true,true,true,true);
    }
    }    
}