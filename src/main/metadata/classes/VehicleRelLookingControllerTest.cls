/*
    Type:       test class
    Purpose:    VehicleRelLookingController test class
    User Story: Release 1.2 Report S&M R006
    Used By:    VehicleRelLookingController 
     History:9-Jun-2014 Sinow    Created
*/
@isTest
public class VehicleRelLookingControllerTest {


    public static testMethod void testVehicleRelLookingController ()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
        Trigger__c newtrg = new Trigger__c(Name= 'TriggerAccountLink',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();   
        Id accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
  
        Account account1 = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_SR_Code__c='Test_SR_Code1',City__c='Beijing',Phone = '080801010',Area_Code__c = '010',ZipCode__c='1003457',lastname = 'Beijing XING Limited',RecordTypeId=accPerson_RecordTypeIdp,MBK_Data_Source__c='Advertisement',Mobile__c='0000000000');
        insert account1;
        
        Contact conComplaint = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
        insert conComplaint;
        
        Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class',Competitor_Brand__c='Audi',Purchase_Year__c='2016',RegistrationNo__c='45878');
        insert vehicles;
        
        Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = VRRecordTypeId,Contact__c = account1.id,Vehicle_ID__c = vehicles.id);
        insert vr;
        
        PageReference vehicleRelLooking = Page.VehicleRelLooking;
        vehicleRelLooking.getParameters().put('id',conComplaint.id);
        Test.setCurrentPage(vehicleRelLooking); 
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',account1.Id);
        VehicleRelLookingController extension = new VehicleRelLookingController();
        Test.stopTest();
        
        List<Vehicle_Relationship__c>    VehilceRels =new List<Vehicle_Relationship__c>();
        VehilceRels = [select Id, Name, Vehicle_ID__c, Vehicle_ID__r.Name, Car_Relation__c, Registration_Number__c,Vehicle_Brand__c, Vehicle_Class__c, Vehicle_Model__c from Vehicle_Relationship__c where Contact__c =:account1.id];
        System.assertEquals(VehilceRels,extension.VehilceRels);        
    }
}