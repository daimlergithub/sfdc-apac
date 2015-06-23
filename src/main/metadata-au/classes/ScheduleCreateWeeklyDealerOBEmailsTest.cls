/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateWeeklyDealerOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateWeeklyDealerOBEmailsTest{
    
    static testMethod void testScheduleCreateWeeklyDealerOBEmails(){

        Test.startTest();
        
        //Create Account Record:
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        testAccount.Email__c='test@mbau.com';
                    testAccount.Email2__c = 'testemail2@test.com';
                    testAccount.Home_Phone_2__c = '98765413';     
        
        //Create Lead Record:
        Date lastWeek = System.today().addDays(-7);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(CAC_Lead_Status__c='New Enquiry'), UtilTestData.LEAD_RT_SALES_LEADS);
       
        testLead.Received_Date_Time__c = lastWeek;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
        
        
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateWeeklyDealerOBEmailsTest', CRON_EXP, new ScheduleCreateWeeklyDealerOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        Test.stopTest();
        
        //Assert Weekly Email Body for the Account Name:
        String weeklyEmailBody = UtilLeadEmailEscalation.getWeeklyEmailBodyByDealer(testAccount);
        system.debug('@Shrinivas Weekly Email Body :' +weeklyEmailBody);
        Boolean contains = weeklyEmailBody.contains(testAccount.Name);
       
        System.assertEquals(contains, true);
    }
}