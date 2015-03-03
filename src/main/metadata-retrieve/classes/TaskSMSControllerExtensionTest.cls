/*
    Type:       test class
    Purpose:    TaskSMSControllerExtension test class
    User Story: BMBS Interactive SMS Workbook

    Used By:    TaskSMSControllerExtension
    ---------------------------------------------------------------
    History:

    27-Nov-2013 Chaos Huang (Nttdata)    Created
*/
@isTest(SeeAllData=true)
public class TaskSMSControllerExtensionTest {

    public static testMethod void testTaskSMSControllerExtension1() 
    {
        system.debug('-----test start');
        User usr = UtilTestData.createUser('OB TL','CAC OB TL');
        system.runas(usr){
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId, PersonMobilePhone = '12345678901');
        insert customer;
        customer = [Select Customer_Number__c, PersonContactId From Account Where Id=:customer.Id];
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId
            ,Dealer_Address_CN__c = 'chaoyang', City_CN__c = 'beijing', Province__c = '151');
        insert dealer;

        //User usr = UtilTestData.createUser('OB TL','CAC OB TL');

        Campaign cp = campaignPreparation();
        String obTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
        Task tas = new Task(
            RecordTypeId = obTaskRecordTypeId,
            OwnerId = usr.Id,
            WhatId = cp.Id,
            WhoId = customer.PersonContactId,
            Subject = 'OB Task',
            Result__c = 'Solved',
            Activity_Status__c = 'no answer',
            Dealer_Name__c = 'Test Dealer',
            DUP_Number__c = '123'
        );
        
        insert tas;
        
        ApexPages.currentPage().getParameters().put('taskId', tas.Id);
        
        // Test click SMS button from Account
        // Instantiate a new controller extension with all parameters in the page
        TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id; 
        String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();       
        List<Template__c> tems = new List<Template__c>();
        Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true, 
                                           Name = 'lai', Message_Detail__c = '{Contact_Name}');
        //Template__c tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true, 
                                           //Name = 'lai', Message_Detail__c = '{Contact_Name}');
        insert tem1;
        cp.OBSMSTemplate__c = tem1.id;
        update cp;
        //insert tem2;
        tems.add(tem1);
        //tems.add(tem2);
        for(Template__c tem : tems) {
            if(tem.Message_Detail__c.indexof('{Contact_') != -1) {
                extension.templateId = tem.id;
            }
        }
        //extension.templateId
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        String message = extension.optimzeContent('temp{CONTACT_SALUTATION}temp');
    
        // Send SMS
        extension.send();
        system.debug('-----test end');
        String recordTypeSMS = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Task t = [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.SMS_Content__c From Task t Where RecordTypeId=:recordTypeSMS and WhatId = :cp.Id]; // and SMS_Content__c=:extension.templateMessage
        System.assertEquals(t.Subject, 'SMS');
        System.assertEquals(t.Status, 'Closed');
        System.assertEquals(t.WhoId, [Select Id From Contact Where accountId = :customer.Id limit 1].Id);
        
        // Test case 2
        customer.PersonOtherPhone='12345678901';
        customer.PersonMobilePhone = '';
        update customer;
        //Test click SMS button from Task
        Task tas1 = new Task(
            RecordTypeId = obTaskRecordTypeId,
            OwnerId = usr.Id,
            WhatId = cp.Id,
            WhoId = customer.PersonContactId,
            Subject = 'OB Task',
            Result__c = 'Solved',
            Activity_Status__c = 'no answer',
            Dealer_Name__c = 'Test Dealer',
            DUP_Number__c = '123'
        );
        insert tas1;
        ApexPages.currentPage().getParameters().put('taskId', tas1.Id);
        
        extension = new TaskSMSControllerExtension(controller);
        Template__c tem3 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true, 
                                           Name = 'lai', Message_Detail__c = '{DEALER_ADDRESS}');
        insert tem3;
        extension.templateId = tem3.id;
        Templates = extension.getTemplates();
        extension.sms.Dealer__c = null; 
        extension.parseTemplateMessage();        
        extension.sms.Dealer__c = dealer.Id; 
        extension.parseTemplateMessage();
        message = extension.optimzeContent('temp{DEALER_ADDRESS}temp');
        // Send SMS
        extension.send();
        }
       
    }

    public static testMethod void testTaskSMSControllerExtensionErr1() {
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId);
        insert dealer;     
        TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
        extension.sms.Dealer__c = dealer.Id;
        String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Campaign cp = campaignPreparation();
        Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true, 
                                           Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
        insert tem1;
        extension.templateId = tem1.id;
        List<SelectOption> Templates = extension.getTemplates();
        extension.parseTemplateMessage();
        // Send SMS
        extension.send();
        
    }


    public static testMethod void testTaskSMSControllerExtensionErr2() 
    {
        User usr = UtilTestData.createUser('OB TL','CAC OB TL');
        system.runas(usr){
        // Testing the SMS Send
        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
        
        // Add parameters to page URL
        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId);
        insert customer;
        customer = [Select Customer_Number__c, PersonContactId From Account Where Id=:customer.Id];
        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId
            ,Dealer_Address_CN__c = 'chaoyang', City_CN__c = 'beijing', Province__c = '151');
        insert dealer;

        //User usr = UtilTestData.createUser('OB TL','CAC OB TL');
        Campaign cp = campaignPreparation();
        String obTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
        Task tas = new Task(
            RecordTypeId = obTaskRecordTypeId,
            OwnerId = usr.Id,
            WhatId = cp.Id,
            WhoId = customer.PersonContactId,
            Subject = 'OB Task',
            Result__c = 'Solved',
            Activity_Status__c = 'no answer',
            Dealer_Name__c = 'Test Dealer',
            DUP_Number__c = '123'
        );
        
        insert tas;
        
        ApexPages.currentPage().getParameters().put('taskId', tas.Id);
        
        // Test click SMS button from Account
        // Instantiate a new controller extension with all parameters in the page
        TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
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
        
        extension.templateMessage = '';
        extension.send();
        
        extension.templateId = '';
        extension.send();
        }
    }

    // Create Campaign
    private static Campaign campaignPreparation(){
        String tempRecordTypeId1 = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        String tempRecordTypeId2 = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Callscript').getRecordTypeId();
        Template__c tem1 = new Template__c(RecordTypeId = tempRecordTypeId1, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{Contact_Name}');
        Template__c tem2 = new Template__c(RecordTypeId = tempRecordTypeId2, Active__c = true,
                                           Name = 'lai', Message_Detail__c = '{Contact_Name}');
        insert tem1;
        insert tem2;
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();  
        // Central Campaign
        Id centCampaignRT = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();                         
        // Centre Campaign Data Prepared
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             //Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 8, 17),
                                             EndDate=date.newinstance(2013, 11, 17),
                                             RecordTypeId=centCampaignRT,
                                             Execution_Type__c= 'OB Call',
                                             OBSMSTemplate__c=tem1.Id,
                                             Template__c=tem2.Id);  
        insert TestData_CCA;
        return TestData_CCA;
    }
  
}