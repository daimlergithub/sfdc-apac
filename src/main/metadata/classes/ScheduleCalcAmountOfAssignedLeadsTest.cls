/*  Name                 : ScheduleCreateMonthlyOutboundEmails
  Object               : Account(Dealer), Lead__c
  Requirement          : 1. BatchCalcAmountOfAssignedLeads
                         2. ScheduleCalcAmountOfAssignedLeads
   Author               : Mouse Liu
  Create Date          : 2013-06-14
  */
@isTest
public with sharing class ScheduleCalcAmountOfAssignedLeadsTest {

public static void preparedTestDataCustomsettings()
{
App_Setting__c ap=new App_Setting__c();
ap.name='DailyAssignedLeadsReport eMail Address';
ap.Value__c='raghuprasad.halakere@nttdata.com';
insert ap;
}
    
    @istest static  void testHasAssignedDealer() {
    
    
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);
        preparedTestDataCustomsettings();
        Test.startTest();
        ScheduleCalcAmountOfAssignedLeads schClass = new ScheduleCalcAmountOfAssignedLeads();
        Date next10thDay = System.today().addDays(10);
        
        
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        System.debug('Debug Output ======> {' + cron + '}');
        
        String jobName = 'Calc Assigned Leads' + Math.rint(Math.random() * 1000000);
        
        System.schedule(jobName, cron, schClass);
        
        //Call the batch apex
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\' AND Name = \'test dealer\'';
            
        BatchCalcAmountOfAssignedLeads calcAssignedLeads = new BatchCalcAmountOfAssignedLeads(query);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);
        
        Test.stopTest();
        
         dealer = [SELECT Assigned_Lead_Amount_of_Everyday__c
                  FROM Account WHERE Id = :dealer.Id];
                  
        system.assertEquals(1, dealer.Assigned_Lead_Amount_of_Everyday__c);
        system.assertnotEquals(null,batchId);
    }

    public static testMethod void testNoAssignedDealer() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(Assigned_Lead_Amount_of_Everyday__c = 1), 
            UtilTestData.ACCOUNT_RT_DEALER);
         preparedTestDataCustomsettings();
        Test.startTest();
        ScheduleCalcAmountOfAssignedLeads schClass = new ScheduleCalcAmountOfAssignedLeads();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Calc Assigned Leads' + Math.rint(Math.random() * 1000000);
        
        
        //System.schedule(jobName, cron, schClass);
        
        //Call the batch apex
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\' AND Name = \'test dealer\'';
            
        BatchCalcAmountOfAssignedLeads calcAssignedLeads = new BatchCalcAmountOfAssignedLeads(query);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);
        
        Test.stopTest();
        
        dealer = [SELECT Assigned_Lead_Amount_of_Everyday__c
                  FROM Account WHERE Id = :dealer.Id];
        
        system.assertEquals(0, dealer.Assigned_Lead_Amount_of_Everyday__c);
        system.assertnotEquals(null,schClass);
        system.assertnotEquals(null,cron); 
        system.assertnotEquals(null,jobName);
         system.assertnotEquals(null,batchId);
    }
    
    public static testMethod void testBatchCalcAssignedLeads() {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;

        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);
         preparedTestDataCustomsettings();
        Test.startTest();

        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\'';

        BatchCalcAmountOfAssignedLeads calcAssignedLeads = 
            new BatchCalcAmountOfAssignedLeads(query);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);

        Test.stopTest();

        dealer = [SELECT Assigned_Lead_Amount_of_Everyday__c
                  FROM Account WHERE Id = :dealer.Id];
        System.assertEquals(dealer.Assigned_Lead_Amount_of_Everyday__c, 1);
        system.assertnotEquals(null,batchId);
    }
}