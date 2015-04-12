/*
    Type:       test class
    Purpose:    TaskSMSControllerExtension test class
    User Story: Central Interactive SMS Workbook

    Used By:    TaskSMSControllerExtension
    ---------------------------------------------------------------
    History:

    27-Nov-2013 Chaos Huang (Nttdata)    Created
*/
@isTest(SeeAllData=true)
public class TaskSMSControllerExtensionTest 
{

    public static testMethod void testTaskSMSControllerExtension1() 
    {
        User usr = UtilTestData.createUser('OB TL','CAC OB TL');
        system.runas(usr)
        {
	        Test.startTest();
	        // Testing the SMS Send
	        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
	        
	        // Add parameters to page URL
	        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	        Account customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId,PersonMobilePhone = '1301111111',PersonOtherPhone = '1301111122');
	        insert customer;
	        customer = [Select Customer_Number__c, PersonContactId From Account Where Id=:customer.Id];
	        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId
	            ,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
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
	        insert tem1;
	        cp.OBSMSTemplate__c = tem1.id;
	        update cp;
	        //insert tem2;
	        tems.add(tem1);
	        //tems.add(tem2);
	        for(Template__c tem : tems) 
	        {
	            if(tem.Message_Detail__c.indexof('{Contact_') != -1) 
	            {
	                extension.templateId = tem.id;
	            }
	        }
	        //extension.templateId
	        List<SelectOption> Templates = extension.getTemplates();
	        extension.parseTemplateMessage();
	        String message = extension.optimzeContent('temp{CONTACT_SALUTATION}temp');
	    
	        // Send SMS
	        extension.send();
	        String recordTypeSMS = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
	        Task t = [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.SMS_Content__c From Task t Where RecordTypeId=:recordTypeSMS and WhatId = :cp.Id]; // and SMS_Content__c=:extension.templateMessage
	        
	        // Test case 2
	        customer.PersonOtherPhone='1234678901';
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
	        Test.stopTest();
	        system.assertequals(ApexPages.currentPage().getParameters().get('taskId'),tas1.Id);
	        system.assert(tems!=Null);
	        system.assertEquals(t.Subject, 'SMS');
	        system.assertEquals(t.Status, 'Closed');
	        system.assertEquals(t.WhoId, [Select Id From Contact Where accountId = :customer.Id limit 1].Id);
	        system.assertEquals(cp.OBSMSTemplate__c,tem1.id);
	        system.assertEquals(tem3.Message_Detail__c, '{DEALER_ADDRESS}');
            system.assertEquals(tem3.RecordTypeId, templateRecordTypeId);
            system.assertEquals(tas1.WhoId,customer.PersonContactId);  
            system.assertEquals(extension.sms.Dealer__c,dealer.Id); 
            system.assertequals(extension.parseTemplateMessage(),Null);	  
	        system.assertequals(extension.optimzeContent('temp{DEALER_ADDRESS}temp'),message);	        	         
	        system.assertEquals(extension.getTemplates(),Templates);	      
        }
    }

    public static testMethod void testTaskSMSControllerExtensionErr1() 
    {
    	Test.startTest();
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
        Test.stopTest();
        system.assertEquals(dealer.RecordTypeId, dealerRecordTypeId);
        system.assertEquals(extension.templateId,tem1.id);        
	    system.assert(tem1!=Null);
	    system.assertEquals(tem1.Message_Detail__c, '{DEALER_NAME}');
        system.assertEquals(tem1.RecordTypeId, templateRecordTypeId);        
        system.assertEquals(extension.sms.Dealer__c,dealer.Id); 
        system.assertequals(extension.parseTemplateMessage(),Null);	   	              
	    system.assertEquals(extension.getTemplates(),Templates);
    }


    public static testMethod void testTaskSMSControllerExtensionErr2() 
    {
        User usr = UtilTestData.createUser('OB TL','CAC OB TL');
        system.runas(usr)
        {
	        Test.startTest();
	        // Testing the SMS Send
	        ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
	        
	        // Add parameters to page URL
	        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	        Account customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId);
	        insert customer;
	        customer = [Select Customer_Number__c, PersonContactId From Account Where Id=:customer.Id];
	        Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId
	            ,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
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
	        Test.stopTest();
        	system.assertEquals(tem1.Message_Detail__c,'{DEALER_NAME}');
        	system.assertEquals(extension.send(), null);
        	system.assertequals(ApexPages.currentPage().getParameters().get('taskId'),tas.Id);	      
	        system.assertEquals(extension.templateMessage,'');	      
            system.assertEquals(tem1.RecordTypeId,templateRecordTypeId);
            system.assertEquals(tas.WhoId,customer.PersonContactId);  
            system.assertEquals(extension.sms.Dealer__c,dealer.Id); 
            system.assertequals(extension.parseTemplateMessage(),Null);	  
	        system.assertequals(extension.optimzeContent('temp{DEALER_ADDRESS}temp'),message);	        	         
	        system.assertEquals(extension.getTemplates(),Templates);
        }
    }

    // Create Campaign
    private static Campaign campaignPreparation()
    {
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
        System.assertEquals(TestData_CCA.OBSMSTemplate__c,tem1.Id);
        System.assert(TestData_CCA.id!=null);
        return TestData_CCA;
    }
  
}