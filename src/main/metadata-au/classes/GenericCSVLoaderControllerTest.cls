@isTest
public class GenericCSVLoaderControllerTest {
    
    static Id acc3rdPartyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
    
    static Account customer = new Account(Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    Email__c='test011@test.com',
                                   Email2__c='test012@test.com',
                                   Home_Phone_2__c='9958745898',
                                    ZipCode__c='000000',
                                    Branch_name__c = '2014/06/05',
                                    File_Name__pc = 'C://User/folder',
                                    RecordTypeId=acc3rdPartyRecordTypeId);
                                    
    static testMethod void myUnitTest1() {
        List<Account> accs = new List<Account>();
        accs.add(customer);
        List<Database.SaveResult> result=  GenericCSVLoaderController.uploadObjects(accs);
        system.assertNotEquals(null, result);
    }
    
    static testMethod void myUnitTest2() {
        List<Account> accs = new List<Account>();
        accs.add(customer);
      List<Database.SaveResult> result =  GenericCSVLoaderController.uploadAccounts(accs);
      //assert
        system.assertNotEquals(null, result);
    }
}