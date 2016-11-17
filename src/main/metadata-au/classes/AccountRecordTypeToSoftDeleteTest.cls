@isTest
public class AccountRecordTypeToSoftDeleteTest {
        private static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        private static final String leadVehicleRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        private static final String fleetVansRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Vans').getRecordTypeId();
        private static String comRecordTypeId = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            
        static testMethod void updatePersonAccountTest(){
            AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
            User u = [SELECT Id FROM User WHERE name = 'sudhirkumar acharya'];
            Test.startTest();
            Account perAcc = new Account(Salutation = 'chief',firstname = 'test Account', lastname='last', recordtypeId = personRecordtypeid, mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
            insert perAcc;
            Task t = new Task(Subject = 'call', priority = 'Normal', Status = 'NOt started', whatId = perAcc.Id, OwnerId = u.id);
            insert t;
            Event e = new Event(Subject  = 'Call', WhatId = perAcc.Id, ownerId = u.Id, StartDateTime = System.Now(), EndDateTime = System.now());
            insert e;
            lead__c curLead = new lead__c(Contact__c = perAcc.id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = leadVehicleRt);
            insert curLead;
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, acc); 
            Test.stopTest();
            Account result= [SELECT Recordtype.Name FROM Account WHERE ID =: perAcc.Id];
            System.assertEquals('Person Account Soft Deleted', result.Recordtype.name);
        }
        
    static testMethod void updateCompanyAccountTest(){
        AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
        User u = [SELECT Id FROM User WHERE name = 'sudhirkumar acharya'];
        Test.startTest();
        Account comAcc = new Account(Name= 'TestAccount', recordTypeId = comRecordTypeId, Mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
        insert comAcc;
        lead__c curLead = new lead__c(Company_Account__c = comAcc.id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = fleetVansRt);
        insert curLead;
        String sch = '0 0 23 * * ?'; 
	    system.schedule('Test Territory Check', sch, acc); 
        Test.stopTest();
        Account result = [SELECT Recordtype.Name FROM Account WHERE ID =: comAcc.Id];
        System.assertEquals('Company Soft Deleted', result.Recordtype.name);
    }
}