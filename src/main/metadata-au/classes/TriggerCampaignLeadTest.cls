/*
    Type:       Test Class for TriggerCampaignLead and UtilCampaignLead
    Purpose:    Populate Campaign Title according to contact of corresponding lead and campaign
    User Story: US-Lead-013, US-Lead-013, US-Lead-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-24
*/
@isTest
Public class TriggerCampaignLeadTest {
    // US-Lead-001
    public static testMethod void testTriggerCampaignLead_PopulateContact() {
        // Create one person account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
           UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // One Lead which has a reference to this person account
        Lead__c lead = new Lead__c(Contact__c = personAccount.Id);
        lead = (Lead__c)UtilTestData.createSobject(lead,
            UtilTestData.LEAD_RT_SALES_LEADS);

        // Create Campaign Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(Lead__c = lead.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);

        // Start Test
        Test.startTest();

        camLead = [SELECT Contact__c FROM Campaign_Lead__c WHERE Id = :camLead.Id];
        System.assert(camlead.Contact__c == personAccount.Id);

        // Stop Test
        Test.stopTest();
    }

    public static testMethod void testTriggerCampaignLead_InsertAction() {
        // Two Account: one Dealer and one Person Account
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Account personAccount = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // One Lead which has a reference to this person account
        Lead__c lead = new Lead__c(Contact__c = personAccount.Id);
        lead = (Lead__c)UtilTestData.createSobject(lead,UtilTestData.LEAD_RT_SALES_LEADS);

        // One Campaign Execution, one CAC Campaign and one Central Marketing Campaign
        // and one Participating Dealer of Central Marketing Campaign
        Campaign centralMKTCampaign = (Campaign)UtilTestData.createSobject(new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

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
      //  partDealer = (Participating_Dealer__c)UtilTestData.createSobject(partDealer, null);

        Campaign cacCampaign = new Campaign(
            ParentId = centralMKTCampaign.Id);
        cacCampaign = (Campaign)UtilTestData.createSobject(
            cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        Campaign campaignExecution = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution = (Campaign)UtilTestData.createSobject(
            campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

        // Create CampaignMember for campaignExecution
        Id personContactId = [SELECT PersonContactId 
                              FROM Account WHERE Id = :personAccount.Id].PersonContactId;
        CampaignMember member = new CampaignMember(
            ContactId = personContactId,
            CampaignId = campaignExecution.Id,
            Participating_Dealer_Package__c = partDealer.Id);
        member = (CampaignMember)UtilTestData.createSobject(member, null);

        // Start Test
        Test.startTest();

        // One related Campaign Lead which has a reference to Campaign Execution
        // and has a reference to Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(
            Lead__c = lead.Id,
            Campaign__c = campaignExecution.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);

        // Insert Part Assert
        camLead = [SELECT Campaign_Title__c, Campaign_Notes__c 
                   FROM Campaign_Lead__c WHERE Id = :camLead.Id];
        System.debug('Debug Output ======> {' + camLead + '}');
        //System.assert(camLead.Campaign_Title__c.contains(camPackage.Name));
        //System.assert(camLead.Campaign_Title__c.contains(camPackage.Package_Description__c));

        //System.assert(camLead.Campaign_Notes__c.contains(dealer.Name));
        System.debug('Debug Output ======> {' + member.Registration_Notes__c + '}');
        //System.assert(camLead.Campaign_Notes__c.contains(member.Registration_Notes__c));

        // Stop Test
        Test.stopTest();
    }

    public static testMethod void testTriggerCampaignLead_UpdateAction() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
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
        // Start Test
        Test.startTest();
        // Create Participating_Dealer__c for centralMKTCampaign
        Participating_Dealer__c partDealer = new Participating_Dealer__c(
            Campaign__c = centralMKTCampaign.Id,
            Campaign_Package__c = camPackage.Id);
       // partDealer = (Participating_Dealer__c)UtilTestData.createSobject(partDealer, null);

        // Create Updated Campaign Package for Central MKT Campaign
        Campaign_Package__c camPackage2 = new Campaign_Package__c(
            Campaign__c = centralMKTCampaign.Id);
        camPackage2 = (Campaign_Package__c)UtilTestData.createSobject(camPackage2, null);

        // Create Updated Participating_Dealer__c for centralMKTCampaign
        Participating_Dealer__c partDealer2 = new Participating_Dealer__c(
            Campaign__c = centralMKTCampaign.Id,
            Dealer__c = dealer.Id,
            Campaign_Package__c = camPackage.Id);
        //partDealer2 = (Participating_Dealer__c)UtilTestData.createSobject(partDealer2, null);


        Campaign cacCampaign = new Campaign(
            ParentId = centralMKTCampaign.Id);
        cacCampaign = (Campaign)UtilTestData.createSobject(
            cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

        Campaign campaignExecution = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution = (Campaign)UtilTestData.createSobject(
            campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

        // Create CampaignMember for campaignExecution
        Id personContactId = [SELECT PersonContactId 
                              FROM Account WHERE Id = :personAccount.Id].PersonContactId;
        CampaignMember member = new CampaignMember(
            ContactId = personContactId,
            CampaignId = campaignExecution.Id,
            Participating_Dealer_Package__c = partDealer.Id);
        member = (CampaignMember)UtilTestData.createSobject(member, null);

        Campaign campaignExecution2 = new Campaign(
            ParentId = cacCampaign.Id);
        campaignExecution2 = (Campaign)UtilTestData.createSobject(
            campaignExecution2, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

        CampaignMember member2 = new CampaignMember(
            ContactId = personContactId,
            CampaignId = campaignExecution2.Id,
            Participating_Dealer_Package__c = partDealer2.Id);
        member2 = (CampaignMember)UtilTestData.createSobject(member2, null);


        // One related Campaign Lead which has a reference to Campaign Execution
        // and has a reference to Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(
            Lead__c = lead.Id,
            Campaign__c = campaignExecution.Id);
        camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);

        // Update Campaign Field of Campaign Lead
        //camLead.Campaign__c = campaignExecution2.Id;
        //update camLead;

        // Assert Updated Result
        camLead = [SELECT Campaign_Title__c, Campaign_Notes__c 
                   FROM Campaign_Lead__c WHERE Id = :camLead.Id];
        System.debug('Debug Output ======> {' + camLead + '}');
        System.debug('Debug Output ======> {' + camLead + '}');
       // System.assert(camLead.Campaign_Title__c.contains(camPackage2.Name));
        //System.assert(camLead.Campaign_Title__c.contains(camPackage2.Package_Description__c));
        //System.assert(camLead.Campaign_Notes__c.contains(dealer.Name));
        //System.assert(camLead.Campaign_Notes__c.contains(member2.Registration_Notes__c));

        // Stop Test
        Test.stopTest();
    }
}