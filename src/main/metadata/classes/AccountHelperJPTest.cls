/*
    Type:      class
    Purpose:   Test class for AccountHelperJP
    Create By: Sneha Chail
    Created Date :2/4/2016
*/
@isTest
public with sharing class AccountHelperJPTest 
{
   private static List<Account> accountlist = new List<Account>();
    private static List<Account> accountlist1 = new List<Account>();
   Private static map<id,Account> accountMap =  new map<id,Account>();
   Private static map<id,Account> accountOldMap =  new map<id,Account>();
   private static User user1;
   private static Account personAcc;
   private static Account companyacc; 
   private static Address__c address;
    private static Account account;
    public static user usr;
    public static Account dealer;
        public static Contact con ;
   public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];
     //Create Test data
   public static void createTestData()
   {       
                   //Create Custom Settings         
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
       //insert updatecustomsettings;
       
         Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
         Trigger__c newtrg1 = new Trigger__c(Name= 'TriggerAccount',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                               enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        upsert newtrg1;  
        
         // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
       //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
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
    Public static testmethod void testUpdateAccountFieldsBeforeInsert()
     { 
      createTestData();      
      Test.Starttest();     
      AccountHelperJP.updateAccountFieldsBeforeInsert(accountlist,true);
      Test.Stoptest();
      system.assertEquals(personAcc.Email_Last_Modified_By3__c,UserInfo.getName());
     // system.assertEquals(personAcc.Email_Last_Modified_Date3__c,System.now());
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
        
        
        AccountHelperJP.updateAccountFieldsBeforeUpdate(accountlist,accountMap,true);
      Test.Stoptest();           
    } 
     Public static testmethod void testUpdatePrimaryAddressdisplay()
      {
       createTestData(); 
       Test.Starttest(); 
       AccountHelperJP.updatePrimaryAddressdisplay(accountlist,accountMap,true);
       Test.Stoptest();      
     }  
    Public static testmethod void testUpdatePrimaryContactInformationBeforeInsert()
     {  
      createTestData(); 
      Test.Starttest(); 
       AccountHelperJP.updatePrimaryContactInformationBeforeInsert(accountlist,true);
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
     
       AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(accountlist,accountMap,true);
       AccountHelperJP.updateCompanyAccountNameBeforeInsert(accountlist);
      Test.Stoptest();      
     }
   public static testmethod void testcreateUCID()
     {  
      createTestData(); 
      Test.Starttest();         
       AccountHelperJP.createUCID(accountlist,true);
       System.runAs (usr) {
       AccountHelperJP.CreateRetailCopy(accountlist,true,true);
       }
      AccountHelperJP.handleAfterInsertUpdateEvent(accountlist,accountMap);
      AccountHelperJP.updateRetailCopy(True,True,True,accountlist,accountOldMap);
      AccountHelperJP.handleAfterInsertEvent(accountlist);
      Test.Stoptest();      
     }     
     public static testmethod void testcreateUCID1()
     {  
      createTestData(); 
      Test.Starttest();  
      accountOldMap.put(personAcc.Id,personAcc);    
       personAcc.LastName = 'galaxy123';   
       update personAcc;  
       accountlist.add(personAcc);
      AccountHelperJP.updateRetailCopy(True,True,True,accountlist,accountOldMap);
      Test.Stoptest();      
     }     
      
  }