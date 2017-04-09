@istest
public class AddressSearchValidationControllerTest 
{
   static testMethod void testMethod1(){
        //test method for Opp country Vietnam,New Zealand,China with proper values for product quantity and discounts
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='XYZ',country='China',market__c='KR',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
                TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='salil_patnaik@infosys.com',
                UserName='salil@infosys.com.test');
        insert user1;

        system.runas(user1){
        Account acc=new Account();
        acc.owner=user1;
       // acc.LastName='Test Person';
        //acc.Phone='09844650654';
        acc.Name ='Test';
         acc.Email__c='test@mbau.com';

       // acc.Mobile__c ='1234567890';
        acc.Data_Source__c  ='Test4';
        
         acc.ZipCode__c='312549';
         
         acc.Preferred_Language__c='English';
        acc.md__c='KR';
      acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        insert acc;
        
        /*Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='KR';
        Address.Foreign_Nationals__c=true;
            
        insert address;
        address.MD__c='TH';
        
        update address;*/
        
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        rg.Province__c='ACT';
        rg.ZipCode__c='312549';
        rg.Language__c='English';
        rg.District__c='bans';
        rg.Sub_DIstrict__c='subdist';
        
        
        insert rg;
        
        
        Address__c address=new Address__c();
    
        address.Address_Type__c='Home';
        address.Province__c='ACT';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='KR';
        address.Foreign_Nationals__c=true;
        address.Language__c='English';  
        address.District__c='bans';
        address.Sub_DIstrict__c='subdist';  
        address.ZipCode__c='05245756';
    
        insert Address;
             
        ApexPages.currentPage().getParameters().put('recordType','company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(address);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
       JPAcccontroller.recordType = 'Company';
       JPAcccontroller.selectedRecordType = 'Company';
       
       test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.SaveAccountDetailsTh();
        JPAcccontroller.saveAccountTH();
        JPAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.onLineDeduplication();
        //List<SelectOption> selOpts=JPAcccontroller.getMobileAreacodeItems();
        //List<SelectOption> selOpts1=JPAcccontroller.getAreacodeItems();
   
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
          Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(address);
          JPAcccontroller1.ValidateAddressSearchCallout(address);
        test.stopTest();

            
    }
    }

      static testMethod void testMethod2(){
        //test method for Opp country Vietnam,New Zealand,China with proper values for product quantity and discounts
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='XYZ',country='China',market__c='TH',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
                TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='salil_patnaik@infosys.com',
                UserName='salil@infosys.com.test');
        insert user1;

        system.runas(user1){
        Account acc=new Account();
        acc.owner=user1;
         acc.LastName='Test Person';
        //acc.Phone='09844650654';
        //acc.Name ='Test';
        //acc.Mobile__c ='1234567890';
        acc.Data_Source__c  ='Test4';
        acc.LastName='newacc';
         acc.Email__c='test@mbau.com';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
        insert acc;
       
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        //address.Address_Line_1__c='gkhkh';
        //address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='TH';
        Address.Foreign_Nationals__c=true;
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(address);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
       
       test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.selectedRecordTypeValue();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.cancel();
        JPAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.onLineDeduplication();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.getAreacodeItems();
   
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
        //JPAcccontroller.ValidateAddressSearchCallout(address);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(address);
         JPAcccontroller1.ValidateAddressSearchCallout(address);
        test.stopTest();
    
}
}
static testMethod void testMethod4(){
        //test method for Opp country Vietnam,New Zealand,China with proper values for product quantity and discounts
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='XYZ',country='China',market__c='JP',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
                TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='salil_patnaik@infosys.com',
                UserName='salil@infosys.com.test');
        insert user1;

        system.runas(user1){
        Account acc=new Account();
        acc.owner=user1;
        acc.Phone='09844650654';
        acc.Name ='Test';
        //acc.LastName='Test Person';
        //acc.Mobile__c ='1234567890';
        acc.Data_Source__c  ='Test4';
        acc.md__c='JP';
       acc.Email__c='test011@test.com';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        insert acc;
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
      // address.Address_Line_1__c='testaddress1';
       //address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='JP';
        
        Address.Foreign_Nationals__c=true;
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(acc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
       JPAcccontroller.recordType = 'Person Account';
       JPAcccontroller.selectedRecordType = 'Person Account';
       
       test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.selectedRecordTypeValue();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.onLineDeduplication();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.getAreacodeItems();
   
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
          Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(address);
         JPAcccontroller1.ValidateAddressSearchCallout(address);
        test.stopTest();
    
}
}
  static testMethod void testMethod3(){
        //test method for Opp country Vietnam,New Zealand,China with proper values for product quantity and discounts
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='XYZ',country='China',market__c='JP',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
                TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='salil_patnaik@infosys.com',
                UserName='salil@infosys.com.test');
        insert user1;

        system.runas(user1){
        Account acc=new Account();
        acc.owner=user1;
        //acc.LastName='Test Person';
        acc.Phone='09844650654';
        acc.Name ='Test';
        //acc.Mobile__c ='1234567890';
        acc.Data_Source__c  ='Test4';
         acc.Email__c='test@mbau.com';
        acc.md__c='JP';
        acc.zipcode__c='3254645';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        insert acc;
      
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        //address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='JP';
        address.zipcode__c='3254645';
        Address.Foreign_Nationals__c=true;
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(acc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
       JPAcccontroller.recordType = 'Company';
       JPAcccontroller.selectedRecordType = 'Company';
       
       test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.selectedRecordTypeValue();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.onLineDeduplication();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.getAreacodeItems();
          //JPAcccontroller.SelectedAddress(); 
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
          Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(address);
         JPAcccontroller1.ValidateAddressSearchCallout(address);
        test.stopTest();
    
}
}
static testMethod void testMethod5(){
        //test method for Opp country Vietnam,New Zealand,China with proper values for product quantity and discounts
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='XYZ',country='China',market__c='KR',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
                TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='salil_patnaik@infosys.com',
                UserName='salil@infosys.com.test');
        insert user1;

        system.runas(user1){
        /*Account acc=new Account();
        acc.LastName='Test Person';
        acc.MBK_Data_Source__c='NEW';
        acc.owner=user1;
        //acc.Name ='Test';
        acc.Data_Source__c  ='Test4';
        acc.md__c='KR';
        insert acc;*/
        Account acc=new Account();
        acc.owner=user1;
        //acc.Phone='09844650654';
        acc.Name ='Test';
       // acc.LastName='Test Person';
       // acc.Mobile__c ='1234567890';
        acc.Email__c='test@mbau.com';
        acc.Data_Source__c  ='Test4';
        acc.md__c='KR';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        insert acc;
        
        
        list<account> a=new  list<account> ();
        a.add(acc);
        
        
        
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        rg.Province__c='ACT';
        rg.ZipCode__c='05245756';
        rg.Language__c='English';
        rg.District__c='test2';
        rg.Sub_DIstrict__c='subdist';
        
        
        insert rg;
        
        
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='ACT';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='KR';
        address.Block__c='NewBlock';
        Address.Foreign_Nationals__c=true;
        address.ZipCode__c='05245756';
       address.Language__c='English';
        address.Sub_DIstrict__c='subdist';
            
        insert address;
        map<string,string> newmap=new map<string,string>();
        newmap.put('KR','JP');
        
             
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(acc);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
     JPAcccontroller.recordType = 'Person Account';
       JPAcccontroller.selectedRecordType = 'Person Account';
       test.startTest();
        //JPAcccontroller.SelectedAddress(); 
       JPAcccontroller.Address_Validated_Flag=True;
       List<SelectOption> selOpts=JPAcccontroller.statusOptions;
       JPAcccontroller.addressobj =address;
       JPAcccontroller.objAccountDeDup=acc;
       JPAcccontroller.show=true;
       JPAcccontroller.phoneAreaCodeMapKR=newmap;
       JPAcccontroller.provincepicklist= address.Province__c;
       JPAcccontroller.cResult=a;
        JPAcccontroller.saveAccount();
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.onLineDeduplicationTH();
         JPAcccontroller.onLineDeduplication();
        //JPAcccontroller.getMobileAreacodeItems();
        //JPAcccontroller.getAreacodeItems();
   
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
          Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(address);
         JPAcccontroller1.ValidateAddressSearchCallout(address);
        test.stopTest();

        }    
    }
   public static void init2()
    {    
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',Market__c='KR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1; 
        
        
        Account objAccount= new Account();
        //objAccount.RecordtypeId=PersonaccRTId;
        objAccount.Firstname='Test Person 1st';
        objAccount.LastName='Test Person';
        objAccount.salutation='Mr.';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Home_Phone_2__c = '098765413';    
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        objAccount.Preferred_Language__c='English';
        objAccount.Individual_Home_Phone__c= '0987654132';
        
        insert objAccount;
        
        
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        rg.Province__c='Province1';
        rg.ZipCode__c='05245756';
        rg.Language__c='English';
        rg.District__c='bans';
        rg.Sub_DIstrict__c='subdist';
        
        
        insert rg;
        
        
        
        Address__c objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        objAddress.Province__c='Province1'; 
        objAddress.Address_Type__c = 'Home';  
        objAddress.ZipCode__c ='05245756';
        objAddress.Language__c='English'; 
        objAddress.District__c='bans';
        objAddress.Sub_DIstrict__c='subdist';
        objAddress.Foreign_Nationals__c=true;
        insert objAddress;
        
     
         ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAddress);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
     JPAcccontroller.recordType = 'Person Account';
       JPAcccontroller.selectedRecordType = 'Person Account';
       test.startTest();
       
       JPAcccontroller.Address_Validated_Flag=True;
       List<SelectOption> selOpts=JPAcccontroller.statusOptions;
       JPAcccontroller.addressobj =objAddress;
        JPAcccontroller.saveAccount();
       
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        
         JPAcccontroller.onLineDeduplication();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.getAreacodeItems();
        JPAcccontroller.onLineDeduplicationTH();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(objaddress);
       JPAcccontroller1.ValidateAddressSearchCallout(objaddress);
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
           JPAcccontroller.SelectedAddress(); 
        test.stopTest();
       
       
        
    }
    public static void init3()
    {    
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId() limit 1] ;
    u.market__c='KR';
    update u;
        
        
        Account objAccount= new Account();
        //objAccount.RecordtypeId=PersonaccRTId;
        objAccount.Firstname='Test Person 1st';
        objAccount.LastName='Test Person';
        objAccount.salutation='Mr.';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        //objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Home_Phone_2__c = '098765413';    
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        objAccount.Preferred_Language__c='English';
        objAccount.Individual_Home_Phone__c= '0987654132';
        objAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
        
        insert objAccount;
        
        RegionMasterInfo__c rg=new RegionMasterInfo__c();
        //rg.Province__c='Province1';
        rg.ZipCode__c='05245756';
        rg.Language__c='English';
        rg.District__c='bans';
        rg.Sub_DIstrict__c='subdist';
        
        
        insert rg;
           
        Address__c objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        //objAddress.Province__c='Province1'; 
        objAddress.Address_Type__c = 'Home';  
        //objAddress.ZipCode__c ='05245756';
        objAddress.Language__c='English'; 
        objAddress.District__c='bans';
        objAddress.Sub_DIstrict__c='subdist';
        objAddress.Foreign_Nationals__c=true;
        insert objAddress;
        
        
     
         ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objaccount);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       
     JPAcccontroller.recordType = 'Person Account';
       JPAcccontroller.selectedRecordType = 'Person Account';
       JPAcccontroller.LanguageSelected='English';
     
       test.startTest();
       JPAcccontroller.getAreacodeItems();
       JPAcccontroller.onLineDeduplication();
       JPAcccontroller.onLineDeduplicationTH();
       JPAcccontroller.getAreacodeItems();
       JPAcccontroller.saveAccount();
       JPAcccontroller.LoadProvince();
        JPAcccontroller.SelectedAddress(); 
       
     // AddressSearchValidationController.addressSelectionWrapper adwrp=new AddressSearchValidationController.addressSelectionWrapper();
      
        test.stopTest();
        
    }
     public static void init6()
    {    
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1; 
        
        
        Account objAccount= new Account();
        //objAccount.RecordtypeId=PersonaccRTId;
        objAccount.Firstname='Test Person 1st';
        objAccount.LastName='Test Person';
        objAccount.salutation='Mr.';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        //objAccount.Email2__c = 'testemail2@test.com';
        //objAccount.Home_Phone_2__c = '098765413';    
        //objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        objAccount.Preferred_Language__c='English';
        objAccount.mobile__c=' -9672317237';
        objAccount.work_phone__c=' -9672317237';
        objAccount.Preferred_Language__c='English';
        
        //objAccount.Individual_Home_Phone__c= '0987654132';
        objAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
        
        insert objAccount;
        
        
      
        
        
        Address__c objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        //objAddress.Province__c='Province1'; 
        objAddress.Address_Type__c = 'Home';  
       // objAddress.ZipCode__c ='05245756';
        //objAddress.Language__c='English'; 
        //objAddress.District__c='bans';
       // objAddress.Sub_DIstrict__c='subdist';
        objAddress.Foreign_Nationals__c=False;
        insert objAddress;
        
     
         ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAddress);
        AddressSearchValidationController JPAcccontroller= new AddressSearchValidationController(objSc);
       //List<SelectOption> selOpts=c.ProductCatList;
     JPAcccontroller.recordType = 'Person Account';
       JPAcccontroller.selectedRecordType = 'Person Account';
       test.startTest();
       
       JPAcccontroller.Address_Validated_Flag=False;
       List<SelectOption> selOpts=JPAcccontroller.statusOptions;
       JPAcccontroller.addressobj =objAddress;
        JPAcccontroller.saveAccount();
       
        JPAcccontroller.LoadProvince();
        JPAcccontroller.LoadDistrict();
        JPAcccontroller.LoadSubDistrict();
        JPAcccontroller.ShowHideFields();
        JPAcccontroller.LoadZip();
        JPAcccontroller.ValidateAddress();
        JPAcccontroller.getAddressOptions();
        JPAcccontroller.AddressSearchbyZipCode();
        JPAcccontroller.validateAddressByZipCode();
        
         JPAcccontroller.onLineDeduplication();
        JPAcccontroller.getMobileAreacodeItems();
        JPAcccontroller.getAreacodeItems();
        JPAcccontroller.onLineDeduplicationTH();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       AddressSearchValidationController JPAcccontroller1= new AddressSearchValidationController(objSc);
       JPAcccontroller1.ValidateAddressCode(objaddress);
       JPAcccontroller1.ValidateAddressSearchCallout(objaddress);
          pagereference pr1 =JPAcccontroller.SaveAccountDetailsTh();
          pagereference pr2 =JPAcccontroller.saveAccountTH();
     // addressSelectionWrapper adwrp=new addressSelectionWrapper();
       JPAcccontroller.SelectedAddress(); 
          //AddressSearchValidationController.addressSelectionWrapper adwrp=new AddressSearchValidationController.addressSelectionWrapper(objAddress); 
        test.stopTest();
       
       
        
    }
    
}