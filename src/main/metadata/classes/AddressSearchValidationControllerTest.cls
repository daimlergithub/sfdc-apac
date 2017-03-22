@istest
public class AddressSearchValidationControllerTest 
{
    public static Account objAccount;
    public static Account objAccount1;
    public static Account personAcc;
    public static Account personAcc1;
    public static Address__C addressobj ;
    
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    
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
        system.assertNotEquals(null, objAccount.id);
    }
    static void createTestData()
    {
       
        
        objAccount= new Account();
        objAccount.RecordtypeId= companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004236';
        objAccount.Email__c='test@mbj.com';        
        objAccount.MBK_Data_Source__c ='Email';
        objAccount.Province__c = 'Province1';
        objAccount.Phone = '08022420181';
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
        personAcc.ZipCode__c = '1004287';
        personAcc.Email__c='test@mbj.com';        
        personAcc.MBK_Data_Source__c ='Email';
        personAcc.Phone = '08022420181';
        personAcc.Province__c = 'Province1';
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
    
    static testmethod void AddressSearchValidationControllerTest7()
    {
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
}