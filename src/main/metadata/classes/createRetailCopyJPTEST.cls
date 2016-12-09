@istest
public class createRetailCopyJPTEST
{
public static Account acc;
public static Account acc1;
public static Account acc2;
public static Account acc3;
public static Address__c add;
public static Address__c add1;
public static Address__c add2;
public static Address__c add3;
public static Address__c add89;
public  List<Address__c> Addres ;



Public static testmethod void testMethod1(){
 
 testdata();
 ApexPages.currentPage().getParameters().put('Id',acc.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(acc);
   createRetailCopy csvi = New createRetailCopy(objSc );
   Test.StartTest();
   csvi.addId = add.Id;
   csvi.getSelected ();
   csvi.getAccount();
   csvi.Save();
   csvi.Cancel();
 Test.StopTest();
 
 }

Public static testmethod void testMethod2()
{
 
 testdata();
 ApexPages.currentPage().getParameters().put('Id',acc2.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(acc2);
   createRetailCopy csvi = New createRetailCopy(objSc );
   Test.StartTest();
   csvi.abc = acc;
  // csvi.ress =Addres ;   
   csvi.getSelected ();
   csvi.getAccount();
   csvi.Save();
   csvi.Cancel();
 Test.StopTest();
 
 }

 public static testMethod void testMethod4(){
    
    
    
    testdata();
    
   
   
    Test.startTest();
    ApexPages.StandardController objSc = new ApexPages.StandardController(acc );
    
       PageReference PageRef = page.RetailCopyButton;
      
        
        Test.setCurrentPage(pageRef);
   pageRef.getParameters().put('id',acc.id);
   ApexPages.StandardController sc = new ApexPages.standardController(acc );
   createRetailCopy csvi = New createRetailCopy(objSc );
   System.assertNotEquals(null,csvi.cancel());
   Test.stopTest();
   }








    public static void testdata(){
    acc = new Account (Name = 'dinesh');
insert acc;


    acc1 = new Account (Name = 'shiva');
    insert acc1;

    acc2 = new Account (Name = 'abhi');
        insert acc2;
        
    acc3 = new account (name = 'bob');
    insert acc3;
  
   add = new Address__c ( Customer__c = acc.id,Address_Type__c = 'Home',ZipCode__c = '7920500',Province__c = 'Ibaraki',TitleOfHonor__c = 'To Person',Status__c = 'Active');
  insert add;
  
    add1 = new Address__c ( Customer__c = acc.id,Address_Type__c = 'Other Address 1',ZipCode__c = '7920506',Province__c = 'Saitama',TitleOfHonor__c = 'To Person',Status__c = 'Active');
  insert add1;
  
  
   add2 = new Address__c ( Customer__c = acc2.id,Address_Type__c = 'Home',ZipCode__c = '7920508',Province__c = 'Osaka',TitleOfHonor__c = 'To Person',Status__c = 'Active');
  insert add2;
  
  add3 = new Address__c (Customer__c = acc2.id,Address_Type__c = 'Home',ZipCode__c = '7920527',Province__c = 'Saitama', TitleOfHonor__c = 'To Person', Status__c = 'Active');
insert add3;
  List<Address__c> Addres = New List<Address__c>();
    add89 = New Address__c ( Customer__c = acc.id,Address_Type__c = 'Home',ZipCode__c = '7920500',Province__c = 'Ibaraki',TitleOfHonor__c = 'To Person',Status__c = 'Active');
   Addres.add(add89 );
   insert Addres;
   
}
}