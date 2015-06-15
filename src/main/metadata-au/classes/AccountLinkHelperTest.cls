@isTest
public class AccountLinkHelperTest 
{
    private static Account objAccount;
    private static Account_Link__c AccLink;
    private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
  public static testMethod void test_nameParsing()
  {
      string crmcode ;
      string name =  'nameDMS-';
      test.startTest();
      String testStr = AccountLinkHelper.nameParsing('nameDMS-');
      test.stopTest();
      name = name.substring(name.indexOf('DMS-'));
      crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
      system.assertEquals(crmCode, testStr);
  }
    
    public static testMethod void test_auBefore_Insert_Events()
  {
      createAccount();
      createAccLink();
      List<Account_Link__c> listALNew = new List<Account_Link__c>();
      listALNew.add(AccLink);
      test.startTest();
      AccountLinkHelper.auBefore_Insert_Events(listALNew);
      test.stopTest();
      system.assertNotEquals(null, AccountLinkHelper.getAllExistentRelationships(listALNew));
  }
   
    public static testMethod void test_isHigherPriority()
  {
      createAccount();
      createAccLink();
      boolean testIhp;
      List<Account_Link__c> relationships = new List<Account_Link__c>();
      relationships.add(AccLink);
      test.startTest();
      AccountLinkHelper.isHigherPriority('one','two');
      testIhp = AccountLinkHelper.isHigherPriority('Customer','two');
      system.assertEquals(true, testIhp);
      testIhp = AccountLinkHelper.isHigherPriority('one','Customer');
      system.assertEquals(false, testIhp);
      
      test.stopTest();
      
  }
    
    public static testMethod void test_getIndex()
  {
      createAccount();
      createAccLink();
      String cid = AccLink.toRole__c, did = AccLink.fromRole__c;
      test.startTest();
      string testStr = AccountLinkHelper.getIndex(AccLink);
      
      test.stopTest();
      system.assertEquals(cid.substring(0, 15) + ';' + did.substring(0, 15),testStr);
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
    
    static void createAccLink()
{
      AccLink = new Account_Link__c();
      AccLink.fromRole__c = objAccount.Id;
      AccLink.toRole__c =  objAccount.Id;
    
} 
}