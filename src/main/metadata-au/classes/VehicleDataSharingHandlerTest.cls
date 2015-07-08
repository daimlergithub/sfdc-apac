@isTest
public class VehicleDataSharingHandlerTest {
     private static String vehicleRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
private static  Vehicle_Relationship__c relationship2;
    private static  Account dealer;
    
    
    
    private static void createTestData()
    {
         Car_Model__c car= new Car_Model__c();
        car.Name='A-Class';
        car.Vehicle_Group__c='PC';
        insert car;
        
          dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        
         Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
         Vehicle__c vehicle = new Vehicle__c();
        vehicle.RecordTypeId=vehicleRecordTypeId;
       vehicle.Car_Model__c=car.Id;
        vehicle.Class__c='A-Class';
       
        vehicle=(Vehicle__c)UtilTestData.createSobject(vehicle, null);
        
        
          relationship2 = new Vehicle_Relationship__c();
        relationship2.RecordTypeId=RecordTypeId;
        relationship2.Vehicle_ID__c = vehicle.Id;
        relationship2.Contact__c = personAccount.Id;
        relationship2.Selling_Dealer__c = dealer.Id;
       
        relationship2 = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship2, null); 
        system.debug('relationship2'+relationship2);
        
        
    }
    
    
    private static testmethod void testExecuteProcessByCRMCode(){
        createTestData();
        
        list<Account>  lstVH = new list<Account>();
        lstVH.add(dealer);
        
        VehicleDataSharingHandler vr =new VehicleDataSharingHandler();
           vr.executeProcessByCRMCode(lstVH);
        
    }

}