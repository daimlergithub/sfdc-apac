@isTest
public class UtilVehicleRelationshipTest {
    
     private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    private static String vehicleRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static testMethod void testcheckVehcileValidity() {
        
       
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Person Account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        // Create Vehicle
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Valid__c='NO';
         vehicle = (Vehicle__c)UtilTestData.createSobject(vehicle, null);
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship.Vehicle_ID__c = vehicle.Id;
        relationship.Contact__c = personAccount.Id;
        relationship.Selling_Dealer__c = dealer.Id;
        relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, null);
        list<Vehicle_Relationship__c> listUV = new  list<Vehicle_Relationship__c>();
        listUV.add(relationship);
        UtilVehicleRelationship.checkVehcileValidity(listUV);
        
        
        // Start Test
        Test.startTest();

        relationship.Validity__c = 'Yes';
        update relationship; 
        list<Vehicle_Relationship__c> listUVnew = new  list<Vehicle_Relationship__c>();
        listUVnew.add(relationship);
        UtilVehicleRelationship.checkVehcileValidity(listUVnew);
        
       
        Test.stopTest();
        //verify
         System.assert([SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id].Valid__c == 'Yes');
  
     

       
    }
    public static testMethod void testUpdateVehicle() {
        
       
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Person Account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        // Create Vehicle
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Valid__c='NO';
         vehicle = (Vehicle__c)UtilTestData.createSobject(vehicle, null);
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship.Vehicle_ID__c = vehicle.Id;
        relationship.Contact__c = personAccount.Id;
         relationship.Validity__c = 'NO';
        relationship.Selling_Dealer__c = dealer.Id;
        relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, null);
        
        list<Vehicle_Relationship__c> queryList1 = new list<Vehicle_Relationship__c>();
        queryList1.add(relationship);
        
        
        Vehicle_Relationship__c relationshipQuery=[select Validity__c,Vehicle_ID__c from Vehicle_Relationship__c where id in:queryList1];
        
        map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
        oldMap.put(relationshipQuery.id, relationshipQuery);
        list<Vehicle_Relationship__c> listUV = new  list<Vehicle_Relationship__c>();
        listUV.add(relationshipQuery);
       // UtilVehicleRelationship.updateVehicle(listUV,oldMap,true,false);
        
          Vehicle_Relationship__c relationship2 = new Vehicle_Relationship__c();
        relationship2.RecordTypeId=RecordTypeId;
        relationship2.Vehicle_ID__c = vehicle.Id;
        relationship2.Contact__c = personAccount.Id;
         relationship2.Validity__c = 'Unknown';
        relationship2.Selling_Dealer__c = dealer.Id;
         relationship2= (Vehicle_Relationship__c)UtilTestData.createSobject(relationship2, null);
         list<Vehicle_Relationship__c> queryList = new list<Vehicle_Relationship__c>();
        queryList.add(relationship2);
        Vehicle_Relationship__c relationshipQuery2=[select Validity__c,Vehicle_ID__c from Vehicle_Relationship__c where id in : queryList];
        
        map<id,Vehicle_Relationship__c> oldMap2 = new map<id,Vehicle_Relationship__c>();
        oldMap2.put(relationshipQuery2.id, relationshipQuery2);
        list<Vehicle_Relationship__c> listUV2 = new  list<Vehicle_Relationship__c>();
        listUV.add(relationshipQuery2);
       
        // Start Test
        Test.startTest();

        // Test TriggerVehicleRelationship
        // Vehicle has two child relationships, if any one is Yes,
        // vehicle Valid is Yes
        relationship.Validity__c = 'Yes';
        update relationship;
         map<id,Vehicle_Relationship__c> newMap = new map<id,Vehicle_Relationship__c>();
        newMap.put(relationship.id, relationship);
        list<Vehicle_Relationship__c> listUVnew = new  list<Vehicle_Relationship__c>();
        listUVnew.add(relationship);
        UtilVehicleRelationship.updateVehicle(listUVnew,oldMap,false,true);
        
        
         relationship2.Validity__c = 'NO';
        update relationship2;
         map<id,Vehicle_Relationship__c> newMap2 = new map<id,Vehicle_Relationship__c>();
        newMap.put(relationship2.id, relationship2);
        list<Vehicle_Relationship__c> listUVnew2 = new  list<Vehicle_Relationship__c>();
        listUVnew2.add(relationship2);
        UtilVehicleRelationship.updateVehicle(listUVnew2,oldMap2,false,true);
        
        
        // Stop Test
        Test.stopTest();
        
        //verify
          System.assert([SELECT Valid__c FROM Vehicle__c WHERE Id = :vehicle.Id].Valid__c == 'No');
    }
}