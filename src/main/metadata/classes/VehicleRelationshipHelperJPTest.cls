@isTest(seeAllData=false)
public with sharing class VehicleRelationshipHelperJPTest{
    
       public static Vehicle_Relationship__c vehicle_relationship;
       public static List<Vehicle_Relationship__c> list_VR;
       public static Account testAccount;
       
       
       public static void createTestData(Date startDate, Date endDate){ 
           
           testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
           vehicle_relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilTestData.VEHICLE_RELATIONSHIP);
           vehicle_relationship.Start_Date__c = startDate;
           vehicle_relationship.End_Date__c = endDate;
           vehicle_relationship.Contact__c = testAccount.Id;
           update vehicle_relationship;
       }
       
       public static testMethod void testInsertValidation(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();         
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.Id, Start_Date__c=today, End_Date__c=today.addDays(1));
           vrHelperJP.validateOverlappingVehicleRelationship(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           system.assertNotEquals(list_VR, null);
           test.StopTest();
           
       }
       
       public static testMethod void testInsert(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.id, Start_Date__c=today, End_Date__c=today.addDays(2));
           vrHelperJP.validateOverlappingVehicleRelationship(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           system.assertNotEquals(list_VR, null);
           test.StopTest();
       }
}