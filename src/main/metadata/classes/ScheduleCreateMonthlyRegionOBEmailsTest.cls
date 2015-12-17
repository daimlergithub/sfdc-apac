/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateMonthlyRegionOBEmails  class
    User Story:  History:

    1. venky created on 2015-03-13
*/
@isTest
public class ScheduleCreateMonthlyRegionOBEmailsTest{
    
    static testMethod void testScheduleCreateMonthlyRegionOBEmails(){

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
        String jobId = System.schedule('ScheduleCreateMonthlyRegionOBEmailsTest', CRON_EXP, new ScheduleCreateMonthlyRegionOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        
        system.assert(testAccount != Null);
        Test.stopTest();
          System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        
        
        //Asserting the Account
        List<Account> accs = 
            [SELECT Id, Name, Dealer_CRM_Manager_Email__c, 
                Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, 
                Dealer_Sales_Manager_Email__c, Owner.Email, 
                OwnerId, Owner.UserRole.ParentRoleId, Dealer_MB_Sub_Region__c,
                Dealer_ND_Code__c, Dealer_Lead_System__c,
                (SELECT Id, Dealer_Untouched_In_72H__c, Dealer_Audit__c,
                    Dealer_Audit_Result__c, Dealer_Lead_Status__c, CAC_Lead_Status__c,
                    Dealer_Successful_Contacted__c
                FROM Lead_Assigned_Dealer__r
                WHERE Received_Date_Time__c = LAST_MONTH
                AND RecordType.Name = 'Sales Leads') 
            FROM Account WHERE RecordType.Name = 'Dealer'
            AND Dealer_MB_Sub_Region__c != null
            ORDER BY Dealer_MB_Sub_Region__c];
        
        
        system.assertEquals(testAccount.Id, accs[0].Id);
        
        //Assert the Account seperated by the Sub-Region.
        List<Account> accountList = new List<Account>();
        accountList.add(testAccount);
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(accountList);
      
        Boolean contains = separatedAccountsBySubRegion.containsKey('North1');
        
        system.assertEquals(contains, True);
        
        List<Account> subRegionAccounts = separatedAccountsBySubRegion.get('North1');
        
        system.assertEquals(subRegionAccounts[0].Id, testAccount.Id);   
        system.debug('Final Assertions Contains: ' +contains + ' SubRegion Account Id ' +subRegionAccounts[0].Id + ' Actual Account Id : ' +testAccount.Id);
    }
}