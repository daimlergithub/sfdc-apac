@isTest
public class TriggerAddressTriggerHandlerTHTest{


static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        test.starttest();
        try
        {
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
        
        Update address; 
        
        map<id,address__c> newmap=new  map<id,address__c>();
        newmap.put(address.id,address);
    AddressHelperTH ad=new AddressHelperTH(); 
    
      
     TriggerAddressTriggerHandlerTH td=new TriggerAddressTriggerHandlerTH(); 
     system.debug('@@');
     td.handleTrigger(True,True,True,True,True);
       system.debug('##');
     td.handleIntegrationTrigger(True,True,True,True,True);
     }
     
    
     catch(Exception e)
     {
     }
     }
     }
 }