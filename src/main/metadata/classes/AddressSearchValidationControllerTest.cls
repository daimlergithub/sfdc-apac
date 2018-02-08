@istest
public class AddressSearchValidationControllerTest 
{
    public static Account objAccount;
    public static Account objAccount1;
    public static Account personAcc;
    public static Account personAcc1;
    public static Address__C addressobj ;
    public static user usr;
    public static User user1;
    public static User user_Obj; 
    
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  //dhanamjaya code
     static testmethod void AddressSearchValidationControllerTestTH()
    {  
    createTestData();
      //Profile profile = [Select Id from Profile where Name = 'System Administrator'];
       // User us = TestClassHelper.createUser('User1TH',profile,'TH');
        //insert US;      
        //system.runAs(US){
        //objAccount = TestClassHelper.CreateAccount(US.Market__c,'FirstName','LastName');
            //insert objAccount;
        objAccount.email__c='dhandkkd44@gmail.com';
        objAccount.Email2__c='dhandkkd44@gmail.com';
        //update objAccount;
      //  update 
        ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.LanguageSelected='English';
        //JPAcccontroller.market='TH';
        JPAcccontroller.province='chittoor';
        JPAcccontroller.district='chittoor';
        JPAcccontroller.subdistrict='chittoor';
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.onLineDeduplicationTH();
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f0p';
        JPAcccontroller.selectedRecordType = 'Company';
        test.startTest();
        JPAcccontroller.saveAccount();
        system.assertEquals(false,JPAcccontroller.AutoFill);
        JPAcccontroller.objAccount = objAccount;
       // JPAccontroller.objAccount.id=null;
        JPAcccontroller.saveAccount();
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
    //}
    }
        static testmethod void AddressSearchValidationControllerTestKR1()
    {createTestData();
      Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User1TH',profile,'KR');
        insert US;      
        system.runAs(US){
        objAccount.email__c='dhandkkd44@gmail.com';
        objAccount.Email2__c='dhandkkd44@gmail.com';
        objAccount.Market__c='KR';  
        update objAccount;
        
        ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.LanguageSelected='English';
        JPAcccontroller.province='chittoor';
        JPAcccontroller.district='chittoor';
        JPAcccontroller.subdistrict='chittoor';
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.LoadZip();
        JPAcccontroller.getAreacodeItems();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.onLineDeduplicationTH();
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f0p';
        JPAcccontroller.selectedRecordType = 'Company';
         system.assertEquals(true,JPAcccontroller.Address_Validated_Flag);    
        test.startTest();
        //JPAcccontroller.saveAccount();
        JPAcccontroller.objAccount = objAccount;
        //JPAcccontroller.saveAccount();
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
        }
    
    }
    static testmethod void AddressSearchValidationControllerTestTH1()
    {
        //Profile profile = [Select Id from Profile where Name = 'System Administrator'];
       // User us = TestClassHelper.createUser('User1TH',profile,'TH');
        //insert US;      
        //system.runAs(US){
        //objAccount = TestClassHelper.CreateAccount(US.Market__c,'FirstName','LastName');
            //insert objAccount;
        createTestData();
        test.startTest();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.Address_Validated_Flag = true;
        //JPAcccontroller.objAccount = objAccount1;
       JPAcccontroller.LanguageSelected='telugu';
        JPAcccontroller.province='chittoor';
        JPAcccontroller.district='chittoor';
        JPAcccontroller.market='TH';
        JPAcccontroller.generateCDMEndPointURL();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.onLineDeduplicationTH();
        JPAcccontroller.objPersonAccount = objAccount;
        JPAcccontroller.recordType = '012280000000f14AAA';
        JPAcccontroller.selectedRecordType = 'Person Account';
        //test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.objPersonAccount = personAcc1;
        JPAcccontroller.saveAccount();
        JPAcccontroller.onLineDedupSwitchTH();
        //JPAcccontroller.saveAccountTH();
       // JPAcccontroller.SelectedAddress();
        JPAcccontroller.validatephonenumber('9898989898');
         system.assertEquals(true,JPAcccontroller.Address_Validated_Flag);
        test.stopTest();  
           
    //}
    }
    //dhanamjaya code
    static testmethod void AddressSearchValidationControllerTest1()
    {
        createTestData();        
        
        ApexPages.currentPage().getParameters().put('recordType','company');
        Test.setMock(WebServiceMock.class, new WSMockCustomerIdenticationResp());
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f0p';
        JPAcccontroller.selectedRecordType = 'Company';
        JPAcccontroller.LanguageSelected='telugu';
        JPAcccontroller.province='chittoor';
        JPAcccontroller.district='chittoor';
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.onLineDeduplicationTH();
        test.startTest();
        JPAcccontroller.saveAccount();
        system.assertEquals(false,JPAcccontroller.AutoFill);
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.saveAccount();
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
    }
    
    static testmethod void AddressSearchValidationControllerTest2()
    {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.Address_Validated_Flag = true;
        //JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f14AAA';
        JPAcccontroller.selectedRecordType = 'Person Account';
        test.startTest();
        JPAcccontroller.saveAccount();
         system.assertEquals(false,JPAcccontroller.AutoFill);
        JPAcccontroller.objPersonAccount = personAcc1;
        JPAcccontroller.saveAccount();
        test.stopTest();  
           
    }
    
    static testmethod void AddressSearchValidationControllerTest3()
    {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = 'Person Account';
        JPAcccontroller.selectedRecordType = 'Person Account';
        JPAcccontroller.AddressObj =  addressobj;
        test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.Address_Validated_Flag = false;
        JPAcccontroller.saveAccount();
        JPAcccontroller.cancel();
        JPAcccontroller.selectedRecordTypeValue();
        test.stopTest();
        system.assertNotEquals(null, personAcc.id);
    
    }
    
    static testmethod void AddressSearchValidationControllerTest4()
    {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = 'Person Account';
        JPAcccontroller.selectedRecordType = 'Person Account';
      
        test.startTest();
        JPAcccontroller.AddressObj =  addressobj;
        JPAcccontroller.saveAccount();
        JPAcccontroller.cancel();
        JPAcccontroller.selectedRecordTypeValue();
        
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        JPAcccontroller.AddressSearchbyZipCode();
        //JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.saveAccount();
        JPAcccontroller.canceljp();
        JPAcccontroller.AutoFillAddress();
        test.stopTest();
        system.assertNotEquals(null, personAcc.id);
    }
    
    static testmethod void AddressSearchValidationControllerTest5()
    {
        createTestData();
        system.runAs(user1){ 
        addressobj.ZipCode__c = '8989812';
       // addressobj.ZipCode__c = '89812';
        update addressobj;
        
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = 'Company';
        JPAcccontroller.selectedRecordType = 'Company';
        addressobj.Address_Type__c = null;
        try
        {
            update addressobj;
        }
        catch(DMLException e)
        {
            system.debug('!!!'+ e);
        }
        JPAcccontroller.AddressObj =  addressobj;
        test.startTest();
        
        
        JPAcccontroller.saveAccount();
        
        addressobj.Address_Type__c = 'Home';
        update addressobj;
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.saveAccount();
        JPAcccontroller.cancel();
        JPAcccontroller.selectedRecordTypeValue();
        
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        JPAcccontroller.AddressSearchbyZipCode();
        //JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.saveAccount();
        system.assertEquals(true,JPAcccontroller.Address_Validated_Flag);    
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        }
    }
   
    static void createTestData(){
      Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='ja_JP', ProfileId = p1.Id, Market__c='TH',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
       user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TH',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
    system.runAs(user1){    
    List<RegionMasterInfo__c> rm= new List<RegionMasterInfo__c>();
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        rg.Province__c='Province1';
        rg.ZipCode__c='24575';
        rg.Language__c='English';
        rg.District__c='bans';
        rg.Sub_DIstrict__c='subdist';
        rm.add(rg);
         RegionMasterInfo__c rg1=new RegionMasterInfo__c();
        rg1.Province__c='chittoor';
        rg1.ZipCode__c='45756';
        rg1.Language__c='English';
        rg1.District__c='chittoor';
        rg1.Sub_DIstrict__c='chittoor';
        rm.add(rg1);
        insert rm;
        objAccount= new Account();
        objAccount.RecordtypeId= companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Status__c='Active';
        //objAccount.LastName='刈乾冠寒刊勘';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='abcf@hji.com';
        //objAccount.ID_Type__c='National ID';
        //objAccount.ID_Number__c='1234567891234';
        objAccount.Commercial_Reg_No__c='adfgrt';
        User us=[select market__c from user where id=:UserInfo.getUserId()];
         if(us.market__c=='TH'||us.market__c=='KR'){
        objAccount.ZipCode__c = '42875';
      
        }
        else{
        objAccount.ZipCode__c = '14287';
        }
        
        objAccount.Email__c='test@mbj.com';  
        //objAccount.Mobile__c='4444-4444';
        objAccount.Preferred_Language__c='English';      
        objAccount.MBK_Data_Source__c ='Email';
        objAccount.Province__c = 'Province1';
        objAccount.Phone = '08022420181';
        objAccount.Vat_No__c='kdjid';
        objAccount.Preferred_Language__c='telugu';
        objAccount.Province__c='apdff';
        
       

        insert objAccount;
        
        objAccount1 = new Account();
        objAccount1.RecordtypeId= companyAccRecordTypeId;
        objAccount1.Name='Test Person 1st';
        //objAccount1.ID_Type__c='National ID';
        //objAccount1.ID_Number__c='1234567891234';
        try{insert objAccount1;}
      catch(DMLException e)
        {
            system.debug('!!!'+ e);
        }
        
        
        personAcc= new Account();
        personAcc.RecordtypeId= strPerson;
        personAcc.LastName='刈乾冠寒刊勘';
        personAcc.Status__c='Active';
        personAcc.Province__c='Province1';
        personAcc.City__c='Test';
        //personAcc.ID_Type__c='National ID';
        //personAcc.ID_Number__c='1234567891234';
        if(us.market__c=='TH'||us.market__c=='KR'){
        personAcc.ZipCode__c = '42877';
        
        }
        else {
        personAcc.ZipCode__c = '14287';
        }
        personAcc.Email__c='test@mbj.com';
        //personAcc.Mobile__c='4444-4444';
        personAcc.Preferred_Language__c='Engmmm';        
        personAcc.MBK_Data_Source__c ='Email';
        personAcc.Phone = '08022420181';
        personAcc.Province__c = 'Province1';
        personAcc.Commercial_Reg_No__c='adfgrt';
        personAcc.Vat_No__c='kdjid';
        personAcc.Preferred_Language__c='telugu';
        insert personAcc;
        
        personAcc1 = new Account();
        personAcc1.RecordtypeId= strPerson;
        personAcc1.LastName='Test Person 2nd';
        //personAcc1.ID_Type__c='National ID';
        //personAcc1.ID_Number__c='1234567891234';
        try{insert personAcc1;}
        catch(DMLException e){
            
            system.debug('!!! '+ e);
            
        }
        
        
        system.debug('+++++++++++++++++'+addressobj);
        addressobj =new Address__C();
        addressobj =  new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Block__c = 'Block';
        addressobj.Customer__c = objAccount.id;
        addressobj.ZipCode__c = '14941';
        addressobj.Province__c ='Fukushima';
        addressobj.TitleOfHonor__c = 'To Person';
        addressobj.Market__c='TH';
        
        insert addressobj;
       
    }
        
    }
    
        
    static testmethod void AddressSearchValidationControllerTest6()
    {
        createTestData();
        system.runAs(user1){ 
        addressobj.city__c = 'test city';
        addressobj.District__c = 'test district';
        update addressobj;
        
        ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        
        JPAcccontroller.market = 'KR';
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f0p';
        JPAcccontroller.selectedRecordType = 'Company';
        JPAcccontroller.RecordType = 'Company';
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.getMobileAreacodeItems();
        
        JPAcccontroller.market = 'JP';
        JPAcccontroller.getAddressOptions();
        //JPAcccontroller.validateAddressByZipCode();
        test.startTest();        
        JPAcccontroller.saveAccount();
        
        JPAcccontroller.selectedRecordType = 'Person Account';
        JPAcccontroller.RecordType = 'Person Account';
        JPAcccontroller.objPersonAccount = objAccount;
        JPAcccontroller.saveAccount();
        
        
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
        }
    }
    
    static testmethod void AddressSearchValidationControllerTest7(){
        createTestData();
        system.runAs(user1){ 
        addressobj.city__c = 'test city';
        addressobj.District__c = 'test district';
        update addressobj;        
        objAccount1.Individual_Home_Phone__c = '-9999';        
        personAcc.Individual_Home_Phone__c = '-9999';
        
        ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'KR';
        JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = '012280000000f0p';
        JPAcccontroller.selectedRecordType = 'Company';
        JPAcccontroller.RecordType = 'Company';
        test.startTest();      
         Test.setMock(WebServiceMock.class, new WebServiceMockImpl());  
        JPAcccontroller.saveAccount();
        
        JPAcccontroller.selectedRecordType = 'Person Account';
        JPAcccontroller.RecordType = 'Person Account';
        JPAcccontroller.objPersonAccount = objAccount;
        JPAcccontroller.saveAccount();
        JPAcccontroller.AddressSearchbyZipCode();
        //JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.ValidateAddressCode(addressobj);
        JPAcccontroller.getAreacodeItems();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.onLineDeduplication();
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
        }
    }
  //SN20170515
  /*
  Name:Sanjay Nandi
  Description:Added to update the code coverage of the method
  Modified Date: 2017-05-15
  */
  
  
   static testmethod void AddressSearchValidationControllerTestSave(){
        createTestData();
    ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'TH';
         JPAcccontroller.wkAreaCode='';
         JPAcccontroller.wkCountryCode='';
          JPAcccontroller.workPhoneAreaCodePart2='';
           JPAcccontroller.workPhoneAreaCodePart3='';
           JPAcccontroller.hmAreaCode='';
           JPAcccontroller.hmCountryCode='';
           JPAcccontroller.homePhoneAreaCodePart2='';
           JPAcccontroller.homePhoneAreaCodePart3='';
           JPAcccontroller.mbAreaCode='';
           JPAcccontroller.mbCountryCode='';
           JPAcccontroller.mobileAreaCodePart2='';
           JPAcccontroller.mobileAreaCodePart3='';
        //JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objAccount.Individual_Home_Phone__c=null;
         JPAcccontroller.objAccount.id=null;
     JPAcccontroller.objAccount.Mobile__c='+66-023-777-9999';         
         JPAcccontroller.objAccount.Work_Phone__c=null; 
         JPAcccontroller.objAccount.Home_Phone_2__c=null; 
         JPAcccontroller.objAccount.Phone=null; 
         JPAcccontroller.objAccount.Email__c=null; 
        JPAcccontroller.RecordType = 'Company';
        test.startTest();      
    
       // JPAcccontroller.saveAccount();
         JPAcccontroller.saveAccountTH();
         JPAcccontroller.objAccount.Work_Phone__c='+66-03-777-9999'; 
         JPAcccontroller.objAccount.Home_Phone_2__c= '+66-03-777-9999';
         JPAcccontroller.objAccount.Individual_Home_Phone__c='+66-03-777-9999'; 
         JPAcccontroller.objAccount.Email__c='sanjay_nandi@infosys.com.uatdev'; 
         JPAcccontroller.objAccount.Email2__c='sanjay_nandi@infosys.com.uatdev'; 
         JPAcccontroller.saveAccountTH();
         JPAcccontroller.objAccount.id=null; 
         JPAcccontroller.addresspicklist = 'Home';
       JPAcccontroller.saveAccountTH();
       system.assertEquals('TH',JPAcccontroller.market);   
       //JPAcccontroller.saveAccountTH();
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        
    }
    
    
    //SN20170515
  /*
  Name:Sanjay Nandi
  Description:Added to update the code coverage of the method
  Modified Date: 2017-05-15
  */
  
  
   static testmethod void AddressSearchValidationControllerTestSave2(){
        createTestData();
    ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'TH';
    
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objAccount.Individual_Home_Phone__c=null;
         JPAcccontroller.objAccount.id=null;
     JPAcccontroller.objAccount.Mobile__c='+66-023-777-9999';         
         JPAcccontroller.objAccount.Work_Phone__c=null; 
         JPAcccontroller.objAccount.Home_Phone_2__c=null; 
         JPAcccontroller.objAccount.Phone=null; 
         JPAcccontroller.objAccount.Email__c=null; 
         JPAcccontroller.objAccount.Email2__c='sanjay_nandi@infosys.com.uatdev'; 
        JPAcccontroller.RecordType = 'Company';
        test.startTest();      
        //JPAcccontroller.saveAccountTH();
        JPAcccontroller.hmphoneNumber= '+66-03-777-9999';
        JPAcccontroller.wkphoneNumber= '+66-03-777-9999';
        JPAcccontroller.mbphoneNumber= '+66-03-777-9999';
         JPAcccontroller.wkAreaCode='02';
         JPAcccontroller.wkCountryCode='+66';
          JPAcccontroller.workPhoneAreaCodePart2='777';
           JPAcccontroller.workPhoneAreaCodePart3='9999';
           JPAcccontroller.hmAreaCode='02';
           JPAcccontroller.hmCountryCode='+66';
           JPAcccontroller.homePhoneAreaCodePart2='777';
           JPAcccontroller.homePhoneAreaCodePart3='9999';
           JPAcccontroller.mbAreaCode='028';
           JPAcccontroller.mbCountryCode='+66';
           JPAcccontroller.mobileAreaCodePart2='777';
           JPAcccontroller.mobileAreaCodePart3='9999';
            //JPAcccontroller.saveAccountTH();
        JPAcccontroller.objAccount.id=null; 
        JPAcccontroller.addresspicklist = 'Home';
         JPAcccontroller.objAccount.Work_Phone__c='+66-03-777-9999'; 
         JPAcccontroller.objAccount.Home_Phone_2__c= '+66-03-777-9999';
         JPAcccontroller.objAccount.Individual_Home_Phone__c='+66-03-777-9999'; 
         JPAcccontroller.objAccount.Email__c='sanjay_nandi@infosys.com.uatdev'; 
         JPAcccontroller.objAccount.Email2__c='sanjay_nandi@infosys.com.uatdev'; 
       //  JPAcccontroller.saveAccountTH();
         JPAcccontroller.objAccount.id=null; 
         JPAcccontroller.addresspicklist = 'Home';
        // JPAcccontroller.saveAccountTH();
         JPAcccontroller.province='test';
         JPAcccontroller.objAccount.id=null; 
         JPAcccontroller.district='test';
         JPAcccontroller.subdistrict='test';
         JPAcccontroller.zip='12345';
         JPAcccontroller.Addressobj.Address_Line_1__c='12345';
         JPAcccontroller.Addressobj.Address_Line_2__c='12345';
       //  JPAccountroller.Addressobj.Address_Line_1__c='test';
         JPAcccontroller.ShowHideFields();
         JPAcccontroller.saveAccountTH();
    JPAcccontroller.saveAccountTH();      
        test.stopTest();
      }
    
   //SN20170515
  /*
  Name:Sanjay Nandi
  Description:Added to update the code coverage of the method
  Modified Date: 2017-05-15
  */
          
     static testmethod void AddressSearchValidationControllerTestonLineDeduplicationKRSucess(){
        createTestData();
    ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'KR';
        //JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objAccount.Individual_Home_Phone__c=null;
         JPAcccontroller.objAccount.id=null;
     JPAcccontroller.objAccount.LastName='sanjay';
     JPAcccontroller.objAccount.Mobile__c='+66-03-777-9999';         
         JPAcccontroller.objAccount.Work_Phone__c=null; 
         JPAcccontroller.objAccount.Home_Phone_2__c=null; 
         JPAcccontroller.objAccount.Phone=null; 
         JPAcccontroller.objAccount.Email__c='abcd@def.com'; 
         
        JPAcccontroller.RecordType = 'Company';
         JPAcccontroller.saveAccount();
       
        test.startTest();      
          Test.setMock(WebServiceMock.class, new WSMockAddressValidationRespAddrSucess ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
         JPAcccontroller.AutoFill=true;
         jpAcccontroller.AddressSearchbyZipCode();
          JPAcccontroller.market = 'JP';
          jpAcccontroller.ValidateAddressSearchCallout(addressobj);
         
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        
    } 
    
     static testmethod void AddressSearchValidationControllerTestonLineDeduplicationKRFailure(){
        createTestData();
    ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'KR';
        //JPAcccontroller.Address_Validated_Flag = true;
        JPAcccontroller.objAccount = objAccount1;
        JPAcccontroller.objAccount.Individual_Home_Phone__c=null;
         JPAcccontroller.objAccount.id=null;
     JPAcccontroller.objAccount.LastName='sanjay';
     JPAcccontroller.objAccount.Mobile__c='+66-03-777-9999';         
         JPAcccontroller.objAccount.Work_Phone__c=null; 
         JPAcccontroller.objAccount.Home_Phone_2__c=null; 
         JPAcccontroller.objAccount.Phone=null; 
         JPAcccontroller.objAccount.Email__c=null; 
         
        JPAcccontroller.RecordType = 'Company';
       JPAcccontroller.saveAccount();
        test.startTest();      
          Test.setMock(WebServiceMock.class, new WSMockAddressValidationResponseFailure ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
         jpAcccontroller.AddressSearchbyZipCode(); 
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.market = 'TH';
         //JPAcccontroller.AutoFill=true;
         JPAcccontroller.validateAddressByZipCode();
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        
    } 
     static testmethod void testOnLineDeduplicationCDMTH(){
        //Person Account
        CDM_Integration_URLs__c cdm=new CDM_Integration_URLs__c();
         cdm.Country__c='TH';
         cdm.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-SearchPersonAccount?';
         cdm.Name='SearchPersonAccount';
         insert cdm;
         CDM_Integration_URLs__c cdm1=new CDM_Integration_URLs__c();
         cdm1.Country__c='TH';
         cdm1.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-SearchCompanyAccount?';
         cdm1.Name='SearchCompanyAccount';
         insert cdm1;
         CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
         cs.DEFAULT_CALLOUT_TIME__c='1000';
         cs.MAX_CALLOUT_TIME__c='5000';
         cs.Name='CalloutValues';
         insert cs;
        personAcc =new Account();
        personAcc.firstname= 'John';
        personAcc.lastname= 'Leamos';
        personAcc.mobile__c= '+666465';
        personAcc.CDM_UCID__c='12345';
        
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.objPersonAccount = personAcc;
        JPAcccontroller.recordType = 'Person Account';
        JPAcccontroller.selectedRecordType = 'Person Account';
        JPAcccontroller.objAccount = personAcc;
        JPAcccontroller.hmphoneNumber='88888888';
        JPAcccontroller.wkphoneNumber='88888888';
        JPAcccontroller.mbphoneNumber='+6618888888899';
        JPAcccontroller.faxphoneNumber='258';
        insert personAcc;
         
         
        Continuation conti = (Continuation)JPAcccontroller.onLineDeduplicationCDMTH();
        if(conti!=null)
        {
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);
            system.assert(requests.get(JPAcccontroller.requestLabel) != null);
            HttpResponse response = new HttpResponse();
            response.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}');  
            Test.setContinuationResponse(JPAcccontroller.requestLabel, response);
             Object result = Test.invokeContinuationMethod(JPAcccontroller, conti);
             System.assertEquals(null, result); 
        }
        
         // System.assertEquals('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}', JPAcccontroller.result);
        //Comapany Acc1
        personAcc1 = new Account();
        personAcc1.Name='New Organization';
        personAcc1.Company_Name__c='New Organization';
        personAcc1.Work_Phone__c='+6611233132';
        ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
        AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
        JPAcccontroller1.objPersonAccount = personAcc1;
        JPAcccontroller1.recordType = 'Company';
        JPAcccontroller1.selectedRecordType = 'Company';
        JPAcccontroller1.objAccount = personAcc1;

        
       Continuation conti1 = (Continuation)JPAcccontroller1.onLineDeduplicationCDMTH();
        Map<String, HttpRequest> requests1 = conti1.getRequests();
        system.assert(requests1.size() == 1);
        system.assert(requests1.get(JPAcccontroller1.requestLabel) != null);
        HttpResponse response1 = new HttpResponse();
        response1.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc1.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}');  
        Test.setContinuationResponse(JPAcccontroller1.requestLabel, response1);
         Object result1 = Test.invokeContinuationMethod(JPAcccontroller1, conti1);
         System.assertEquals(null, result1);
        
    }
      static testmethod void testOnLineDeduplicationCDMMY(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            CDM_Integration_URLs__c cdm=new CDM_Integration_URLs__c();
             cdm.Country__c='MY';
             cdm.type__c='Person Account';
             cdm.Context__c='Person Account';
             cdm.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-SearchPersonAccount?';
             cdm.Name='SearchPersonAccount';
             insert cdm;
             CDM_Integration_URLs__c cdm1=new CDM_Integration_URLs__c();
             cdm1.Country__c='MY';
             cdm1.type__c='Company';
             cdm1.Context__c='Company';
             cdm1.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-SearchCompanyAccount?';
             cdm1.Name='SearchCompanyAccount';
             insert cdm1;
             CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
             cs.DEFAULT_CALLOUT_TIME__c='1000';
             cs.MAX_CALLOUT_TIME__c='5000';
             cs.Name='CalloutValues';
             insert cs;
             
             
            personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+666465';
            personAcc.ID_Number__c='12312';
            personAcc.UCID__c='12345';
            personAcc.market__c='MY';
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc;
            
           // insert personAcc;
             
          
            Continuation cont2 = (Continuation)JPAcccontroller.onLineDeduplicationMY();
            Map<String, HttpRequest> requests = cont2.getRequests();
            system.assert(requests.size() == 1);
            system.assert(requests.get(JPAcccontroller.requestLabel) != null);
            HttpResponse response = new HttpResponse();
            response.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc.UCID__c+',"AdminClientNum":"'+personAcc.id+'"}]}');  
            Test.setContinuationResponse(JPAcccontroller.requestLabel, response);
             Object result = Test.invokeContinuationMethod(JPAcccontroller, cont2);
             System.assertEquals(null, result);
             // System.assertEquals('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}', JPAcccontroller.result);
            //Comapany Acc1
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='+6611233132';
            personAcc1.Name='New Organization';
            ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
            JPAcccontroller1.objPersonAccount = personAcc1;
            JPAcccontroller1.recordType = 'Company';
            JPAcccontroller1.selectedRecordType = 'Company';
            JPAcccontroller1.objAccount = personAcc1;
            JPAcccontroller1.hmphoneNumber='123456';
           Continuation conti3 = (Continuation)JPAcccontroller1.onLineDeduplicationMY();
            Map<String, HttpRequest> requests1 = conti3.getRequests();
            system.assert(requests1.size() == 1);
            system.assert(requests1.get(JPAcccontroller1.requestLabel) != null);
            HttpResponse response1 = new HttpResponse();
            response1.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc1.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}');  
            Test.setContinuationResponse(JPAcccontroller1.requestLabel, response1);
             Object result1 = Test.invokeContinuationMethod(JPAcccontroller1, conti3);
             System.assertEquals(null, result1);
            }
       
        static testmethod void testSaveMY(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            system.runas(user1){
             
            personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+666465';
            personAcc.ID_Number__c='12312';
            
            personAcc.UCID__c='12345';
            personAcc.market__c='MY';
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc;     
            
            
            JPAcccontroller.hmphoneNumber='123456';
            JPAcccontroller.wkphoneNumber='123456';
            JPAcccontroller.mbphoneNumber='123456';
            JPAcccontroller.faxphoneNumber='123456';
            
            JPAcccontroller.hmAreaCode='12';
            JPAcccontroller.wkAreaCode='12';
            JPAcccontroller.faxAreaCode='12';
            
            JPAcccontroller.faxCountryCode='+65';
            JPAcccontroller.hmCountryCode='+65';
            JPAcccontroller.wkCountryCode='+65';
            JPAcccontroller.checkcountrycode();
            
            JPAcccontroller.faxCountryCode='+60';
            JPAcccontroller.hmCountryCode='+60';
            JPAcccontroller.wkCountryCode='+60';
            JPAcccontroller.checkcountrycode();
            
            JPAcccontroller.saveAccountMY();
            
            
            
            
            
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='+6011233132';
            personAcc1.Name='New Organization';
            personAcc1.Ucid__c='123212132';
            ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
            JPAcccontroller1.objPersonAccount = personAcc1;
            JPAcccontroller1.recordType = 'Company';
            JPAcccontroller1.selectedRecordType = 'Company';
            JPAcccontroller1.objAccount = personAcc1;
            JPAcccontroller1.hmphoneNumber='123456';
            
            JPAcccontroller1.hmphoneNumber='123456';
            JPAcccontroller1.wkphoneNumber='123456';
            JPAcccontroller1.mbphoneNumber='123456';
            JPAcccontroller1.faxphoneNumber='123456';
            
            JPAcccontroller1.hmAreaCode='12';
            JPAcccontroller1.wkAreaCode='12';
            JPAcccontroller1.faxAreaCode='12';
            
            JPAcccontroller1.faxCountryCode='+65';
            JPAcccontroller1.hmCountryCode='+65';
            JPAcccontroller1.wkCountryCode='+65';
            JPAcccontroller1.checkcountrycode();
            
            JPAcccontroller1.faxCountryCode='+60';
            JPAcccontroller1.hmCountryCode='+60';
            JPAcccontroller1.wkCountryCode='+60';
            JPAcccontroller1.checkcountrycode();
            JPAcccontroller1.saveAccountMY();
               }
       }
        
          static testmethod void testSavewithaddressMY(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            system.runas(user1){
             
            personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+666465';
            personAcc.ID_Number__c='12312';
            
            personAcc.UCID__c='12345';
            personAcc.market__c='MY';
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc;     
            
            JPAcccontroller.addressobj =  new Address__C();
            JPAcccontroller.addressobj.Address_Type__c = 'Home';
            JPAcccontroller.addressobj.Address_Line_1__c = 'line 1';
            JPAcccontroller.addressobj.Address_Line_2__c = 'line 2';
            JPAcccontroller.addressobj.Block__c = 'Block';
            JPAcccontroller.addressobj.Customer__c = personAcc.id;
            JPAcccontroller.addressobj.ZipCode__c = '104031';
            JPAcccontroller.addressobj.Province__c ='Fukushima';
            JPAcccontroller.addressobj.District__c ='Fukushima';
            
          
            
            JPAcccontroller.hmphoneNumber='123456';
            JPAcccontroller.wkphoneNumber='123456';
            JPAcccontroller.mbphoneNumber='123456';
            JPAcccontroller.faxphoneNumber='123456';

            
            JPAcccontroller.faxCountryCode='+65';
            JPAcccontroller.hmCountryCode='+65';
            JPAcccontroller.wkCountryCode='+65';
            JPAcccontroller.checkcountrycode();
            
            
            JPAcccontroller.saveAccountMY();
            
            
            
            
            
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='+6011233132';
            personAcc1.Name='New Organization';
            personAcc1.Ucid__c='123212132';
            ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
            JPAcccontroller1.objPersonAccount = personAcc1;
            JPAcccontroller1.recordType = 'Company';
            JPAcccontroller1.selectedRecordType = 'Company';
            JPAcccontroller1.objAccount = personAcc1;
            JPAcccontroller1.hmphoneNumber='123456';
            
            JPAcccontroller1.hmphoneNumber='123456';
            JPAcccontroller1.wkphoneNumber='123456';
            JPAcccontroller1.mbphoneNumber='123456';
            JPAcccontroller1.faxphoneNumber='123456';
            
            JPAcccontroller1.hmAreaCode='12';
            JPAcccontroller1.wkAreaCode='12';
            JPAcccontroller1.faxAreaCode='12';
            
            JPAcccontroller1.faxCountryCode='+65';
            JPAcccontroller1.hmCountryCode='+65';
            JPAcccontroller1.wkCountryCode='+65';
            JPAcccontroller1.checkcountrycode();
            JPAcccontroller1.district='Fukushima';
            JPAcccontroller1.province='Fukushima';
            JPAcccontroller1.zip='12312';
            JPAcccontroller1.addressobj =  new Address__C();
            JPAcccontroller1.addressobj.Address_Type__c = 'Home';
            JPAcccontroller1.addressobj.Address_Line_1__c = 'line 1';
            JPAcccontroller1.addressobj.Address_Line_2__c = 'line 2';
            JPAcccontroller1.addressobj.Block__c = 'Block';
            JPAcccontroller1.addressobj.Customer__c = personAcc.id;
            JPAcccontroller1.addressobj.ZipCode__c = '104031';
            JPAcccontroller1.addressobj.Province__c ='Fukushima';
            JPAcccontroller1.addressobj.District__c ='Fukushima';
            JPAcccontroller1.saveAccountMY();
           }
       }
       
       
       static testmethod void testSavewithaddressMY12(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            system.runas(user1){
             
            personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+666465';
            personAcc.ID_Number__c='12312';
            
            personAcc.UCID__c='12345';
            personAcc.market__c='MY';
            test.startTest();    
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc;     
            
            JPAcccontroller.addressobj =  new Address__C();
            JPAcccontroller.addressobj.Address_Type__c = 'Home';
            JPAcccontroller.addressobj.Address_Line_1__c ='' ;
            JPAcccontroller.addressobj.Address_Line_2__c ='' ;
            JPAcccontroller.addressobj.Block__c = 'Block';
            JPAcccontroller.addressobj.Customer__c = personAcc.id;
            JPAcccontroller.addressobj.ZipCode__c ='' ;
            JPAcccontroller.addressobj.Province__c ='Fukushima';
            JPAcccontroller.addressobj.District__c ='Fukushima';
            
          
            
            JPAcccontroller.hmphoneNumber='123456';
            JPAcccontroller.wkphoneNumber='123456';
            JPAcccontroller.mbphoneNumber='123456';
            JPAcccontroller.faxphoneNumber='123456';

            
            JPAcccontroller.faxCountryCode='+65';
            JPAcccontroller.hmCountryCode='+65';
            JPAcccontroller.wkCountryCode='+65';
            JPAcccontroller.checkcountrycode();
            
            
            JPAcccontroller.saveAccountMY();
            
            
            
            
            
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='+6011233132';
            personAcc1.Name='New Organization';
            personAcc1.Ucid__c='123212132';
            ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
            JPAcccontroller1.objPersonAccount = personAcc1;
            JPAcccontroller1.recordType = 'Company';
            JPAcccontroller1.selectedRecordType = 'Company';
            JPAcccontroller1.objAccount = personAcc1;
            JPAcccontroller1.hmphoneNumber='123456';
            
            JPAcccontroller1.hmphoneNumber='123456';
            JPAcccontroller1.wkphoneNumber='123456';
            JPAcccontroller1.mbphoneNumber='123456';
            JPAcccontroller1.faxphoneNumber='123456';
            
            JPAcccontroller1.hmAreaCode='12';
            JPAcccontroller1.wkAreaCode='12';
            JPAcccontroller1.faxAreaCode='12';
            
            JPAcccontroller1.faxCountryCode='+65';
            JPAcccontroller1.hmCountryCode='+65';
            JPAcccontroller1.wkCountryCode='+65';
            JPAcccontroller1.checkcountrycode();
            JPAcccontroller1.addressobj =  new Address__C();
            JPAcccontroller1.addressobj.Address_Type__c = 'Home';
            JPAcccontroller1.addressobj.Address_Line_1__c = 'line 1';
            JPAcccontroller1.addressobj.Address_Line_2__c = 'line 2';
            JPAcccontroller1.addressobj.Block__c = 'Block';
            JPAcccontroller1.addressobj.Customer__c = personAcc.id;
            JPAcccontroller1.addressobj.ZipCode__c = '104031';
            JPAcccontroller1.addressobj.Province__c ='Fukushima';
            JPAcccontroller1.addressobj.District__c ='Fukushima';
            JPAcccontroller1.saveAccountMY();
            test.stopTest();    
           }
       }
        static testmethod void testPagination(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            system.runas(user1){
            List<account> acclist= new list<account>();
            for(integer i=0;i<12;i++){
                personAcc =new Account();
                personAcc.firstname= 'John';
                personAcc.lastname= 'Leamos';
                personAcc.mobile__c= '+666465';
                personAcc.ID_Number__c='12312';     
                personAcc.UCID__c='12345'+i;
                personAcc.market__c='MY';
                acclist.add(personAcc);
            }
            test.startTest();
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc; 
            JPAcccontroller.DedupAccountList.addall(acclist);
            JPAcccontroller.LastIndex=acclist.size();
            JPAcccontroller.First();
            JPAcccontroller.next();
            JPAcccontroller.previous();
            JPAcccontroller.last();
            system.assertEquals(false,JPAcccontroller.AutoFill);     
            test.stopTest();    
            }
            
            
        }
        
         static testmethod void testSavewithaddressMY13(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            system.runas(user1){
             
            personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+666465';
            personAcc.ID_Number__c='12312';
            
            personAcc.UCID__c='12345';
            personAcc.market__c='MY';
             test.startTest();   
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
            JPAcccontroller.market='MY';
            JPAcccontroller.objPersonAccount = personAcc;
            JPAcccontroller.recordType = 'Person Account';
            JPAcccontroller.selectedRecordType = 'Person Account';
            JPAcccontroller.objAccount = personAcc;     
            
            JPAcccontroller.addressobj =  new Address__C();
            JPAcccontroller.addressobj.Address_Type__c = 'Home';
            JPAcccontroller.addressobj.Address_Line_1__c ='12312' ;
            JPAcccontroller.addressobj.Address_Line_2__c ='12312' ;
            JPAcccontroller.addressobj.Block__c = 'Block';
            JPAcccontroller.addressobj.Customer__c = personAcc.id;
            JPAcccontroller.addressobj.ZipCode__c ='12342' ;
            JPAcccontroller.addressobj.Province__c ='Fukushima';
            JPAcccontroller.addressobj.District__c ='Fukushima';
            JPAcccontroller.province='1231231';
            JPAcccontroller.zip='12312';
            JPAcccontroller.district='1231';
            JPAcccontroller.addressobj.Country__c='Malaysia';
          
            
            JPAcccontroller.hmphoneNumber='123456';
            JPAcccontroller.wkphoneNumber='123456';
            JPAcccontroller.mbphoneNumber='123456';
            JPAcccontroller.faxphoneNumber='123456';

            
            JPAcccontroller.faxCountryCode='+65';
            JPAcccontroller.hmCountryCode='+65';
            JPAcccontroller.wkCountryCode='+65';
            JPAcccontroller.checkcountrycode();
            JPAcccontroller.ShowHideFields();
            
            JPAcccontroller.saveAccountMY();        
            
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='+6011233132';
            personAcc1.Name='New Organization';
            personAcc1.Ucid__c='123212132';
            ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc1);
            JPAcccontroller1.objPersonAccount = personAcc1;
            JPAcccontroller1.recordType = 'Company';
            JPAcccontroller1.selectedRecordType = 'Company';
            JPAcccontroller1.objAccount = personAcc1;
            JPAcccontroller1.hmphoneNumber='123456';
            JPAcccontroller1.province='1231231';
            JPAcccontroller1.zip='12312';
            JPAcccontroller1.district='1231';
            JPAcccontroller.addressobj.Country__c='Malaysia';
            JPAcccontroller1.hmphoneNumber='123456';
            JPAcccontroller1.wkphoneNumber='123456';
            JPAcccontroller1.mbphoneNumber='123456';
            JPAcccontroller1.faxphoneNumber='123456';
            
            JPAcccontroller1.hmAreaCode='12';
            JPAcccontroller1.wkAreaCode='12';
            JPAcccontroller1.faxAreaCode='12';
            
            JPAcccontroller1.faxCountryCode='+65';
            JPAcccontroller1.hmCountryCode='+65';
            JPAcccontroller1.wkCountryCode='+65';
            JPAcccontroller1.checkcountrycode();
            JPAcccontroller1.addressobj =  new Address__C();
            JPAcccontroller1.addressobj.Address_Type__c = 'Home';
            JPAcccontroller1.addressobj.Address_Line_1__c = 'line 1';
            JPAcccontroller1.addressobj.Address_Line_2__c = 'line 2';
            JPAcccontroller1.addressobj.Block__c = 'Block';
            JPAcccontroller1.addressobj.Customer__c = personAcc.id;
            JPAcccontroller1.addressobj.ZipCode__c = '104031';
            JPAcccontroller1.addressobj.Province__c ='Fukushima';
            JPAcccontroller1.addressobj.District__c ='Fukushima';
            JPAcccontroller1.saveAccountMY();
            system.assertEquals(false,JPAcccontroller.AutoFill); 
           test.stopTest();     
           }
       }
}