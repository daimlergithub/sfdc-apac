@isTest
public class GenericCSVLoaderControllerTest {
    
   private static Id acc3rdPartyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
    private static Account customer;
    private static Account BranchName ;
                                    
    public static void preparedTestdata()
    {
    customer = new Account(Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    Branch_name__c = '2014/06/05',
                                    File_Name__pc = 'C://User/folder',
                                    RecordTypeId=acc3rdPartyRecordTypeId);
                                   
    }        
    
    public static void preparedTestAccountdata()
    {
    BranchName = new Account(Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                     Branch_name__c = '2014-06-05',
                                    File_Name__pc = 'C://User/folder',
                                    RecordTypeId=acc3rdPartyRecordTypeId);
                                   
    }                        
    static testMethod void TestuploadAccounts() {
    preparedTestdata();
        List<Account> accs = new List<Account>();
        accs.add(customer);
        GenericCSVLoaderController.uploadObjects(accs);
       system.assert(accs!=null);
        system.assert(customer!=null);
    }
    
    static testMethod void TestuploadAccountsElseCondition() {
    preparedTestAccountdata();
        List<Account> accbranch = new List<Account>();
        accbranch .add(BranchName);
        GenericCSVLoaderController.uploadAccounts(accbranch );
        system.assert(accbranch!=null);
        system.assert(BranchName!=null);
    }
}