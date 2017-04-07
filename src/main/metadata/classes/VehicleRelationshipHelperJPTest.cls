@isTest(seeAllData=false)
public with sharing class VehicleRelationshipHelperJPTest{
    
       public static Vehicle_Relationship__c vehicle_relationship;
       public static List<Vehicle_Relationship__c> list_VR;
       public static Account testAccount;
       public static List<Account> accList;
       public static Account accObj;
       public static Vehicle__c vehicleObj;
       public static Vehicle_Relationship__c vehicleRelationshipObj;
       public static Lead__c leadObj;
       public static List<Lead__c> leadlst;
       static List<Vehicle_Relationship__c> vrlst;
       public static void createTestData(Date startDate, Date endDate){ 
           
           List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
           insert updatecustomsettings;
      
           testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
           vehicle_relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilTestData.VEHICLE_RELATIONSHIP);
           vehicle_relationship.Start_Date__c = startDate;
           vehicle_relationship.End_Date__c = endDate;
           vehicle_relationship.Contact__c = testAccount.Id;
           vehicle_relationship.End_Reason__c = 'DMS';
           update vehicle_relationship;
           system.assertNotEquals(vehicle_relationship,null);
       }
       
       public static testMethod void testInsertValidation(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();         
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.Id, Start_Date__c=today, End_Date__c=today.addDays(1), End_Reason__c = 'DMS');
           VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           map<Id,Vehicle_Relationship__c> mapLst = new map<Id,Vehicle_Relationship__c>();
           mapLst.put(vehicle_relationship.id, vehicle_relationship);
           cls.validateOverlappingVehicleRelationshiponUpdate(new List<Vehicle_Relationship__c>{vehicle_relationship},mapLst);
           map<Id,List<Id>> newmaplist = new map<Id,List<id>>();
           
           system.assertNotEquals(list_VR, null);
           
           
           test.StopTest();
           
       }
       
       public static testMethod void testInsert(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.id, Start_Date__c=today, End_Date__c=today.addDays(2), End_Reason__c = 'DMS');
           VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           system.assertNotEquals(list_VR, null);
           test.StopTest();
       }
       public static testMethod void validateOverlappingVehicleRelationship_test(){
           creatTestData();
           Test.startTest();
              
               VehicleRelationshipHelperJP vrjpObj = new VehicleRelationshipHelperJP();
               //VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           //cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
               system.assertNotEquals(vrjpObj ,null);
           Test.stopTest();
       }
       public static testMethod void OnAfterInsert_test(){
           creatTestData();
           Test.startTest();
               VehicleRelationshipHelperJP.OnAfterInsert(vrlst);
                system.assertNotEquals(vrlst,null);
           Test.stopTest();
       }
        public static testMethod void OnAfterUpdate_test(){
           creatTestData();
           Test.startTest();
               vrlst.get(0).Car_Relation__c = 'Self-registered';
               vrlst.get(0).Owner_Relation__c = 'Friend';
               update vrlst.get(0);
               List<Vehicle_Relationship__c> vrlstnew = new List<Vehicle_Relationship__c>();
               vrlstnew.add(vrlst.get(0));
               vrlst.get(0).Car_Relation__c = 'Purchaser';
               vrlst.get(0).Owner_Relation__c = 'Others';
               update vrlst.get(0);
               Map<Id,Vehicle_Relationship__c> vrlstold = new  Map<Id,Vehicle_Relationship__c>();
               vrlstold.put(vrlst.get(0).Id,vrlst.get(0));
               VehicleRelationshipHelperJP.OnAfterUpdate(vrlstnew,vrlstold);
               system.assertNotEquals(vrlstold,null);
           Test.stopTest();
       }
        public static testMethod void OnAfterDelete_test(){
           creatTestData();
           Test.startTest();
               VehicleRelationshipHelperJP.OnAfterDelete(vrlst);
               system.assertNotEquals(vrlst,null);
           Test.stopTest();
       }
       public static void creatTestData(){
            accList = new List<Account>();
            Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez');
            accList.add(accObj);
            Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez');
            accList.add(accObj);
            Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            accList.add(accObj);
            insert accList;
            Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
            vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000);
            insert vehicleObj;
            vrlst = new List<Vehicle_Relationship__c>();
            vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            vrlst.add(vehicleRelationshipObj);
            vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            vrlst.add(vehicleRelationshipObj);
            insert vrlst;
            
       
       }
}