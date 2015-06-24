/*
    Type:       Test Class
    Purpose:    Test the ScheduledSharingContractToCROs class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Barney lai created on 2014-3-3
*/
@isTest(seeAllData=true)
public class ScheduledSharingContractToCROsTest{

    static testMethod void testScheduledSharingContractToCROs(){

        String userRoleId = [select id, name from UserRole where name = 'Customer Retention Office 1'].id;
        String profileId = [select id, name from Profile where name = 'Customer Retention'].id;
        
        User usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = userRoleId;
        usr.ProfileId = profileId;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'test';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.localesidkey='en_US';
        usr.isActive = true;
        usr.Active_Permission_Set__c= true;
        insert usr;   
        
        system.runAs(usr){
            Test.startTest();
            testMain1();
            Test.stopTest();
        }
    }
    
    @future
    private static void testMain1() {
    
        String personAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();   
    
        Account account1 = new Account(
            firstName = 'Test',
            lastName = 'lai',
            Salutation = 'Doctor',
            PersonMobilePhone = '13011111111',
            PersonOtherPhone = '13022222222',
            Phone = '1234567',
            Individual_Home_Phone__c = '1234567',
            PersonAssistantPhone = '1234567',
            RecordTypeId = personAccountRT,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
        
        insert account1;
        
        Account account2 = new Account(
            firstName = 'Test',
            lastName = 'lai',
            Salutation = 'Doctor',
            Email__c = 'xiaomusyz@sohu.com',
            PersonAssistantPhone = '1234567',
            PersonMobilePhone ='1800999999',
            RecordTypeId = personAccountRT,Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413');
        insert account2;
        
        Retail_Task__c contract1 = new Retail_Task__c (Account__c= account1.id,
                                          StartDate__c= date.today().addDays(-5),
                                          Duration__c= 13,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          Welcome_Call__c = true,
                                          Welcome_Call_Task__c = true);
        insert contract1;
        Retail_Task__c contract11 = new Retail_Task__c (Account__c= account2.id,
                                          StartDate__c= date.today().addDays(-5),
                                          Duration__c= 13,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          Welcome_Call__c = true,
                                          Welcome_Call_Task__c = true);
        insert contract11;
        
        Retail_Task__c contract2 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-1),
                                          Duration__c= 37,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_1_del__c = true);
        insert contract2;
        
        Retail_Task__c contract3 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-2),
                                          Duration__c= 49,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_2_del__c = true);
        insert contract3;
        
        Retail_Task__c contract4 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addYears(-3),
                                          Duration__c= 61,
                                          Status__c  = 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_3_del__c = true);
        insert contract4;
        
        Retail_Task__c contract5 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c= 13,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_1_del__c = true);
        insert contract5;
        
        Retail_Task__c contract6 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 6,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_2_del__c = true);
        insert contract6;
        
        Retail_Task__c contract7 = new Retail_Task__c(Account__c= account1.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 3,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_3_del__c = true);
        insert contract7;
        
        Retail_Task__c contract22 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addYears(-1),
                                          Duration__c = 37,
                                          Status__c = 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_1_del__c = true);
        insert contract22;
        
        Retail_Task__c contract33 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addYears(-2),
                                          Duration__c = 49,
                                          Status__c= 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_2_del__c = true);
        insert contract33;
        
        Retail_Task__c contract44 = new Retail_Task__c(Account__c= account2.id,
                                           StartDate__c= date.today().addYears(-3),
                                          Duration__c = 61,
                                          Status__c= 'Current',
                                          GFV__c = true,
                                          Annual_Call__c = true,
                                          Annual_Call_Task_3_del__c = true);
        insert contract44;
        
        Retail_Task__c contract55 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 13,
                                          Status__c= 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_1_del__c = true);
        insert contract55;
        
        Retail_Task__c contract66 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 6,
                                          Status__c= 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_2_del__c = true);
        insert contract66;
        
        Retail_Task__c contract77 = new Retail_Task__c(Account__c= account2.id,
                                          StartDate__c= date.today().addDays(1),
                                          Duration__c = 3,
                                          Status__c= 'Current',
                                          GFV__c = true,
                                          EOC_Call__c = true,
                                          EOC_Call_Task_3_del__c = true);
        insert contract77;
        
     String jobId = System.schedule('ScheduledSharingContractToCROsTest', '0 0 6 * * ?', new ScheduledSharingContractToCROs());
    }
}