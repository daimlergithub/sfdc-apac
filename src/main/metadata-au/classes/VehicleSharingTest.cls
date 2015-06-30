@isTest
private class VehicleSharingTest {
    Private static Account acc; 
    
    private static Account dealer;
    private static Vehicle__c vehicle;
    private static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Private static String accountLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId();   
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    Private static String retailType =Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get(UtilTestData.Vehicle_Relationship_Retail).getRecordTypeId();
    Private static String VehicleRetailType =Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    //create test data
    static {      
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;
        
        acc = new Account(Salutation='Brother',FirstName='test',LastName='acme', Phone='11111222', Area_Code__c = '010' ,Email__c='test011@test.com',Email2__c='test012@test.com',Home_Phone_2__c = '98765413', RecordTypeId = personAccountRecordTypeId);
        
        insert acc;
       
     
        
        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;        
                      
        vehicle = new Vehicle__c(RecordTypeId=VehicleRetailType);
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContact2Contact() {
    	//create test data
    	  Account_Link__c accountLink = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
    	  
    	 //start test
        Test.startTest();            
        VehicleSharingWrapService wrapService = new VehicleSharingWrapService();
         List<SharingWrapper> testSharingWrapC2C = wrapService.wrapVehicleFromAccountLinks(new List<Account_Link__c>{accountLink});
        Test.stopTest();
        system.assertNotEquals(null, testSharingWrapC2C);

    }
    
    @isTest 
    static void testWrapRetailVehicleRelationships() {
    	//create test data
        Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(Contact__c=acc.id,RecordTypeId = retailType, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
        insert retailVehicleRelationship;
        
         //start test
        Test.startTest();
        VehicleSharingWrapService wrapService = new VehicleSharingWrapService();
      List<SharingWrapper> wrapVehicleFromRetailRelationships=wrapService.wrapVehicleFromRetailRelationships(new List<Vehicle_Relationship__c>{retailVehicleRelationship});
        Test.stopTest();
        system.assertNotEquals(null, wrapVehicleFromRetailRelationships);
    }

    @isTest
    static void testVehicleTrigger() {
    	//create test data
    	 Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c(Contact__c=acc.id,RecordTypeId = retailType, Owner_Dealer__c = dealer.Id, Vehicle_ID__c = vehicle.Id);
         Account_Link__c accountLink = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
    	 //start test
        Test.startTest();
         insert retailVehicleRelationship;
         insert accountLink;
        Test.stopTest();
        //verify
        Vehicle_Relationship__c VR=[select Vehicle_ID__c from Vehicle_Relationship__c];
        system.assertEquals(VR.Vehicle_ID__c, vehicle.Id);
        
    }
}