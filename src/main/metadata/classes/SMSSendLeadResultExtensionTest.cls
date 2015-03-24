/*
    Type:       test class
    Purpose:    SMSSendLeadResultExtension test class
    User Story: US-Lead-023 - Send SMS content to customer

    Used By:    SMSSendLeadResultExtension
    ---------------------------------------------------------------
    History:

    20-May-2013 Sinow zhang (Nttdata)    Created
*/
@isTest
public class SMSSendLeadResultExtensionTest {

    public static testMethod void testSMSSendLeadResultExtension1()
    {
        User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        User UsedCarDM = UtilTestData.createUser('Used Car DM (E)','CAC IB CSR');
        User SmartDM = UtilTestData.createUser('smart DM (E1)','CAC IB CSR');

        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user1;

        System.runAs ( user1 ) {
	        String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	        String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
			Test.startTest();
            Account customer = new Account(LastName = 'Acme Customer', Phone = '8888888', RecordTypeId = personAccountRecordTypeId, PersonMobilePhone = '12345678901');
            insert customer;
            Account dealer = new Account(Name = 'Acme Dealer', Phone = '8888888', RecordTypeId = dealerRecordTypeId     ,Dealer_Address_CN__c = 'chaoyang', City__c = 'beijing', Province__c = '151');
            insert dealer;

            Lead__c lead = new Lead__c();
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

            // Testing the SMS Send
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put('leadId',lead.Id);
            ApexPages.currentPage().getParameters().put('retURL',lead.Id);

            // Test click SMS button from Lead
            // Instantiate a new controller extension with all parameters in the page
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);
            List<Template__c> tems = new List<Template__c>();
            String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
            Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER_name}', Name = 'lai');
            Template__c tem2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER}', Name = 'lais');
            insert tem1;
            insert tem2;
            tems.add(tem1);
            tems.add(tem2);
            for(Template__c tem : tems) {
                if(tem.Message_Detail__c.indexOf('{DEALER_') != -1) {
                    extension.templateId = tem.id;
                }
            }
            //extension.templateId = tem.id;
            List<SelectOption> Templates = extension.getTemplates();
            extension.parseTemplateMessage();
            String message = extension.optimzeContent('temp{DEALER_NAME}temp');
            // Send SMS
            extension.send();
            Test.stopTest();
            System.assertEquals(tem1.Message_Detail__c, '{DEALER_name}');
            System.assertEquals(tem2.RecordTypeId, templateRecordTypeId);
            System.assertEquals(lead.Assigned_Dealer__c, dealer.Id);               
	        system.assertEquals(dealer.Phone, '8888888');
	        system.assertEquals(customer.RecordTypeId, personAccountRecordTypeId);
	        system.assertEquals(dealer.RecordTypeId, dealerRecordTypeId);
	        system.assert(Templates!=Null);	         
	        system.assertEquals(extension.getTemplates(),Templates);
	        system.assertequals(extension.parseTemplateMessage(),Null);	        
	        system.assertequals(ApexPages.currentPage().getParameters().get('leadId'),lead.Id);
	        system.assertequals(ApexPages.currentPage().getParameters().get('retURL'),lead.Id);
        }
    }
    
    /**
     * for SMSSendLeadResultExtension Line 31 & 40
     */
    public static testMethod void testSMSSendLeadResultExtension4()
    {
        User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        User UsedCarDM = UtilTestData.createUser('Used Car DM (E)','CAC IB CSR');
        User SmartDM = UtilTestData.createUser('smart DM (E1)','CAC IB CSR');

        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user1;

        System.runAs ( user1 ) {
        	Test.startTest();
            Account customer = new Account(LastName = 'acme', Allow_Data_Sharing__c = 'Yes', Province__c = 'jiangsu', City__c = 'nanjing', Preferred_Language__c = 'English');
            customer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            customer.OwnerId = usr.Id;
            insert customer;

            // Create a dealer for lead dealer
            Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);

            Lead__c lead = new Lead__c();
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

            // Testing the SMS Send
            ApexPages.standardController controller = new ApexPages.standardController(new SMS__c());
            ApexPages.currentPage().getParameters().put('leadId',lead.Id);
            ApexPages.currentPage().getParameters().put('retURL',lead.Id);

            // Test click SMS button from Lead
            // Instantiate a new controller extension with all parameters in the page
            SMSSendLeadResultExtension extension = new SMSSendLeadResultExtension(controller);

            String templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
            Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = 'temp{DEALER_ADDRESS}temp', Name = 'lai');
            insert tem1;
            extension.templateId = '123';
            List<SelectOption> Templates = extension.getTemplates();
            //extension.sms.dealer=null;
            extension.parseTemplateMessage();
            String message = extension.optimzeContent('temp{DEALER_NAME}temp');
            // Send SMS
            extension.send();
            Test.stopTest();
            system.assert(lead!=Null);
            system.assertEquals(lead.Contact__c, customer.Id);            
            system.assertEquals(tem1.Message_Detail__c, 'temp{DEALER_ADDRESS}temp');
            system.assertEquals(tem1.RecordTypeId, templateRecordTypeId);
            system.assertEquals(lead.Assigned_Dealer__c, dealer.Id);               
	        system.assertEquals(dealer.Phone, '021-000000');
	        system.assert(Templates!=Null);        
	        system.assertEquals(extension.getTemplates(),Templates);
	        system.assertequals(extension.parseTemplateMessage(),Null);	      
	        system.assertequals(ApexPages.currentPage().getParameters().get('leadId'),lead.Id);
	        system.assertequals(ApexPages.currentPage().getParameters().get('retURL'),lead.Id);
        }
    }
}