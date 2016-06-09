@isTest
public class AddresscontrollerTest 
{
    private static Account objAcct;
    private static Account objAcct2;
    private static Address__c objAddress;
    
    private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
   
    public static testMethod void testgetaddressList_details() 
   
   { 
      createAccount();
      createAddress(); 
      list<Address__c> addlist=new list<Address__c>();
      addlist = [select id,Name,Customer__c,MD__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                          from Address__c Where Customer__c=:objAcct.Id AND Preferred__c=:true Limit 1]; 
     test.startTest();
     ApexPages.currentPage().getParameters().put('Id',objAcct.id);
     ApexPages.StandardController objSc = new ApexPages.StandardController(objAcct);
     Addresscontroller  objAddresscontroller = new Addresscontroller(objSc);
     objAddresscontroller.getaddressList_details();
     test.stopTest();
     System.assertEquals(addlist[0],Addresscontroller.addresslist[0]);
    
   }
    
   public static testMethod void testgetaddressList_details_negative() 
   
   { 
      createAccount2();
      
      list<Address__c> addlist=new list<Address__c>();
      addlist = [select id,Name,Customer__c,Preferred__c,Address_Type__c,Address_Line_1__c,Address_Line_2__c,Country__c,ZipCode__c,Province__c,Status__c,District__c 
                          from Address__c Where Customer__c=:objAcct2.Id AND Preferred__c=:true Limit 1];
      
     test.startTest();
     ApexPages.currentPage().getParameters().put('Id',objAcct2.id);
     ApexPages.StandardController objSc = new ApexPages.StandardController(objAcct2);
     Addresscontroller  objAddresscontroller = new Addresscontroller(objSc);
     objAddresscontroller.getaddressList_details();
     test.stopTest();
     System.assertEquals(addlist ,Addresscontroller.addresslist);
   }
    
 static void createAccount()
  {
    objAcct= new Account();
    objAcct.RecordtypeId=companyAccRecordTypeId;
    objAcct.Name='Test Person 1st';
    objAcct.Type='Personal';
    objAcct.Status__c='Active';
    objAcct.Province__c='Province1';
    objAcct.City__c='Test';
    objAcct.Email__c='test@mbau.com';
    objAcct.Mobile__c ='8884545243';
    insert objAcct;
  }  
  
  
    static void createAccount2()
  {
    objAcct2= new Account();
    objAcct2.RecordtypeId=companyAccRecordTypeId;
    objAcct2.Name='Test Person 1st';
    objAcct2.Type='Personal';
    objAcct2.Status__c='Active';
    objAcct2.Province__c='Province1';
    objAcct2.City__c='Test';
    objAcct2.Email__c='test@mbau.com';
    objAcct2.Mobile__c ='8884545243';
    insert objAcct2;
  }   
     
    
    static void createAddress()
  {
    objAddress= new Address__c();
    objAddress.Customer__c=objAcct.Id;
    objAddress.Preferred__c=true;
    objAddress.Province__c='ACT';
    insert objAddress;
  }
    
  
    
}