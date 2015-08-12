@isTest
public class ReportUserControllerTest {
     final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     public static Profile userProfile = [select Id from Profile where Name = 'CAC SSI SV' limit 1];
     public static String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    public static user usr;

    public static testmethod void testGetTheResults()
    {
         
        usr = new User(
            Username = System.now().millisecond() +math.random()+ '987654321test12345@test.com',
            FirstName = 'firstname',
            ProfileId = userProfile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert usr;
        //  Insert person Account 
        system.runAs(usr){
        Account person = new Account(
            RecordTypeId = personRecordtypeid,
            PersonMobilePhone = '1861001001',
            FirstName = 'First',
            LastName = 'Last',
            PersonEmail = 'test@test.com',
            Salutation = 'Unknown'
        );
        person.Home_Phone_2__c ='1243';
        person.Email__c = 'hs@gsad.com';
        person.Email2__c = 'ywfhedw@gsc.com';
        person.Phone ='476';
        insert person;
        
        SSI__c ssi = new SSI__c();
        insert ssi;
        
        Task task = new Task(Subject = '1st Survey Result', RecordTypeId = SSITaskRecordTypeId, WhatId = ssi.Id);
        insert task;
        
             
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        Vehicle__c vehicle=(Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), null);
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship.Vehicle_ID__c = vehicle.Id;
        relationship.Contact__c = person.Id;
        relationship.Selling_Dealer__c = dealer.Id;
            
        
        ReportUserController objReportUserController = new ReportUserController();
         objReportUserController.getTheResults();
        system.assertNotEquals(null, objReportUserController.getTheResults());
        }
    }
}