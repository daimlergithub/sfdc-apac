@isTest
public class AddressHelperTHTest{
    
    static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        test.starttest();
        Account acc=new Account();
        acc.owner=user1;
        acc.Phone='09844650654';
        acc.Name ='Test';
        acc.Mobile__c ='1234567890';
        acc.Data_Source__c  ='Test4';
        insert acc;
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.MD__c='KR';
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        
        acc.Primary_Address_Reference__c=address.id;
        update acc;
        list<address__c> list1=new list<address__c>();
        list1.add(address);
        
        //AddressHelperTH ad=new AddressHelperTH ();
        map<id,address__c> addmap=new map<id,address__c>();
        addmap.put(address.id,address);
        AddressHelperTH.updateAddressOnAccount(list1);
        AddressHelperTH.validateSameAddressType(list1,addmap,true,true);
        AddressHelperTH.validateSameAddressType(list1,addmap,False,False);
        AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        AddressHelperTH.updateAccountonDeletion(list1);
        test.stopTest();
   

    }
  }
    }