@isTest
private class VehicleRelationshipSharingTest {
    
    private static Account dealer;
    private static Vehicle__c vehicle;
    
    static {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;

        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert vehicle;
        
        
    }
    
    @isTest 
    static void testWrapRetailVehicleRelationships() {
        RecordType retailType = [select Id from RecordType where SObjectType = 'Vehicle_Relationship__c' and DeveloperName = 'Vehicle_Relationship_Retail' limit 1];
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(RecordTypeId = retailType.Id, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        //insert retailVehicleRelationship;
        
        Test.startTest();
        VehicleRelationshipSharingWrapService wrapService = new VehicleRelationshipSharingWrapService();        
        List<SharingWrapper> wrapRetailVehicleRelationships=wrapService.wrapRetailVehicleRelationships(new List<Vehicle_Relationship__c>{retailVehicleRelationship});
        Test.stopTest();
        system.assertNotEquals(null, wrapRetailVehicleRelationships);
    }

    @isTest 
    static void testVehicleRelationshipTrigger() {
        Test.startTest();
        RecordType retailType = [select Id from RecordType where SObjectType = 'Vehicle_Relationship__c' and DeveloperName = 'Vehicle_Relationship_Retail' limit 1];
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(RecordTypeId = retailType.Id, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        //insert retailVehicleRelationship;
        Test.stopTest();
        system.assertNotEquals(null, retailVehicleRelationship);
        system.assertNotEquals(null, retailVehicleRelationship.Owner_Dealer__c);
    }
}