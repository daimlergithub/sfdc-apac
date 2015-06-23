@isTest
public class AccountOptinandOptoutControllerTest
{
  private static Account objAccount;
  private static Address__c objAddress;
  private static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  
  public static testMethod void testAccountOptinandOptoutController()
    {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AccountOptinandOptoutController objaccountOptinandOptoutController= new AccountOptinandOptoutController(objSc);
        test.stopTest();
        
        //verify
        system.assert(objaccountOptinandOptoutController.isShow);
    }
    
    public static testMethod void test_updateAddress()
    {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AccountOptinandOptoutController objaccountOptinandOptoutController= new AccountOptinandOptoutController(objSc);
        objaccountOptinandOptoutController.objAddress = new Address__c();
        objaccountOptinandOptoutController.objAddress.Opt_In_Hardcopy__c=true;
        objaccountOptinandOptoutController.objAddress.FS_Opt_In_Hardcopy__c=true;
        objAddress.Opt_In_Hardcopy__c=true;
        objAddress.FS_Opt_In_Hardcopy__c=true;
        update objAddress;
        objaccountOptinandOptoutController.updateAddress();
        test.stopTest();
        
        //verify
        Address__c objAdd=[Select Id, Opt_In_Hardcopy__c,FS_Opt_In_Hardcopy__c from Address__c where Customer__c=:objAccount.Id AND Preferred__c=true];
        system.assert(objAdd.Opt_In_Hardcopy__c);
        system.assert(objAdd.FS_Opt_In_Hardcopy__c);
    }
    
    static void createAccount()
    {
      objAccount= new Account();
      objAccount.RecordtypeId=personAccRecordTypeId;
      objAccount.Firstname='Test Person 1st';
      objAccount.salutation='Mr.';
      objAccount.LastName='Test Person';
      objAccount.Type='Personal';
      objAccount.Status__c='Active';
      objAccount.Province__c='Province1';
      objAccount.City__c='Test';
      objAccount.Email__c='test@mbau.com';
       objAccount.Email__c='test011@test.com';
      objAccount.Email2__c='test012@test.com';
      objAccount.PersonMobilePhone='8884545243';
      objAccount.Home_Phone_2__c='5487987458';
      insert objAccount;
    }
    
    static void createAddress()
    {
      objAddress= new Address__c();
      objAddress.Customer__c=objAccount.Id;
      objAddress.Preferred__c=true;
      objAddress.Province__c='ACT';
      insert objAddress;
    }
}