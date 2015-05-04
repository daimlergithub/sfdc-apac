@isTest
private class VehicleSharingTest {
	
	private static Account dealer;
    private static Vehicle__c vehicle;
    Private static String accountLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId();   
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    Private static String retailType =Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get(UtilTestData.Vehicle_Relationship_Retail).getRecordTypeId();
    static {      
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;        
                      
        vehicle = new Vehicle__c();
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContact2Contact() {
        Test.startTest();            
        Account_Link__c accountLink = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        VehicleSharingWrapService wrapService = new VehicleSharingWrapService();
        wrapService.wrapVehicleFromAccountLinks(new List<Account_Link__c>{accountLink});
        Test.stopTest();
    }
	
	@isTest 
    static void testWrapRetailVehicleRelationships() {
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(RecordTypeId = retailType, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        insert retailVehicleRelationship;
        
        Test.startTest();
        VehicleSharingWrapService wrapService = new VehicleSharingWrapService();
        wrapService.wrapVehicleFromRetailRelationships(new List<Vehicle_Relationship__c>{retailVehicleRelationship});
        Test.stopTest();
    }

    @isTest
    static void testVehicleTrigger() {
    	Test.startTest();
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(RecordTypeId = retailType, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        insert retailVehicleRelationship;
        Account_Link__c accountLink = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        insert accountLink;
        Test.stopTest();
    }
}