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
		objAddressDisplayInlineEditCtrl.AddEditOptions();
        objAddressDisplayInlineEditCtrl.cancelEdit();
        test.stopTest();
        system.assertEquals(null,addressobj);
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
            sysAdminUser1 = new User ( Alias = 'sysAdm'
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
            objAccount.Firstname='testOne';
            objAccount.LastName='testTwo';
            objAccount.salutation='Mr.';
            objAccount.Type='Personal';
            objAccount.Phone ='+911234567890';
            objAccount.Work_Phone__c ='+911234567890';
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
            editadds[0].Province__c='testOn';
            editadds[0].isTestrunning__c=true;
            //editadds[0].Address_Type__c ='Company';        
            update editadds;
            
            RegionMasterInfo__c RMObj=new RegionMasterInfo__c();
            RMObj.Province__c = 'test';
            RMObj.District__c = 'test';
            RMObj.Language__c = 'English';
            RMObj.Sub_DIstrict__c = 'test';
            RMObj.ZipCode__c = '123456';
            RMObj.Market__c = 'IN';
            insert RMObj;
        }
    }
  
}