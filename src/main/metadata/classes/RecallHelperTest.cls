@isTest
private with sharing class RecallHelperTest {

    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.                                        
    static Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE, EuroVIN__c = '12345678901011000',
                                                UsVIN__c = '12345678901011000', RecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId());
    static Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE); 
    static Account account = new Account(Recall__c = FALSE, Phone = '1234567',
                                        Area_Code__c ='010',
                                         RecordTypeId = accPerson_RecordTypeId,
                                         LastName = 'lai');                                          
    static Recall__c custom = new Recall__c(VIN__c = '12345678901011000');                                    
       static testMethod void myUnitTest() {        
        User user1 = UtilTestData.createUser('IB CSR','CAC IB CSR');   
        system.runAs(user1){
            Test.startTest();
            testMain();
            Test.stopTest();
            system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,false);
            system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,false);
      }        
    }
                                                                                                                                                                                      
    @future
    private static void testMain(){
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;
        insert vehicles;
        insert account;
        VR.Contact__c = account.id;
        VR.Vehicle_ID__c = vehicles.id;
        insert VR;
        custom.Vehicle_ID__c = vehicles.id;
        insert custom;
        
        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,TRUE);
        
        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,TRUE);

        //test Recall__c is auto checked When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle_Relationship__c WHERE id = :VR.id].Recall__c,TRUE);


        delete custom;
        
        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,FALSE);
        
        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,FALSE);

        //test Recall__c is auto removed When custom insert
        system.assertEquals([SELECT Recall__c FROM Vehicle_Relationship__c WHERE id = :VR.id].Recall__c,FALSE);    
    
    }


}