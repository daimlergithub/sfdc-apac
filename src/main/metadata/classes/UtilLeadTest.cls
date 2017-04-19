@isTest
public With Sharing class UtilLeadTest
{
    public static List<Account> accList;
    public static Account accObj;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj;
    public static Lead__c leadObj;
    public static List<Lead__c> leadlst;
    public static testmethod void updateLeadForDataSharing_test()
    {
        createData();
        Test.startTest();
            List<Lead__c> leadlstCustom = new List<Lead__c>();
            leadlstCustom.add(leadlst.get(0));
            UtilLead.updateLeadForDataSharing(leadlstCustom);
            UtilLead.updateRelatedVehicleRelFields(leadlstCustom);
            system.assertNotEquals(leadlstCustom ,null);
        Test.stopTest();
    }
    public static testmethod void beforeInsert_updateEvents_test()
    {
        createData();
        Test.startTest();
            List<Lead__c> leadlstCustom = new List<Lead__c>();
            leadlstCustom.add(leadlst.get(1));
            map<Id,Lead__c> leadOldmap = new map<Id,Lead__c>();
            leadOldmap.put(leadlst.get(1).Id,leadlst.get(1));
            UtilLead.beforeInsert_updateEvents(leadlstCustom,leadOldmap,true,false);
            leadlstCustom.clear();
            leadOldmap.clear();
            leadlstCustom.add(leadlst.get(2));
            leadOldmap.put(leadlst.get(2).Id,leadlst.get(2));
            UtilLead.beforeInsert_updateEvents(leadlstCustom,leadOldmap,false,true);
            system.assertNotEquals(leadlstCustom ,null);
            
            //UtilLead.updateRelatedVehicleRelFields(leadlstCustom);
        Test.stopTest();
    }
    public static testmethod void utilProfile_Test(){
        Test.startTest();
            UtilProfile.getProfileId('System Administrator');
           try{
            UtilProfile.getProfileId('');
            
            }catch(Exception e){
                system.assertNotEquals(e.getMessage(),null);
            }
            try{
              UtilProfile.getProfileId('Test');
            }catch(Exception e){
                system.assertNotEquals(e.getMessage(),null);
            }
        Test.stopTest();
        
    }
     public static testmethod void UtilSobject_test()
    {
        createData();
        Test.startTest();
            List<Lead__c> errorlist = new List<Lead__c>();
            errorlist.add(leadlst.get(0));
            
            UtilSobject.updateSobjects(errorlist);
            errorlist.clear();
            errorlist.add(leadlst.get(0));
            UtilSobject.updateSobjects(errorlist);
            errorlist.clear();
            UtilSobject.updateSobjects(errorlist);
            system.assertNotEquals(errorlist,null);
          
        Test.stopTest();
    }
    public static testmethod void UtilSobjectDelete_test()
    {
        createData();
        Test.startTest();
            List<Lead__c> errorlist = new List<Lead__c>();
            errorlist.add(leadlst.get(0));
            UtilSobject.deleteSobjects(errorlist);
            errorlist.clear();
            UtilSobject.deleteSobjects(errorlist);
            system.assertNotEquals(errorlist,null);
          
        Test.stopTest();
    }
     public static testmethod void UtilSobjectInsert_test()
    {
        createData();
        Test.startTest();
            Id salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
            leadObj = new Lead__c(Current_Vehicle__c = vehicleObj.Id,Contact__c = accList.get(2).Id,VehicleRel_No__c = vehicleRelationshipObj.Id,RecordTypeId = salesRecordTypeId,Assigned_Date_Time__c = system.now());
            List<Lead__c> errorlist = new List<Lead__c>();
            errorlist.add(leadObj);
            UtilSobject.insertSobjects(errorlist);
            errorlist.clear();
            UtilSobject.insertSobjects(errorlist);
            system.assertNotEquals(errorlist,null);
          
        Test.stopTest();
    }
    
    public static void createData(){
        accList = new List<Account>();
        Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez',
        Mobile__c ='01234567895');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',
        Mobile__c ='01234567896');
        accList.add(accObj);
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605',
        Mobile__c ='01234567892');
        accList.add(accObj);
        insert accList;
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='tlikkkkkkkklllll8',Recall__c = FALSE,
        EuroVIN__c = '12345678901111111',CurrentMileage__c=5000,NextMileage__c=6000,FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert vehicleObj;
        
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id );
        insert vehicleRelationshipObj;
        leadlst = new List<Lead__c>();
        leadObj = new Lead__c(Current_Vehicle__c = vehicleObj.Id,Contact__c = accList.get(2).Id,VehicleRel_No__c = vehicleRelationshipObj.Id,Assigned_Date_Time__c = system.now());
        leadlst.add(leadObj);
        Id aftersalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        leadObj = new Lead__c(Current_Vehicle__c = vehicleObj.Id,Contact__c = accList.get(2).Id,VehicleRel_No__c = vehicleRelationshipObj.Id,RecordTypeId = aftersalesRecordTypeId,Assigned_Date_Time__c = system.now());
        leadlst.add(leadObj);
        Id salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        leadObj = new Lead__c(Current_Vehicle__c = vehicleObj.Id,Contact__c = accList.get(2).Id,VehicleRel_No__c = vehicleRelationshipObj.Id,RecordTypeId = salesRecordTypeId,Assigned_Date_Time__c = system.now());
        leadlst.add(leadObj);
        insert leadlst;
       
        
        
    }
}