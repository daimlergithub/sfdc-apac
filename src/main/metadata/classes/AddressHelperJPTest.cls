/*
    Type:      class
    Purpose:   Test class for AddressHelperJp
    Create By: Sriram kalluri
*/
@isTest
public class AddressHelperJPTest {
     private static Account account;
     private static Address__c address;
     private static User user1;
     private static  profile ProfileAdmin = [select Id from Profile where Name = 'System Administrator'];
     public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
     public static List<Address__c> addresslist =new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
       //create test data
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
       try{
       insert al;}catch(Exception e){}
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
           
       }
         public static testMethod void testUpdatePrimaryAddressOnAccount1(){
         
        
       
        User u =[select id,name from user where profile.name='IntegrationAPI' limit 1];
        
        system.runas(u){
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
    try{
       insert al;}catch(Exception e){}
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
          } 
       }
        Public static testmethod void afterInsetAddressUpdateRetailPersonTest()
        {
        profile p=[select id from Profile where name='Japan Dealer Company Manager'];
        
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser1@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = p.Id,            
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
        System.runAs(usr){
        Account  personAcc = new Account(Dealer_Default_Flag__c=false,
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
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       insert personAcc;
       
        List<Address__c> addlist=new List<Address__c>();
        
        Address__c add=new Address__c();
        add.Customer__c=personAcc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        add.MD__c='JP';
        add.RecordTypeId= Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
      addlist.add(add);
        insert addlist;
       Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=personAcc.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
         Test.Starttest(); 
         AddressHelperJP.afterInsetAddressUpdateRetailPerson(addlist);
           Test.Stoptest();
        
        }
      
       }
       
        Public static testmethod void afterInsetAddressUpdateRetailPersonTest2()
        {
        profile p=[select id from Profile where name='Japan Dealer Company Manager'];
        
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser1@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = p.Id,            
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
        System.runAs(usr){
        Account personAcc = new Account(Dealer_Default_Flag__c=false,
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
       
       insert personAcc;
       
        List<Address__c> addlist=new List<Address__c>();
        
        Address__c add=new Address__c();
        add.Customer__c=personAcc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        add.MD__c='JP';
        add.RecordTypeId= Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
      addlist.add(add);
        insert addlist;
       Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=personAcc.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
         Test.Starttest(); 
         AddressHelperJP.afterInsetAddressUpdateRetailPerson(addlist);
           Test.Stoptest();
        
        }
      
       }
    }