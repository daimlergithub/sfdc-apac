@isTest
public class VehicleHelperTHTest {
private static Account dealer1;
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Id vehicleProductrecordid = RecordTypeAccessService.getRecordTypeId('vehicle__C','Vehicle Product');
	static testMethod void testAccAssignment() {
        Trigger__C vehtrigger=new Trigger__C(name='TriggerVehicle',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerVehicleTriggerHandlerTH',Trigger_Name__c='TriggerVehicle',update__c=true);
        insert vehtrigger;
        profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
        dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
        group g=new group(name='TH1235');
        insert g;
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
        User user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
        insert user2;
        System.runAs (user2) {
            vehicle__c v=new vehicle__c(recordtypeid=vehicleProductrecordid);
            insert v;
        }
	}
}