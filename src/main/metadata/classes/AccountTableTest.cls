@isTest
public class AccountTableTest {
static testMethod void testMethod1() 
 {
 UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
 Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
 User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
 system.runAs(user_Obj)
 {    
     
 List <Account> lstAccount = new List<Account>();
 
 Account dealer = new Account(Name = 'Shanghai test',
                                     Province__c = 'Shanghai',
                                     City__c = 'Xuhui district,',
                                     Dealer_Sales_Type__c = 'Smart',
                                     MBK_Data_Source__c = 'Email',
                                     Dealer_Service_Codes__c = 'Sales;Parts',
                                     MD__c='JP',
                                     Dealer_Type__c='Outlet' ,
                                     Dealer_Active__c=true);
        dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);
        lstAccount.add(dealer);

 
 Test.startTest();
  try{   
  Test.setCurrentPage(Page.AddParticipatingDealer);
  ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount);
  stdSetController.setSelected(lstAccount);
  AccountTable ext = new AccountTable();
  AccountTable.AddingParticipatingDealer empW = new AccountTable.AddingParticipatingDealer();
  //system.assertNotEquals(null,ext.CamId);    
  ext.regionValue='sid' ;  
  ext.getAccount();
  ext.dropDown();
  ext.clickMe();
  ext.SearchLogic();
  ext.first();
  ext.last();
  ext.next();
  ext.previous();   
  boolean test1 = ext.hasNext;
  boolean test2 = ext.hasPrevious;
  integer test3 = ext.pageNumber;
  ext.selectAllParticipatingdealers();
  String s= ext.size;   
  boolean b= ext.display;
  String ss=ext.CompanyName;
  String sss=ext.soql;   
  ext.dealerType='abcd';
  ext.dealerCode='abcd'; 
  ext.dealerSalestype='abcd';
  ext.DealerServiceFun ='abcd';
  ext.DealerSalesfunc  ='abcd';
  ext.DealerUsedCarFunc ='abcd';
  ext.DealerUsedCarCorner ='abcd';
  ext.DealerAMGPerformance ='abcd';
  ext.DealerNDCode ='abcd';
  ext.Name ='abcd';
  ext.DealerGroup='abcd';
  ext.DealerProvince='abcd';
  ext.DealerCarsDlrClassSales ='abcd'; 
  ext.DealerActive='abcd';
  ext.regionValue='aid' ;  
  system.assertEquals(true, ext.panelStopper);    
  ext.dropDown();   
  system.assertEquals(false, ext.panelStopper);       
  ext.SearchLogic(); 
      
  }catch(Exception e)
  {}
  Test.stopTest();
  }
 }
}