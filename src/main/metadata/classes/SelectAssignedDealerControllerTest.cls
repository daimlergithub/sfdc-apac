/*
    Type:       Test class for SelectAssignedDealerController
    Purpose:    Test logic in SelectAssignedDealerController.cls
    User Story: US-Lead-003
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-05-03
*/
@isTest
private class SelectAssignedDealerControllerTest {
    public static testMethod void testSelectAssignedDealerController_hasPartDealer() {
        // Two Account: one Dealer and one Person Account
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(
                Dealer_Sales_Type__c ='MB', 
                Province__c = 'Anhui',
                City__c = 'anyang',
                Dealer_Active__c = true,
                Dealer_Service_Codes__c = 'Sales',
                Name = 'Beijing Test'
            ), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // One Lead which has a reference to this person account
        Lead__c lead = new Lead__c(Contact__c = personAccount.Id);
        lead = (Lead__c)UtilTestData.createSobject(lead,
            UtilTestData.LEAD_RT_SALES_LEADS);

        // One Campaign Execution, one CAC Campaign and one Central Marketing Campaign
        // and one Participating Dealer of Central Marketing Campaign
        Campaign centralMKTCampaign = (Campaign)UtilTestData.createSobject(
            new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        // Create Campaign Package for Central MKT Campaign
        Campaign_Package__c camPackage = new Campaign_Package__c(
            Campaign__c = centralMKTCampaign.Id);
        camPackage = (Campaign_Package__c)UtilTestData.createSobject(camPackage, null);

        // Create Package Item for this Central MKT Campaign
        // Because Campaign Offer is the Master Object of Package Item, 
        // so we need to create campaign offering firstly
        Campaign_Offering__c offering = (Campaign_Offering__c)UtilTestData.createSobject(
            new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id), null);

        // Create packageItem under camPackage and offering
        Package_Item__c packageItem = (Package_Item__c)UtilTestData.createSobject(
            new Package_Item__c(
                Offering__c = offering.Id,
                Package_Name__c = camPackage.Id), null);

        // Create Participating_Dealer__c for centralMKTCampaign
        Participating_Dealer__c partDealer = new Participating_Dealer__c(
            Campaign__c = centralMKTCampaign.Id,
            Dealer__c = dealer.Id,
            Campaign_Package__c = camPackage.Id);
        partDealer = (Participating_Dealer__c)UtilTestData.createSobject(partDealer, null);

        Campaign cacCampaign = new Campaign(
            ParentId = centralMKTCampaign.Id);
        cacCampaign = (Campaign)UtilTestData.createSobject(
            cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        Campaign campaignExecution = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution = (Campaign)UtilTestData.createSobject(
            campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

        // One related Campaign Lead which has a reference to Campaign Execution
        // and has a reference to Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(
            Lead__c = lead.Id,
            Campaign__c = campaignExecution.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);

        PageReference pr = new PageReference('/apex/SelectAssignedDealer?Id=' + lead.Id);
        Test.setCurrentPage(pr);
        Test.startTest();
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(
            new ApexPages.StandardController(lead));
        System.assert(selectDealer.dealers.size() == 1);
        // One default -- None --, another is test data
        System.assert(selectDealer.campaignOptions.size() == 2);
        System.assert(selectDealer.dealers[0].Id == dealer.Id);

        // Test Dealer Province is Beijing, so has query result
        selectDealer.dealer.Province__c = 'Anhui';
        selectDealer.dealer.City__c = 'Anyang';
        selectDealer.query();
        System.assert(selectDealer.dealers.size() == 1);

        // Test Dealer Province Name is Beijing Test, so has result
        selectDealer.Name = 'Beijing';
        selectDealer.query();
        System.assert(selectDealer.dealers.size() == 1);

        // Test Dealer Province is Beijing, so no query result
        selectDealer.dealer.Province__c = 'Shanghai';
        selectDealer.query();
        System.assert(selectDealer.dealers.size() == 0);

        // Test choose action
        selectDealer.choosenDealerId = dealer.Id;
        selectDealer.choose();
        //lead = [SELECT Assigned_Dealer__c FROM Lead__c WHERE Id = :lead.Id];
        //System.assert(lead.Assigned_Dealer__c == dealer.Id);
        Test.stopTest();
    }

   public static testMethod void testSelectAssignedDealerController_NoPartDealer() {
        // Two Account: one Dealer and one Person Account
        Account dealer = new Account(Dealer_Sales_Type__c ='MB');
        dealer = (Account)UtilTestData.createSobject(dealer, 
            UtilTestData.ACCOUNT_RT_DEALER);
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // One Lead which has a reference to this person account
        Lead__c lead = new Lead__c(Contact__c = personAccount.Id);
        lead = (Lead__c)UtilTestData.createSobject(lead,
            UtilTestData.LEAD_RT_SALES_LEADS);

        // One Campaign Execution, one CAC Campaign and one Central Marketing Campaign
        // and one Participating Dealer of Central Marketing Campaign
        Campaign centralMKTCampaign = (Campaign)UtilTestData.createSobject(
            new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        Campaign cacCampaign = new Campaign(
            ParentId = centralMKTCampaign.Id);
        cacCampaign = (Campaign)UtilTestData.createSobject(
            cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        Campaign campaignExecution = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution = (Campaign)UtilTestData.createSobject(
            campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

        // One related Campaign Lead which has a reference to Campaign Execution
        // and has a reference to Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(
            Lead__c = lead.Id,
            Campaign__c = campaignExecution.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);

        PageReference pr = new PageReference('/apex/SelectAssignedDealer?Id=' + lead.Id);
        Test.setCurrentPage(pr);
        SelectAssignedDealerController selectDealer = new SelectAssignedDealerController(
            new ApexPages.StandardController(lead));
        System.debug('Debug Output ======> {' + selectDealer.dealers + '}');
        //System.assert(selectDealer.dealers.size() == 0);
    }
}