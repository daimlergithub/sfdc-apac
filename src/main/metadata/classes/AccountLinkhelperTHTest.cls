@isTest
public Class AccountLinkhelperTHTest {
    private static Account dealer;
    private static Account dealer1;
    public static User user3 = TestUtils.IntegrationAPIUser();
    public static User user1 = TestUtils.createAdminUser();
    private Static List < Address__c > address = new List < Address__C > ();
    public static List < Account_Link__c > listcampaigns1 = new List < Account_Link__c > ();
    public static List < Account_Link__c > acclinklist = new List < Account_Link__c > ();
    public static id contacttocontactid = RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Contact2Contact'); //Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public static id personaccountid = RecordTypeAccessService.getRecordTypeId('Account', 'Person Account');
    Private static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    static testMethod void testAccAssignment() {
        Trigger__C casetrigger = new Trigger__C(name = 'TriggerAccountLinkTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAccountlinkHandlerTH', Trigger_Name__c = 'TriggerAccountLink', update__c = true);
        insert casetrigger;

        profile p2 = [select id from profile where Name = 'Thailand Dealer Delegate Admin'];

        dealer1 = new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'TH', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1', Dealer_GC_Code__c = '12345', Dealer_nd_Code__C = '1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test', Md__c = 'TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
        User user2 = new User(LastName = 'GEORGE', contactid = dealerContact.id, country = 'Australia', ProfileId = p2.Id, Alias = 'ain1234', EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', Email = 'Ibtesamuddin_M@infosys.com', UserName = 'george@usgboral.com.dev01');
        insert user2;

        dealer = new Account(Dealer_Rollout_Status__c = 'Done', Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'TH', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
        insert dealer;
        List < Group > gr = new List < group > {
            new Group(Name = 'TH12345'),
            new Group(Name = 'TH1234')
        };
        insert gr;

        List < Account > acc = new List < Account > ();
        acc.add(new Account(Md__c = 'TH', UCID__c = '989898989', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857'));
        acc.add(new Account(Md__c = 'TH', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857'));
        insert acc;
        address.add(new Address__c(Address_Type__c = 'Home', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'TH'));
        address.add(new Address__c(Address_Type__c = 'Home', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'TH'));
        insert address;
        system.runAs(user1) {
            listcampaigns1.add(new Account_Link__c(Retail_Address_Reference__c = address[0].id, Name = 'new al', Md__c = 'TH', toRole__c = acc[0].id, fromrole__c = dealer.id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(), Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female'));
            listcampaigns1.add(new Account_Link__c(Retail_Address_Reference__c = address[0].id, Name = 'new al', Md__c = 'TH', toRole__c = acc[0].id, fromrole__c = acc[1].id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                RecordTypeId = contacttocontactid, Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female'));

            insert listcampaigns1;
            TriggerRecursiveCheck.AccountLinkCheck = true;
            List < Account_Link__c > updatelst = new List < Account_Link__c > ();
            listcampaigns1[0].fromrole__c = dealer1.id;

            updatelst.add(listcampaigns1[0]);
            TriggerRecursiveCheck.AccountLinkCheck = true;
            update updatelst;
            Address__C a = new address__C(Address_Type__c = 'Business', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'TH');
            insert a;
            TriggerRecursiveCheck.AccountLinkCheck = true;
            List < Account_link__C > ac = new List < account_link__c > ();
            for (Account_link__C ab: listcampaigns1) {
                ab.Retail_Full_Name__c = 'abc';
                ab.Retail_Gender__c = 'male';
                ab.Retail_Address_Reference__c = a.id;
                ac.add(ab);
            }
            update ac;
            TriggerRecursiveCheck.AccountLinkCheck = true;
            listcampaigns1[0].active__c = false;
            listcampaigns1[0].fromrole__c = dealer1.id;
            update listcampaigns1[0];


        }
        system.runAs(user3) {
            TriggerUtil.userCreate = false;
            acclinklist.add(new Account_Link__c(Retail_Address_Reference__c = address[0].id, Name = 'new al', Md__c = 'TH', toRole__c = acc[0].id, fromrole__c = dealer.id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(), Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female'));
            insert acclinklist;

        }
    }

}