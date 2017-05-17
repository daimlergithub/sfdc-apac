@isTest
public class AccountTableTest {
static testMethod void testMethod1() 
 {
 List <Account> lstAccount = new List<Account>();
 
 Account dealer = new Account(Name = 'Shanghai test',
                                     Province__c = 'Shanghai',
                                     City__c = 'Xuhui district,',
                                     Dealer_Sales_Type__c = 'Smart',
                                     MBK_Data_Source__c = 'Email',
                                     Dealer_Service_Codes__c = 'Sales;Parts');
        dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);
        lstAccount.add(dealer);
 
 
 Test.startTest();
  Test.setCurrentPage(Page.AddParticipatingDealer);
  ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount);
  stdSetController.setSelected(lstAccount);
  AccountTable ext = new AccountTable();
  AccountTable.AddingParticipatingDealer empW = new AccountTable.AddingParticipatingDealer();
  ext.getAccount();
  ext.dropDown();
  ext.clickMe();
  ext.SearchLogic();
  boolean test1 = ext.hasNext;
  boolean test2 = ext.hasPrevious;
  integer test3 = ext.pageNumber;
  
 Test.stopTest();
 }







}