/*
Type:       Test Class
Purpose:    Test On AddressDisplayInlineEditController
Created by: Sravanthi Gudibandi
Created Date:15-March-2018
*/

@isTest
public class AddressDisplayInlineEditControllerINTest 
{
    public static Account objAccount;
    public static Address__c objaddress;
    public static RegionMasterInfo__c objRegMaster;
    public static Id editaddressId;
    public static Id addressId;
    public static Address__c addressobj;
    public static List<Address__c> editadds;
    public static User sysAdminUser1;
    public static User sysAdminUser2; 
    
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static string PersonaccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    
    public static  testMethod void SaveAddressINtest1() {
        initIN();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditCtrl = new AddressDisplayInlineEditController(objSc);
        
        test.startTest();
        objAddressDisplayInlineEditCtrl.addressobj = objaddress;
        objAddressDisplayInlineEditCtrl.market = 'IN';
        objAddressDisplayInlineEditCtrl.addressId = objaddress.Id; 
        objAddressDisplayInlineEditCtrl.editaddressId = addressId;  
        objAddressDisplayInlineEditCtrl.aid = objAccount.Id;
        objAddressDisplayInlineEditCtrl.province = 'test'; 
        objAddressDisplayInlineEditCtrl.district = 'test';  
        objAddressDisplayInlineEditCtrl.subdistrict = 'test'; 
        objAddressDisplayInlineEditCtrl.zip = '123456';
        objAddressDisplayInlineEditCtrl.LanguageSelected = 'English';
        objAddressDisplayInlineEditCtrl.IsForeignNational = true;
        objAddressDisplayInlineEditCtrl.Validation = false;
        objAddressDisplayInlineEditCtrl.addresspicklist = 'test';
        objAddressDisplayInlineEditCtrl.addressobj.Country__c = 'India';
        objAddressDisplayInlineEditCtrl.addressobj.Foreign_Nationals__c = true;
        objAddressDisplayInlineEditCtrl.addressobj.preferred__c = true;
        objAddressDisplayInlineEditCtrl.addressobj.Address_Type__c = 'Home';
        objAddressDisplayInlineEditCtrl.addressobj.ZipCode__c = '123456';
        objAddressDisplayInlineEditCtrl.addressobj.Address_Line_1__c = 'test';
        objAddressDisplayInlineEditCtrl.addressobj.Province__c = 'test';
        objAddressDisplayInlineEditCtrl.addressobj.District__c = 'test';
        //objAddressDisplayInlineEditCtrl.updateHidefields();
        objAddressDisplayInlineEditCtrl.ShowHideFields();
        objAddressDisplayInlineEditCtrl.SaveAddressIN();
        objAddressDisplayInlineEditCtrl.EditOptions();
        test.stopTest();
    }
    public static testMethod void testCancelEdit()
    {
        initIN();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);        
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditCtrl = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditCtrl.addressobj = editadds[0];
        objAddressDisplayInlineEditCtrl.market = 'IN';
        objAddressDisplayInlineEditCtrl.addressId = objaddress.Id; 
        objAddressDisplayInlineEditCtrl.editaddressId = addressId;  
        objAddressDisplayInlineEditCtrl.aid = objAccount.Id;
        objAddressDisplayInlineEditCtrl.province = 'test1'; 
        objAddressDisplayInlineEditCtrl.district = 'test1';  
        objAddressDisplayInlineEditCtrl.subdistrict = 'test1'; 
        objAddressDisplayInlineEditCtrl.zip = '123456';
        objAddressDisplayInlineEditCtrl.LanguageSelected = 'English';
        objAddressDisplayInlineEditCtrl.IsForeignNational = false;
        objAddressDisplayInlineEditCtrl.Validation = false;
        objAddressDisplayInlineEditCtrl.addresspicklist = 'test1';
        objAddressDisplayInlineEditCtrl.addressobj.Country__c = 'India';
        objAddressDisplayInlineEditCtrl.addressobj.Foreign_Nationals__c = false;
        objAddressDisplayInlineEditCtrl.addressobj.preferred__c = false;
        objAddressDisplayInlineEditCtrl.addressobj.Address_Type__c = 'Home';
        objAddressDisplayInlineEditCtrl.addressobj.ZipCode__c = '12345678';
        objAddressDisplayInlineEditCtrl.addressobj.Address_Line_1__c = 'test1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
        objAddressDisplayInlineEditCtrl.addressobj.Address_Line_2__c = 'test1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
        objAddressDisplayInlineEditCtrl.addressobj.Address_Line_3__c = 'test1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
        objAddressDisplayInlineEditCtrl.addressobj.Province__c = 'test';
        objAddressDisplayInlineEditCtrl.addressobj.District__c = 'test';
        objAddressDisplayInlineEditCtrl.SaveAddressIN();
        objAddressDisplayInlineEditCtrl.EditOptions();
        objAddressDisplayInlineEditCtrl.cancelEdit();
        test.stopTest();
        system.assertEquals(null,addressobj);
    }
    public static testMethod void testLoadData()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.loadData();
        test.stopTest();
        system.assertEquals(objAddress.Customer__c, objAccount.id);
        
    }
    
  
        
    public static testMethod void testSaveAddress()
    {
        init();        
        test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
        objAddressDisplayInlineEditController.EditOptions();
        objAddressDisplayInlineEditController.saveAddress(); 
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.Validation=false;
        objAddressDisplayInlineEditController.saveAddress();
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.saveAddress();       
        objAddressDisplayInlineEditController.editaddressId=editadds[0].Id;
        objAddressDisplayInlineEditController.saveAddress();        
        objAddressDisplayInlineEditController.editaddressId=editadds[0].Id;
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.Validation=true;
        objAddressDisplayInlineEditController.saveAddress();
        objAddressDisplayInlineEditController.ValidateAddressCode(editadds[0]);
        AddressDisplayInlineEditController.addressSelectionWrapper addWrap = new AddressDisplayInlineEditController.addressSelectionWrapper(editadds[0]);
        test.stopTest();
        system.assertEquals(null, editaddressId, objaddress);
        
    }
    
    public static testMethod void testSaveAddressIN()
    {
        init();        
        test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
        objAddressDisplayInlineEditController.EditOptions();
        objAddressDisplayInlineEditController.saveAddressIN(); 
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.Validation=false;
        objAddressDisplayInlineEditController.saveAddressIN();
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.saveAddressIN();       
        objAddressDisplayInlineEditController.editaddressId=editadds[0].Id;
        objAddressDisplayInlineEditController.saveAddressIN();        
        objAddressDisplayInlineEditController.editaddressId=editadds[0].Id;
        objAddressDisplayInlineEditController.Address_Validated_Flag=true;
        objAddressDisplayInlineEditController.Validation=true;
        objAddressDisplayInlineEditController.saveAddressIN();
        objAddressDisplayInlineEditController.ValidateAddressCode(editadds[0]);
        objAddressDisplayInlineEditController.saveAddressIN();
        objAddressDisplayInlineEditController.IsForeignNational=true;
        objAddressDisplayInlineEditController.Validation=true;
        
        AddressDisplayInlineEditController.addressSelectionWrapper addWrap = new AddressDisplayInlineEditController.addressSelectionWrapper(editadds[0]);
        test.stopTest();
        system.assertEquals(null, editaddressId, objaddress);
        
    }
    public static testMethod void testAddEditOptions()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.addEditOptions();
        objAddressDisplayInlineEditController.LoadProvince();
        objAddressDisplayInlineEditController.ShowpageBlockFlag =false;
        
        test.stopTest();
        system.assertEquals(objAddress.Customer__c, objAccount.id);
        
        
    }
    
   
    
    public static testMethod void testEditOptions()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);       
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.editaddressId =objaddress.id;
        objAddressDisplayInlineEditController.LanguageSelected='';
        objAddressDisplayInlineEditController.market = 'TH';
        objAddressDisplayInlineEditController.addressobj = editadds[0];
        objAddressDisplayInlineEditController.addressobj.Province__c = null;
        objAddressDisplayInlineEditController.EditOptions();
        test.stopTest();
        system.assertEquals(null,editaddressId,objaddress.Id);
    }
    
   
    
    public static testMethod void testDelAccountAddress()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);       
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.editaddressId =objaddress.id;
        objAddressDisplayInlineEditController.addressId=objaddress.Id;
        objAddressDisplayInlineEditController.addressobj = editadds[0];
        objAddressDisplayInlineEditController.delAccountAddress();
        test.stopTest();
        system.assertEquals(null,addressId);
        system.assertNotEquals(objaddress.id,editaddressId);
        
        }
  
        /**public static testMethod void testValidateAddressSearch()
    {  
    init(); 
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
    ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
    AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
    objAddressDisplayInlineEditController.ValidateAddressSearch();
    test.stopTest();  
    system.assert(objAddressDisplayInlineEditController.addressobj!=Null);        
    }**/
     
    public static testMethod void testZipCodeValidateAddressSearch()
    {  
        
        init();
        test.startTest();
        system.RunAs(sysAdminUser1){
            
            
            ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
            objAddressDisplayInlineEditController.addressobj=editadds[0];
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            objAddressDisplayInlineEditController.ValidateAddressSearch();
            
            system.assert(objAddressDisplayInlineEditController.addressobj!=Null);  
        }  
        test.stopTest();            
    }
  
    public static testMethod void testAddressSearch()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);     
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.AddressSearch(); 
        //If ZipCode is not null
        objAddressDisplayInlineEditController.addressobj=editadds[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.AddressSearch();       
        test.stopTest();
        system.assert(objAddressDisplayInlineEditController.addressobj!=Null);
    }  
    
        
    public static void init()
    {    
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
        User user_Obj = new User(LastName='User'+System.Today(),Market__c='MY',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        //insert user_Obj;
        DMLManagerService.insertAsSystem(user_Obj);
        system.runAs(user_Obj)
        {
            // Fetch Profile Id
            Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1].ID;
            
            // Create User
            List<User> userList = new List<User>();
            sysAdminUser1 = new User ( Alias = 'sysA1'
                                      , Email='sysAdmin1@dialmer.com'
                                      , EmailEncodingKey='UTF-8'
                                      , LastName='Adminstrator'
                                      , FirstName='System'
                                      , LanguageLocaleKey='en_US'
                                      , LocaleSidKey='en_US'
                                      , ProfileId = sysAdminProfileId
                                      , TimeZoneSidKey='America/Los_Angeles'
                                      , Market__c = 'JP'
                                      , UserName='sysAdmin1@mbj.daimler-apac.com.asiadev1'+String.valueof(DateTime.now().getTime()));
            userList.add(sysAdminUser1);
            
            sysAdminUser2 = new User ( Alias = 'sysA2'
                                      , Email='sysAdmin2@dialmer.com'
                                      , EmailEncodingKey='UTF-8'
                                      , LastName='Adminstrator'
                                      , FirstName='System'
                                      , LanguageLocaleKey='en_US'
                                      , LocaleSidKey='en_US'
                                      , ProfileId = sysAdminProfileId
                                      , TimeZoneSidKey='America/Los_Angeles'
                                      , Market__c = 'KR'
                                      , UserName='sysAdmin2@mbj.daimler-apac.com.asiadev1'+String.valueof(DateTime.now().getTime()));
            userList.add(sysAdminUser2);
            insert userList;
            
            // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            //insert updatecustomsettings;
            Trigger__c TriggerAccount=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
            insert TriggerAccount;
            
            objAccount= new Account();
            objAccount.RecordtypeId=PersonaccRTId;
            objAccount.Firstname='刈乾冠寒刊勘';
            objAccount.LastName='刈乾冠寒刊勘';
            objAccount.salutation='Mr.';
            objAccount.Type='Personal';
            objAccount.Status__c='Active';
            objAccount.Province__c='Province1';
            objAccount.City__c='Test';
            objAccount.Email__c='test@mbau.com';
            objAccount.Email2__c = 'testemail2@test.com';
            //objAccount.Home_Phone_2__c = '098-876-4134';    
            objAccount.PersonMobilePhone ='8884545243';
            objAccount.Partner_Surname__c='Test Person';
            objAccount.MBK_Data_Source__c ='Email';
            objAccount.MD__c = 'JP';
            //objAccount.Mobile__c = '999999999';
            
            
            system.runas(sysAdminUser1){
                insert objAccount;
            }
            
            
            objAddress= new Address__c();
            objAddress.Customer__c=objAccount.Id;
            objAddress.TitleOfHonor__c = 'To Person';       
            objAddress.Preferred__c=true;
            objAddress.Province__c='ACT'; 
            objAddress.Address_Type__c = 'Home';  
            objAddress.ZipCode__c ='1234567'; 
            objAddress.MD__c = 'JP';
            objAddress.Address_Line_1__c = 'Banglore';
            objAddress.Address_Line_2__c = 'Test Address 2';
            objAddress.Block__c = 'Test Block';
            objAddress.City__c = 'Test City';
            objAddress.District__c = 'Test District';
            objAddress.Language__c = 'English';
            objAddress.Sub_District__c = 'Test Sub District';
            system.runas(sysAdminUser1){
                insert objAddress;
            }
            
            system.debug('objAddress>>>>>'+objAddress.Id);
            
            editadds = [Select id,Name,market__c,md__c,isTestrunning__c,Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                        Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Id =:objAddress.Id];
            system.debug('editadds>>>'+editadds);
            editadds[0].Preferred__c=false;
            editadds[0].Province__c='NSW';
            editadds[0].isTestrunning__c=true;
            //editadds[0].Address_Type__c ='Company';        
            update editadds;
            
            RegionMasterInfo__c RMObj=new RegionMasterInfo__c();
            RMObj.Province__c = 'NSW';
            RMObj.District__c = 'Test District';
            RMObj.Language__c = 'English';
            RMObj.Sub_DIstrict__c = 'Test Sub District';
            RMObj.ZipCode__c = '1234567';
            insert RMObj;
            
        }
    }
    
    
    public static void initIN()
    {    
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
        User user_Obj = new User(LastName='User'+System.Today(),Market__c='IN',country='India',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='Asia/Kolkata',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@infosys.com',UserName='testUser@Name.com'+String.valueof(DateTime.now().getTime()));
        //insert user_Obj;
        DMLManagerService.insertAsSystem(user_Obj);
        system.runAs(user_Obj)
        {
            // Fetch Profile Id
            Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1].ID;
            
            // Create User
            List<User> userList = new List<User>();
            sysAdminUser1 = new User ( Alias = 'sysA1'
                                      , Email='sysAdmin1@dialmer.com'
                                      , EmailEncodingKey='UTF-8'
                                      , LastName='Adminstrator'
                                      , FirstName='System'
                                      , LanguageLocaleKey='en_US'
                                      , LocaleSidKey='en_US'
                                      , ProfileId = sysAdminProfileId
                                      , TimeZoneSidKey='Asia/Kolkata'
                                      , Market__c = 'IN'
                                      , UserName='testUser@Name1.com'+String.valueof(DateTime.now().getTime()));
            userList.add(sysAdminUser1);
            
            //insert updatecustomsettings;
            Trigger__c TriggerAccount=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
            insert TriggerAccount;
            
            objAccount= new Account();
            objAccount.RecordtypeId=PersonaccRTId;
            objAccount.Firstname='test1';
            objAccount.LastName='test2';
            objAccount.salutation='Mr.';
            objAccount.Type='Personal';
            objAccount.Status__c='Active';
            objAccount.Province__c='test';
            objAccount.City__c='test';
            objAccount.Email__c='test@test.com';
            objAccount.Email2__c = 'testemail2@test.com';   
            objAccount.PersonMobilePhone ='+911234567890';
            objAccount.Partner_Surname__c='Test Person';
            objAccount.MBK_Data_Source__c ='Email';
            objAccount.MD__c = 'IN';
            
            system.runas(sysAdminUser1){
                insert objAccount;
            }
            
            
            objAddress= new Address__c();
            objAddress.Customer__c=objAccount.Id;
            objAddress.TitleOfHonor__c = 'To Person';       
            objAddress.Preferred__c=true;
            objAddress.Province__c='test'; 
            objAddress.Address_Type__c = 'Home';  
            objAddress.ZipCode__c ='123456'; 
            objAddress.MD__c = 'IN';
            objAddress.Country__c = 'India';
            objAddress.Address_Line_1__c = 'test';
            objAddress.Address_Line_2__c = 'test';
            objAddress.Block__c = 'test';
            objAddress.City__c = 'test';
            objAddress.District__c = 'test';
            objAddress.Language__c = 'English';
            objAddress.Sub_District__c = 'test';
            system.runas(sysAdminUser1){
                insert objAddress;
            }
            system.debug('objAddress>>>>>'+objAddress.Id);
            
            editadds = [Select id,Name,market__c,md__c,isTestrunning__c,Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                        Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Id =:objAddress.Id];
            system.debug('editadds>>>'+editadds);
            editadds[0].Preferred__c=false;
            editadds[0].Province__c='test1';
            editadds[0].isTestrunning__c=true;
            //editadds[0].Address_Type__c ='Company';        
            update editadds;
            
            RegionMasterInfo__c RMObj=new RegionMasterInfo__c();
            RMObj.Province__c = 'test';
            RMObj.District__c = 'test';
            RMObj.Language__c = 'English';
            RMObj.Sub_DIstrict__c = 'test';
            RMObj.ZipCode__c = '123456';
            insert RMObj;
        }
    }
  
        
    public static void initUpdated(String MD)
    {    
        // Fetch Profile Id
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1].ID;
        
        // Create User
        List<User> userList = new List<User>();
        sysAdminUser1 = new User ( Alias = 'sysA1'
                                  , Email='sysAdmin1@dialmer.com'
                                  , EmailEncodingKey='UTF-8'
                                  , LastName='Adminstrator'
                                  , FirstName='System'
                                  , LanguageLocaleKey='en_US'
                                  , LocaleSidKey='en_US'
                                  , ProfileId = sysAdminProfileId
                                  , TimeZoneSidKey='America/Los_Angeles'
                                  , Market__c = MD
                                  , UserName='sysAdmin1@mbj.daimler-apac.com.asiadev1');
        userList.add(sysAdminUser1);
        sysAdminUser2 = new User ( Alias = 'sysA2'
                                  , Email='sysAdmin2@dialmer.com'
                                  , EmailEncodingKey='UTF-8'
                                  , LastName='Adminstrator'
                                  , FirstName='System'
                                  , LanguageLocaleKey='en_US'
                                  , LocaleSidKey='en_US'
                                  , ProfileId = sysAdminProfileId
                                  , TimeZoneSidKey='America/Los_Angeles'
                                  , Market__c = MD
                                  , UserName='sysAdmin2@mbj.daimler-apac.com.asiadev1');
        userList.add(sysAdminUser2);
        
        insert userList;
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        List<Trigger__c> updatecustomsettingsTH =  UtilCustomSettingTH.customSettingDetails();
        insert updatecustomsettingsTH;
        
        objAccount= new Account();
        objAccount.RecordtypeId=PersonaccRTId;
        objAccount.Firstname='Test Person';
        objAccount.LastName='1st';
        objAccount.salutation='Mr.';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Email2__c = 'testemail2@test.com';
        //objAccount.Home_Phone_2__c = '098-876-4134';    
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        objAccount.MBK_Data_Source__c ='Email';
        objAccount.MD__c = MD;
        //objAccount.Mobile__c = '999999999';
        
        
        //insert objAccount;
        
        
        objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        objAddress.Province__c='ACT'; 
        objAddress.Address_Type__c = 'Home';  
        objAddress.ZipCode__c ='1234567'; 
        objAddress.MD__c = MD;
        objAddress.Address_Line_1__c = 'Banglore';
        objAddress.Address_Line_2__c = 'Test Address 2';
        objAddress.Block__c = 'Test Block';
        objAddress.City__c = 'Test City';
        objAddress.District__c = 'Test District';
        insert objAddress;
        
        
        
        system.debug('objAddress>>>>>'+objAddress.Id);
        
    /*  editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
    Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Id =:objAddress.Id];
    editadds[0].Preferred__c=false;
    editadds[0].Province__c='NSW';
    
    update editadds;
    */
        
    }
    
    public static testMethod void testMethod1(){
        
        
        init();        
        
        test.startTest();
        system.RunAs(sysAdminUser1){
            
            ApexPages.currentPage().getParameters().put('Id',objAccount.id);       
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
            List<SelectOption> getAddresOptions = objAddressDisplayInlineEditController.getAddressOptions();
            system.assertEquals(objAddressDisplayInlineEditController.market,'JP');
            
            system.assertNotEquals(getAddresOptions.size(),2);
            
            objAddressDisplayInlineEditController.ValidateAddressSearch();
            for(Apexpages.Message msg: ApexPages.getMessages()){
                system.assert(msg.getDetail().contains(system.Label.Zipcode_validation));
            }
        }
        
        system.RunAs(sysAdminUser2){
            
            ApexPages.currentPage().getParameters().put('Id',objAccount.id);       
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
            List<SelectOption> getAddresOptions = objAddressDisplayInlineEditController.getAddressOptions();
            system.assertEquals(objAddressDisplayInlineEditController.market,'KR');
            system.assertEquals(getAddresOptions.size(),2);  
        }
        test.stopTest();
    }
    
    public static testMethod void testValidateAddressSearchCalloutInValidAddress(){ 
        
        init(); 
        test.startTest();
        system.RunAs(sysAdminUser2){
            
            
            ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
            objAddressDisplayInlineEditController.addressobj=editadds[0];
            Test.setMock(WebServiceMock.class, new WSMockAddressValidationRespInvalidAddr());
            objAddressDisplayInlineEditController.ValidateAddressSearch();
            
            system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        }
        test.stopTest(); 
    }
    
    public static testMethod void testValidateAddressSearchCalloutFailure(){  
        init(); 
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=editadds[0];
        Test.setMock(WebServiceMock.class, new WSMockAddressValidationResponseFailure());
        objAddressDisplayInlineEditController.ValidateAddressSearch();
        test.stopTest();    
        system.assert(objAddressDisplayInlineEditController.addressobj!=Null);     
    }
        /*
    public static testMethod void testAddressSearchZipCode(){  
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
    
    objAccount= new Account();
    objAccount.RecordtypeId=PersonaccRTId;
    objAccount.Firstname='Test Person';
    objAccount.LastName='1st';
    objAccount.Individual_Home_Phone__c='8884545243';
    objAccount.Mobile__c='8884545243';
    objAccount.Work_Phone__c='8884545243';
    objAccount.salutation='Mr.';
    objAccount.Type='Personal';
    objAccount.Status__c='Active';
    objAccount.Province__c='Province1';
    objAccount.City__c='Test';
    objAccount.Email__c='test@mbau.com';
    objAccount.Email2__c = 'testemail2@test.com';    
    objAccount.PersonMobilePhone ='8884545243';
    objAccount.Partner_Surname__c='Test Person';
    objAccount.MBK_Data_Source__c ='Email';
    //objAccount.Mobile__c = '9999999999';
    insert objAccount;
    
    objAddress= new Address__c();
    objAddress.Customer__c=objAccount.Id;
    objAddress.Address_Line_1__c='Test';
    objAddress.City__c='Test';
    objAddress.Province__c='Test';
    objAddress.TitleOfHonor__c = 'To Person';       
    objAddress.Preferred__c=true;
    objAddress.Address_Type__c = 'Home';  
    objAddress.ZipCode__c ='123456';
    insert objAddress;
    
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);     
    ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
    AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
    objAddressDisplayInlineEditController.addressobj= objAddress;
    
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    objAddressDisplayInlineEditController.AddressSearch();
    test.stopTest();
    system.assert(objAddressDisplayInlineEditController.addressobj!=Null);  
    system.assertNotEquals(objAddress.ZipCode__c,null);  
    }
    */
    
        /*
    public static testMethod void testSaveAddressTHValidation1(){
    //init();
    CallOutHandlerSettingDFW__c callOutObj=new CallOutHandlerSettingDFW__c(Name='CalloutValues',DEFAULT_CALLOUT_TIME__c='5000',MAX_CALLOUT_TIME__c='10000');       
    insert callOutObj;        
    SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
    insert sysObj;
    //initUpdated('TH');      
    
  
    
    system.RunAs(sysAdminUser1){        
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
    ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
    
    objAddressDisplayInlineEditController.saveAddressTH();
    test.stopTest();
    //  system.assertEquals(null, editaddressId, objaddress);
    }
    }
    */   
        /*    public static testMethod void testSaveAddressTHValidation()
    {
    //init();
    initUpdated('TH');      
    
 
    
    system.RunAs(sysAdminUser1){        
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
    ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
    
    objAddress.ZipCode__c='56789';
    objAddress.Address_Line_1__c='Sanjay ,bangalore';
    objAddress.District__c='Sathorn';
    objAddress.Sub_District__c='Sathorn abc';
    objAddress.Address_Line_2__c='Sathorns';
    update objAddress;
    objAddressDisplayInlineEditController.SaveAddressTH();
    //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    
    test.stopTest();
    //  system.assertEquals(null, editaddressId, objaddress);
    }  
    }*/
        
      
        /*
    public static testMethod void testSaveAddressTHValidationSuccess()
    {
    //init(); 
    initUpdated('TH');       
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    objAddress.MD__c='TH';
    objAddress.ZipCode__c='56789';
    objAddress.Address_Line_1__c='Sanjay ,bangalore';
    objAddress.District__c='Sathorn';
    objAddress.Sub_District__c='Sathorn abc';
    objAddress.Address_Line_2__c='Sathorns';
    update objAddress;
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
    ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
    system.RunAs(sysAdminUser1){        
    test.startTest();
    AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
    objAddressDisplayInlineEditController.editaddressId= objAddress.id;
    objAddressDisplayInlineEditController.EditOptions();
    objAddressDisplayInlineEditController.SaveAddressTH();
    objAddress.preferred__c=False;
    update objAddress;  
    objAddressDisplayInlineEditController.EditOptions();
    objAddressDisplayInlineEditController.SaveAddressTH();
    objAddressDisplayInlineEditController.addressId=null;
    objAddressDisplayInlineEditController.SaveAddressTH();
    //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    
    test.stopTest();
    }
    
    } */  
    public static testMethod void testValidateAddressSearchCalloutInValidAddressUpdated(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        objAddressDisplayInlineEditController.market='JP';
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.ValidateAddressSearch();
        //objAddressDisplayInlineEditController.mapAddressResponse[0].isselected=true;
        objAddressDisplayInlineEditController.SelectedAddress();
        system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    public static testMethod void testValidateAddressSearchCalloutNotValidAddressUpdated2(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        objAddressDisplayInlineEditController.market='KR';
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.ValidateAddressSearch(); 
        //objAddressDisplayInlineEditController.SelectedAddress();
        system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    public static testMethod void testLoadProvince(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.LoadProvince(); 
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    
    public static testMethod void testLoadDistrict(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        objAddressDisplayInlineEditController.addressobj.District__c= null;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.LoadDistrict(); 
        
        
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    
    public static testMethod void testLoadSubDistrict(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.LoadSubDistrict(); 
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    
    public static testMethod void testLoadZip(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.LoadZip(); 
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    public static testMethod void testShowHideFieldsTrue(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.addressobj.Foreign_Nationals__c=true ;
        objAddressDisplayInlineEditController.market='MY';
        objAddressDisplayInlineEditController.market='IN';
        objAddressDisplayInlineEditController.ShowHideFields(); 
        objAddressDisplayInlineEditController.updateHidefields();
        objAddressDisplayInlineEditController.SaveAddressMY();
        objAddressDisplayInlineEditController.SaveAddressIN();
        objAddressDisplayInlineEditController.AutoFillAddress();
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
    public static testMethod void testShowHideFieldsFalse(){  
        init(); 
        ApexPages.currentPage().getParameters().put('Id',objAccount.id); 
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);          
        objAddressDisplayInlineEditController.addressobj=objAddress;
        test.startTest();
        //system.RunAs(sysAdminUser1){
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        objAddressDisplayInlineEditController.market='TH';  
        objAddressDisplayInlineEditController.addressobj.Foreign_Nationals__c=false ;
        objAddressDisplayInlineEditController.ShowHideFields(); 
        //objAddressDisplayInlineEditController.SelectedAddress();
        //system.assert(objAddressDisplayInlineEditController.addressobj!=Null); 
        // }
        test.stopTest(); 
    }
    
}