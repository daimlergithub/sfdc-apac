@isTest
private class VehicleRelationshipHelperTest {

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
       
       Test.StartTest();
        insert vehicles;
        insert account1;
        insert account2;
        VR.Contact__c = account1.id;
        VR.Vehicle_ID__c = vehicles.id;
        VR.Owner_Dealer__c = account2.id;
        insert VR;
        VR1.Contact__c = account1.id;
        VR1.Vehicle_ID__c = vehicles.id;
        VR1.Owner_Dealer__c = account2.id;
        insert VR1;
         Test.stopTest();
        system.assertEquals(VR1.Contact__c,account1.id); 

    }
                                                                                                                                                                                      
}