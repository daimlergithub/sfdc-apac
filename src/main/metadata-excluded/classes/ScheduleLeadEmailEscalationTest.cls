/*
  Name                 : ScheduleLeadEmailEscalationTest
  Object               : Account(Dealer), Lead__c
  Requirement          : Test Class for 
                         1. ScheduleCreateWeeklyDealerOBEmails
                         2. ScheduleCreateMonthlyDealerOBEmails
                         3. BatchCreateDealerOBEmails
                         4. UtilOutboundEmail
                         5. ScheduleCreateMonthlyRegionOBEmails
                         6. ScheduleCreateWeeklyRegionOBEmails
                         7. ScheduleSendLeadEscalationEmails
                         8. BatchSendLeadEscalationEmails
                         9. ScheduleCreateConversionRateOBEmails

  Author               : Mouse Liu
  Create Date          : 2013-06-24
  Modify History       : 
 */
@isTest
private class ScheduleLeadEmailEscalationTest {
    public static testMethod void testScheduleCreateWeeklyDealerOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCreateWeeklyDealerOBEmails schClass = 
            new ScheduleCreateWeeklyDealerOBEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Create OutboundEmail Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testScheduleCreateMonthlyDealerOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCreateMonthlyDealerOBEmails schClass = 
            new ScheduleCreateMonthlyDealerOBEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Create OutboundEmail Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testBatchCreateWeeklyDealerOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();

        String query = 'SELECT Id, Name, Dealer_CRM_Manager_Email__c, ' + 
                       'Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, ' + 
                       'Dealer_Sales_Manager_Email__c, Owner.Email, ' + 
                       'Dealer_MB_Sub_Region__c ' + 
                       'FROM Account WHERE RecordType.Name = \'Dealer\'';

        BatchCreateDealerOBEmails calcAssignedLeads = 
            new BatchCreateDealerOBEmails(query, false);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);

        Test.stopTest();
    }

    public static testMethod void testBatchCreateMonthlyDealerOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();

        String query = 'SELECT Id, Name, Dealer_CRM_Manager_Email__c, ' + 
                       'Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, ' + 
                       'Dealer_Sales_Manager_Email__c, Owner.Email, ' + 
                       'Dealer_MB_Sub_Region__c ' +
                       'FROM Account WHERE RecordType.Name = \'Dealer\'';

        BatchCreateDealerOBEmails calcAssignedLeads = 
            new BatchCreateDealerOBEmails(query, true);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);

        Test.stopTest();
    }

    public static testMethod void testScheduleCreateMonthlyRegionOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCreateMonthlyRegionOBEmails schClass = 
            new ScheduleCreateMonthlyRegionOBEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Create OutboundEmail Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testScheduleCreateWeeklyRegionOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCreateWeeklyRegionOBEmails schClass = 
            new ScheduleCreateWeeklyRegionOBEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Create OutboundEmail Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testScheduleCreateConversionRateOBEmails() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Lead__c lead = new Lead__c(
            Assigned_Dealer__c = dealer.Id,
            CAC_Lead_Status__c = 'Assigned'
        );
//, Assigned_Date_Time__c = System.today().toStartOfWeek() - 3
        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCreateConversionRateOBEmails schClass = 
            new ScheduleCreateConversionRateOBEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Create OutboundEmail Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testScheduleMonthlyCreateOutboundEmail() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Outbound_Email__c email = (Outbound_Email__c)UtilTestData.createSobject(
            new Outbound_Email__c(TargetObjectId__c = dealer.Id), null);

        Attachment att = (Attachment)UtilTestData.createSobject(
            new Attachment(ParentId = email.Id), null);

        Test.startTest();
        ScheduleSendLeadEscalationEmails schClass = 
            new ScheduleSendLeadEscalationEmails();
        Date next10thDay = System.today().addDays(10);
        String cron = '0 0 13 ' + next10thDay.day() + ' '
                                + next10thDay.month() + ' ? ' 
                                + next10thDay.year();
        String jobName = 'Schedule Send Outbound Email ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }

    public static testMethod void testBatchSendEmails() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Outbound_Email__c email = (Outbound_Email__c)UtilTestData.createSobject(
            new Outbound_Email__c(TargetObjectId__c = dealer.Id), null);

        Attachment att = (Attachment)UtilTestData.createSobject(
            new Attachment(ParentId = email.Id), null);
        
        Test.startTest();

        String query = 'SELECT Id, CcAddresses__c, ToAddresses__c, ' + 
                       'Subject__c, TargetObjectId__c, Status__c, ' +
                       'Html_Body__c, Text_Body__c ' +
                       'FROM Outbound_Email__c ' + 
                       'WHERE Status__c = \'Not Sent\'';

        // Populate parentIdAttMap
        List<Attachment> atts = [SELECT ParentId, Name, Body 
                                 FROM Attachment 
                                 WHERE ParentId IN 
                                 (SELECT Id FROM Outbound_Email__c 
                                  WHERE Status__c = 'Not Sent')];
        Map<Id, Attachment> parentIdAttMap = new Map<Id, Attachment>();
        for (Attachment a : atts) {
            parentIdAttMap.put(a.ParentId, a);
        }

        // Get Id of Organization-Wide Email Addresses by Name
        OrgWideEmailAddress address = 
            [SELECT Id FROM OrgWideEmailAddress
             WHERE DisplayName = 'BMBS CRM Governance'];
        String addressId = address.Id;

        BatchSendLeadEscalationEmails sendEmailBatch = 
            new BatchSendLeadEscalationEmails(query, parentIdAttMap, addressId);

        Id batchId = Database.executeBatch(sendEmailBatch, 200);

        Test.stopTest();

        email = [SELECT Status__c FROM Outbound_Email__c WHERE Id = :email.Id];
        System.debug('Debug Output ======> {' + email + '}');
        System.debug('Debug Output ======> {' + email.Status__c + '}');
        System.assertEquals(email.Status__c, 'Sent');
    }
}