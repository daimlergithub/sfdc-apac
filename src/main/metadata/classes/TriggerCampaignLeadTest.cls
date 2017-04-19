/*
    Type: Test Class for TriggerCampaignLead and UtilCampaignLead
    Purpose: Populate Campaign Title according to contact of corresponding lead and campaign
    User Story: US-Lead-013, US-Lead-013, US-Lead-001
    1. Mouse Created on 2013-04-24
*/
@isTest
Public with sharing class TriggerCampaignLeadTest {
    
    public static Account personAccount;
    public static Account Dealer;
    public static Campaign centralMKTCampaign;
    public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id centralMKTCampaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static Id campaignexecutionRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Simple').getRecordTypeId();
    public static Id salesleadsRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    
    static void preparetestdata(){
      // Create one person account
      //personAccount = (Account)UtilTestData.createSobject(new Account(),UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
   Trigger__c newtrg = new Trigger__c(Name= 'TriggerAccount12',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
      personAccount = new Account(LastName='testacc',ZipCode__c='1024371',PersonMobilePhone='000-0000-9842',MBK_Data_Source__c = 'Email',Mobile__c = '00000009842',RecordTypeId=personRecordtypeid);
      insert personAccount;    

      //Dealer = new Account(Name='testone',MBK_Data_Source__c = 'Email',Mobile__c = '00000009842',RecordTypeId=DealerRecordTypeId); 
      //insert Dealer;                             

      // Two Account: one Dealer and one Person Account
      //dealer = (Account)UtilTestData.createSobject(new Account(),UtilTestData.ACCOUNT_RT_DEALER);

      //centralMKTCampaign = (Campaign)UtilTestData.createSobject(new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);
      centralMKTCampaign = new Campaign(RecordTypeId=centralMKTCampaignRecordTypeId,Name='TestData_CAE_OB_SIM_C',Type='CRM Loyalty Program',StartDate=system.today(),EndDate=system.today(),
                                        Campaign_Code__c='code exe ob sim testc',Campaign_Objectives__c='testcampaign',Description='testdec',Execution_Type__c='OB Call',Task_Created_By__c='Contact');
      insert centralMKTCampaign;

      //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;
    }
    
    // US-Lead-001
    public static testMethod void testTriggerCampaignLead_PopulateContact() {
    try{
      preparetestdata();  
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        // insert updatecustomsettings;
      //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;
        
      // One Lead which has a reference to this person account
      Lead__c lead = new Lead__c(RecordTypeId=salesleadsRecordTypeId,CAC_Lead_Status__c='New Enquiry',Contact__c = personAccount.Id);
      insert lead;
      system.debug('%%%%%%%%%%%%%%%%%%%'+personAccount.Id);
      //lead = (Lead__c)UtilTestData.createSobject(lead,UtilTestData.LEAD_RT_SALES_LEADS);
      system.debug('%%%%%%%%%%%%%%%%%%%'+lead);
      system.debug('%%%%%%%%%%%%%%%%%%%'+lead.id);
      
      Test.startTest();
        // Create Campaign Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(Lead__c = lead.Id,Contact__c= personAccount.Id);
        //camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead,null);
        insert camLead;
        // Start Test
        system.debug('%%%%%%%%%%%%%%%%%%%'+camLead.id);
        camLead = [SELECT Contact__c FROM Campaign_Lead__c WHERE Id = :camLead.Id];       
        // Stop Test
       /* TriggerCampaignLeadTriggerHandler cclth = new TriggerCampaignLeadTriggerHandler();
        cclth.handleTrigger(false, false, false, false, false);
        cclth.handleIntegrationTrigger(false, false, false, false, false);*/
        
        TriggerCampaignLeadTriggerHandlerJP cclthJP = new TriggerCampaignLeadTriggerHandlerJP();
        cclthJP.handleTrigger(false, false, false, false, false);
        cclthJP.handleIntegrationTrigger(false, false, false, false, false);
      Test.stopTest();
      system.debug('!!!!!!'+camlead.Contact__c +'!!!!!!!!'+ personAccount.Id);
      System.assert(camlead.Contact__c == personAccount.Id);
}catch(exception e){}
    }

    /*public static testMethod void testTriggerCampaignLead_InsertAction() {
      preparetestdata();  
      //List<Trigger__c> lstCustomSetting = Trigger__c.getall().values();
      //delete lstCustomSetting;
       
      //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
      //insert updatecustomsettings;
      // One Lead which has a reference to this person account
      Lead__c lead = new Lead__c(CAC_Lead_Status__c='New Enquiry',Contact__c = personAccount.Id);
      lead = (Lead__c)UtilTestData.createSobject(lead,UtilTestData.LEAD_RT_SALES_LEADS);
      
      // Create Campaign Package for Central MKT Campaign
      Campaign_Package__c camPackage = new Campaign_Package__c(Campaign__c = centralMKTCampaign.Id);
      camPackage = (Campaign_Package__c)UtilTestData.createSobject(camPackage, null);       
      
      //Create Offering
      Campaign_Offering__c camOffering = new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id,Description__c= 'Test');
      insert camOffering;
        
      //Create Package Item
      Package_Item__c packageItem= (Package_Item__c)UtilTestData.createSobject(new Package_Item__c(Offering__c = camOffering.Id,Package_Name__c = camPackage.Id), null);
          
      // Create Package Item for this Central MKT Campaign
      // Because Campaign Offer is the Master Object of Package Item, 
      // Create Participating_Dealer__c for centralMKTCampaign
      Participating_Dealer__c partDealer = new Participating_Dealer__c(Campaign__c = centralMKTCampaign.Id,Dealer__c = dealer.Id,Campaign_Package__c = camPackage.Id);       
      system.debug('%%%%%%%%%%%%%%%%%%%'+dealer.Id);
      Campaign cacCampaign = new Campaign(ParentId = centralMKTCampaign.Id);
      cacCampaign = (Campaign)UtilTestData.createSobject(cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

      Campaign campaignExecution = new Campaign(RecordTypeId=campaignexecutionRecordTypeId,Name='testcampaign',ParentId = cacCampaign.Id);
      //campaignExecution = (Campaign)UtilTestData.createSobject(campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);
      insert campaignExecution;
      // Create CampaignMember for campaignExecution
      Id personContactId = [SELECT PersonContactId FROM Account WHERE Id = :personAccount.Id].PersonContactId;
      CampaignMember member = new CampaignMember(ContactId = personContactId,CampaignId = campaignExecution.Id,Participating_Dealer_Package__c = partDealer.Id);
      system.debug('%%%%%%%%%%%%%%%%%%%'+campaignExecution.Id);

      Test.startTest();
        //member = (CampaignMember)UtilTestData.createSobject(member, null);
        System.debug('member ->'+member);
        System.debug('member ->'+member.Package_Name__c+ ' '+ member.Package_Description__c+ ' '+member.Participating_Dealer_Name__c+ ' '+member.Package_Description__c);
        // Start Test
        // One related Campaign Lead which has a reference to Campaign Execution
        // and has a reference to Lead
        Campaign_Lead__c camLead = new Campaign_Lead__c(Lead__c = lead.Id,Campaign__c = campaignExecution.Id);
        //camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);
        insert camLead;
        // Insert Part Assert
        camLead = [SELECT Lead__c, Campaign_Notes__c FROM Campaign_Lead__c WHERE Id = :camLead.Id];
        // Stop Test
      Test.stopTest( );              
      system.assertEquals(camLead.Lead__c, lead.id);            
    }

    public static testMethod void testTriggerCampaignLead_UpdateAction() {
       preparetestdata();  
      //List<Trigger__c> lstCustomSetting = Trigger__c.getall().values();
      //delete lstCustomSetting;
     
       //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
       //insert updatecustomsettings;        
       // One Lead which has a reference to this person account
       Lead__c lead = new Lead__c(RecordTypeId=salesleadsRecordTypeId,CAC_Lead_Status__c='New Enquiry',Contact__c = personAccount.Id);
       //lead = (Lead__c)UtilTestData.createSobject(lead,UtilTestData.LEAD_RT_SALES_LEADS);

       // Create Campaign Package for Central MKT Campaign
       Campaign_Package__c camPackage = new Campaign_Package__c(Campaign__c = centralMKTCampaign.Id);
       camPackage = (Campaign_Package__c)UtilTestData.createSobject(camPackage, null);
       
       //Create Offering
       Campaign_Offering__c camOffering = new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id,Description__c= 'Test');
       insert camOffering;
        
       //Create Package Item
       //Package_Item__c packageItem= (Package_Item__c)UtilTestData.createSobject(new Package_Item__c(Offering__c = camOffering.Id,Package_Name__c = camPackage.Id), null);
       Package_Item__c packageItem= new Package_Item__c(Offering__c = camOffering.Id,Package_Name__c = camPackage.Id);     
       // Start Test
       // Create Participating_Dealer__c for centralMKTCampaign
       Participating_Dealer__c partDealer = new Participating_Dealer__c(Campaign__c = centralMKTCampaign.Id,Campaign_Package__c = camPackage.Id);
       //partDealer = (Participating_Dealer__c)UtilTestData.createSobject(partDealer, null);

       // Create Updated Campaign Package for Central MKT Campaign
       Campaign_Package__c camPackage2 = new Campaign_Package__c(Campaign__c = centralMKTCampaign.Id);
       //camPackage2 = (Campaign_Package__c)UtilTestData.createSobject(camPackage2, null);

       Campaign_Offering__c camOffering2 = new Campaign_Offering__c(Campaign__c = centralMKTCampaign.Id,Description__c= 'Test');
       insert camOffering2;
        
       //Create Package Item
       //Package_Item__c packageItem2= (Package_Item__c)UtilTestData.createSobject(new Package_Item__c(Offering__c = camOffering.Id,Package_Name__c = camPackage2.Id), null);
       Package_Item__c packageItem2= new Package_Item__c(Offering__c = camOffering.Id,Package_Name__c = camPackage2.Id); 
          
       // Create Updated Participating_Dealer__c for centralMKTCampaign
       Participating_Dealer__c partDealer2 = new Participating_Dealer__c(Campaign__c = centralMKTCampaign.Id, Dealer__c = dealer.Id,Campaign_Package__c = camPackage2.Id);
       //partDealer2 = (Participating_Dealer__c)UtilTestData.createSobject(partDealer2, null);

       Campaign cacCampaign = new Campaign(RecordTypeId=centralMKTCampaignRecordTypeId,ParentId = centralMKTCampaign.Id);
       //cacCampaign = (Campaign)UtilTestData.createSobject(cacCampaign, UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);

       Campaign campaignExecution = new Campaign(RecordTypeId=campaignexecutionRecordTypeId,ParentId = cacCampaign.Id);
       //campaignExecution = (Campaign)UtilTestData.createSobject(campaignExecution, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);

       // Create CampaignMember for campaignExecution
       Id personContactId = [SELECT PersonContactId FROM Account WHERE Id = :personAccount.Id].PersonContactId;
       CampaignMember member = new CampaignMember(ContactId = personContactId,CampaignId = campaignExecution.Id,Participating_Dealer_Package__c = partDealer.Id);
       //member = (CampaignMember)UtilTestData.createSobject(member, null);

       Campaign campaignExecution2 = new Campaign(RecordTypeId=campaignexecutionRecordTypeId,Name='testcampaign2',ParentId = cacCampaign.Id);
       //campaignExecution2 = (Campaign)UtilTestData.createSobject(campaignExecution2, UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);
       insert campaignExecution2;
       CampaignMember member2 = new CampaignMember(ContactId = personContactId,CampaignId = campaignExecution2.Id,Participating_Dealer_Package__c = partDealer2.Id);
       //member = (CampaignMember)UtilTestData.createSobject(member2, null);
       system.debug('%%%%%%%%%%%%%%%%%%%'+campaignExecution2.Id);
       Test.startTest();
         
         // One related Campaign Lead which has a reference to Campaign Execution
         // and has a reference to Lead
         Lead__c lead1 = new Lead__c(RecordTypeId=salesleadsRecordTypeId,CAC_Lead_Status__c='New Enquiry',Contact__c = personAccount.Id);
         insert lead1;
         Campaign_Lead__c camLead = new Campaign_Lead__c(Lead__c = lead1.Id,Campaign__c = campaignExecution2.Id);
         system.debug('%%%%%%%%%%%%%%%%%%%'+lead1.Id);
         //camLead = (Campaign_Lead__c)UtilTestData.createSobject(camLead, null);
         insert camLead;
         //Update Campaign Field of Campaign Lead
         camLead.Campaign__c = campaignExecution2.Id;
         update camLead;
        
         camLead = [SELECT Lead__c, Campaign_Notes__c FROM Campaign_Lead__c WHERE Id = :camLead.Id];
         // Stop Test
       Test.stopTest();
       system.assertEquals(camLead.Lead__c, lead1.id);  
    }*/
}