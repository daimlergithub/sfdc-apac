/*
    Type:       Test class for SelectAssignedDealerController
    Purpose:    Test logic in SelectAssignedDealerController.cls
    User Story: US-Lead-003
    
    1. Mouse Created on 2013-05-03
*/
@isTest
private with sharing class SelectAssignedDealerControllerTest 
{
    private static Account dealer;
    private static Account personAccount;
    private static Lead__c lead;
    private static Campaign centralMKTCampaign;
    private static Campaign_Package__c camPackage;
    private static Campaign_Offering__c offering;
    private static Package_Item__c packageItem;
    private static Participating_Dealer__c partDealer;
    private static Campaign cacCampaign;
    private static Campaign campaignExecution;
    private static Campaign_Lead__c camLead;
    private static string utilTest='UtilTestData.LEAD_RT_SALES_LEADS';
    private static string pageRef = '/apex/SelectAssignedDealer?Id=';
    private static string provinceValue = 'Anhui';
    
    public static testMethod void testSelectAssignedDealerController()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        // Test Dealer Province is Beijing, so has query result
        selectDealer.dealer.Province__c = provinceValue;
        selectDealer.dealer.City__c = 'Anyang';
        selectDealer.query();
        Test.stopTest();
        System.assertequals(true,selectDealer.hasQueryResult);
    }
    
    public static testMethod void testgetCityOptions()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        selectDealer.dealer.Province__c = provinceValue;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption(dealer.City__c,dealer.City__c));
        selectDealer.getCityOptions();
        Test.stopTest();
        system.assertequals(options,selectDealer.getCityOptions());
    }
    
    public static testMethod void testrefreshPage()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        selectDealer.refreshPage();
        Test.stopTest();
        system.assertequals(null,selectDealer.refreshPage());
    }
    
    public static testMethod void testchoose()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        selectDealer.choosenDealerId=dealer.Id;
        id expectedID;
        selectDealer.choose();
        expectedID=selectDealer.lead.Assigned_Dealer__c;
        Test.stopTest();
        system.assertequals(dealer.Id,expectedID);
    }
    
    public static testMethod void testcampaignOptions()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef+ lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        List<SelectOption> campaignOptions = new List<SelectOption>();
        campaignOptions.add(new SelectOption('', '--None--'));
        campaignOptions.add(new SelectOption(campaignExecution.Id, campaignExecution.Name));
        List<SelectOption> temp=selectDealer.campaignOptions;
        Test.stopTest();
        system.assertequals(campaignOptions,temp);
    }
    
    public static testMethod void testquery()
    {
        Test.startTest();
        prepareTestdata('UtilTestData.LEAD_RT_AFTER_SALES_LEADS');
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        // Test Dealer Province is Beijing, so has query result
        selectDealer.dealer.Province__c = provinceValue;
        selectDealer.dealer.City__c = 'Anyang';
        selectDealer.lead= new Lead__c();
        selectDealer.query();
        Test.stopTest();
        System.assertequals(true,selectDealer.hasQueryResult);
        System.assertequals(camLead.Lead__c,lead.id);
    }
    
    public static testMethod void testqueryelseCondition()
    {
        Test.startTest();
        prepareTestdata('UtilTestData.LEAD_RT_AFTER_SALES_LEADS');
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        // Test Dealer Province is Beijing, so has query result
        selectDealer.dealer.Province__c = 'test';
        selectDealer.dealer.City__c = 'test';
        selectDealer.lead= new Lead__c();
        selectDealer.query();
        Test.stopTest();
        System.assertequals(false,selectDealer.hasQueryResult);
        System.assertequals(camLead.Lead__c,lead.id);
    }
    
    public static testMethod void testchooseelseCondition()
    {
        Test.startTest();
        prepareTestdata(utilTest);
        PageReference pr = new PageReference(pageRef + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(new ApexPages.StandardController(lead));
        selectDealer.choosenDealerId=personAccount.Id;
        id expectedID;
        selectDealer.choose();
        expectedID=selectDealer.lead.Assigned_Dealer__c;
        Test.stopTest();
        system.assertequals(personAccount.Id,expectedID);
    }
    
    static void prepareTestdata(string leadType)
    {
    
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;

        // Two Account: one Dealer and one Person Account
        dealer = (Account)UtilTestData.createSobject(
            new Account(
                Dealer_Sales_Type__c ='MB',
                Province__c = provinceValue,
                City__c = 'anyang',
                Dealer_Active__c = true,
                Dealer_Service_Codes__c = 'Sales',
                Name = 'Beijing Test',MBK_Data_Source__c='Advertisement',Mobile__c='000-000-0000'
            ), 
            UtilTestData.ACCOUNT_RT_DEALER);

        personAccount = (Account)UtilTestData.createSobject(new Account(MBK_Data_Source__c='Advertisement',Mobile__c='000-000-0000'), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
personAccount.Email__c='test@mbau.com';
                    personAccount.Email2__c = 'testemail2@test.com';
                    personAccount.Home_Phone_2__c = '98765413';  
        // One Lead which has a reference to this person account
        lead = new Lead__c(Contact__c = personAccount.Id);
        lead = (Lead__c)UtilTestData.createSobject(lead,
            leadType);

        // One Campaign Execution, one CAC Campaign and one Central Marketing Campaign
        // and one Participating Dealer of Central Marketing Campaign
        centralMKTCampaign = (Campaign)UtilTestData.createSobject(
            new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        // Create Campaign Package for Central MKT Campaign
        camPackage = new Campaign_Package__c(
            Campaign__c = centralMKTCampaign.Id);
        camPackage = (Campaign_Package__c)UtilTestData.createSobject(camPackage, null);

        // Create Package Item for this Central MKT Campaign
        // Because Campaign Offer is the Master Object of Package Item, 
        // so we need to create campaign offering firstly
        offering = (Campaign_Offering__c)UtilTestData.createSobject(
            new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id), null);

       
        packageItem= (Package_Item__c)UtilTestData.createSobject(
            new Package_Item__c(
                Offering__c = offering.Id,
                Package_Name__c = camPackage.Id), null);

        // Create Participating_Dealer__c for centralMKTCampaign
        partDealer = new Participating_Dealer__c(
            Campaign__c = centralMKTCampaign.Id,
            Dealer__c = dealer.Id,
            Campaign_Package__c = camPackage.Id);
        
        cacCampaign = new Campaign(
            ParentId = centralMKTCampaign.Id);
        cacCampaign = (Campaign)UtilTestData.createSobject(
            cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        campaignExecution = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution = (Campaign)UtilTestData.createSobject(
            campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

      
        camLead = new Campaign_Lead__c(
            Lead__c = lead.Id,
            Campaign__c = campaignExecution.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);
        system.assertNotEquals(null,packageItem);
        system.assertNotEquals(null,partDealer);
    }
}