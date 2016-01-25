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
        JPAcccontroller.recordType = 'Company';
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
        JPAcccontroller.recordType = 'Person Account';
        JPAcccontroller.selectedRecordType = 'Person Account';
        test.startTest();
        JPAcccontroller.saveAccount();
        JPAcccontroller.objPersonAccount = personAcc1;
        JPAcccontroller.saveAccount();
        test.stopTest();
        system.assertEquals(null, personAcc1.id);
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
        JPAcccontroller.validateAddressByZipCode();
        JPAcccontroller.saveAccount();
        test.stopTest();
        system.assertNotEquals(null, personAcc.id);
    }
    
    static testmethod void AddressSearchValidationControllerTest5()
    {
        createTestData();
        addressobj.ZipCode__c = null;
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
        JPAcccontroller.validateAddressByZipCode();
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
        objAccount.ZipCode__c = '五五五五五五五';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
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
        personAcc.ZipCode__c = '五五五五五五五';
        personAcc.Email__c='test@mbj.com';
        personAcc.Mobile__c ='0435488899';
        personAcc.Phone = '08022420181';
        insert personAcc;
        
        personAcc1 = new Account();
        personAcc1.RecordtypeId= strPerson;
        personAcc1.LastName='Test Person 2nd';
        try{insert personAcc1;}
        catch(DMLException e){
            
            system.debug('!!! '+ e);
            
        }
        
        addressobj =  new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Block__c = 'Block';
        addressobj.Customer__c = objAccount.id;
        addressobj.ZipCode__c = '1040041';
        
        insert addressobj;
        
    }
    
    
    
}