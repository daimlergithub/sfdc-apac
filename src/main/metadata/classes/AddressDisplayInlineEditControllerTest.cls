/*
    Type:       Test Class
    Purpose:    Test On AddressDisplayInlineEditController
    Created by: Sudhir 11/26/2015

*/
@isTest
public class AddressDisplayInlineEditControllerTest 
{
    public static Address__c objaddress;
    public static Account objAccount;
    public static Id editaddressId;
    public static Id addressId;
    public static Address__c addressobj;
    public static List<Address__c> editadds;
    public static User sysAdminUser1;
    public static User sysAdminUser2;
    
    private static Id PersonaccRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   
   
   /**    
     * @Description : Cancel functionality 
     * @author      : Sudhir
     * @Date        : 12/7/2015 
   **/  
    public static testMethod void testCancelEdit()
    {
        init();
        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);        
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.addressobj = editadds[0];
        objAddressDisplayInlineEditController.cancelEdit();
        test.stopTest();
        system.assertEquals(null,addressobj);
    }
    /**    
     * @Description : load updated data after deletion of address
     * @author      : Sudhir
     * @Date        : 12/7/2015 
   **/
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

    /**    
     * @Description : creation of new address record
     * @author      : Sudhir
     * @Date        : 12/7/2015 
     * @Modified By : Sneha
     * @Modified Date: 2/1/2016
   **/
    
    public static testMethod void testSaveAddress()
    {
        init();        
        test.startTest();
       
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);      
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);  
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
   /**    
     * @Description : Validation Check for adding of address maximum 5 address can be added.
     * @author      : Sudhir
     * @Date        : 12/11/2015 
   **/ 
    public static testMethod void testAddEditOptions()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.addEditOptions();
        test.stopTest();
        system.assertEquals(objAddress.Customer__c, objAccount.id);
        
    }
    
    /**    
     * @Description : edit the address record
     * @author      : Sudhir
     * @Date        : 12/7/2015 
   **/
    
    public static testMethod void testEditOptions()
    {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);       
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.editaddressId =objaddress.id;
        objAddressDisplayInlineEditController.addressobj = editadds[0];
        objAddressDisplayInlineEditController.EditOptions();
        test.stopTest();
        system.assertEquals(null,editaddressId,objaddress.Id);
    }
    
    /**    
     * @Description : deletion of address record
     * @author      : Sudhir
     * @Date        : 12/7/2015 
   **/
    
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
   /**    
     * @Description : For creation of Account and Address record
     * @author      : Sneha
     * @Date        : 1/2/2016 
   **/ 
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
   /**    
     * @Description : For creation of Account and Address record
     * @author      : Sneha
     * @Date        : 1/2/2016 
   **/
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
    
       /**    
     * @Description : Search functionality 
     * @author      : Sneha
     * @Date        : 1/28/2016 
   **/  
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
    /**    
     * @Description : For creation of Account and Address record
     * @author      : Sudhir
     * @Date        : 12/7/2015 
   **/
    
   public static void init()
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
                                        , Market__c = 'KR'
                                        , UserName='sysAdmin2@mbj.daimler-apac.com.asiadev1');
        userList.add(sysAdminUser2);
        insert userList;

        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
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
        objAccount.MD__c = 'JP';
        //objAccount.Mobile__c = '999999999';
        
        
        insert objAccount;
        
        
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
        insert objAddress;
        
        system.debug('objAddress>>>>>'+objAddress.Id);
        
       editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                  Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Id =:objAddress.Id];
        system.debug('editadds>>>'+editadds);
        editadds[0].Preferred__c=false;
        editadds[0].Province__c='NSW';
        //editadds[0].Address_Type__c ='Company';        
        update editadds;
        
        
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
    
    public static testMethod void testAddressSearchZipCode(){  
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
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
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        objAccount.MBK_Data_Source__c ='Email';
        //objAccount.Mobile__c = '9999999999';
        insert objAccount;
        
        objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        objAddress.Address_Type__c = 'Home';  
        objAddress.ZipCode__c ='1234567';
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
    
}