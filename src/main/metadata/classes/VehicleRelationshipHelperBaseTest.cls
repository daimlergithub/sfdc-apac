/**
* Test class for VehicleRelationshipHelperBase
* Author:Sushma Bharti
* Created Date : 9th Oct 2017
*/


//SB2017
@istest
public class VehicleRelationshipHelperBaseTest {
    public static Account accObj;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj;
    public static List<Vehicle_Relationship__c> vrlst;
    public static User user1;
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c','Vehicle Relationship Retail');
    public static User user2;
    public static List<Account> accList;
    
    public static void createPersonaUser(){
         Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        System.runAs (user1) {
            PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
            
            CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            insert sea;
             
            user2 = UtilTestData.createPersornaUser(ps, p1);
            insert user2;
        }
    }
    
    public static void creatTestData(){
        List<Sobject> sobj=new List<sObject>();
        Trigger__c tr=new Trigger__c(Trigger_Handler__c='TriggerVehicleRelTriggerHandlerMY',Name='TriggerVehicleRelationshipMY',Market__c='MY',
        Trigger_Name__c='TriggerVehicleRelationship',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,update__c=true);
        sobj.add(tr);
        Group gr=new Group(Name='12345');
        sobj.add(gr);
        insert sobj;
        accList = new List<Account>();
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+6612123789', md__c ='MY');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id recordTypeAccCompanyAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+6612123789', md__c ='MY');
        accList.add(accObj);
        Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+6612123789',Dealer_ND_Code__c='12345', md__c ='MY');
        accList.add(accObj1);
        Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Home_Phone_2__c = '02202245626',Individual_Home_Phone__c='+6612123789',Dealer_ND_Code__c='12345', md__c ='MY');
        accList.add(accObj2);
        insert accList;
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000, md__c ='MY');
        insert vehicleObj;
        vrlst = new List<Vehicle_Relationship__c>();
        vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(0).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accObj1.id,recordtypeid=retailCompany_RecordTypeId, md__c ='MY');
        vrlst.add(vehicleRelationshipObj);
        Vehicle_Relationship__c vehicleRelationshipObj1 = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(0).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX', md__c ='MY');
        vrlst.add(vehicleRelationshipObj1);
        Vehicle_Relationship__c vehicleRelationshipObj2 = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Partner',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(1).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accObj1.id,recordtypeid=retailCompany_RecordTypeId, md__c ='MY');
        vrlst.add(vehicleRelationshipObj2);
        insert vrlst;
        vehicleRelationshipObj1.Owner_Dealer__c=accObj1.id;
        vehicleRelationshipObj1.recordtypeid=retailCompany_RecordTypeId;
        vehicleRelationshipObj.Owner_Dealer__c=accObj2.id;
        vehicleRelationshipObj2.Owner_Dealer__c=null;
        update vrlst;
        delete vrlst;
       }
       
       public static testMethod void VehicleRelationshipHelperMYTestMethod(){
        createPersonaUser();
        System.runAs (user2) {
            test.startTest();
            try{
                creatTestData();
            }
            catch(Exception e){}
            test.stopTest();
        }
    }
}