@isTest
public class AccountConatctcontrollerTest 
{
  private static Account objAccount;
  private static Account objAccount1;
 
  private static Address__c objAddress;
  private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  
 public static testMethod void test_showPopup()
  {
     
	     createAccount();
      createAddress(objAccount);
      
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
  
  public static testMethod void test_updateAccount1()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='042548';        
      
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
    public static testMethod void test_updateAccount2()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425';       
      
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
    public static testMethod void test_updateAccount3()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425383899';       
      objAccount1.Individual_Home_Phone__c='042548';
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
  
    public static testMethod void test_updateAccount4()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425383899';       
      objAccount1.Individual_Home_Phone__c='0425487899';
       objAccount1.Home_Phone_2__c='04254';
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
    public static testMethod void test_updateAccount5()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425383899';       
      objAccount1.Individual_Home_Phone__c='0425487899';
       objAccount1.Home_Phone_2__c='0425487698';
      objAccount1.Work_Phone__c='042548';
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
     public static testMethod void test_updateAccount6()
  {
      //prepare test data
      objAccount1= new Account();
	  objAccount1.RecordtypeId=companyAccRecordTypeId;
	  objAccount1.Name='Test Person 1st';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425383899';       
      objAccount1.Individual_Home_Phone__c='0425487899';
       objAccount1.Home_Phone_2__c='0425487698';
      objAccount1.Work_Phone__c='0435487698';
      objAccount1.Phone='043548';
	  insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      objAccountConatctcontroller.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
  
  
 
  public static testMethod void test_userInfo()
  {
      //prepare test data
      createAccount();
      createAddress(objAccount);
      
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
      createAddress(objAccount);
      
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
      public static testMethod void testAccountConatctcontroller()
  {
      //prepare test data
      createAccount();
      createAddress(objAccount);
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AccountConatctcontroller objAccountConatctcontroller= new AccountConatctcontroller(objSc);
      test.stopTest();
        
      //verify
      system.assertequals(objAccountConatctcontroller.accountList_details.id,objAccount.id);
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
   
	
  static void createAddress(Account objAcc)
  {
	  objAddress= new Address__c();
	  objAddress.Customer__c=objAcc.Id;
	  objAddress.Preferred__c=true;
	  objAddress.Province__c='ACT';
	  insert objAddress;
  }
}