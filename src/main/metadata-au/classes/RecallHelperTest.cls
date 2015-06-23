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
private class RecallHelperTest {

    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
                                            
    static Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE, EuroVIN__c = '12345678901011000',
                                                UsVIN__c = '12345678901011000', RecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId());
                                                
    static Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE); 
                                                                    
    static Account account = new Account(Recall__c = FALSE, Phone = '1234567',
                                        Area_Code__c ='010',
                                         RecordTypeId = accPerson_RecordTypeId,firstname='test acme',Salutation='Brother',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413',
                                         LastName = 'lai'); 
                                         
    static Recall__c custom = new Recall__c(VIN__c = '12345678901011000');
                                     
                                                                               
                                         
    static testMethod void myUnitTest() {
        
        User user1 = UtilTestData.createUser('IB CSR','CAC IB CSR');
   
        system.runAs(user1){
            Test.startTest();
            testMain();
            Test.stopTest();
        }
        
    }
                                                                                                                                                                                      
    @future
    private static void testMain(){
        insert vehicles;
        insert account;
        VR.Contact__c = account.id;
        VR.Vehicle_ID__c = vehicles.id;
        insert VR;
        custom.Vehicle_ID__c = vehicles.id;
        insert custom;
        
        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,
                            TRUE);
        
        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,
                            TRUE);

        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle_Relationship__c WHERE id = :VR.id].Recall__c,
                            TRUE);


        delete custom;
        
        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,
                            FALSE);
        
        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,
                            FALSE);

        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle_Relationship__c WHERE id = :VR.id].Recall__c,
                            FALSE);    
    
    }


}