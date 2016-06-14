/*
    Type:       Test Class
    Purpose:    Test the ScheduledSendNotificationEmail class
    1. Justin Yu created on 2013-10-23
*/
@isTest
public class ScheduledSendNotificationEmailTest{
   
    static testMethod void testScheduledSendNotificationEmail(){
        String personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
        String leadFleetRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Finance Lead').getRecordTypeId();
        User usr1 = UtilTestData.createUser('Australia','Fleet');
        system.runAs(usr1){
        
        Account account = new Account(RecordTypeId = personRecordTypeId);
        account.Status__c='Customer';
        account.LastName = 'LastName';
        account.Salutation = 'Title';
        account.FirstName = 'FirstName';
        account.Suffix__c = 'suffix';
        account.PersonEmail='bing.bai@nttdata.com';
        account.PersonMobilePhone ='1800999999';
        account.Email__c='test@mbau.com';
        account.Email2__c = 'testemail2@test.com';
        account.Home_Phone_2__c = '98765413';
        insert account;
        
        Vehicle__c vehicle = new Vehicle__c(Class__c = 'C-Class Sedan');
        insert vehicle;
        
        Retail_Task__c  contract = new Retail_Task__c (Account__c = account.Id);
        contract.StartDate__c= Date.Today();
        contract.EndDate__c= Date.Today().addMonths(18);       
        insert contract;
        
        Lead__c financeLeadWith15Days = new Lead__c(
            RecordTypeId = leadFinanceRT, 
            Contact__c = account.Id,
            Lead_Source__c = 'End of Contract',
            Nature_of_Request__c = 'Key2Key',
            Business_Unit__c = 'Cars',
            Sub_BusinessUnit__c = 'Sales',
            CAC_Lead_Status__c = 'New Enquiry',
            Existing_Contract__c = contract.Id,
            //Financial_Product__c = 'Agility Contract',
            Is_Finance_Send_Email_Before_15_Days__c = true
        );
        insert financeLeadWith15Days;
        
        Lead__c financeLeadWith20Days = financeLeadWith15Days.clone();
        financeLeadWith20Days.Is_Finance_Send_Email_Before_20_Days__c = true;
        insert financeLeadWith20Days;
        
        Lead__c financeLeadWith45Days = financeLeadWith15Days.clone();
        financeLeadWith45Days.Is_Fleet_Send_Email_Before_45_Days__c = true;
        insert financeLeadWith45Days;
        
        Lead__c fleetLeadWith15Days = new Lead__c(
            RecordTypeId = leadFleetRT, 
            Contact__c = account.Id,
            Lead_Source__c = 'End of Contract',
            Nature_of_Request__c = 'Key2Key',
            Business_Unit__c = 'Cars',
            Sub_BusinessUnit__c = 'Sales',
            CAC_Lead_Status__c= 'New Enquiry',
            Existing_Contract__c = contract.Id,
            //Financial_Product__c = 'Agility Contract',
            Is_Fleet_Send_Email_Before_15_Days__c = true
        );
        insert fleetLeadWith15Days;
        
        Lead__c fleetLeadWith20Days = fleetLeadWith15Days.clone();
        fleetLeadWith20Days.Is_Fleet_Send_Email_Before_20_Days__c = true;
        insert fleetLeadWith20Days;
        
        Lead__c fleetLeadWith60Days = fleetLeadWith15Days.clone();
        fleetLeadWith60Days.Is_Fleet_Send_Email_Before_60_Days__c = true;
        insert fleetLeadWith60Days;
        
        Test.startTest();
         String jobId =System.schedule('ScheduledSendNotificationEmailTest', '0 0 13 * * ?', new ScheduledSendNotificationEmail());
        Test.stopTest();
         CronTrigger ct = [select id, CronExpression,State, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        system.assertEquals('WAITING', ct.State);
        }
        
    }
}