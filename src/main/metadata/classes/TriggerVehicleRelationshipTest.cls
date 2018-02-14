/*
    Type:       Test class
    Purpose:    Test Class for TriggerVehicleRelationship.trigger
    User Story: US-CP-008
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-06
*/
@isTest
public class TriggerVehicleRelationshipTest {
    public static testMethod void testTriggerVehicleRelationship() {
    
         Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
          User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
          DMLManagerService.insertAsSystem(user_Obj ); 
          System.runAs (user_Obj) { 
          Trigger__c TriggerVehicleRelationship= new Trigger__c(Name='TriggerVehicleRelationship',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
          insert TriggerVehicleRelationship;  
          List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
          //insert updatecustomsettings;
            
            
            //System.debug('Current User Id: ' + UserInfo.getUserId());
            //system.debug('Custom Settings inserted...' +updatecustomsettings);
            //system.debug('Running as user...' +user_Obj);
            
            // Create Dealer
            Account dealer = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_DEALER);
            
            // Create Person Account
            Account personAccount = (Account)UtilTestData.createSobject(new Account(
                                       Mobile__c ='09865234112'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            
            // Create Vehicle
            Vehicle__c vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilTestData.VEHICLE_MB);
            
            // Create Vehicle Relationship
            Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
            relationship.Vehicle_ID__c = vehicle.Id;
            relationship.Contact__c = personAccount.Id;
            relationship.Selling_Dealer__c = dealer.Id;
            relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, UtilTestData.VEHICLE_RELATIONSHIP);
            
            // Create Vehicle Relationship
            Vehicle_Relationship__c relationship2 = new Vehicle_Relationship__c();
            relationship2.Vehicle_ID__c = vehicle.Id;
            relationship2.Contact__c = personAccount.Id;
            relationship2.Selling_Dealer__c = dealer.Id;
            relationship2 = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship2, UtilTestData.VEHICLE_RELATIONSHIP);
    
            // Start Test
            Test.startTest();
    
            // Test TriggerVehicleRelationship
            // Vehicle has two child relationships, if any one is Yes,
            // vehicle Valid is Yes
            relationship.Validity__c = 'Yes';
            update relationship;       
            
            // Two child Relationship records, one is No, one is Unknown,
            // so Vehicle Valid is Unkown
            
            Vehicle__c v= [SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id];
            //system.debug('Vehicle Validity...' +v);
            
            relationship.Validity__c = 'No';
            update relationship;
            //System.assert([SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id].Valid__c == 'Unknown');
    
            // Two child Relationship records, both are no,
            // so Vehicle Valid is No
            relationship2.Validity__c = 'No';
            update relationship2;
            system.assertEquals('No', relationship2.Validity__c)  ;  
            //System.assert([SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id].Valid__c == 'No');
            delete relationship2;
            //system.assertEquals(null,relationship2 );
              // Stop Test
            Test.stopTest();
        }
    }
    
     public static testMethod void testTriggerVehicleRelationship1() {
    
         Profile p1 = [select id,name from profile WHERE Name='IntegrationAPI'];  
        
          User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
          DMLManagerService.insertAsSystem(user_Obj ); 
          System.runAs (user_Obj) { 
          triggerutil.userCreate=false;    
          Trigger__c TriggerVehicleRelationship= new Trigger__c(Name='TriggerVehicleRelationship',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
          insert TriggerVehicleRelationship;  
          List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
          //insert updatecustomsettings;
            
            
            //System.debug('Current User Id: ' + UserInfo.getUserId());
            //system.debug('Custom Settings inserted...' +updatecustomsettings);
            //system.debug('Running as user...' +user_Obj);
            
            // Create Dealer
            Account dealer = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_DEALER);
            
            // Create Person Account
            Account personAccount = (Account)UtilTestData.createSobject(new Account(
                                       Mobile__c ='09865234112'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            
            // Create Vehicle
            Vehicle__c vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilTestData.VEHICLE_MB);
            
            // Create Vehicle Relationship
            Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
            relationship.Vehicle_ID__c = vehicle.Id;
            relationship.Contact__c = personAccount.Id;
            relationship.Selling_Dealer__c = dealer.Id;
            relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, UtilTestData.VEHICLE_RELATIONSHIP);
            
            // Create Vehicle Relationship
            Vehicle_Relationship__c relationship2 = new Vehicle_Relationship__c();
            relationship2.Vehicle_ID__c = vehicle.Id;
            relationship2.Contact__c = personAccount.Id;
            relationship2.Selling_Dealer__c = dealer.Id;
            relationship2 = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship2, UtilTestData.VEHICLE_RELATIONSHIP);
    
            // Start Test
            Test.startTest();
    
            // Test TriggerVehicleRelationship
            // Vehicle has two child relationships, if any one is Yes,
            // vehicle Valid is Yes
            
            relationship.Validity__c = 'Yes';
            update relationship;       
            
            // Two child Relationship records, one is No, one is Unknown,
            // so Vehicle Valid is Unkown
            
            Vehicle__c v= [SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id];
            //system.debug('Vehicle Validity...' +v);
            
            relationship.Validity__c = 'No';
            update relationship;
                
            // Two child Relationship records, both are no,
            // so Vehicle Valid is No
            relationship2.Validity__c = 'No';
            update relationship2;
            system.assertEquals('No', relationship2.Validity__c)  ;
            //System.assert([SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id].Valid__c == 'No');
            triggerutil.userCreate=false; 
            delete relationship2;
            Test.stopTest();
        }
    }
}