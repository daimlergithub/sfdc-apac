@istest
public class UtilwebserviceTest 
{
   public static Address__c Addressobj ;
   public static Account objAccount ; 
   public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    static testmethod void UtilWebserviceTest()
    {
        createTestData();
        test.startTest();
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        response = UtilWebservice.validateAddressByZipCode(addressobj);
        
        system.debug('response-->>>>'+ response.ValidationStatus);
        test.stopTest();
        system.assertEquals('OK', response.ValidationStatus);
    }
    
    static void createTestData()
    {
        
        objAccount= new Account();
        objAccount.RecordtypeId= companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1040044';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        insert objAccount;
        
        addressobj =  new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Province__c='Province1';
        addressobj.Block__c = 'Block';
        addressobj.Customer__c = objAccount.id;
        addressobj.ZipCode__c = '1040041';
        insert addressobj;
        
        
    }
    
    
    
}