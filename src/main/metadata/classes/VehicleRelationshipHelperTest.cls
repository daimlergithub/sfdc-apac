/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

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
                                    City_CN__c='Beijing',
                                    Phone = '80801010',
                                    Area_Code__c = '010',
                                    LastName = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    RecordTypeId=accPerson_RecordTypeIdp);

    static Account account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City_CN__c='Beijing',
                                    Phone = '80801011',
                                    Area_Code__c = '010',            
                                    Name = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    RecordTypeId=accPerson_RecordTypeId);
                                                                    
                                                                                                                                   
    static testMethod void myUnitTest() {
       
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
        
        //test Vehicle_Relationship__Share is auto inserted When Vehicle Relationship created
        //system.assertEquals([SELECT id FROM Vehicle_Relationship__Share WHERE ParentId = :VR.id AND AccessLevel = 'Read'].size(), 3);

    }
                                                                                                                                                                                      
}