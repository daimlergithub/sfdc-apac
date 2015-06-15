@isTest
private class VehicleRelationshipSharingTest {
	
    private static Account dealer;
    Private static Account acc; 
    private static Vehicle__c vehicle;
    private static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    //prepare test data
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        
		acc = new Account(Salutation='Brother',FirstName='test',LastName='acme', Phone='11111222', Area_Code__c = '010' ,RecordTypeId = personAccountRecordTypeId);
        insert acc;
        
        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;

        vehicle = new Vehicle__c();
        insert vehicle;
    }
    
    @isTest 
    static void testWrapRetailVehicleRelationships() {
        //prepare test data
        RecordType retailType = [select Id from RecordType where SObjectType = 'Vehicle_Relationship__c' and DeveloperName = 'Vehicle_Relationship_Retail' limit 1];
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(Contact__c=acc.id,RecordTypeId = retailType.Id, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        insert retailVehicleRelationship;
        
        //start test
        Test.startTest();
        VehicleRelationshipSharingWrapService wrapService = new VehicleRelationshipSharingWrapService();
        wrapService.wrapRetailVehicleRelationships(new List<Vehicle_Relationship__c>{retailVehicleRelationship});
        Test.stopTest();
        
       
    }

    @isTest 
    static void testVehicleRelationshipTrigger() {
        
         //start test
        Test.startTest();
        RecordType retailType = [select Id from RecordType where SObjectType = 'Vehicle_Relationship__c' and DeveloperName = 'Vehicle_Relationship_Retail' limit 1];
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(Contact__c=acc.id,RecordTypeId = retailType.Id, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        insert retailVehicleRelationship;
        Test.stopTest();
        //verify
         Vehicle_Relationship__c retailVehicleRelationship1 =[select Vehicle_ID__c from Vehicle_Relationship__c ];
        system.assertEquals(retailVehicleRelationship1.Vehicle_ID__c, retailVehicleRelationship.Vehicle_ID__c);
         
    }
}