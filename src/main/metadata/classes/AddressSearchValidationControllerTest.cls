@istest
public class AddressSearchValidationControllerTest 
{
    public static Account objAccount;
    public static Account objAccount1;
    public static Account personAcc;
    public static Account personAcc1;
    public static Address__C addressobj ;
    public static user usr;
    
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
        test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.objAccount = objAccount;
        JPAcccontroller.saveAccount();
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
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.Address_Validated_Flag = true;
        //JPAcccontroller.objAccount = objAccount1;
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
        JPAcccontroller.objPersonAccount = objAccount;
        JPAcccontroller.recordType = '012280000000f14AAA';
        JPAcccontroller.selectedRecordType = 'Person Account';
        test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.objPersonAccount = personAcc1;
        JPAcccontroller.saveAccount();
        test.stopTest();  
           
    //}
    }
    //dhanamjaya code
    static testmethod void AddressSearchValidationControllerTest1()
    {
        createTestData();        
        
        ApexPages.currentPage().getParameters().put('recordType','company');
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
        test.stopTest();
        system.assertNotEquals(null, personAcc.id);
    }
    
    static testmethod void AddressSearchValidationControllerTest5()
    {
        createTestData();
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
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
    }
   
    static void createTestData(){
    List<RegionMasterInfo__c> rm= new List<RegionMasterInfo__c>();
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        rg.Province__c='Province1';
        rg.ZipCode__c='05245756';
        rg.Language__c='English';
        rg.District__c='bans';
        rg.Sub_DIstrict__c='subdist';
        rm.add(rg);
         RegionMasterInfo__c rg1=new RegionMasterInfo__c();
        rg1.Province__c='chittoor';
        rg1.ZipCode__c='05245756';
        rg1.Language__c='English';
        rg1.District__c='chittoor';
        rg1.Sub_DIstrict__c='chittoor';
        rm.add(rg1);
        insert rm;
        objAccount= new Account();
        objAccount.RecordtypeId= companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Commercial_Reg_No__c='adfgrt';
        User us=[select market__c from user where id=:UserInfo.getUserId()];
         if(us.market__c=='TH'||us.market__c=='KR'){
        objAccount.ZipCode__c = '14287';
      
        }
        else{
        objAccount.ZipCode__c = '1004287';
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
        try{insert objAccount1;}
      catch(DMLException e)
        {
            system.debug('!!!'+ e);
        }
        
        
        personAcc= new Account();
        personAcc.RecordtypeId= strPerson;
        personAcc.LastName='Test Person 1st';
        personAcc.Status__c='Active';
        personAcc.Province__c='Province1';
        personAcc.City__c='Test';
        
        if(us.market__c=='TH'||us.market__c=='KR'){
        personAcc.ZipCode__c = '14287';
        
        }
        else {
        personAcc.ZipCode__c = '1004287';
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
        addressobj.ZipCode__c = '1040041';
        addressobj.Province__c ='Fukushima';
        addressobj.TitleOfHonor__c = 'To Person';
        
        insert addressobj;
       
        
        
    }
    
        
    static testmethod void AddressSearchValidationControllerTest6()
    {
        createTestData();
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
    
    static testmethod void AddressSearchValidationControllerTest7(){
        createTestData();
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
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.ValidateAddressCode(addressobj);
        JPAcccontroller.getAreacodeItems();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.onLineDeduplication();
        test.stopTest();
        system.assertNotEquals(null, objAccount.id);
        
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
        JPAcccontroller.saveAccountTH();
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
            JPAcccontroller.saveAccountTH();
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
  
  
   static testmethod void AddressSearchValidationControllerTestonLineDeduplicationTH(){
        createTestData();
    ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
        JPAcccontroller.market = 'TH';
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
       
        test.startTest();      
        //  Test.setMock(WebServiceMock.class, new WSMockAddressValidationRespInvalidAddrTH ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='12345';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
         jpAcccontroller.onLineDeduplicationTH();
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        
    } 
     static testmethod void AddressSearchValidationControllerTestonLineDeduplicationKR(){
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
       
        test.startTest();      
        //  Test.setMock(WebServiceMock.class, new WSMockAddressValidationRespInvalidAddrTH ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='12345';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
         jpAcccontroller.onLineDeduplication();
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
        
    } 
    
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
         JPAcccontroller.objAccount.Email__c=null; 
         
        JPAcccontroller.RecordType = 'Company';
       
        test.startTest();      
          Test.setMock(WebServiceMock.class, new WSMockAddressValidationRespAddrSucess ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
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
       
        test.startTest();      
          Test.setMock(WebServiceMock.class, new WSMockAddressValidationResponseFailure ());  
    //jpAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.objPersonAccount.lastname = 'Company'; 
         jpAcccontroller.AddressSearchbyZipCode();
         JPAcccontroller.AddressObj.ZipCode__c='1234523';
         JPAcccontroller.market = 'TH';
         JPAcccontroller.validateAddressByZipCode();
        test.stopTest();
        //system.assertNotEquals(null, objAccount.id);
    } 
}