/*
This test class has been created to cover a class UtilAccount

*/
@isTest
public With Sharing class UtilAccountTest
{
     public static List<Account> accList;
     public static Account accObj;
     public static Account dealer;
     public static Account pAccount;
     public static Vehicle__c vehicleObj;
     public static Vehicle_Relationship__c vehicleRelationshipObj;
     public static Lead__c leadObj;
     public static List<Lead__c> leadlst;

     public static testmethod void testBeforeAccDealerInfo()
     {
         Test.startTest();
         createData();
         System.debug('SKM ->'+accList.get(1));
         //accList.get(1).Dealer_DMS_SR_Code__c = 'TEST';
         accList.get(1).Status__c = 'Customer';
         accList.get(1).City_CN__c = 'CA';
         accList.get(1).Allow_Data_Sharing__c = 'Yes';
         accList.get(2).Allow_Data_Sharing__c = 'Yes';
         update accList;
         Test.stopTest();
     }
     public static void createData(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;

        accList = new List<Account>();
        Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez');
        accList.add(accObj);
        
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez', Dealer_Default_Flag__c = true, City_CN__c = 'MA');
        accList.add(accObj);
        
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='No',Phone ='0874760605');
        accList.add(accObj);
        
        insert accList;
        
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='tlikkkkkkkkllllll',EuroVIN__c ='tlikkkkkkkklllll',CurrentMileage__c=5000,NextMileage__c=6000);
        insert vehicleObj;
        
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id );
        insert vehicleRelationshipObj;
        
        leadlst = new List<Lead__c>();
        Id salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        leadObj = new Lead__c(Current_Vehicle__c = vehicleObj.Id,Contact__c = accList.get(2).Id,VehicleRel_No__c = vehicleRelationshipObj.Id,RecordTypeId = salesRecordTypeId,Assigned_Date_Time__c = system.now());
        leadlst.add(leadObj);
        insert leadlst;
    }
}