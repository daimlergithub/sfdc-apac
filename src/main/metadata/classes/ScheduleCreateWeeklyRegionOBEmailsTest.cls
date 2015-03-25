/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateWeeklyRegionOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateWeeklyRegionOBEmailsTest{
    
    static testMethod void testScheduleCreateWeeklyRegionOBEmails(){
        Test.startTest();
        
        //Create Account Record:
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        //Create Lead Record:
        Date lastWeek = System.today().addDays(-7);
        Lead__c testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilTestData.LEAD_RT_SALES_LEADS);
        
        testLead.Received_Date_Time__c = lastWeek;
        testLead.Assigned_Dealer__c = testAccount.Id;
        update testLead;
         
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateWeeklyRegionOBEmailsTest', CRON_EXP, new ScheduleCreateWeeklyRegionOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        List<Account> account_List = new List<Account>();
        account_List.add(testAccount);
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(account_List);
            
        system.assert(separatedAccountsBySubRegion != Null);
    }
}