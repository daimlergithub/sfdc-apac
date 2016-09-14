/*
    Type:      class
    Purpose:   Test class for AddressHelperKR
    Create By: Sampath kumar
*/
@isTest
public class AddressHelperKRTest {

     private static Account account;
     private static Address__c address;
     public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
     public static List<Address__c> addresslist =new List<Address__c>();
 

@isTest static void testUpdatePrimaryAddressOnAccount(){
 
     Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
     upsert TriggerAddress;
        
     account= new Account();
     account.Phone='09844650654';
     account.FirstName = 'Test';
     account.Mobile__c='0123456789';
     account.Data_Source__c = 'Event';
     account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account); 
 
     address=new Address__c();
     address.Address_Type__c='Home';
     address.Province__c='test1';
     address.City__c='bangalore';
     address.District__c='test2';
     address.HouseNumber__c='123';
     address.Address_Line_1__c='testaddress1';
     address.Address_Line_2__c='testaddress2';
     address.Customer__c=account.id;
     insert address;
     
     addresslist.add(address);
     newmap.putAll(addresslist);
     account.Primary_Address_Reference__c=address.id;
     update account;
        
     //start test        
     test.startTest();
     address.Address_Type__c='Business';
     update address;
     test.stopTest();
    
     //address.Customer__c = account.Id;
     address.Province__c='test1';
     delete address;
    }
}