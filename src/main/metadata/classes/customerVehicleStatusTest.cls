@isTest
public class customerVehicleStatusTest {
    public Static void createTestRecord(){
        Account acc =new Account();
        acc.lastname='Narendra Nimmana';
        acc.Firstname='';
        acc.MBK_Data_Source__c='MB website';
        acc.mobile__c='010-1456-2156';
		acc.MD__c='KR';			   
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
		v1.Md__c='KR';			  
        insert v1;
        
        Vehicle__c v2= new Vehicle__c();
        v2.Brand__c='Mercedes-Benz';
        v2.RegistrationNo__c='74864';
        v2.VehicleStatus__c='Active';
        v2.FirstRegistrationDate__c=system.today();
        v2.Model__c='E-Class';
        v2.Purchase_Month__c='06';
        v2.Purchase_Year__c='2017';
		v2.Md__c='KR';	  
        insert v2;
        
        Loyalty_Card__c lc = new Loyalty_Card__c();
        lc.Account__c=acc.Id;
        lc.Loyalty_Card_Number__c='987654321';
        lc.Loyalty_Card_End_Date__c=system.today()+10;
        lc.Vehicle__c=v1.Id;
		lc.MD__c='KR';			  
        insert lc;
        
        Vehicle_Relationship__c vr1= new Vehicle_Relationship__c();
        vr1.Contact__c=acc.Id;
        vr1.Vehicle_ID__c=v1.Id;
        vr1.Car_Relation__c='Purchaser';
        vr1.Status_1__c='A';
		vr1.MD__c='KR';		   
        insert vr1;
        
        Vehicle_Relationship__c vr2= new Vehicle_Relationship__c();
        vr2.Contact__c=acc.Id;
        vr2.Vehicle_ID__c=v2.Id;
        vr2.Car_Relation__c='Purchaser';
        vr2.Status_1__c='A';
		vr2.MD__c='KR';			   
        insert vr2;
    }
    @isTest static void testValidateNewCustomer() {
		 user u1=TestUtils.IntegrationAPIUser();
        system.runas(u1){
        createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.salesforce.com/services/apexrest/ValidateNewCustomer/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "Nimmana","LastName" : "NArendra","Email" : "nari.nimm","Mobile" : "010-1456-2156","RegistrationNumber" : "64864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res1 = customerVehiceStatus.findUCID();
        System.assertEquals(res1.get('VehicleExists') , 'True');
        System.assertEquals(res1.get('VehicleRelationship') , '987654321');
        System.assertEquals(res1.get('LoyalityCardNumber') , '987654321');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "Narendra","LastName" : "Nimmana","Email" : "nari.nimm","Mobile" : "010-1456-2156","RegistrationNumber" : "74864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res2 = customerVehiceStatus.findUCID();
        System.assertEquals(res1.get('VehicleExists') , 'True');
        System.assertEquals(res1.get('VehicleRelationship') , '987654321');
        System.assertEquals(res1.get('LoyalityCardNumber') , '987654321');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "Nar","LastName" : "","Email" : "nari.nimm","Mobile" : "010-1456-256","RegistrationNumber" : "74864"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res3 = customerVehiceStatus.findUCID();
        System.assertEquals(res3.get('VehicleRelationship') , 'Owner');
        
        request.requestBody = Blob.valueOf('{"data":{"FirstName" : "민철","LastName" : "이","Email" : "nari.nimm","Mobile" : "","RegistrationNumber" : "3542"}}');
        RestContext.request = request;
        customerVehiceStatus.findUCID();
        Map<String,String> res4 = customerVehiceStatus.findUCID();
        System.assertEquals(res4.get('VehicleExists') , 'False');
        System.assertEquals(res4.get('VehicleRelationship') , 'Nil');
        System.assertEquals(res4.get('LoyalityCardNumber') , 'Nil');
		}  
	}   
    @isTest static void testUcid() {
		user u1=TestUtils.IntegrationAPIUser();
        system.runas(u1){								   
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
}