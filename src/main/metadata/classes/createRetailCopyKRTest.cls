@istest
public class createRetailCopyKRTest {
  public static Account acc;
  public static Account acc2;
  public static Address__c add89;
  public static Account_Link__c acclinkobj;
  public  List<Address__c> Addres ;
  public static Id retailcompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();

  Public static testmethod void testMethod2() {
    testdata();
    ApexPages.currentPage().getParameters().put('Id',acc2.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(acc2);
    createRetailCopyKR csvi = New createRetailCopyKR(objSc );
    Test.StartTest();
      csvi.abc = acc;
      csvi.getSelected ();
      csvi.getAccount();
      csvi.Save();
      csvi.Cancel();
    Test.StopTest();
  }
  public static void testdata() {
    acc = new Account (Name = 'sreeni');
    insert acc;

    acc2 = new Account (Name = 'pradeep');
    insert acc2;
    
    acclinkobj = new Account_Link__c();
    acclinkobj.RecordTypeId = retailcompanyRecordTypeId;
    acclinkobj.Name = 'accountlinktest';
    acclinkobj.fromRole__c = acc.id;
    acclinkobj.toRole__c = acc.id;
    insert acclinkobj;
    system.debug('$$$$$ acclinkobj $$$$$' +acclinkobj);
    
    List<Address__c> Addres = New List<Address__c>();
    add89 = New Address__c ( Customer__c = acc.id,Address_Type__c = 'Home',ZipCode__c = '7920500',Province__c = 'Ibaraki',TitleOfHonor__c = 'To Person',Status__c = 'Active');
    Addres.add(add89 );
    insert Addres;
  }
}