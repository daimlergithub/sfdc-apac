/*
    Type:Test class
    Purpose:Test Class for VehicleAndVRShareBatchClass
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 15-07-2017
    2. Modified     
*/
@isTest
public class VehicleAndVRShareBatchClassTest 
{
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id retailVR_RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();    
    public static void init()
    {          
        Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='MBK09Shq',MD__C='KR'); 
        insert dealer;
        Account  personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc',MD__C='KR',Data_Source__c='Dealer Outlet',MBK_Data_Source__c='Dealers',Mobile__c='000-0000-9642');
        insert personAcc;
        Vehicle__c Veh = new Vehicle__c (EuroVIN__c = 'DSA2MDS7CS0CS1M', MD__c = 'KR',Model__c = 'Test', Purchase_Month__c = '06', Purchase_Year__c = '2017',RegistrationNo__c = '12321321', FirstRegistrationDate__c = System.today());
        insert Veh;
        Vehicle_Relationship__c  vehRel = new Vehicle_Relationship__c(RecordTypeId = retailVR_RecordTypeId,Owner_Dealer__c=dealer.id,Contact__c = personAcc.id,MD__C='KR', Vehicle_ID__c = Veh.Id);
        insert vehRel;         
    }
    static testmethod void batchAugment()
    {
        init();
        Test.startTest();
        VehicleAndVRShareBatchClass bc= new VehicleAndVRShareBatchClass();
        database.executeBatch(bc);
        Test.stopTest();
    }
}