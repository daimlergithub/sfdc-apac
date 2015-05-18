@isTest
public class AccountConatctcontrollerTest 
{
  private static Account objAccount;
  private static Address__c objAddress;
  private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  
  public static testMethod void testAccountConatctcontroller()
  {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      test.stopTest();
        
      //verify
      system.assertequals(objAccountConatctcontroller.accountList_details.name,objAccount.Name);
  }
  
  public static testMethod void test_updateAccount()
  {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount.id,ApexPages.currentPage().getParameters().get('Id'));
  }
  
  public static testMethod void test_showPopup()
  {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.showPopup();
      test.stopTest();
        
      //verify
      System.assert(objAccountConatctcontroller.displayPopup);
  }
  public static testMethod void test_userInfo()
  {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.selectedUserName=userinfo.getFirstName()+' '+userinfo.getlastName();
      objAccountConatctcontroller.userInfo();
      test.stopTest();
        
      //verify
      System.assert(objAccountConatctcontroller.usrInfolst!=null);
       
  } 
  public static testMethod void test_closePopup()
  {
      //prepare test data
      createAccount();
      createAddress();
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.selectedUserName=userinfo.getName();
      objAccountConatctcontroller.userInfo();
      objAccountConatctcontroller.closePopup();
      objAccountConatctcontroller.LastModifiedby='Test';
      objAccountConatctcontroller.LastModifieddate='Test';
      objAccountConatctcontroller.FSLastModifiedby='Test';
      objAccountConatctcontroller.FSLastModifieddate=system.today();
      test.stopTest();
        
      //verify
      System.assert(!objAccountConatctcontroller.displayPopup);
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
	  objAccount.Mobile__c ='8884545243';
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