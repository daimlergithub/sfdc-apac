/*
Type:    Test class
Purpose: Test Class for ContactTableController
---------------------------------------------------------------   
1. Created on 18-Jan-2017  
2: Updated by manjunath 11-05-2017
*/
@istest
public class contactTableControllerTest {
    public static Account objAccount; 
    public static User usr;
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Profile profile;
    private static UserRole role;
    public static string teststring='test';
    static void createTestData() {
        Profile p1 = [select id,name from profile WHERE Name='System Administrator']; 
        usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert usr;
        KR_Switch__c krswitch=new KR_Switch__c(Name='Call Flow Switch',Enable_Flag__c=True);
        List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
        lsttrgt.add(krswitch);
      insert lsttrgt;
      Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         
        system.runAs(usr){
        if (!CDMRCCreation) {
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '000-0000-9642';
        objAccount.Home_Phone_2__c = '000-0000-9642';
        objAccount.Work_Phone__c = '000-0000-9642';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '000-0000-9642';
        objAccount.Area_code__c = '0101';
        objAccount.MD__c = 'KR';
        objAccount.Market__c = 'KR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '1002347';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '000-0000-9642';
        objAccount.Mobile2__c = '000-0000-9642';
        objAccount.Primary_Email__c = 'Email1';
        objAccount.Primary_Fax__c = 'FAX2';
        objAccount.Primary_Phone__c ='Other2';
        insert objAccount; 
        }
        
        else{
        
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '+82-00-000-9642';
        objAccount.Work_Phone__c = '+82-00-000-9642';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '000-0000-9642';
        objAccount.Area_code__c = '0101';
        objAccount.MD__c = 'KR';
        objAccount.Market__c = 'KR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '1002347';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '+82-00-000-9642';
        objAccount.Primary_Email__c = 'Email1';
        objAccount.Primary_Fax__c = 'FAX2';
        objAccount.Primary_Phone__c ='Other2';
        insert objAccount; 
        
       
       } 
    }      
    }
    static void createTestDataSwitch() {
    
        Profile p1 = [select id,name from profile WHERE Name='System Administrator']; 
        usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert usr;
        KR_Switch__c krswitch=new KR_Switch__c(Name='Call Flow Switch',Enable_Flag__c=false);
        List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
        lsttrgt.add(krswitch);
      insert lsttrgt;
      Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         
        system.runAs(usr){
        if (!CDMRCCreation) {
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '000-0000-9642';
        objAccount.Home_Phone_2__c = '000-0000-9642';
        objAccount.Work_Phone__c = '000-0000-9642';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '000-0000-9642';
        objAccount.Area_code__c = '0101';
        objAccount.MD__c = 'KR';
        objAccount.Market__c = 'KR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '1002347';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '000-0000-9642';
        objAccount.Mobile2__c = '000-0000-9642';
        objAccount.Primary_Email__c = 'Email1';
        objAccount.Primary_Fax__c = 'FAX2';
        objAccount.Primary_Phone__c ='Other2';
        insert objAccount; 
        }
        
        else{
       
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '+82-00-000-9642';
        objAccount.Work_Phone__c = '+82-00-000-9642';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '000-0000-9642';
        objAccount.Area_code__c = '0101';
        objAccount.MD__c = 'KR';
        objAccount.Market__c = 'KR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '1002347';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '+82-00-000-9642';
        objAccount.Primary_Email__c = 'Email1';
        objAccount.Primary_Fax__c = 'FAX2';
        objAccount.Primary_Phone__c ='Other2';
        insert objAccount; 
        
        
       } 
    }      
    }
    public static testMethod void PhoneNumberFormatTest() {
    try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormat();
        test.stoptest();
        if (!CDMRCCreation) {
        system.assertEquals(objAccount.Individual_Home_Phone__c,'000-0000-9642');
        }
        else 
        {
         system.assertEquals(objAccount.Individual_Home_Phone__c,'+82-00-000-9642');
        }
       
        }
        catch(Exception e)
        {
        }
    }
    public static testMethod void UpdateAccountTest() {
    try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormat();
        ctc.UpdateAccount();
        test.stoptest();
        if (!CDMRCCreation) {
        system.assertEquals(objAccount.Individual_Home_Phone__c,'000-0000-9642');
        }
        else 
        {
         system.assertEquals(objAccount.Individual_Home_Phone__c,'+82-00-000-9642');
        }
       
        }
        catch(Exception e)
        {
        }
    }
    public static testMethod void EditAccountTest() {
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.EditAccount();
        test.stoptest();
        if (!CDMRCCreation) {
        system.assertEquals(objAccount.MD__c,'KR');
        }
        else 
        {
         system.assertEquals(objAccount.MD__c,'KR');
        }
       
        }
        catch(Exception e)
        {
        }
        
    }
    public static testMethod void AreacodeItemsTest() {
    try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.getAreacodeItems();
        test.stoptest();
        if (!CDMRCCreation) {
         system.assertEquals(objAccount.Area_code__c,'0101');
        }
        else 
        {
         system.assertEquals(objAccount.Area_code__c,'101');
        }
       
        }
        catch(Exception e)
        {
        }
        system.assertEquals(objAccount.Area_code__c,'0101');
    }
    public static testMethod void MobileAreacodeItemsTest() {
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.getMobileAreacodeItems();
        test.stoptest();
       
        if (!CDMRCCreation) {
        system.assertEquals(objAccount.Mobile__c,'000-0000-9642');
        }
        else 
        {
         system.assertEquals(objAccount.Mobile__c,'+82-00-000-9642');
        }
       
        }
        catch(Exception e)
        {
        }
        
    }
    public static testMethod void CancelUpdateTest() {
       try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         createTestData();
         createTestDataSwitch();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.CancelUpdate();
        test.stoptest();
         if (!CDMRCCreation) {
        system.assertEquals(objAccount.Individual_Home_Phone__c,'000-0000-9642');
        }
        else 
        {
         system.assertEquals(objAccount.Individual_Home_Phone__c,'+82-00-000-9642');
        }
       
        }
        catch(Exception e)
        {
        }
    }
    // Manjunath  - This is used for TH
    public static testMethod void EditAccountTHTest() {
        Profile prof = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User1TH',prof,'TH');
        insert US;
        system.runAs(US){
            //createTestData();
            objAccount = TestClassHelper.CreateAccount(US.Market__c,'FirstName','LastName');
            insert objAccount;
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            ContactTableController ctc = new ContactTableController(sc);
            test.startTest();
            ctc.EditAccount();
            test.stoptest();
            system.assertEquals(objAccount.FirstName,'FirstName');
        }
    }
    public static testMethod void UpdateAccountTHTest() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'TH');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            insert objAccount;
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            ContactTableController ctc = new ContactTableController(sc);
            test.startTest();
            //ctc.UpdateAccount(); // before it will be blank then edit will parse the code
            ctc.EditAccount();
			ctc.PhoneNumberFormatTH();
            ctc.UpdateAccount();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'TH');
        }
    }
    // Home code is not null;
    /*public static testMethod void UpdateAccountTHPhoneTest() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'TH');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            insert objAccount;
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            ContactTableController ctc = new ContactTableController(sc);
            test.startTest();
            ctc.PhoneNumberFormatTH();
            ctc.UpdateAccount();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'TH');
        }
    }*/
	public static testMethod void UpdateAccountTHPhoneTest2() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'TH');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '';
            objAccount.Fax = '12121222';
            objAccount.Mobile__c = '';
            objAccount.Work_Phone__c = '';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '';
            ctc.wkCountryCode = '';
            ctc.mbCountryCode = '';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.PhoneNumberFormatTH();
            ctc.UpdateAccountTH();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'TH');
        }
    }
    
    public static testMethod void UpdateAccountTHPhoneTest3() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'TH');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '';
            objAccount.Fax = '';
            objAccount.Mobile__c = '';
            objAccount.Work_Phone__c = '';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '';
            ctc.wkCountryCode = '';
            ctc.mbCountryCode = '';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.PhoneNumberFormatTH();
            ctc.UpdateAccountTH();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'TH');
        }
    }
    public static testMethod void AreacodeItemsKRTest() {
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean CDMRCCreation = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           CDMRCCreation  = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
         
         
        profile = [Select Id from Profile where Name = 'System Administrator'];
         usr = TestClassHelper.createUser('User1KRAcode',profile,'KR');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            createTestData();
            createTestDataSwitch();
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            ContactTableController ctc = new ContactTableController(sc);
            test.startTest();
            List<SelectOption> selectOption =ctc.getAreacodeItems();
            ctc.getMobileAreacodeItems();
            test.stoptest();
            if (!CDMRCCreation) {
       system.assert(selectOption.size()>0);
       system.assertEquals(objAccount.MD__c,'KR');
        }
        else 
        {
        system.assert(selectOption.size()>0);
             system.assertEquals(objAccount.MD__c,'KR');
        }
       }
      }
        catch(Exception e)
        {
        }
      }
    public static testMethod void UpdateAccountANZTest1() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'AU');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '';
            objAccount.Fax = '';
            objAccount.Mobile__c = '';
            objAccount.Work_Phone__c = '';
            objAccount.MD__C ='AU';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '';
            ctc.wkCountryCode = '';
            ctc.mbCountryCode = '';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.EditAccount();
            ctc.UpdateAccount();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'AU');
        }
    }
	
   public static testMethod void UpdateAccountANZTest2() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'AU');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '+61234567894';
            objAccount.Fax = '';
            objAccount.Mobile__c = '+61485745689';
            objAccount.Work_Phone__c = '+61236547896';
            objAccount.MD__C ='AU';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '+61';
            ctc.wkCountryCode = '+61';
            ctc.mbCountryCode = '+61';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.PhoneNumberFormatANZ();
            ctc.UpdateAccountANZ();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'AU');
        }
    }    
 public static testMethod void UpdateAccountANZTest3() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'NZ');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');

            objAccount.Individual_Home_Phone__c = '+6434098941';
            objAccount.Fax = '';
            objAccount.Mobile__c = '+6428574569';

            objAccount.Work_Phone__c = '+6434098941';
            objAccount.MD__C ='NZ';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '+64';
            ctc.wkCountryCode = '+64';
            ctc.mbCountryCode = '+64';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.PhoneNumberFormatANZ();
            ctc.UpdateAccountANZ();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'NZ');
            
        }
    } 
 public static testMethod void UpdateAccountANZTest4() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'NZ');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');

            objAccount.Individual_Home_Phone__c = '+642409894';
            objAccount.Fax = '';
            objAccount.Mobile__c = '+6428574569';

            objAccount.Work_Phone__c = '+642409894';
            objAccount.MD__C ='NZ';
          //  insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '+64';
            ctc.wkCountryCode = '+64';
            ctc.mbCountryCode = '+64';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.checkcountrycodeANZ();
            ctc.PhoneNumberFormatANZ();


            test.stoptest();

            
        }
    }   
 public static testMethod void UpdateAccountANZTest5() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'NZ');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '+6033647896';
            objAccount.Fax = '';
            objAccount.Mobile__c = '+6028574569';
            objAccount.Work_Phone__c = '+6033647896';
            objAccount.MD__C ='NZ';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '+64';
            ctc.wkCountryCode = '+64';
            ctc.mbCountryCode = '+64';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.PhoneNumberFormatANZ();

            test.stoptest();

            
        }
    }   

  public static testMethod void UpdateAccountANZTest7() {
        profile = [Select Id from Profile where Name = 'System Administrator'];
        usr = TestClassHelper.createUser('User2TH',profile,'AU');
        insert usr;
        system.runAs(usr){
            objAccount = TestClassHelper.CreateAccount(usr.Market__c,'FirstName','LastName');
            objAccount.Individual_Home_Phone__c = '';
            objAccount.Fax = '';
            objAccount.Secondary_Email__c = 'test@test.com';
            objAccount.Work_Phone__c = '';
            objAccount.MD__C ='AU';
            insert objAccount;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
            
            ContactTableController ctc = new ContactTableController(sc);
            
            ctc.hmCountryCode = '';
            ctc.wkCountryCode = '';
            ctc.mbCountryCode = '';
            ctc.faxCountryCode = '';
            test.startTest();
            ctc.UpdateAccountANZ();
            test.stoptest();
            system.assertEquals(objAccount.MD__c,'AU');
        }
    }    
   //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to setup test data for MY
      Modified Date: 2017-09-13
  */
  
    @testSetup
    static void setupTestData(){
    List<String> PhoneAreaCodes=new List<String>();
    PhoneAreaCodes.add('Name');
    PhoneAreaCodes.add('Country_Code__c');
    PhoneAreaCodes.add('Mobile_Area_Code__c');
    PhoneAreaCodes.add('Phone_Area_Code__c');
    List<PhoneAreaCode__c> PhoneAreaCodesList=DataFactoryServices.createRecords('PhoneAreaCode__c',PhoneAreaCodes,'',2);
    PhoneAreaCodesList[0].name='Area1';
    PhoneAreaCodesList[0].Country_Code__c='+60';
    PhoneAreaCodesList[0].Mobile_Area_Code__c='32';
    PhoneAreaCodesList[0].Phone_Area_Code__c='89';
    PhoneAreaCodesList[1].name='Area2';
    PhoneAreaCodesList[1].Country_Code__c='+65';
    PhoneAreaCodesList[1].Mobile_Area_Code__c='12';
    PhoneAreaCodesList[1].Phone_Area_Code__c='80';
    insert PhoneAreaCodesList;
    List<String> AccountFields=new List<String>();
    AccountFields.add('Lastname');
    AccountFields.add('Firstname');
    AccountFields.add('Individual_Home_Phone__c');
    AccountFields.add('Work_Phone__c');
    AccountFields.add('fax');
    AccountFields.add('Mobile__c');
    AccountFields.add('MD__c');
    List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',3);
    AccountFieldsList[0].Lastname='Lastname1';
    AccountFieldsList[0].Firstname='Fname1';
    AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
    AccountFieldsList[0].Work_Phone__c='+60825634789541';
    AccountFieldsList[0].fax='+60827896541';
    AccountFieldsList[0].Mobile__c='+609856321478';
    AccountFieldsList[0].MD__c='MY';
    AccountFieldsList[1].Lastname='Lastname2';
    AccountFieldsList[1].Firstname='Fname2';
    AccountFieldsList[1].Individual_Home_Phone__c='';
    AccountFieldsList[1].Work_Phone__c='';
    AccountFieldsList[1].fax='';
    AccountFieldsList[1].Mobile__c='';
    AccountFieldsList[1].MD__c='MY';
    AccountFieldsList[2].Lastname='Lastname3';
    AccountFieldsList[2].Firstname='Fname2';
    AccountFieldsList[2].Individual_Home_Phone__c='+601236547895';
    AccountFieldsList[2].Work_Phone__c='+601234857612';
    AccountFieldsList[2].fax='+601024563075';
    AccountFieldsList[2].Mobile__c='+601798456321';
    AccountFieldsList[2].MD__c='MY';
    insert AccountFieldsList;
   } 
   
     //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */
  static testmethod void testContactTableController()
    {                  
		 profile = [Select Id from Profile where Name = 'System Administrator'];
         usr = TestClassHelper.createUser('User1MYAcode1',profile,'MY');
        insert usr;
        system.runAs(usr){				
        List<Account> AccountObj  =  [SELECT Lastname,Individual_Home_Phone__c,Work_Phone__c,fax,Mobile__c,MD__c,Market__C from Account];
        ApexPages.StandardController objSc1 = new ApexPages.StandardController(AccountObj[0]);
        ContactTableController c1=new ContactTableController(objSc1);
        c1.PhoneNumberFormatMY();
        c1.EditAccount();
        c1.UpdateAccountMY();
        ApexPages.StandardController objSc2 = new ApexPages.StandardController(AccountObj[1]);
        ContactTableController c2=new ContactTableController(objSc2);
        c2.PhoneNumberFormatMY();
        c2.EditAccount();
        c2.UpdateAccountMY();
        ApexPages.StandardController objSc3 = new ApexPages.StandardController(AccountObj[2]);
        ContactTableController c3=new ContactTableController(objSc3);
        c3.PhoneNumberFormatMY();
        c3.EditAccount();
        c3.UpdateAccountMY();
		}
     }  
    
}