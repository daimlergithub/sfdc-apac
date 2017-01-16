@istest
public class ContactTableControllerTest 
{
    public Static Account objAccount;
    private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    public static testMethod void test_method()
    {
        
        createAccount();
        
        
        //process
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        ContactTableController AccContactTableController= new ContactTableController(objSc);
        
        //verify
        system.assertNotEquals(null, objAccount);
        
        
        
        
        
    }
    public static testMethod void test_EditAccount()
    {
        
        createAccount();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        ContactTableController AccContactTableController= new ContactTableController(objSc);
        AccContactTableController.EditAccount();
        //verify
        system.assertEquals(true, AccContactTableController.editMode);
        test.stopTest();
        
    }
    
    public static testMethod void test_CancelUpdate()
    {
        createAccount();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        ContactTableController AccContactTableController= new ContactTableController(objSc);
        AccContactTableController.CancelUpdate();
        //verify
        system.assertEquals(false, AccContactTableController.editMode);
        test.stopTest();        
    }
    
    public static testMethod void test_UpdateAccount()
    {
        createAccount();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        ContactTableController AccContactTableController= new ContactTableController(objSc);
        AccContactTableController.UpdateAccount();
        //verify
        system.assertNotEquals(null, AccContactTableController.AccId);
        test.stopTest();
    }  
    
    
    static void createAccount()
    {
        objAccount= new Account();
        objAccount.RecordtypeId=companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Mobile__c ='0435488899';
        
        
        insert objAccount;
    }
    
    
    
}