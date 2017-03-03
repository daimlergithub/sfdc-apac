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
    
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id DealercRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id centralRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id camexecuRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Simple').getRecordTypeId();
    public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    
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
     
    static void prepareTestdata(string leadType) {
   List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
   //insert updatecustomsettings;
Trigger__c newtrg = new Trigger__c(Name= 'TriggerAccountLink',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
   dealer = new Account(RecordTypeId=DealercRecordTypeId,Dealer_Sales_Type__c ='MB', Province__c = provinceValue, City__c = 'anyang', 
                        Dealer_Active__c = true, Dealer_Service_Codes__c = 'Sales',Name = 'Beijing Test',Mobile__c='0000000000'); 
   insert dealer;       

   personAccount = new Account();
   personAccount.RecordTypeId=personAccRecordTypeId;
   personAccount.Lastname='testlastname';
   personAccount.Mobile__c='0000000000';
   personAccount.Email__c='test@mbau.com';
   personAccount.Email2__c = 'testemail2@test.com';
   personAccount.Home_Phone_2__c = '0000009842';  
        
   insert personAccount;
        
   // One Lead which has a reference to this person account
        
   lead = new Lead__c();
   lead.Contact__c = personAccount.Id;
   lead.RecordTypeId=salesleadRecordTypeId;
   insert lead;
        
   centralMKTCampaign = new Campaign(RecordTypeId=centralRecordTypeId,Name='Testnamecampaign');
   insert centralMKTCampaign;
    
   camPackage = new Campaign_Package__c(Campaign__c = centralMKTCampaign.Id);
   insert camPackage;
        
   offering = new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id);
   insert offering;
        
   packageItem= new Package_Item__c(Offering__c = offering.Id,Package_Name__c = camPackage.Id);
   insert packageItem;
    
   partDealer = new Participating_Dealer__c(Campaign__c = centralMKTCampaign.Id,Dealer__c = dealer.Id,Campaign_Package__c = camPackage.Id);
   insert partDealer;
        
   cacCampaign = new Campaign(Name = 'TYest Rec',RecordTypeId=centralRecordTypeId,ParentId = centralMKTCampaign.Id);
   insert cacCampaign;
        
   campaignExecution = new Campaign(Name = 'TYest Rec1',RecordTypeId=camexecuRecordTypeId,ParentId = cacCampaign.Id);
   insert campaignExecution;
        
   camLead = new Campaign_Lead__c(Lead__c = lead.Id,Campaign__c = campaignExecution.Id);
   insert camLead;
        
   system.assertNotEquals(null,packageItem);
   system.assertNotEquals(null,partDealer);
 }
}