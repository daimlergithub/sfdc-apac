@istest
public class createRetailCopyKRTest {
  public static Account accobj;
  public static Account accountobj;
  public static Account_Link__c acclinkobj;
  public static Address__c addressobj1;
  public static Address__c addressobj;
  public static List<Address__c> addresslist;
   public static Account dealer;
  public static Id retailcompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();

  static void createTestData() {
  dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
    accobj = new Account (Name = 'Sreeni');
    insert accobj;

    accountobj = new Account (Name = 'Pradeep',Company__c = dealer.Id);
    insert accountobj;
    
    acclinkobj = new Account_Link__c();
    acclinkobj.RecordTypeId = retailcompanyRecordTypeId;
    acclinkobj.Name = 'accountlinktest';
    acclinkobj.fromRole__c = accobj.id;
    acclinkobj.toRole__c = accobj.id;
    insert acclinkobj;
    system.debug('$$$$$ acclinkobj $$$$$' +acclinkobj);
    
    addressobj = new Address__c();
    addressobj.Customer__c = accobj.id;
    addressobj.Address_Type__c = 'Home';
    addressobj.ZipCode__c = '7920500';
    addressobj.Province__c = 'Ibaraki';
    addressobj.TitleOfHonor__c = 'To Person';
    addressobj.Status__c = 'Active';
    
    //Addresslist insert
    
    addresslist = new List<Address__c>();
    addresslist.add(addressobj);

    
    addressobj1 = new Address__c();
    addressobj1.Customer__c = dealer.id;
    addressobj1.Address_Type__c = 'Home';
    addressobj1.ZipCode__c = '7920500';
    addressobj1.Province__c = 'Ibaraki';
    addressobj1.TitleOfHonor__c = 'To Person';
    addressobj1.Status__c = 'Active';
    
    //Addresslist insert
    
    addresslist.add(addressobj1);

    insert addresslist;
  }
  
  Public static testmethod void createRetailCopyKRTest1() {
    createTestData();
    ApexPages.currentPage().getParameters().put('Id',accountobj.Id);

     ApexPages.currentPage().getParameters().put('idselected',addressobj1.Id);
      ApexPages.currentPage().getParameters().put('Status',addressobj1.Id);

    ApexPages.StandardController objSc = new ApexPages.StandardController(accountobj);
    createRetailCopyKR crkr = New createRetailCopyKR(objSc );
    test.startTest();
      crkr.abc = accobj;
      crkr.getSelected ();
      crkr.getAccount();
      crkr.Save();
      crkr.Cancel();
    test.stopTest();
  }
  /*Public static testmethod void createRetailCopyKRTest2() {
    createTestData();
    ApexPages.currentPage().getParameters().put('Id',accountobj.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(accountobj);
    createRetailCopyKR crkr = New createRetailCopyKR(objSc );
    test.startTest();
      crkr.abc = accobj;
      addressobj.Address_Type__c = 'Other Address 3';
      update addressobj;
      crkr.Save();
    test.stopTest();
  }*/
}