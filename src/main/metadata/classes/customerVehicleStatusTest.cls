@isTest
public class customerVehicleStatusTest {
    public Static void createTestRecord(){
        Account acc =new Account();
        acc.lastname='Nimmana';
        acc.Firstname='Narendra';
        acc.MBK_Data_Source__c='MB website';
        acc.mobile__c='010-1456-2156';
        insert acc;
        
        Vehicle__c v1= new Vehicle__c();
        v1.Brand__c='Mercedes-Benz';
        v1.RegistrationNo__c='64864';
        v1.VehicleStatus__c='Active';
        v1.Related_contact__c=acc.Id;
        v1.FirstRegistrationDate__c=system.today();
        v1.Model__c='E-Class';
        v1.Purchase_Month__c='06';
        v1.Purchase_Year__c='2017';
        insert v1;
        
        Vehicle__c v2= new Vehicle__c();
        v2.Brand__c='Mercedes-Benz';
        v2.RegistrationNo__c='74864';
        v2.VehicleStatus__c='Active';
        v2.FirstRegistrationDate__c=system.today();
        v2.Model__c='E-Class';
        v2.Purchase_Month__c='06';
        v2.Purchase_Year__c='2017';
        insert v2;
        
        Loyalty_Card__c lc = new Loyalty_Card__c();
        lc.Account__c=acc.Id;
        lc.Loyalty_Card_Number__c='987654321';
        lc.Loyalty_Card_End_Date__c=system.today()+10;
        lc.Vehicle__c=v1.Id;
        insert lc;
        
        Vehicle_Relationship__c vr1= new Vehicle_Relationship__c();
        vr1.Contact__c=acc.Id;
        vr1.Vehicle_ID__c=v1.Id;
        vr1.Car_Relation__c='Purchaser';
        insert vr1;
        
        Vehicle_Relationship__c vr2= new Vehicle_Relationship__c();
        vr2.Contact__c=acc.Id;
        vr2.Vehicle_ID__c=v2.Id;
        vr2.Car_Relation__c='Purchaser';
        insert vr2;
    }
    @isTest static void testValidateNewCustomer() {
        createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.salesforce.com/services/apexrest/ValidateNewCustomer/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "NArendra","LastName" : "Nimmana","Email" : "nari.nimm","Mobile" : "010-1456-2156","RegistrationNumber" : "64864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res1 = customerVehiceStatus.findUCID();
        System.assertEquals(res1.get('Vehicle Exists') , 'True');
        System.assertEquals(res1.get('Vehicle Relationship') , '987654321');
        System.assertEquals(res1.get('Loyality Card Number') , '987654321');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "Narendra","LastName" : "Nimmana","Email" : "nari.nimm","Mobile" : "010-1456-2156","RegistrationNumber" : "74864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res2 = customerVehiceStatus.findUCID();
        System.assertEquals(res1.get('Vehicle Exists') , 'True');
        System.assertEquals(res1.get('Vehicle Relationship') , '987654321');
        System.assertEquals(res1.get('Loyality Card Number') , '987654321');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "Nar","LastName" : "","Email" : "nari.nimm","Mobile" : "010-1456-256","RegistrationNumber" : "74864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res3 = customerVehiceStatus.findUCID();
        System.assertEquals(res3.get('Vehicle Relationship') , 'Owner');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "dfg","LastName" : "dgdf","Email" : "nari.nimm","Mobile" : "","RegistrationNumber" : "3542"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res4 = customerVehiceStatus.findUCID();
        System.assertEquals(res4.get('Vehicle Exists') , 'False');
        System.assertEquals(res4.get('Vehicle Relationship') , 'Nil');
        System.assertEquals(res4.get('Loyality Card Number') , 'Nil');
    }  
    @isTest static void testUcid() {
        createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.salesforce.com/services/apexrest/Loyality/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"data":{"Loyalty_Card_No":"987654321","Vehicle_Registration":"64864"}}');
        RestContext.request = request;
        LoyalityManger.LAValidateCardHolder();
        Map<String,String> res2 = LoyalityManger.LAValidateCardHolder();
        System.assertEquals(res2.get('Loyalty_Card') , '987654321');
        System.assertEquals(res2.get('Vehicle_exist') , 'True');
        request.requestBody = Blob.valueOf('{"data":{"Loyalty_Card_No":"12345","Vehicle_Registration":"45784"}}');
        LoyalityManger.LAValidateCardHolder();
        
    }
}