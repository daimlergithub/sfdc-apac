@istest
public class UtilSobjectTest {
	public static String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static List<Account> aacList = new List<Account>();
    public static Account Dealer;
    static void createTestData(){
       Dealer = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '180801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',                                    
                                    ZipCode__c='000000',
                                    RecordTypeId=DealerRecordtypeid);       
       insert Dealer;
    }
    
   public static testmethod void test_insertSobjects(){
       createTestData();
       test.startTest();
       aacList.add(Dealer);
       UtilSobject.insertSobjects(aacList);
       aacList.remove(0);
       UtilSobject.insertSobjects(aacList);
       test.stopTest();
       system.assert(aacList.isEmpty());
   }
   
   public static testmethod void test_updateSobjects(){
       createTestData();
       test.startTest();
       Dealer.Phone='180801019';
       aacList.add(Dealer);
       UtilSobject.updateSobjects(aacList);
		Account a = new Account();
       aacList.add(a);
       UtilSobject.updateSobjects(aacList);
       test.stopTest();
       system.assert(!aacList.isEmpty());
   }
    
   public static testmethod void test_deleteSobjects(){
       createTestData();
       test.startTest();
       aacList.add(Dealer);
       UtilSobject.deleteSobjects(aacList);
	   Account a = new Account();
       Account Dealer2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '180801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',                                    
                                    ZipCode__c='000000',
                                    RecordTypeId=DealerRecordtypeid);
       insert Dealer2;
       a.Id=Dealer2.Id;
       aacList.add(a);
       UtilSobject.deleteSobjects(aacList);
       test.stopTest();
       system.assert(!aacList.isEmpty());
   }
}