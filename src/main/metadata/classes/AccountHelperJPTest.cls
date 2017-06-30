/*
Type:      class
Purpose:   Test class for AccountHelperJP
Create By: Sudhir Kumar Acharya
Created Date :2/4/2016
*/
@isTest
public with sharing class AccountHelperJPTest 
{
    private static List<Account> accountlist = new List<Account>();
    private static List<Account> dealeraccountlist = new List<Account>();
    private static List<Account> accountlist1 = new List<Account>();
    Private static map<id,Account> accountMap =  new map<id,Account>();
    Private static map<id,Account> accountOldMap =  new map<id,Account>();
    private static User user1;
    private static Account personAcc;
    private static Account companyacc; 
    private static Address__c address;
    private static Account account;
    public static user usr;
    public static List<Account> listcampaigns;
    public static Account dealer;
    public static Contact con ;
    public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id dealeraddRecordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    //Create Test data
    public static void createTestData()
    {       
        //Create Custom Settings         
        //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
        
        //  Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
        //                      enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        //insert newtrg;
        Trigger__c newtrg1 = new Trigger__c(Name= 'TriggerAccount',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                            enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert newtrg1;  
        
        // create a Dealer
        dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerUser211911@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = DealerDelegatedAdmin.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ContactId=con.id
            );
            
            insert usr;
        }
        
        personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = 'galaxy1',
                                FirstName = 'First Name',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                OwnerId = usr.id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        
        //insert personAcc;
        accountlist.add(personAcc);
        companyacc = new Account(Dealer_Default_Flag__c=false,
                                 Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                 Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                 City__c='Beijing',
                                 Gender__c = 'Male',
                                 Phone = '0801801010',
                                 Area_code__c = '0101',
                                 //MD__c = 'JP',
                                 name = 'tes company name',
                                 //Salutation = 'Unknown',      
                                 Province__c = 'Shanghai',
                                 ZipCode__c= '1003465',
                                 Mobile__c = '024482832',
                                 Mobile2__c = '034456232',
                                 Primary_Email__c = 'Email2',
                                 Primary_Fax__c = 'FAX2',
                                 Primary_Phone__c ='Other2',
                                 MD__c = 'JP',
                                 OwnerId = usr.id,
                                 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        
        //insert companyacc;
        accountlist.add(companyacc);
        insert accountlist;  
        accountOldMap.put(companyacc.Id,companyacc);
        accountOldMap.put(personAcc.Id,personAcc);   
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = accountlist[0].id, ReCordTypeId = RetailPerson);
        insert acclnk;
        for(Account acc: accountlist){
            accountMap.put(acc.Id,acc);
            accountOldMap.put(acc.Id,acc);
        } 
        
    }
    Public static testmethod void testUpdateAccountFieldsBeforeUpdate()
    {
        createTestData(); 
        Test.Starttest(); 
        personAcc.Mobile__c = '054323424';
        personAcc.Mobile2__c = '054234423';
        personAcc.Individual_Home_Phone__c = '06585855';
        personAcc.Home_Phone_2__c = '06742354';
        personAcc.Work_Phone__c = '04564785';
        personAcc.Phone = '02346643';
        personAcc.Email__c = 'test123@test.com';
        personAcc.Email2__c = 'testemail222@test.com';
        personAcc.Email3__c = 'testemail333@test.com';
        personAcc.Primary_Fax__c = 'FAX1';
        personAcc.Primary_Email__c = 'Email2';
        personAcc.Primary_Phone__c = 'Work Mobile';   
        update personAcc;
        dealeraccountlist.add(dealer);
        AccountHelperJP.handleAfterInsertEvent(dealeraccountlist);
        Test.Stoptest();           
    } 
    public static testmethod void testUpdatePrimaryContactInformationBeforeUpdate()
    {  
        createTestData(); 
        Test.Starttest();  
            personAcc.LastName = 'galaxy123';
            personAcc.Gender__c = 'Female';
            //personAcc.Fax= '123456';
            personAcc.Allow_Data_Sharing2__c = 'Yes';
            personAcc.Complaint_Amount__c = 10;
            personAcc.Primary_Fax__c = 'FAX1';
            personAcc.Primary_Email__c = 'Email3';
            personAcc.Primary_Phone__c = 'Home Phone';
            //personAcc.Company_Name_Native_1__c = 'Test ';
            personAcc.Industry = 'Education';
            update personAcc;  
            Test.Stoptest();      
    }
    public static testmethod void testcreate1()
    {  
        createTestData(); 
        Test.Starttest();  
        accountOldMap.put(personAcc.Id,personAcc);    
        personAcc.LastName = 'galaxy123';   
        update personAcc;  
        accountlist.add(personAcc);
        
        Test.Stoptest();      
    }     
    
    
    public static testmethod void testcreateUCID1()
    { 
        List<account> acc=new List<account>();
        test.startTest();
        createTestData();
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_GC_Code__c='12345');
        acc.add(dealer1);
        Group testGroup = new Group();
        testGroup.Name = 'acme23';
        testGroup.DeveloperName = 'ABC';
        INSERT testGroup;
        insert acc;
        
        Test.Stoptest();      
    }     
    
    
    
    @isTest static void updateretailcopyTest()
    {
        User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
            
            Test.StartTest();
            Trigger__c AccountTriggerJP = new Trigger__c(Name= 'TriggerAccount',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                            enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert AccountTriggerJP; 
            listcampaigns=new List<Account>();
            
            Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                              Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                              Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                              City__c='Beijing',
                                              Gender__c = 'Male',
                                              Phone = '0801801110',
                                              Area_code__c = '0101',
                                              //MD__c = 'JP',
                                              LastName = 'galaxy1',
                                              FirstName = 'First Name',
                                              Salutation = 'Unknown',      
                                              Province__c = 'Shanghai',
                                              ZipCode__c= '1002347',
                                              Mobile__c = '023482832',
                                              Mobile2__c = '035456232',
                                              Primary_Email__c = 'Email1',
                                              Primary_Fax__c = 'FAX2',
                                              Fax='035456232',
                                              Primary_Phone__c ='Other2',
                                              Allow_Data_Sharing2__c='No Choice Yet',  
                                              MD__c = 'JP',
                                              Industry = 'Other',
                                              Dealer_Rollout_Status__c ='Done',
                                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
            
            insert personAcc14;
            
            Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                              Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                              Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                              City__c='Beijing',
                                              Gender__c = 'Male',
                                              Phone = '0801801110',
                                              Area_code__c = '0101',
                                              //MD__c = 'JP',
                                              LastName = 'galaxy1',
                                              FirstName = 'First Name',
                                              Salutation = 'Unknown',      
                                              Province__c = 'Shanghai',
                                              ZipCode__c= '1002347',
                                              Mobile__c = '023482832',
                                              Mobile2__c = '035456232',
                                              Primary_Email__c = 'Email1',
                                              Primary_Fax__c = 'FAX2',
                                              Fax='035456232',
                                              Primary_Phone__c ='Other2',
                                              Allow_Data_Sharing2__c='No Choice Yet',  
                                              MD__c = 'JP',
                                              Industry = 'Other',
                                              
                                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
            
            listcampaigns.add(personAcc13);
            insert listcampaigns;  
            
            Account_Link__c al=new Account_Link__c(Name='new al',
                                                   toRole__c=listcampaigns[0].id,
                                                   fromRole__c=personAcc14.id,
                                                   RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
                                                  );
            
            insert al;
            Account listCampaign =[select Name,MBK_Data_Source__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
            list<Account> oldList = new  list<Account>();
            oldList.add(listCampaign);
            map<id,Account> oldMap = new map<id,Account>();
            oldMap.put(listCampaign.id, listCampaign);
            personAcc13.LastName = 'galaxy2';
            personAcc13.Fax='035456232';
            personAcc13.Allow_Data_Sharing2__c='Yes';
            personAcc13.Gender__c='Female';
            personAcc13.Individual_Home_Phone__c = '046234864';
            personAcc13.Work_Phone__c = '023482321';
            personAcc13.Mobile__c = '023382832';
            personAcc13.Email__c = 'testemail1@test.com';
            personAcc13.Primary_Phone__c ='Other1';
            update personAcc13;
            update listcampaigns;
            
            
            
            
            Test.StopTest();
            system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
    }
    @isTest static void updateretailcopyTest3()
    {
        User thisUser = [ select Id,ContactId,Email,Market__c from User where Market__c='JP' and isactive=true and Profile.Name != 'IntegrationAPI' limit 1];
       	List<Vehicle_Relationship__c> vRList = new List<Vehicle_Relationship__c>();
        System.runAs(thisUser){
            
            Test.StartTest();
            Trigger__c AccountTriggerJP = new Trigger__c(Name= 'TriggerAccount',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                            enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert AccountTriggerJP;
            listcampaigns=new List<Account>();
            
            Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                              Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                              Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                              City__c='Beijing',
                                              Gender__c = 'Male',
                                              Phone = '0801801010',
                                              Area_code__c = '0101',
                                              //MD__c = 'JP',
                                              name = 'tes company name',
                                              //Salutation = 'Unknown',      
                                              Province__c = 'Shanghai',
                                              ZipCode__c= '1003465',
                                              Mobile__c = '024482832',
                                              Mobile2__c = '034456232',
                                              Primary_Email__c = 'Email2',
                                              Primary_Fax__c = 'FAX2',
                                              Primary_Phone__c ='Other2',
                                              MD__c = 'JP',
                                              
                                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            listcampaigns.add(personAcc14);
            
            Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                              Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                              Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                              City__c='Beijing',
                                              Gender__c = 'Male',
                                              Fax='025645435',
                                              Phone = '0801801010',
                                              Area_code__c = '0101',
                                              //MD__c = 'JP',
                                              name = 'tes company name',
                                              //Salutation = 'Unknown', 
                                              Company_Name__c='test',
                                              Company_Legal_form__c='Stock company',
                                              Company_Legal_Form_text__c='test',
                                              Commercial_Reg_No__c='test',     
                                              Province__c = 'Shanghai',
                                              ZipCode__c= '1003465',
                                              Mobile__c = '024482832',
                                              Mobile2__c = '034456232',
                                              Primary_Email__c = 'Email2',
                                              Primary_Fax__c = 'FAX2',
                                              Primary_Phone__c ='Other2',
                                              MD__c = 'JP',
                                              
                                              RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            
            listcampaigns.add(personAcc13);
            insert listcampaigns; 
            
            Map<String,String> TranslateMap= UtilAddressTranslation.gettranslatedAccName('JP');
            Address__c add=new Address__c();
            add.Customer__c=personAcc13.id;
            add.Province__c='Gunma';
            add.City__c='Hyd';
            add.District__c='RR DIst';
            add.Block__c='New gad';
            add.RecordTypeId=Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            add.Address_Line_1__c='Dilsukhnagar';
            add.Address_Line_2__c ='Dilsukhnagar';
            add.Address_Type__c='Business';
            insert add;
            
            personAcc13.Primary_Address_Reference__c=add.id;
            update personAcc13;
            update listcampaigns;
            
            Vehicle__c  vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                                                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                                                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
            insert vehicles;
            
            Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE,Vehicle_Phone_picklist__c = 'Home Phone',vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel.Contact__c = personAcc13.id;
            vRel.Vehicle_ID__c = vehicles.id;
            vRel.End_Date__c = null;
            vRel.Vehicle_address_picklist__c = '--None--';
            vRList.add(vRel);
            insert vRList;
            
            Account_Link__c al=new Account_Link__c(Name='new al',
                                                   toRole__c=personAcc14.id,
                                                   RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
                                                  );
            
            insert al;
            map<id,Account> oldMap = new map<id,Account>();
            oldMap.put(personAcc13.id, personAcc13);
            AccountHelperJP.handleAfterInsertUpdateEvent(listCampaigns,oldmap);
            Test.StopTest();
        }
    }
}