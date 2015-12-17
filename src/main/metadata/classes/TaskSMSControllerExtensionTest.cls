/*
    Type:       test class
    Purpose:    TaskSMSControllerExtension test class
    User Story: Central Interactive SMS Workbook
    Used By:    TaskSMSControllerExtension
    History:27-Nov-2013 Chaos Huang (Nttdata)    Created
*/
@isTest
public with sharing class TaskSMSControllerExtensionTest{

  private static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  private static String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
  private static String obTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
  private static Account customer;
  private static Account dealer;
  private static Campaign CampaignR;
  private static Campaign_Lead__c camlead;
  private static Task tas;
  private static Template__c tem1;
  private static Template__c tem2;
  private static Lead__c lead;
  private static SMS__c sms;
  private static string acc_ID='taskId';
  private static string TASK_ID='taskId';
  private static List<Template__c> tems = new List<Template__c>();
  static user userObj;
  static{
    Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        userObj = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert userObj;
  }
 

     public static testMethod void testTaskSMSControllerExtension()
    {
        System.runAs(userObj)
        {
            Test.startTest();
            prepareTestData();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(acc_ID,dealer.Id);
            ApexPages.currentPage().getParameters().put(TASK_ID,tas.Id);

            // Test click SMS button from Lead
            // Instantiate a new controller extension with all parameters in the page
            TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
            Test.stopTest();
            system.assertequals(extension.taskObject.id,tas.id);
        }
    }
    
  
    
     public static testMethod void testgetTemplates()
    {
        System.runAs(userObj) {
            Test.startTest();
            prepareTestData();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(Task_ID,tas.Id);
            TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            for(Template__c obj:tems)
                options.add(new SelectOption(obj.Id, obj.Name));
            List<SelectOption> temp=extension.getTemplates();
            Test.stopTest();
           system.assertequals(temp,options);
        }
    }
    
     public static testMethod void testsend()
    {
        System.runAs(userObj) {
            Test.startTest();
            prepareTestData();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(TASK_ID,tas.Id);
            TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
            extension.sms.Dealer__c = dealer.Id;
            extension.templateId=tem1.Id;
            extension.templateMessage='test message';
            extension.send();
            Test.stopTest();
            List<task> lsttask=[select whatid from task where whatid=:camlead.Id];
            system.assertequals(true,!lsttask.isEmpty());
            system.assertequals(customer.Gender__c,'Male');
        }
    }
    
    public static testMethod void testsendElseCondition()
    {
    	List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		 insert updatecustomsettings;
        System.runAs(userObj) {
            Test.startTest();
            prepareTestDataElseCondition();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(TASK_ID,tas.Id);
            TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
            extension.templateId=null;
            extension.send();
            TaskSMSControllerExtension extension1 = new TaskSMSControllerExtension(controller);
            extension1.templateId=tem1.id;
            extension1.templateMessage='test message';
            extension1.send();
            Test.stopTest();
            system.assertequals(extension1.templateId,tem1.id);
            system.assertequals(extension1.templateMessage,'test message');
            system.assertequals(customer.Gender__c,'Female');
        }
    }
    
    public static testMethod void testparseTemplateMessage()
    {
        System.runAs(userObj) {
            Test.startTest();
            prepareTestData();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put('CLead',camlead.Id);
            ApexPages.currentPage().getParameters().put(TASK_ID,tas.Id);
            TaskSMSControllerExtension extension = new TaskSMSControllerExtension(controller);
            extension.templateId=tem1.Id;
            extension.getTemplates();
            extension.parseTemplateMessage();
            Test.stopTest();
            system.assertequals(extension.templateId,tem1.id);
        }
    }


    static void prepareTestData()
    {
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		 insert updatecustomsettings;
        customer = new Account(LastName = 'Acme Customer', Phone = '08888888',PersonOtherPhone='99999999', RecordTypeId = personAccountRecordTypeId, PersonMobilePhone = '12345678901',Gender__c ='Male');
        insert customer;
        dealer = new Account(Name = 'Acme Dealer', Phone = '08888888',RecordTypeId = dealerRecordTypeId,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
        insert dealer;
        sms=new SMS__c(CustomerName__c='Acme Dealer',Secondary_Mobile__c=true);
        insert sms;
        campaignPreparation();
       
       
    }
    
    static void prepareTestDataElseCondition()
    {
      customer = new Account(Area_Code__c = '010', LastName = 'Acme Customer', Phone = '08888888', RecordTypeId = personAccountRecordTypeId,Gender__c ='Female');
        insert customer;
        customer = [Select Customer_Number__c, PersonContactId From Account Where Id=:customer.Id];
        dealer = new Account(Name = 'Acme Dealer', Phone = '08888887', RecordTypeId = dealerRecordTypeId,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
        insert dealer;
        
        campaignPreparation();
      
          }
    
    private static Campaign_Lead__c campaignPreparation()
    {
     tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true, 
                                               Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
                                               insert tem1;
        lead = new Lead__c();
        lead.Assigned_Dealer__c = dealer.Id;
        lead.Contact__c = customer.Id;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'Used Car';
        lead.Relation_With_The_Leads__c = 'test';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'test';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'C-CLASS';
        insert lead;
    
       // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();  
        // Central Campaign
        Id centCampaignRT = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();                         
        // Centre Campaign Data Prepared
        // Central Campaign Inital
         CampaignR = new Campaign(Name='TestData_CCA_Campaign',
                                             //Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 8, 17),
                                             EndDate=date.newinstance(2013, 11, 17),
                                             RecordTypeId=centCampaignRT,
                                             OBSMSTemplate__c=tem1.id,
                                             Execution_Type__c= 'OB Call');  
        insert CampaignR;
        
        camlead=new Campaign_Lead__c();
        camlead.Contact__c=customer.id;
        camlead.Lead__c=lead.id;
        camlead.Campaign__c=CampaignR.id;
        insert camlead;
          

    customer = [Select Customer_Number__c, PersonContactId,Gender__c  From Account Where Id=:customer.Id];
    
    tas = new Task(
                RecordTypeId = obTaskRecordTypeId,
                OwnerId = userObj.Id,
                WhatId = camlead.Id,
                WhoId = customer.PersonContactId,
                Subject = 'OB Task',
                Result__c = 'Solved',
                Activity_Status__c = 'no answer',
                Dealer_Name__c = 'Test Dealer',
                DUP_Number__c = '123'
            );
            
            insert tas;
           
             ApexPages.currentPage().getParameters().put(TASK_ID, tas.Id);
             
             
          tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,Name = 'lai', Message_Detail__c = '{DEALER_NAME}');
          insert tem2;
                                                             
        tems.add(tem1);
               
        return camlead;
        
    }
    
    
  
}