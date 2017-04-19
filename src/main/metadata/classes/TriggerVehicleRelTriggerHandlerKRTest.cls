/**
* Test class for TriggerVehicleRelTriggerHandlerKR
* Author : Chethan A
* Created date : 23-AUG-2016
*/

@isTest
public class TriggerVehicleRelTriggerHandlerKRTest{
 private static Account personAcc;
 private static Vehicle__c vehicle;
 private static Vehicle_Relationship__c vehicleRel;
 private static List<Vehicle_Relationship__c> vehicleRelList = new List<Vehicle_Relationship__c>();
 
 public static void prepareTestData(){
  Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerVehicleRelationshipKR',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerAccountKR;
  
  // Prepare test data for Account
  personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',City__c='Beijing',Gender__c = 'Male',Phone = '000-0000-9642',
                           Area_code__c = '0101',MD__c = 'KR',LastName = 'galaxy1',FirstName = 'First Name',Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',Mobile__c = '000-0000-9642',Mobile2__c = '000-0000-9642',Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
    insert personAcc;    
    
   // Prepare test data for Vehicle
    vehicle = new Vehicle__c(Vehicle_Name__c ='Test1',UsVIN__c ='abchgdtrsghtredfr',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02',
    Model__c = 'R350L 4MATIC',Class__c = 'A-Class',Purchase_Year__c = '2004',RegistrationNo__c = '12345',RecordTypeId=Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId());
    insert vehicle;
     
   system.debug('$$$$$$$$$$$$$$'+personAcc.Id);
   system.debug('$$$$$$$$$$$$$$'+vehicle.Id);  
   // Prepare test data for VehicleRelationship
    vehicleRel = new Vehicle_Relationship__c(Car_Relation__c = 'Purchaser',Contact__c = personAcc.Id,Vehicle_ID__c = vehicle.Id);
    
    vehicleRelList.add(vehicleRel);                                           
                                                                                      
 } 
 
 
 public static testMethod void testHandlerInsert(){
     try{
     prepareTestData();
     insert vehicleRelList;
     }catch(exception e){}
 }
 
 public static testMethod void testHandlerUpdate(){
     try{
     prepareTestData();
     insert vehicleRelList;
     update vehicleRelList;
     }catch(exception e){}
 } 

/* 
  public static testMethod void testHandlerDelete(){
     prepareTestData();
     insert vehicleRelList;
     
     Delete ;
     
 } */
 
}