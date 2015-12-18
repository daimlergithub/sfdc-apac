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
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        //Create Account Record : 
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        //Create Lead Records:
        Date lastMonth = System.today().toStartOfMonth().addMonths(-1);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilTestData.LEAD_RT_SALES_LEADS);
        
        testLead.Received_Date_Time__c = lastMonth;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
        
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