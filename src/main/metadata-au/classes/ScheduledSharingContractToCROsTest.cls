/*
    Type:       Test Class
    Purpose:    Test the ScheduledSharingContractToCROs class
 1. Barney lai created on 2014-3-3
*/
@isTest
public class ScheduledSharingContractToCROsTest{
    private static Account account1;
    private static Account account2;
    private static Retail_Task__c contract1;
    private static Retail_Task__c contract11;
    private static Retail_Task__c contract2;
    private static Retail_Task__c contract3; 
    private static Retail_Task__c contract4;
    private static string statusValue ='Current';
    private static CronTrigger ct;
    
    private static void createAccount(){
        
        String personAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();   
    
         account1 = new Account(
            firstName = 'Test',
            lastName = 'lai',
            Salutation = 'Doctor',
            PersonMobilePhone = '13011111111',
            PersonOtherPhone = '13022222222',
            Phone = '1237567',
            Individual_Home_Phone__c = '1244567',
            PersonAssistantPhone = '1234967',
            RecordTypeId = personAccountRT,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
        
        insert account1;
        
         account2 = new Account(
            firstName = 'Test',
            lastName = 'lai',
            Salutation = 'Doctor',
            Email__c = 'xiaomusyz@sohu.com',
            PersonAssistantPhone = '1234667',
            PersonMobilePhone ='1800999999',
            RecordTypeId = personAccountRT,Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
        insert account2;
        
    }
    private static void createTask(){
          contract1 = new Retail_Task__c (Account__c= account1.id,
                                          StartDate__c= date.today().addDays(-5),
                                          Duration__c= 13,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          Welcome_Call__c = true,
                                          Welcome_Call_Task__c = true);
        insert contract1;
         contract11 = new Retail_Task__c (Account__c= account2.id,
                                          StartDate__c= date.today().addDays(-5),
                                          Duration__c= 13,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          Welcome_Call__c = true,
                                          Welcome_Call_Task__c = true);
        insert contract11;
        
         contract2 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-1),
                                          Duration__c= 37,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_1_del__c = true);
        insert contract2;
        
         contract3 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-2),
                                          Duration__c= 49,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_2_del__c = true);
        insert contract3;
        
         contract4 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-3),
                                          Duration__c= 61,
                                          Status__c  = statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_3_del__c = true);
        insert contract4;
        
        
    }

    static testMethod void testScheduledSharingContractToCROs(){

        String userRoleId1 = [select id, name from UserRole where name = 'Central Sales & Marketing'].id;        
        String profileId = [select id, name from Profile where name = 'Customer Retention'].id;
        String userRoleId2 = [select id, name from UserRole where name = 'Customer Retention Office 1'].id;
        
        User usr = new User();
        usr.UserName = 'test1' + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = userRoleId1;
        usr.ProfileId = profileId;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'test2';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.localesidkey='en_US';
        usr.isActive = true;
        usr.Active_Permission_Set__c= true;
        insert usr;   
        
        User usr2 = new User();
        usr2.UserName = 'test123' + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr2.UserRoleId = userRoleId2;
        usr2.ProfileId = profileId;
        usr2.LastName = 'Test User 1';
        usr2.Email = 'test001@daimler.com.full2';
        usr2.Alias = 'test23';
        usr2.TimeZoneSidKey = 'Asia/Shanghai';
        usr2.EmailEncodingKey = 'UTF-8';
        usr2.LanguageLocaleKey = 'en_US';
        usr2.localesidkey='en_US';
        usr2.isActive = true;
        usr2.Active_Permission_Set__c= true;
        insert usr2;
        
        system.runAs(usr){
            Test.startTest();
            testMain1();
             String CRON_EXP = '0 0 0 1 1 ? 2025';
             String jobId = System.schedule('ScheduledSharingContractToCROsTest2', CRON_EXP, new ScheduledSharingContractToCROs());
             ct = [select id, CronExpression,State, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            
            Test.stopTest();
             System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        }
       
    }
     
    @future
    private static void testMain1() {
    createAccount();
        createTask();
        
       
        Retail_Task__c contract5 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c= 13,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_1_del__c = true);
        insert contract5;
        
        Retail_Task__c contract6 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 6,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_2_del__c = true);
        insert contract6;
        
        Retail_Task__c contract7 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 3,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_3_del__c = true);
        insert contract7;
        
        Retail_Task__c contract22 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addYears(-1),
                                          Duration__c = 37,
                                          Status__c = statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_1_del__c = true);
        insert contract22;
        
        Retail_Task__c contract33 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addYears(-2),
                                          Duration__c = 49,
                                          Status__c= statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_2_del__c = true);
        insert contract33;
        
        Retail_Task__c contract44 = new Retail_Task__c(Account__c= account2.id,
                                           StartDate__c= date.today().addYears(-3),
                                          Duration__c = 61,
                                          Status__c= statusValue,
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_3_del__c = true);
        insert contract44;
        
        Retail_Task__c contract55 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 13,
                                          Status__c= statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_1_del__c = true);
        insert contract55;
        
        Retail_Task__c contract66 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 6,
                                          Status__c= statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_2_del__c = true);
        insert contract66;
        
        Retail_Task__c contract77 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 3,
                                          Status__c= statusValue,
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_3_del__c = true);
        insert contract77;
        String CRON_EXP = '0 0 0 1 1 ? 2025';
     String jobId = System.schedule('ScheduledSharingContractToCROsTest', CRON_EXP, new ScheduledSharingContractToCROs());
         ct = [select id, CronExpression,State, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    }
}