@isTest
public class DealerSearchTest {
  Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();

static testMethod void testMethod1() 
 {
 Test.startTest();
 List <Account> lstAccount = new List<Account>();
 
 Account dealer = new Account(Name = 'Shanghai test',
                                     Province__c = 'Shanghai',
                                     City__c = 'Xuhui district,',
                                     Dealer_Sales_Type__c = 'Smart',
                                     MBK_Data_Source__c = 'Email',
                                     Dealer_Service_Codes__c = 'Sales;Parts',MD__c ='KR',Dealer_ND_Code__c='1234',Dealer_Type__c='Outlet');
        dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);
        
   Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType,MBK_Data_Source__c = 'Email',Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_ND_Code__c='1234',Dealer_Type__c='Outlet');
   insert dealer1;
        lstAccount.add(dealer1);
        lstAccount.add(dealer);
 DM_Material__c dm=new DM_Material__c();
 dm.name='test dm';
 insert dm;       
  
    
            string obId ;
            obId=dm.id;
            PageReference pageRef = Page.DealerSearchPage;
            pageRef.getParameters().put('id', dm.Id);
           
            Test.setCurrentPage(pageRef); 
 
  
  //Test.setCurrentPage(Page.DealerSearchPage);
  ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount);
  stdSetController.setSelected(lstAccount);
  //DealerSearch.SharingDealers empW = new DealerSearch.SharingDealers();
  
  DealerSearch ext = new DealerSearch();
   
  ext.getAccount();
  ext.dropDown();
  ext.ShareRecordd();
  ext.SearchLogic();
  ext.first();
  ext.last();
  ext.previous();
  ext.next();
  boolean test1 = ext.hasNext;
  boolean test2 = ext.hasPrevious;
  integer test3 = ext.pageNumber;
 
  
  Test.stopTest();
 }







}