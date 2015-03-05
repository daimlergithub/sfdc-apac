/*
    Type:       test class
    Purpose:    SMSControllerExtension test class
    User Story: US-SMS-001 - Send SMS content to customer

    Used By:    SMSControllerExtension
    ---------------------------------------------------------------
    History:

    07-Mar-2013 Sinow zhang (Nttdata)    Created
*/
@isTest(SeeAllData=true)
public class SMSControllerExtensionTest {

    public static testMethod void testSMSControllerExtension1() 
    {
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId, PersonMobilePhone = '12345678901');
        insert customer;
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId
            ,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
        insert dealer;
        //String accountId = [Select Id, PersonMobilePhone, Name From Account where isPersonAccount = true Limit 1][0].Id;
        ApexPages.currentPage().getParameters().put('accountId',customer.Id);
        ApexPages.currentPage().getParameters().put('retURL',customer.Id);
        ApexPages.currentPage().getParameters().put('type','SMS');
        
        // Test click SMS button from Account
        // Instantiate a new controller extension with all parameters in the page
        SMSControllerExtension extension = new SMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id; 
        String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();       
        List<Template__c> tems = new List<Template__c>();
        Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
        Template__c tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
        insert tem1;
        insert tem2;
        tems.add(tem1);
        tems.add(tem2);
        for(Template__c tem : tems) {
            if(tem.Message_Detail__c.indexof('{DEALER_') != -1) {
                extension.templateId = tem.id;
            }
        }
        //extension.templateId
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        String message = extension.optimzeContent('temp{DEALER_NAME}temp');
    
        // Send SMS
        extension.send();
        
        Task t = [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.SMS_Content__c From Task t Where WhatId=:customer.Id]; // and SMS_Content__c=:extension.templateMessage
        System.assertEquals(t.Subject, 'SMS');
        System.assertEquals(t.Status, 'Closed');
        System.assertEquals(t.WhoId, [Select Id From Contact Where accountId = :customer.Id limit 1].Id);
        
        //Test click SMS button from Case
        String inquiryRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
        Case cas = new Case(AccountId = customer.Id, Subject = 'acme', RecordTypeId = inquiryRecordTypeId);
        insert cas;
        ApexPages.currentPage().getParameters().put('caseId', cas.Id);
        ApexPages.currentPage().getParameters().put('accountId', customer.Id);
        ApexPages.currentPage().getParameters().put('retURL', cas.Id);
        
        extension = new SMSControllerExtension(controller);
        Template__c tem3 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_ADDRESS}');
        insert tem3;
        customer.PersonOtherPhone='12345678901';
        customer.PersonMobilePhone = '';
        update customer;
        extension.templateId = tem3.id;
        Templates = extension.getTemplates();
        extension.sms.Dealer__c = null; 
        extension.parseTemplateMessage();        
        extension.sms.Dealer__c = dealer.Id; 
        extension.parseTemplateMessage();
        message = extension.optimzeContent('temp{DEALER_ADDRESS}temp');
        // Send SMS
        extension.send();
        //t = [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.SMS_Content__c From Task t Where WhatId = :cas.Id]; // and SMS_Content__c=:extension.templateMessage
        //System.assertEquals(t.Subject, 'SMS');
        //System.assertEquals(t.Status, 'Closed');
        //Contact personContact = [select Id from Contact where AccountId = :customer.Id limit 1];
        //System.assertEquals(t.WhoId, personContact.Id);
    }

    public static testMethod void testSMSControllerExtensionErr1() {
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        ApexPages.currentPage().getParameters().put('type','SMS');
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId);
        insert dealer;     
        SMSControllerExtension extension = new SMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id;
        String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
        insert tem1;
        extension.templateId = tem1.id;
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        // Send SMS
        extension.send();
        
    }
    
    public static testMethod void testSMSControllerExtensionErr2() {
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        ApexPages.currentPage().getParameters().put('type','SMS');
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account customer = new Account(Area_Code__c = '010' ,LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId);
        insert customer;
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId);
        insert dealer;
        //String accountId = [Select Id, PersonMobilePhone, Name From Account where isPersonAccount = true Limit 1][0].Id;
        ApexPages.currentPage().getParameters().put('accountId',customer.Id);
        ApexPages.currentPage().getParameters().put('retURL',customer.Id);
        
        SMSControllerExtension extension = new SMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id;
        extension.templateId = '';
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        // Send SMS
        extension.send();
        
    }
    
    public static testMethod void testSMSControllerExtensionErr3() {
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        ApexPages.currentPage().getParameters().put('type','SMS');
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Account customer = new Account(Area_Code__c = '010' ,LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId, PersonOtherPhone = '12345678901');
        insert customer;
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId);
        insert dealer;
        Template__c template = new Template__c(RecordTypeId = templateRecordTypeId,
                                               Active__c = true);
        insert template;
        template.Message_Detail__c = 'DEALER_LAI';
        update template;     
        SMSControllerExtension extension = new SMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id;
        extension.templateId = template.Id;
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        // Send SMS
        extension.send();
        
    }
}