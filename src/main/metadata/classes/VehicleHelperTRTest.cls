@isTest
public class VehicleHelperTRTest {
    private static Account dealer1;
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Id vehicleProductrecordid = RecordTypeAccessService.getRecordTypeId('vehicle__C',Label.MB_Vehicle);
    static testMethod void testAccAssignment() {
        
        profile p2=[select id from profile where Name='Turkey Dealer Delegate Admin'];
        userrole roleId = [select id,name from userrole where name ='MBTR Management'];   
        user sysUser = TestUtils.createTRAdminUser();
        sysUser.userroleid=roleId.Id;
        update sysUser;
        group g;
        Contact dealerContact;
        User user2;
        system.runas(sysUser){
            Trigger__C vehtrigger=new Trigger__C(name='TriggerVehicle',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TR',Trigger_Handler__c='TriggerVehicleTriggerHandlerTR',Trigger_Name__c='TriggerVehicle',update__c=true);
            insert vehtrigger;
            dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            g=new group(name='TR1235');
            insert g;
            insert dealer1;
            
            dealerContact = new Contact(FirstName = 'Test',Market__c='TR', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
            insert dealerContact;
            
            user2 = new User(LastName='GEORGE',Market__c='TR',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
            insert user2;
        }
        
        
        System.runAs (user2) {
            vehicle__c v=new vehicle__c(recordtypeid=vehicleProductrecordid,market__c='TR',warranty_type__c ='Service Plus');
            insert v;
            TriggerVehicleTriggerHandlerTR tdc=new TriggerVehicleTriggerHandlerTR();
            tdc.handleIntegrationTrigger(true,true,true,true,true);
            List<String> VehicleRelFields=new List<String>();
            VehicleRelFields.add('Car_Relation__c');
            //VehicleRelFields.add('Contact__c');
            VehicleRelFields.add('Vehicle_ID__c');
            VehicleRelFields.add('Status_1__c');
            VehicleRelFields.add('Validity__c');
            VehicleRelFields.add('Owner_Relation__c');
            VehicleRelFields.add('Market__c');
            List<Vehicle_Relationship__c> VehicleRelFieldsList=DataFactoryServices.createRecords('Vehicle_Relationship__c',VehicleRelFields,'',1);
            VehicleRelFieldsList[0].Car_Relation__c='Sales';
            // VehicleRelFieldsList[0].Contact__c=AccountFieldsList[0].Id;
            VehicleRelFieldsList[0].Vehicle_ID__c=v.Id;
            VehicleRelFieldsList[0].Status_1__c='C'; 
            VehicleRelFieldsList[0].Start_Date__c=system.today();
            VehicleRelFieldsList[0].End_Date__c=null;
            VehicleRelFieldsList[0].Validity__c='Yes';
            VehicleRelFieldsList[0].Owner_Relation__c='Friend';
            VehicleRelFieldsList[0].Market__c='TR';
            VehicleRelFieldsList[0].Purchase_Date__c = system.Today()-1170;     
            system.debug('VR ---> '+VehicleRelFieldsList[0]);
            insert VehicleRelFieldsList;
            Task t = new Task();
            t.whatid = VehicleRelFieldsList[0].Id;
            t.status = 'Open';
            insert t;
            v.warranty_type__c ='Advantage Plus';
            update v;
            database.executebatch(new batchCloseVRTasks());
            
        }
    }
}