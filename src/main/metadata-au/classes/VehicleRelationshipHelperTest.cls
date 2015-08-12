@isTest
private class VehicleRelationshipHelperTest {
     private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    private static String vehicleRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();     // Dealer.
    static Id accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
    static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();    //VehicleRelationship
    
     
        
    
     
                                            
    static Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
                                                
    static Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = VRRecordTypeId);
    // CR-000119
    static Vehicle_Relationship__c VR1 = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Owner', RecordTypeId = VRRecordTypeId);
    
    static Account account1 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code1',
                                    //Status__c='Unknown',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_Code__c = '010',
                                    PersonTitle='Mr',
                                    Salutation='Brother',
                                    FirstName='Test',
                                    LastName = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    RecordTypeId=accPerson_RecordTypeIdp);

    static Account account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '80801011',
                                    Area_Code__c = '010',            
                                    Name = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    RecordTypeId=accPerson_RecordTypeId);
                                                                    
                                                                                                                                   
    static testMethod void myUnitTest() {
        UserRole role = [SELECT Id, Name FROM UserRole where  Name = 'Australia'];
        
        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user2 = new User(ProfileId = profile.Id,UserRoleId=role.id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user2;
        set<id> users= new set<id> ();
        users.add(user2.id);
       system.runAs( user2 ) {
        insert vehicles;
        insert account1;
        insert account2;
        VR.Contact__c = account1.id;
        VR.Vehicle_ID__c = vehicles.id;
        VR.Owner_Dealer__c = account2.id;
        insert VR;
        list<Vehicle_Relationship__c> listVR = new  list<Vehicle_Relationship__c>();
        listVR.add(VR);
        VehicleRelationshipHelper.shareVR(listVR);
        VR1.Contact__c = account1.id;
        VR1.Vehicle_ID__c = vehicles.id;
        VR1.Owner_Dealer__c = account2.id;
        insert VR1;
        VehicleRelationshipHelper.getRoleSubordinateUsers(user2.id);
      
      
       }
       system.assertNotEquals(null, VehicleRelationshipHelper.getRoleSubordinateUsers(user2.id));
    }
    public static testMethod void testAUTriggerVehicleRelationship() {
        
        
        
        //create test data
       Car_Model__c car= new Car_Model__c();
        car.Name='A-Class';
        car.Vehicle_Group__c='PC';
        insert car;
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Person Account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
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