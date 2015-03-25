/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateMonthlyRegionOBEmails  class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateMonthlyRegionOBEmailsTest{
    
    static testMethod void testScheduleCreateMonthlyRegionOBEmails(){

        Test.startTest();
        
        //Create Account Record : 
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        //Create Lead Records:
        Date lastMonth = System.today().toStartOfMonth().addMonths(-1);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilTestData.LEAD_RT_SALES_LEADS);
        
        testLead.Received_Date_Time__c = lastMonth;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
        
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateMonthlyRegionOBEmailsTest', CRON_EXP, new ScheduleCreateMonthlyRegionOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        List<Account> accountList = new List<Account>();
        accountList.add(testAccount);
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(accountList);
            
        system.assert(separatedAccountsBySubRegion != Null);
    }
}