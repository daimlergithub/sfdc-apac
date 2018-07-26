/*********************************************************************************
Name         : EmailNotificationSchedulerClassTest
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 20th November 2017
Modified Date:
Requirement  : SFDCKR - 1558
Usages       : Test class for code coverage related to EmailNotificationSchedulerClass & EmailNotificationfor5days10days15days.
*********************************************************************************/
@isTest
private class EmailNotificationSchedulerClassTest 
{
    static testMethod void testDataPreparation() 
    {
        Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id personAccountRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id salesLeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        Id afterSalesLeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        List<Lead__c> leadobjList = new List<Lead__c>();
        
        Account dlrAcc = new Account();
        dlrAcc.RecordTypeId = recordTypeAccDealerAccountObjId;
        dlrAcc.Name='Dealer Company';
        dlrAcc.Phone ='543234760605';
        dlrAcc.Dealer_Rollout_Status__c='Done';
        dlrAcc.MD__c='KR';
        dlrAcc.Dealer_Type__c = 'Company';
        dlrAcc.Dealer_GC_Code__c='GC1234';
        dlrAcc.Dealer_ND_Code__c='MBK963KR';
        insert dlrAcc;
        
        Account personAccount = new Account();
        personAccount.RecordTypeId=personAccountRecordtypeid;
        personAccount.LastName='Test Person Account';
        personAccount.MBK_Data_Source__c='Mercedes-Benz';
        personAccount.Mobile__c='010-9876-5678';
        insert personAccount;
        
        for(integer i=5; i<=10; i++)
        {
            Lead__c leadobj = new Lead__c();
            leadobj.Contact__c = personAccount.Id;
            leadobj.RecordTypeId = salesLeadRecordTypeId;
            leadobj.Dealer_Lead_Status__c='Not Started';
            leadobj.Lead_Type__c = 'Used Car';
            leadobj.Lead_Sub_Type__c = 'Demo Car';
            leadobj.Assigned_dealer__c = dlrAcc.Id;
            leadobj.Dealer_Assigned_Date_Time__c = system.Today()-i;
            leadobjList.add(leadobj);
        }
        for(integer i=10; i<=15; i++)
        {
            Lead__c leadobj = new Lead__c();
            leadobj.Contact__c = personAccount.Id;
            leadobj.RecordTypeId = afterSalesLeadRecordTypeId;
            leadobj.Dealer_Lead_Status__c='Not Started';
            leadobj.Lead_Type__c = 'Used Car';
            leadobj.Lead_Sub_Type__c = 'Demo Car';
            leadobj.Assigned_dealer__c = dlrAcc.Id;
            leadobj.Dealer_Assigned_Date_Time__c = system.today()-i;
            leadobjList.add(leadobj);
        }
        for(integer i=15; i<=25; i++)
        {
            Lead__c leadobj = new Lead__c();
            leadobj.Contact__c = personAccount.Id;
            leadobj.RecordTypeId = salesLeadRecordTypeId;
            leadobj.Dealer_Lead_Status__c='Not Started';
            leadobj.Lead_Type__c = 'Used Car';
            leadobj.Lead_Sub_Type__c = 'Demo Car';
            leadobj.Assigned_dealer__c = dlrAcc.Id;
            leadobj.Dealer_Assigned_Date_Time__c = system.today()-i;
            leadobjList.add(leadobj);
        }
        
        insert leadobjList;
    }
    static testMethod void scheduleNotificationTest() 
    {
        Test.startTest();
        testDataPreparation();
        string strSchedule = '0 0 4 ? *  MON-FRI';
        System.schedule('EmailNotificationfor5days10days15daysSampleTest', strSchedule, new EmailNotificationSchedulerClass());
        Test.stopTest();
    }
}