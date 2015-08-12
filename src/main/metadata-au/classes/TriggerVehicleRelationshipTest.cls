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
    private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    private static String vehicleRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
   
    public static testMethod void testAUTriggerVehicleRelationship() {
        
        
        
        //create test data
       Car_Model__c car= new Car_Model__c();
        car.Name='A-Class';
        car.Vehicle_Group__c='PC';
        insert car;
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        dealer.Email__c='test@mbau.com';
                    dealer.Email2__c = 'testemail2@test.com';
                    dealer.Home_Phone_2__c = '98765413';  
        
        // Create Person Account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        personAccount.Email__c='test@mbau.com';
                    personAccount.Email2__c = 'testemail2@test.com';
                    personAccount.Home_Phone_2__c = '98765413';  
        
        // Create Vehicle
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.RecordTypeId=vehicleRecordTypeId;
       vehicle.Car_Model__c=car.Id;
        vehicle.Class__c='A-Class';
       
        vehicle=(Vehicle__c)UtilTestData.createSobject(vehicle, null);
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship.Vehicle_ID__c = vehicle.Id;
        relationship.Contact__c = personAccount.Id;
        relationship.Selling_Dealer__c = dealer.Id;
        
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship2 = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship2.Vehicle_ID__c = vehicle.Id;
        relationship2.Contact__c = personAccount.Id;
        relationship2.Selling_Dealer__c = dealer.Id;
       
        
        // Start Test
        Test.startTest();
        relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, null);
        relationship2 = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship2, null);          
        Test.stopTest();
        list<Vehicle_Relationship__c> vrId=new list<Vehicle_Relationship__c>();
        vrId.add(relationship);
        
        //verify 
        
       Vehicle_Relationship__c  vrList = [select Vehicle_ID__c from Vehicle_Relationship__c where id IN:vrId ];
        system.assertEquals(vrList.Vehicle_ID__c, relationship.Vehicle_ID__c);
        system.assertEquals(vrList.Vehicle_ID__c, relationship2.Vehicle_ID__c);
    }
}