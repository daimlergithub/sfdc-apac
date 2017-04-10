@istest
public class CheckAccountDuplicateController_Test 
{
    public static Account objAccount;
    public static Account objAccount1;
    public static Account personAcc;
    public static Account personAcc1;
    public static Address__C addressobj ;
    
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    
    static testmethod void AddressSearchValidationControllerTest4()
    {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('Id',personAcc.Id);
        //ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        CheckAccountDuplicateController JPAcccontroller= new CheckAccountDuplicateController();
     
        test.startTest();
     Test.setMock(WebServiceMock.class, new WebServiceMockImpl2 ());
        JPAcccontroller.onLineDeduplication();       
        test.stopTest();
  
    }
    static testmethod void AddressSearchValidationControllerTest5()
    {
        createTestData();
        
        ApexPages.currentPage().getParameters().put('Id',objAccount.Id);
        //ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        CheckAccountDuplicateController JPAcccontroller= new CheckAccountDuplicateController();
     
        test.startTest();
     Test.setMock(WebServiceMock.class, new WebServiceMockImpl2 ());
        JPAcccontroller.onLineDeduplication();       
        test.stopTest();
  
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
        objAccount.Mobile__c ='0000000000';
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
        personAcc.FirstName = 'Test Person';
        personAcc.LastName='Test Person 1st';
        personAcc.LastName_Native_1__c = 'ァアィイゥウェエォオ';
        personAcc.FirstName_Native_1__c ='ァアィイゥウェエォオ';
        personAcc.Province__c='Province1';
        personAcc.City__c='Test';
        personAcc.ZipCode__c = '1004287';
        personAcc.Email__c='test@mbj.com';
        personAcc.Email2__c ='test@mbj.com';
        personAcc.Email3__c='test@mbj.com';
        personAcc.Individual_Home_Phone__c = '0000000000';
        personAcc.MBK_Data_Source__c ='Email';
        personAcc.Home_Phone_2__c = '08022420181';
        personAcc.Work_Phone__c= '08022420181';
        personAcc.Phone= '08022420181';
        personAcc.Mobile2__c = '08022420181';
        personAcc.Mobile__c = '08022420181';
        personAcc.Province__c = 'Province1';
        personAcc.MD__c = 'JP';
        insert personAcc;
        
        personAcc1 = new Account();
        personAcc1.RecordtypeId= strPerson;
        personAcc1.LastName='Test Person 2nd';
        try{insert personAcc1;}
        catch(DMLException e){            
            system.debug('!!! '+ e);            
        }
        
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
}