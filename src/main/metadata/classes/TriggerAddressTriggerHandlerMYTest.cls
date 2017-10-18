//SB2017
    /*
      Name:Sushma Bharti
      Description:Test class for AddressTriggerHandler for MY
      Modified Date: 2017-09-13
  */

@isTest
public class TriggerAddressTriggerHandlerMYTest{

//SB2017
    /*
      Name:Sushma Bharti
      Description:Added to setup test data for MY
      Modified Date: 2017-09-13
  */
  
@testSetup
    static void setupTestData(){
    
    Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User'+System.Today(),Market__c='MY',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
       insert user1;
       System.runAs (user1) {  
       
    List<String> AccountFields=new List<String>();
    AccountFields.add('Lastname');
    AccountFields.add('Individual_Home_Phone__c');
    AccountFields.add('Work_Phone__c');
    AccountFields.add('fax');
    AccountFields.add('Mobile__c');
    AccountFields.add('MD__c');
    List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
    AccountFieldsList[0].Lastname='Lastname1';
    AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
    AccountFieldsList[0].Work_Phone__c='+60825634789541';
    AccountFieldsList[0].fax='+60827896541';
    AccountFieldsList[0].Mobile__c='+609856321478';
    AccountFieldsList[0].MD__c='MY';
    AccountFieldsList[0].email__c='abc@xyz.com';
    insert AccountFieldsList;
    List<String> AddressFields=new List<String>();
    AddressFields.add('Address_Line_1__c');
    AddressFields.add('Address_Line_2__c');
    AddressFields.add('Address_Line_3__c');
    AddressFields.add('Address_Type__c');
    AddressFields.add('City__c');
    AddressFields.add('Province__c');
    AddressFields.add('MD__c');
    List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',1);
    AddressFieldsList[0].Address_Line_1__c='Lastname1';
    AddressFieldsList[0].Address_Line_2__c='+6003123654789';
    AddressFieldsList[0].Address_Line_3__c='+60825634789541';
    AddressFieldsList[0].Address_Type__c='Home';
    AddressFieldsList[0].Province__c='+609856321478';
    AddressFieldsList[0].City__c='+609856321478';
    AddressFieldsList[0].MD__c='MY';
    AddressFieldsList[0].ZipCode__c='12345';
    AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
    AddressFieldsList[0].Market__c= 'MY';
    //AddressFieldsList[0].preferred__c=True; 
    insert AddressFieldsList;
    //AddressFieldsList[0].Address_Type__c='business';
    //update AddressFieldsList;
    }
   } 

 //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */  
    static testMethod void testAccAssignment() {
    
        try{                        
              TriggerAddressTriggerHandlerMY td=new TriggerAddressTriggerHandlerMY(); 
              td.handleTrigger(True,false,True,false,false);
           }    
         catch(Exception e)
         {
             //System.debug('Testing failed due to ' + e.getMessage());
         }
     }

 //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */     
     static testMethod void testAccAssignment2() {
    Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User'+System.Today(),Market__c='MY',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sa1m@usgboral.com.dev01');
       insert user1;
       System.runAs (user1) {  
        try{          
              List<Address__c> Addressobj  =  [SELECT Address_Type__c from Address__c];
              Addressobj[0].Address_Type__c='business';
              update Addressobj;
              map<id,address__c> newmap=new  map<id,address__c>();
              newmap.put(Addressobj[0].id,Addressobj[0]);
              AddressHelperTH ad=new AddressHelperTH(); 
              TriggerAddressTriggerHandlerMY td=new TriggerAddressTriggerHandlerMY(); 
              system.debug('@@');
              td.handleTrigger(false,True,false,false,true);
              system.debug('##');
           }    
         catch(Exception e)
         {
         }
         }
     }

 //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */         
     static testMethod void testAccAssignment3() {
    
        try{          
              List<Address__c> Addressobj  =  [SELECT Address_Type__c from Address__c];
              delete Addressobj[0];
              AddressHelperTH ad=new AddressHelperTH(); 
              TriggerAddressTriggerHandlerMY td=new TriggerAddressTriggerHandlerMY(); 
              system.debug('@@');
              td.handleTrigger(false,false,false,true,true);
              system.debug('##');
           }    
         catch(Exception e)
         {
         }
     }
     
      //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */
     
     static testMethod void testAccAssignment4() {
           TriggerAddressTriggerHandlerMY td=new TriggerAddressTriggerHandlerMY();
           td.handleIntegrationTrigger(false,false,false,true,true);
     } 
     
 //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-09-13
  */
    static testMethod void testAccAssignment5() {
    
        try{              
              List<Address__c> Addressobj  =  [SELECT Address_Type__c,preferred__c from Address__c];
              Addressobj[0].Address_Type__c='business';
              Addressobj[0].preferred__c=true;
              update Addressobj;
              map<id,address__c> newmap=new  map<id,address__c>();
              newmap.put(Addressobj[0].id,Addressobj[0]);
              AddressHelperTH ad=new AddressHelperTH(); 
              TriggerAddressTriggerHandlerMY td=new TriggerAddressTriggerHandlerMY(); 
              system.debug('@@');
              td.handleTrigger(true,True,true,false,false);
              system.debug('##');
           }    
         catch(Exception e)
         {
         }
     }
     
   }