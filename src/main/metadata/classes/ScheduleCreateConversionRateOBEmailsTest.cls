/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateConversionRateOBEmails class
    User Story:  History:
    1. venky created on 2015-03-13
*/
@isTest 
public class ScheduleCreateConversionRateOBEmailsTest{
    
    public static Account testAccount;
    static testMethod void testScheduleCreateConversionRateOBEmails(){
        Test.startTest();
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        //Create the Account Records : 
        testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
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
        system.assert(testAccount != Null);
        Test.stopTest();
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        
        //Asserting the inserted Account     
        List<Account> accsInPast12Months = 
        [SELECT Id, Name, Dealer_CRM_Manager_Email__c, 
             Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c,
             Dealer_Sales_Manager_Email__c, Owner.Email,
             OwnerId, Owner.UserRole.ParentRoleId, Dealer_MB_Sub_Region__c,
            (SELECT Id, Dealer_Untouched_In_72H__c, Dealer_Audit__c,
                Dealer_Audit_Result__c, Dealer_Lead_Status__c,
                Purchased_Date__c, CAC_Lead_Status__c, 
                Dealer_Successful_Contacted__c
             FROM Lead_Assigned_Dealer__r
             WHERE Assigned_Date_Time__c >= :firstDay
             AND Assigned_Date_Time__c < :lastDay
             AND RecordType.Name = 'Sales Leads')
        FROM Account 
        WHERE RecordType.Name = 'Dealer' 
        AND Dealer_MB_Sub_Region__c != null
        ORDER BY Dealer_MB_Sub_Region__c];
        
        system.assertEquals(testAccount.Id, accsInPast12Months[0].Id);  
         
        //Assert the Account seperated by the Sub-Region.
        List<Account> listAcc = new List<Account>();
        listAcc.add(testAccount);
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(listAcc);
            
        Boolean contains = separatedAccountsBySubRegion.containsKey('NORTH1');
        
        system.assertEquals(contains, True);
        
        List<Account> subRegionAccounts = separatedAccountsBySubRegion.get('NORTH1');
        
        system.assertEquals(subRegionAccounts[0].Id, testAccount.Id);

    }
    
}