/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateMonthlyDealerOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateMonthlyDealerOBEmailsTest{
    
    static testMethod void testScheduleCreateMonthlyDealerOBEmails(){

        Test.startTest();
        
        //Create Account Record : 
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        testAccount.Email__c='test@mbau.com';
                    testAccount.Email2__c = 'testemail2@test.com';
                    testAccount.Home_Phone_2__c = '98765413'; 
        //Create Lead Records:
        Date lastMonth = System.today().toStartOfMonth().addMonths(-1);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(CAC_Lead_Status__c='New Enquiry'), UtilTestData.LEAD_RT_SALES_LEADS);
                System.debug('!@!@!#### testAccount'+testAccount);

        testLead.Received_Date_Time__c = lastMonth;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
        System.debug('!@!@!#### testLead '+testLead);
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateMonthlyDealerOBEmailsTest', CRON_EXP, new ScheduleCreateMonthlyDealerOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        String emailBody = UtilLeadEmailEscalation.getMonthlyEmailBodyByDealer(testAccount);
        system.debug('Email body' +emailBody);
        system.assert(emailBody !=Null);
    }
}