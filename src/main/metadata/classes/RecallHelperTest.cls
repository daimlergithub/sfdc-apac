@isTest
private with sharing class RecallHelperTest {
    
    static set<Id> vehicleIDS = new set <Id> ();
    static list <Recall__c> recalist = new list <Recall__c> ();
    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.                                        
    static Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE, EuroVIN__c = '12345678901011000',
                                                UsVIN__c = '12345678901011000', RecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId());
    static Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE , Vehicle_ID__c= vehicles.Id); 
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
            RecallHelper RecallHelp = new RecallHelper();
        //RecallHelper.removeRecall(vehicleIDS);
        RecallHelper.updateRecall(vehicleIDS);
        RecallHelper.AfterInsertEvent(recalist);
        RecallHelper.beforeDeleteEvent(recalist);
            Test.stopTest();
            //system.assertEquals([SELECT Recall__c FROM Vehicle__c WHERE id = :vehicles.id AND UsVIN__c = '12345678901011000'].Recall__c,false);
            //system.assertEquals([SELECT Recall__c FROM Account WHERE id = :account.id].Recall__c,false);
      }        
    }
                                                                                                                                                                                      
    private static void testMain(){
        list<Account> accList = new List<Account>();
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         //insert updatecustomsettings;
          Trigger__c TriggerVehicleRelationshipKR=new Trigger__c(Name='TriggerVehicleRelationship',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerJP',
                                                         update__c=False,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='KR');                                                         
    insert TriggerVehicleRelationshipKR;  
         
        insert vehicles;
        accList.add(account);

        //insert accList;

        //insert account;
        //VR.Contact__c = accList[0].id;
        VR.Vehicle_ID__c = vehicles.id;
        //insert VR;
        custom.Vehicle_ID__c = vehicles.id;
        insert custom;
        vehicleIDS.add(vehicles.Id);
        recalist.add(custom);
       /* list <Recall__c> recalist = new list <Recall__c> ();
        recalist = [select Id,Recall__c.Vehicle_ID__c from Recall__c];
        
        set<Id> vehicleIDS = new set <Id> ();
        list <Vehicle__c> vehicleList = new list <Vehicle__c> ();
        vehicleList = [select Id FROM Vehicle__c];
        for (Vehicle__c v: vehicleList)
        {
        vehicleIDS.add(v.Id);
        }*/
        //test Recall__c is auto checked When custom insert
       


        delete custom;
      
    }

}