@isTest
public class AccountRecordTypeToSoftDeleteTest {
        private static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        private static final String leadVehicleRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        private static final String fleetVansRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Vans').getRecordTypeId();
        private static String comRecordTypeId = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        private static User u;    
        static testMethod void updatePersonAccountTest(){
            AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
            createTestData();
            Test.startTest();
            Account perAcc = new Account(Salutation = 'chief',firstname = 'test Account', lastname='last', recordtypeId = personRecordtypeid, mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
            insert perAcc;
            Task t = new Task(Subject = 'call', priority = 'Normal', Status = 'NOt started', whatId = perAcc.Id, OwnerId = u.id);
            insert t;
            Event e = new Event(Subject  = 'Call', WhatId = perAcc.Id, ownerId = u.Id, StartDateTime = System.Now(), EndDateTime = System.now());
            insert e;
            lead__c curLead = new lead__c(Contact__c = perAcc.id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Closed Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = leadVehicleRt);
            insert curLead;
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, acc); 
            Test.stopTest();
            Account result= [SELECT Recordtype.Name FROM Account WHERE ID =: perAcc.Id];
        }
        
    static testMethod void updateCompanyAccountTest(){
        createTestData();
        Test.startTest();
        Account comAcc = new Account(Name= 'TestAccount', recordTypeId = comRecordTypeId, Mobile__c='040123456',PC_Status__c = 'Prospect',VAN_Status__c = 'Prospect',Insurance_Status__c = 'Prospect' );
        insert comAcc;
        lead__c curLead = new lead__c(Company_Account__c = comAcc.id ,Nature_of_Request__c = 'campaign', Lead_Source__c = 'campaign', 	CAC_Lead_Status__c = 'Closed Lost', Business_Unit__c = 'Fleet', Sub_BusinessUnit__c = 'Sales', CAC_Lost_Reason__c = 'Lost Competitor', RecordTypeId = fleetVansRt);
        insert curLead;
        Task t = new Task(Subject = 'call', priority = 'Normal', Status = 'NOt started', whatId = comAcc.Id, OwnerId = u.id);
        insert t;
        Event e = new Event(Subject  = 'Call', WhatId = comAcc.Id, ownerId = u.Id, StartDateTime = System.Now(), EndDateTime = System.now());
        insert e;        
        AccountRecordTypeToSoftDelete acc = new AccountRecordTypeToSoftDelete();
        Database.executeBatch(acc, 200);
        Test.stopTest();
        Account result = [SELECT Recordtype.Name FROM Account WHERE ID =: comAcc.Id];
    }
    Public static void createTestData()
    {
        
        Profile p = [select Id From Profile where name = 'System Administrator'];
        u = new User(
            Username = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com',
            FirstName = 'firstname',
            ProfileId = p.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty3',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert u;
    }
}