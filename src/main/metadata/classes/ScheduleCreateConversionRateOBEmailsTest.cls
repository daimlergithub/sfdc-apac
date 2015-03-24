/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateConversionRateOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateConversionRateOBEmailsTest{
    
    static testMethod void testScheduleCreateConversionRateOBEmails(){

        Test.startTest();
        
        //Create the Account Records : 
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        testAccount.Dealer_Region__c = 'NORTH';
        testAccount.Dealer_MB_Sub_Region__c = 'NORTH1';
        update testAccount;
        
        //Create Lead Records:
        Date lastDay = System.today().toStartOfMonth().addMonths(-12);
        Date firstDay = lastDay.addMonths(-2);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilTestData.LEAD_RT_SALES_LEADS);
        
        testLead.Assigned_Date_Time__c = lastDay;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
        
        
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateConversionRateOBEmailsTest', CRON_EXP, new ScheduleCreateConversionRateOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        List<Account> listAcc = new List<Account>();
        listAcc.add(testAccount);
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(listAcc);
            
        system.debug('@Shrinivas seperated Accs:' +separatedAccountsBySubRegion);
        system.assert(separatedAccountsBySubRegion !=Null);

    }
}