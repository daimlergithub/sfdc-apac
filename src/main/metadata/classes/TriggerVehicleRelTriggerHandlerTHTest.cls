@isTest
public class TriggerVehicleRelTriggerHandlerTHTest{
 private static Account personAcc;
 private static Vehicle__c vehicle;
 private static Vehicle_Relationship__c vehicleRel;
 private static List<Vehicle_Relationship__c> vehicleRelList = new List<Vehicle_Relationship__c>();
 
 public static void prepareTestData(){
  Trigger__c TriggerAccountTH = new Trigger__c(Name='TriggerVehicleRelationshipTH',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
  insert TriggerAccountTH;
  
  // Prepare test data for Account
  personAcc = new Account(
                            Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '02-202-2456',Home_Phone_2__c = '02-202-2457',Work_Phone__c = '023482322525',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              LastName = 'galaxy1',
                              FirstName = 'First Name',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Shanghai',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '918197597651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=True,
                               //ownerid=user1.id,
                               PersonHasOptedOutOfEmail=True,
                               Opt_In_Email__c=true,
                               //owner=user1,
                               PersonBirthdate=date.today(),
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
    
   // Prepare test data for Vehicle
    vehicle = new Vehicle__c(Brand__c = 'BMW',
                             RecordTypeId=Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId()
                            );
     
     
   // Prepare test data for VehicleRelationship
    vehicleRel = new Vehicle_Relationship__c(Car_Relation__c = 'Purchaser',
                                            Contact__c = personAcc.Id,
                                            Vehicle_ID__c = vehicle.Id
                                            );

    vehicleRelList.add(vehicleRel);                                           
                                                                                      
 } 
 
 
 public static testMethod void testHandlerInsert(){
     prepareTestData();
     insert vehicleRelList;
     
 }
 
 public static testMethod void testHandlerUpdate(){
     prepareTestData();
     insert vehicleRelList;
     update vehicleRelList;
     
 } 
 
 public static testMethod void testHandlerDelete(){
     prepareTestData();
     insert vehicleRel;
     List<Vehicle_Relationship__c> vrList = [SELECT Id,Name FROM Vehicle_Relationship__c WHERE Id =:vehicleRel.Id];
     delete vrList;
     
 } 
 
 
}