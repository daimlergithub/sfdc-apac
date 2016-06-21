/*
    Type:       test class
    Purpose:    SMSSendLeadResultExtension test class
    User Story: US-Lead-023 - Send SMS content to customer
   20-May-2013 Sinow zhang (Nttdata)    Created
*/
@isTest
public class SMSSendLeadResultExtensionTest {

    private static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static Account customer;
    private static Account dealer;
    private static Lead__c lead;
    private static Template__c tem1;
    private static Template__c tem2;
    private static string LEAD_ID='leadid';
    private static string RET_URL='retURL';
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
    
    public static testMethod void testSMSSendLeadResultExtension()
    {
        System.runAs(userObj) {
            prepareTestData();
            Test.startTest();            
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(LEAD_ID,lead.Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lead.Id);
            // Test click SMS button from Lead
            // Instantiate a new controller extension with all parameters in the page
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            Test.stopTest();
            system.assertequals(extension.leadInfo.Id,lead.Id);
        }
    }
    
    public static testMethod void testSMSSendLeadResultExtension_elsecondition()
    {
        System.runAs(userObj) {
            prepareTestData();
            Test.startTest();            
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            // Test click SMS button from Lead
            // Instantiate a new controller extension with all parameters in the page
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            Test.stopTest(); 
            system.assertequals(extension.leadInfo,null);
        }
    }
    
    public static testMethod void testgetTemplates()
    {
        System.runAs(userObj) {
        
            prepareTestData();
            Test.startTest();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(LEAD_ID,lead.Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lead.Id);
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
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
            prepareTestData();
            Test.startTest();            
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(LEAD_ID,lead.Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lead.Id);
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            extension.templateId=tem1.Id;
            extension.templateMessage='test message';
            extension.send();
            Test.stopTest();
            List<task> lsttask=[select whatid from task where whatid=:lead.Id];
            system.assertequals('test message',extension.templateMessage);
        }
    }
    
    public static testMethod void testsend_elsecondition()
    {
        System.runAs(userObj) {
            prepareTestData_elsecondition();
            Test.startTest();            
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(LEAD_ID,lead.Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lead.Id);
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            extension.templateId=null;
            extension.send();
            SMSSendLeadResultExtension extension1 = new SMSSendLeadResultExtension(controller);
            extension1.templateId=tem1.id;
            extension1.templateMessage='test message';
            extension1.send();
            Test.stopTest();
            system.assertequals('test message',extension1.templateMessage);
        }
    }
    
    public static testMethod void testparseTemplateMessage()
    {
        System.runAs(userObj) {
            prepareTestData();
            Test.startTest();
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put(LEAD_ID,lead.Id);
            ApexPages.currentPage().getParameters().put(RET_URL,lead.Id);
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            extension.templateId=tem1.Id;
            extension.getTemplates();
            extension.parseTemplateMessage();
            Test.stopTest();
            system.assertequals(tem1.id,extension.templateId);
        }
    }
    
    static void prepareTestData()
    {
        customer = new Account(LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId, PersonMobilePhone = '12345678901');
        insert customer;
        dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
        insert dealer;
        createLead();
        createTemplate();
    }
    
    static void prepareTestData_elsecondition()
    {
        customer = new Account(LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId);
        insert customer;
        dealer = new Account(Name = 'Acme Dealer', Phone = '8888887', RecordTypeId = dealerRecordTypeId,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
        insert dealer;
        createLead();
        createTemplate();
    }
    
    static void createLead()
    {
        lead = new Lead__c();
        lead.Assigned_Dealer__c = dealer.Id;
        lead.Contact__c = customer.Id;
        lead.CAC_Lead_Status__c = 'New Enquiry';//Qualified
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
    }
    
        static void createTemplate()
    {
        tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER_name}', Name = 'lai');
        tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER}', Name = 'lais');
        insert tem1;
        insert tem2;
        tems.add(tem1);
        tems.add(tem2);
    }
}