@isTest(seeAllData=false)
public class VehicleRelationshipHelperTHTest{
        public static List<Account> accList;
    public static Account accObj;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj;
    public static List<Vehicle_Relationship__c> vrlst;
    public static User user1= TestUtils.createAdminUser();
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c','Vehicle Relationship Retail');
	public static void creatTestData(){
        List<Sobject> sobj=new List<sObject>();
        Trigger__c tr=new Trigger__c(Trigger_Handler__c='TriggerVehicleRelTriggerHandlerTH',Name='TriggerVehicleRelationshipTH',Market__c='TH',
        Trigger_Name__c='TriggerVehicleRelationship',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,update__c=true);
        sobj.add(tr);
        Group gr=new Group(Name='12345');
        sobj.add(gr);
        insert sobj;
        accList = new List<Account>();
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id recordTypeAccCompanyAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
        accList.add(accObj);
        Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345');
        accList.add(accObj1);
        Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Home_Phone_2__c = '02202245626',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345');
        accList.add(accObj2);
        insert accList;
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000);
        insert vehicleObj;
        vrlst = new List<Vehicle_Relationship__c>();
        vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(0).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accObj1.id,recordtypeid=retailCompany_RecordTypeId);
        vrlst.add(vehicleRelationshipObj);
        Vehicle_Relationship__c vehicleRelationshipObj1 = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(0).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX');
        vrlst.add(vehicleRelationshipObj1);
        Vehicle_Relationship__c vehicleRelationshipObj2 = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Partner',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(1).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accObj1.id,recordtypeid=retailCompany_RecordTypeId);
        vrlst.add(vehicleRelationshipObj2);
        insert vrlst;
        vehicleRelationshipObj1.Owner_Dealer__c=accObj1.id;
        vehicleRelationshipObj1.recordtypeid=retailCompany_RecordTypeId;
        vehicleRelationshipObj.Owner_Dealer__c=accObj2.id;
        vehicleRelationshipObj2.Owner_Dealer__c=null;
        update vrlst;
        delete vrlst;
       }
    public static testMethod void VehicleRelationshipHelperTHTestMethod(){
        System.runAs (user1) {
            test.startTest();
            creatTestData();
            test.stopTest();
        }
    }
}