/*
    Type:       Test Class for TriggerLead
    Purpose:    Test Logic in TriggerLead
    User Story: US-Lead-016, US-Lead-009
    1. Mouse Created on 2013-04-26
    2. Mouse Updated on 2013-07-04 for US-Lead-009
*/
@isTest
private with sharing class TriggerLeadTest {
    
    private static Account dealer;
    private static Contact contact1;
    private static  string dealerStatusValue = 'Accepted';
    private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    // US-Lead-009
    // 
    public static void dealerCreation(){
         dealer = new Account(RecordTypeId = dealerRecordTypeId, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today(),Business_Unit__c = 'Alliance');
        insert dealer;
        
        contact1 = new Contact (          AccountId = dealer.id,
                                         Inactive__c=false,
                                         Business_Unit__c='Alliance',
                                         Sub_BusinessUnit__c='Finance',
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
                   insert contact1;
        
    }
    public static testMethod void testLeadAllowDataSharing() {
       dealerCreation();
        
        Account personAccount = new Account(Allow_Data_Sharing__c = 'Yes');
        UtilTestData.createSobject(personAccount, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        Lead__c lead = new Lead__c(Contact__c = personAccount.Id,Assigned_Dealer__c=dealer.id);
        UtilTestData.createSobject(lead, UtilTestData.LEAD_RT_SALES_LEADS);

        lead = [SELECT Allow_Data_Sharing__c FROM Lead__c WHERE Id = :lead.Id];
        system.assertEquals(lead.Allow_Data_Sharing__c , true);
       
    }

    public static testMethod void testTriggerLead_PopulateLeadStatus() {
        dealerCreation();
        Lead__c lead = new Lead__c(
            CAC_Lead_Status__c='New Enquiry',
            Assigned_Date_Time__c = null,
            Dealer_Audit__c = false,
            Assigned_Dealer__c=dealer.id,
            Dealer_Lead_Status__c = dealerStatusValue);

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        // Start Test
        Test.startTest();

        lead.Assigned_Date_Time__c = System.now();
        update lead;

        lead = [SELECT Dealer_Lead_Status__c FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(lead.Dealer_Lead_Status__c, dealerStatusValue);

        // Stop Test
        Test.stopTest();
    }
    
    public static testMethod void testTriggerLead_add() {
        system.debug('===================I am in ++++++++++++++++++++++++');
        
        // Start Test
        Test.startTest(); 
        Account customer = new Account();
        String personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        customer.Salutation='Brother';
        customer.FirstName='test';
        customer.Allow_Data_Sharing__c = 'Yes'; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = 'English';
        customer.Dealer_Lead_System__c = 'Salesforce';
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '200235';
        customer.Type = '0=Company';
         customer.Email__c='test011@test.com';
        customer.Email2__c='test012@test.com';
        customer.Home_Phone_2__c='9958745898';
        customer.Phone = '12332111'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId = personRecordTypeId;

        customer.Area_Code__c = '010';
        insert customer;
        Vehicle__c vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), null);
        Vehicle_Relationship__c vr = new Vehicle_Relationship__c(Contact__c=customer.Id,
                                                                 Vehicle_ID__c=vehicle.id,
                                                                 Car_Relation__c='user');
        insert vr;
                                                                 
        Id aftersalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 'Service Lead');
                                                                 
        Lead__c lead = new Lead__c(
            VehicleRel_No__c = vr.Id,
            RecordTypeId = aftersalesRecordTypeId,
            Dealer_Audit__c = false,
            Dealer_Lead_Status__c = dealerStatusValue,
            CAC_Lead_Status__c = dealerStatusValue,
            Assigned_Date_Time__c = System.now(),
            Contact__c = customer.Id
        );

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        System.debug('***************##########'+lead);

       
        // Stop Test
        Test.stopTest();
        
         lead = [SELECT CAC_Lead_Status__c FROM Lead__c WHERE Id = :lead.Id];
        System.debug('**************************************'+lead);
        System.assertEquals(lead.CAC_Lead_Status__c, dealerStatusValue);

    }

    public static testMethod void testTriggerLead_PopulateIsQualify1() {
        Lead__c lead = new Lead__c(
            Dealer_Audit__c = false,
            CAC_Lead_Status__c = 'New');

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        // Start Test
        Test.startTest();

        // Update CAC_Lead_Status__c from New to 'Lost(CAC)'
        lead.CAC_Lead_Status__c = 'Lost(CAC)';
        lead.Lost_CAC_Date__c = System.today();
        update lead;

       
        // Stop Test
        Test.stopTest();
         lead = [SELECT CAC_Lead_Status__c FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(lead.CAC_Lead_Status__c, 'Lost(CAC)');

    }

    public static testMethod void testTriggerLead_PopulateIsQualify2() {
        Lead__c lead = new Lead__c(
            Dealer_Audit__c = false,
            CAC_Lead_Status__c = 'New');

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        // Start Test
        Test.startTest();
        // Update CAC_Lead_Status__c from New to 'Lost(CAC)'
        lead.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
        lead.Bought_Vehicle_Brand__c = 'MB';
        lead.Bought_Vehicle_Class__c = 'A-Class';
        lead.Bought_Vehicle_Model__c = 'A160';
        lead.Purchased_CAC_Date__c = System.today();
        update lead;
      
        // Stop Test
        Test.stopTest();
          lead = [SELECT Is_Qualify__c FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(lead.Is_Qualify__c, 'Qualified');

    }
}