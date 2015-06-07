@isTest
public class GenericCSVLoaderControllerTest {
    
    static Id acc3rdPartyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
    
    static Account customer = new Account(Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    Branch_name__c = '2014/06/05',
                                    File_Name__pc = 'C://User/folder',
                                    RecordTypeId=acc3rdPartyRecordTypeId);
                                    
    static testMethod void myUnitTest1() {
        List<Account> accs = new List<Account>();
        accs.add(customer);
        GenericCSVLoaderController.uploadObjects(accs);
    }
    
    static testMethod void myUnitTest2() {
        List<Account> accs = new List<Account>();
        accs.add(customer);
        GenericCSVLoaderController.uploadAccounts(accs);
    }
}