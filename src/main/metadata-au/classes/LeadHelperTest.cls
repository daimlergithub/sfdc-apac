/*
    Type:       Test Class for LeadHelper
    Purpose:    Create a custom sharing to share the lead record with 
    Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
    User Story: US-QC-022, US-QC-023, US-DP-022, US-DP-023, US-IB-001
    1. Sinow Created on 2013-04-25
    2. Justin
*/


@isTest
public with sharing class LeadHelperTest {
    private static Account customer;
    private static Account dealer;
    private static Account account;
    private static Account personaccount1;
    private static Lead__c lead;
    
    private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
    private static final String leadVehicleRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId(); 
    private static String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     private static final String leadSPRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Service/Parts Lead').getRecordTypeId();
    private static TestDataUtil testData = TestDataUtil.getInstance();
    private static string localeSideKeyValue = 'en_US';
    //add in 11/27
    private static string BusinessUnitValue = 'Alliance';
    private static string EOCRecipientTypeValue = '60 days primary';
    private static string LeadEscalationRecipientTypeValue ='Immediate Notice';
     private static string SubBusinessUnitValue = 'Finance';
    private static string SubBusinessUnitValue1 = 'Finance & Insurance';
    private static string LeadTypeValue1 = 'New Car';
     private static string FinanceLeadType = 'Key 2 Key';
     private static string CACLeadStatusValue1='New Enquiry';
    private static string LeadSourceValue = 'Campaign';
    private static User user;
    private static Vehicle__c vehicles;
    private static void createUser(Profile profile){        
        
         user = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao7',
                                  Email = 'sichao7.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = localeSideKeyValue,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = localeSideKeyValue);
        insert user;
        
        
    }
    private static void createDealer(){
         
         dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58396243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today(),Business_Unit__c=BusinessUnitValue);
            insert dealer;
         vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
        insert vehicles;
        
    }    
   
  

    @istest(seealldata = false)
    public static void LeadHelperTest2() {
       
      
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Service/Parts Lead').getRecordTypeId();
       
        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
         createUser(profile);
        
      

        system.runAs( user ) {
            createDealer();
            
            Account dealer2 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58399243', Name = 'dealer2');
            insert dealer2;
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58396243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao8');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City__c = 'Anqing city';
            a1.Preferred_Language__c = 'English';
            //a1.Lead_Escalation_Recipient_Type__c='Immediate Notice';
            //a1.Dealer_Lead_Gate_Keeper__c=false;
            insert a1;
             
            
            Account a2 = new Account(Allow_Data_Sharing__c = 'No', Phone = '56392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao9');
            a2.Gender__c = 'Male';
            a2.Province__c = 'Shanghai';
            a2.City__c = 'Anqing city';
            a2.Preferred_Language__c = 'English';
            a2.Dealer_Lead_System__c = 'Salesforce';
            a2.Allow_Data_Sharing__c = 'Yes';
            
            insert a2;
            Contact contact1 = new Contact ( AccountId = dealer.id,
                                         FirstName = 'lai',
                                         LastName = 'sichao11',
                                         Email = 'sichao11.lai@nttdata.com',
                                         EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                         Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue,Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
            insert contact1;
           Test.startTest();
            Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Assigned_Dealer__c = dealer.id;
            le1.Contact__c = a1.id;
            le1.RecordTypeId = afterSalesRecordTypeId;
            le1.CAC_Lead_Status__c = 'Qualified';
            insert le1;
            List<Lead__c> le2 = new List<Lead__c>();
            le2.add(getLead1(user));
            
            le2[0].Contact__c = a1.id;
            le2[0].Lead_Type__c = LeadTypeValue1;
            le2[0].Relation_With_The_Leads__c = 'I owner';
            le2[0].CAC_Lead_Status__c = 'Assigned';
            le2[0].Purchase_Time__c = '0 - 3 months';
            le2[0].Interested_Vehicle_Brand__c = 'MB';
            le2[0].Lead_Desired_Service__c = 'Test Drive';
            update le2[0];
            
            Test.stopTest();
            //verify
            //
             lead = [select CAC_Lead_Status__c,Assigned_Dealer__c from Lead__c where id =:le1.id ];
            system.assertEquals(lead.CAC_Lead_Status__c, le1.CAC_Lead_Status__c);
            system.assert(lead.Assigned_Dealer__c == le1.Assigned_Dealer__c );
        }
    }

    @istest(seealldata = false)
    public static void LeadHelperTest3() {
        
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        createUser(profile);       
       
           system.runAs( user) {
          
            
            getLead(user);
                 createDealer();
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                         Inactive__c=false,
                                         Business_Unit__c=BusinessUnitValue,
                                         Sub_BusinessUnit__c=SubBusinessUnitValue,
                                         FirstName = 'lai3',
                                         LastName = 'sichao3',
                                         Email = 'sichao3.lai@nttdata.com',
                                         EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                         Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue,Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
                   insert contact1;
                Test.startTest();             
                 
         lead = new Lead__c();
        
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadVehicleRt;
        lead.Lead_Type__c = LeadTypeValue1;
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c='Brochure Request';
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c='Parts';
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
        insert lead;
       
         lead.X24H_Untouched__c=true;
         lead.X72H_Untouched__c=true;
         lead.Is_Finance_Send_Email_Before_20_Days__c=true;
         update lead;
               
               lead.Assigned_Dealer__c=dealer.id;
               lead.Business_Unit__c=BusinessUnitValue;
               lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;
               update lead;
               map<id,id> NewCaseLeadIds = new  map<id,id>();
               NewCaseLeadIds.put(lead.id, lead.id);
               
               LeadHelper.UpdateCasesWithLeadId(NewCaseLeadIds);
               LeadHelper.insertLeadSharing(NewCaseLeadIds,NewCaseLeadIds);
                  Test.stopTest();
               
               Lead__c leadList = [select Assigned_Dealer__c,Business_Unit__c from Lead__c where id =:lead.id ];
               system.assertEquals(leadList.Assigned_Dealer__c, lead.Assigned_Dealer__c);
               system.assertEquals(leadList.Business_Unit__c, lead.Business_Unit__c);
               
           }
        
        
    }
     @istest(seealldata = false)
    public static void LeadHelperTest5() {
        
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        createUser(profile);

       
       
           system.runAs( user) {
          
            
            getLead(user);
                createDealer();
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                               Inactive__c=false,
                                               Business_Unit__c=BusinessUnitValue,
                                               Sub_BusinessUnit__c=SubBusinessUnitValue1,
                                               FirstName = 'lai1',
                                               LastName = 'sichao2',
                                               Email = 'sichao2.lai@nttdata.com',
                                               EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                               Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
                               insert contact1;
              Test.startTest();
             
               
               Vehicle__c vehicles1 = new Vehicle__c(EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222');
        insert vehicles1;
        
          lead = new Lead__c();
        lead.Current_Vehicle__c=vehicles1.id;
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadSPRt;
        lead.Lead_Type__c = LeadTypeValue1;
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c=FinanceLeadType;
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
        insert lead;
        
        
              
               
               lead.Assigned_Dealer__c=dealer.id;
               lead.Business_Unit__c=BusinessUnitValue;
               lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;
               lead.X24H_Untouched__c=true;
               lead.X72H_Untouched__c=true;
               lead.Is_Finance_Send_Email_Before_60_Days__c=true;
               update lead;
               
               string accountId=string.valueOf(dealer.id);
               string leadId =String.valueOf(lead.id);
               string userId =String.valueOf(user.id);
               string tempTitle='teststring';
               
               set<string> oldDealerIds =new set<string>();
               oldDealerIds.add(accountId);
               set<string> leadIds =new set<string>();
               leadIds.add(leadId);
               LeadHelper.getEPIntegrationUser();
               LeadHelper.newLeadShare(leadId,userId);
               LeadHelper.newAccountShare(accountId,userId);
               LeadHelper.createdNewSMSTaskForInstructor(lead,user,user,dealer,dealer);
               LeadHelper.createdNewSMSTaskForCustomer(lead,user,dealer,dealer,tempTitle);
               LeadHelper.shareToAssignedDealer(oldDealerIds,leadIds);
               Test.stopTest();         
               Lead__c leadList = [select Assigned_Dealer__c,Business_Unit__c from Lead__c where id =:lead.id ];
               system.assertEquals(leadList.Assigned_Dealer__c, lead.Assigned_Dealer__c);
               system.assertEquals(leadList.Business_Unit__c, lead.Business_Unit__c);
               
           }
    }
    @istest(seealldata = false)
    public static void LeadHelperTest7() {
        
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        createUser(profile);

       
       
           system.runAs( user) {
          
            
            getLead(user);
                createDealer();
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                               Inactive__c=false,
                                               Business_Unit__c=BusinessUnitValue,
                                               Sub_BusinessUnit__c=SubBusinessUnitValue,
                                               FirstName = 'lai1',
                                               LastName = 'sichao2',
                                               Email = 'sichao2.lai@nttdata.com',
                                               EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                               Lead_Escalation_Recipient_Type__c='CC Lead Escalation Recipient',Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
                               insert contact1;
              Test.startTest();  
              Lead__c lead1=createLead(user);
               lead1.Assigned_Dealer__c=dealer.id;
               lead1.Business_Unit__c=BusinessUnitValue;
               lead1.Sub_BusinessUnit__c=SubBusinessUnitValue1;
               lead.X24H_Untouched__c=true;
               lead.X72H_Untouched__c=true;
               lead.Is_Finance_Send_Email_Before_60_Days__c=true;
               update lead1;
               
               string accountId=string.valueOf(dealer.id);
               string leadId =String.valueOf(lead1.id);
               string userId =String.valueOf(user.id);
               string tempTitle='teststring';
               
               set<string> oldDealerIds =new set<string>();
               oldDealerIds.add(accountId);
               set<string> leadIds =new set<string>();
               leadIds.add(leadId);
               LeadHelper.getEPIntegrationUser();
               LeadHelper.newLeadShare(leadId,userId);
               LeadHelper.newAccountShare(accountId,userId);
               LeadHelper.createdNewSMSTaskForInstructor(lead,user,user,dealer,dealer);
               LeadHelper.createdNewSMSTaskForCustomer(lead,user,dealer,dealer,tempTitle);
               LeadHelper.shareToAssignedDealer(oldDealerIds,leadIds);
                 Test.stopTest();                
               Lead__c leadList = [select Assigned_Dealer__c,Business_Unit__c from Lead__c where id =:lead1.id ];
               system.assertEquals(leadList.Assigned_Dealer__c, lead1.Assigned_Dealer__c);
               system.assertEquals(leadList.Business_Unit__c, lead1.Business_Unit__c);
               
           }
    }
      @istest(seealldata = false)
    public static void LeadHelperTest4() {
       
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        createUser(profile);

       
       
           system.runAs( user) {
          
            
            getLead(user);
                createDealer();
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                         Inactive__c=false,
                                         Business_Unit__c=BusinessUnitValue,
                                         Sub_BusinessUnit__c=SubBusinessUnitValue,
                                         Finance_Lead_Type__c=FinanceLeadType,
                                         FirstName = 'lai5',
                                         LastName = 'sichao1',
                                         Email = 'sichao1.lai@nttdata.com',
                                         EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                         Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue,Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
            insert contact1;
               Lead__c lead1=createLead(user);
               update lead1;
               
           Map<id,Lead__c> oldMap = new  Map<id,Lead__c>();
               oldMap.put(lead1.id, lead1);
           list<Lead__c> listLead = new list<Lead__c>();  
               listLead.add(lead1);
           set<id> dealerId = new set<id>();
             dealerId.add(dealer.id); 
                Test.startTest();
               LeadHelper.UpdateLeadOwnerFromContact(dealerId,listLead);
               LeadHelper.UpdateLeadOwner(dealerId,listLead);
               LeadHelper.ShareToGateKeeper(dealerId,listLead);
               LeadHelper.beforeInsert_UpdateEvents(listLead,oldMap,false,true);
               LeadHelper.afterInsert_UpdateEvents(listLead,oldMap,false,true);
               LeadHelper.afterInsert_UpdateEvents(listLead,oldMap,true,false);
               LeadHelper.ShareLeadsToCampaignUser(listLead,oldMap,oldMap,false,true);
               LeadHelper.ShareLeadsToCampaignUser(listLead,oldMap,oldMap,true,false);
               Test.stopTest();
               Lead__c leadList = [select Nature_of_Request__c,Business_Unit__c from Lead__c where id =:lead1.id ];
               system.assertEquals(leadList.Nature_of_Request__c, lead1.Nature_of_Request__c);
               system.assertEquals(leadList.Business_Unit__c, lead1.Business_Unit__c);
           }
    }
     @istest(seealldata = false)
    public static void LeadHelperTest6() {
       
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        createUser(profile);

       
       
           system.runAs( user) {
          
            
            getLead(user);
                createDealer();
                 
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                         Inactive__c=false,
                                         Business_Unit__c=BusinessUnitValue,
                                         Sub_BusinessUnit__c=SubBusinessUnitValue,
                                         Finance_Lead_Type__c=FinanceLeadType,
                                         FirstName = 'lai5',
                                         LastName = 'sichao1',
                                         Email = 'sichao1.lai@nttdata.com',
                                         EOC_Recipient_Type__c = EOCRecipientTypeValue,
                                         Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue,Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
            insert contact1;
                Test.startTest();
               Lead__c lead1=createLead(user);
                lead1.Current_Vehicle__c=vehicles.id;
               update lead1;              
          
               Test.stopTest();
               Lead__c leadList = [select Nature_of_Request__c,Business_Unit__c from Lead__c where id =:lead1.id ];
               system.assertEquals(leadList.Nature_of_Request__c, lead1.Nature_of_Request__c);
               system.assertEquals(leadList.Business_Unit__c, lead1.Business_Unit__c);
           }
    }
     
      @istest(seealldata = false)
    public static void emailNotificationsToAssignedDealerTest() {
        Trigger__c TriggerCampaignLead=new Trigger__c(Name='TriggerCampaignLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
        upsert TriggerCampaignLead;
        
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'account name';
        acc.Phone = '10786';
        acc.Area_Code__c = '010';
        acc.Fax = '10086';
        acc.BillingCity = 'San Francisco';
        acc.BillingCountry = 'USA';
        acc.BillingPostalCode = '94105';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert acc;
		Account account1 = new Account();
        account1.Name = 'account name1';
        account1.Phone = '10786';
        account1.Area_Code__c = '010';
        account1.Fax = '10086';
        account1.BillingCity = 'San Francisco';
        account1.BillingCountry = 'USA';
        account1.BillingPostalCode = '94105';
        account1.BillingState = 'CA';
        account1.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account1;
		
		Lead__c lead1 = new Lead__c();
        lead1.recordTypeId = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Finance Lead').getRecordTypeId();
      //  lead1.CAC_Lead_Status__c = 'Qualified';
         lead1.Company_Account__c=acc.Id;
         lead1.Assigned_Dealer__c = acc.Id;
         lead1.Lead_Source__c = 'Web Form';
         lead1.Nature_of_Request__c='General Enquiry';
         lead1.Business_Unit__c= 'Vans';
         lead1.Sub_BusinessUnit__c='Auto Body Repairer';
         lead1.CAC_Lead_Status__c = 'Credit Review in Process';
         insert lead1;
		 lead1.Assigned_Dealer__c=account1.id;
		 update lead1;
        // LeadHelper.emailNotificationsToAssignedDealer(listNewLeads, leadNewMap, leadOldMap, isInsert, isUpdate)
        Lead__c lead3 = new Lead__c();
        lead3.recordTypeId = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Fleet Vans').getRecordTypeId();
        lead3.Company_Account__c=acc.Id;
        lead3.Assigned_Dealer__c = acc.Id;
        lead3.Lead_Source__c = 'Web Form';
        lead3.Nature_of_Request__c='General Enquiry';
        lead3.Business_Unit__c= 'Vans';
        lead3.Sub_BusinessUnit__c='Auto Body Repairer';
        lead3.CAC_Lead_Status__c = 'Credit Review in Process';
        insert lead3;
        Test.stopTest();
        Lead__c lead2 = [select Assigned_Dealer__c,Business_Unit__c from Lead__c where id =:lead1.id ];
         System.assertEquals(lead1.Assigned_Dealer__c, lead2.Assigned_Dealer__c);
		 
    }
    public static testmethod void leadPriorityScoreTest()
    {
        Trigger__c TriggerCampaignLead=new Trigger__c(Name='TriggerCampaignLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
        upsert TriggerCampaignLead;
        
        test.startTest();
        account = new Account();
        account.Name = 'account name';
        account.Phone = '10096';
        account.Area_Code__c = '010';
        account.Dealer_Allocation__c='MBAuP';
        account.Activation_Date__c=system.today();
        account.Fax = '10076';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
        
        Account acc = new Account();
        acc.Salutation = 'Lord';
        acc.FirstName = 'Jon' ;
        acc.LastName = 'Snow' ;
        acc.Gender__c = '0=Male';
        acc.ZipCode__c = '200235';
        acc.Type = '0=Company';
        acc.Phone = '12332111'; 
        acc.Status__c = '0=Customer';
        acc.RecordTypeId = PersonRecordtypeid;
        acc.Area_Code__c = '010';
        acc.PC_Status__c = 'Customer';
        acc.VAN_Status__c = 'Prospect';
        acc.CV_Status__c = 'Prospect';
        insert acc;
                                
        Vehicle__c vehicles1 = new Vehicle__c();
        vehicles1.EuroVIN__c = '12345678901111111';
        vehicles1.UsVIN__c = '12345678902222222';
        vehicles1.Class__c = 'G-Class';
        vehicles1.Vehicle_Group__c = 'PC';
        insert vehicles1;
                
        Vehicle_Relationship__c vrel = new Vehicle_Relationship__c();
        vrel.Vehicle_ID__c = vehicles1.Id;
        vrel.Car_Relation__c = 'Owner';
        vrel.Contact__c = acc.Id;
        insert vrel;
        
        Retail_Task__c rtask = new Retail_Task__c();
        rtask.RecordTypeId = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId(); 
        rtask.Related_Dealer__c = account.Id; 
        rtask.Related_Vehicle__c = vehicles1.Id;
        rtask.Account__c = acc.id;
        insert rtask;
        
        lead = new Lead__c();
        lead.Contact__c = acc.Id;
        lead.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c='Test Drive Request';
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c='Parts';
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
		lead.MB_Vehicle_Interest__c = 'G-Class';
		lead.Purchase_Time__c = '24 Hours';
		lead.Assigned_Dealer__c = account.Id;
        lead.MD__c = 'AU';
        insert lead;
                        
         test.stopTest();
        Lead__c lead2 = [select contact__c, contact__r.PC_status__c,Business_Unit__c,Nature_of_Request__c from Lead__c where id =:lead.id ];
        //System.assertEquals(lead2.contact__r.PC_status__c, 'Customer');
        system.assertEquals(lead2.Nature_of_Request__c, 'Test Drive Request');
       
        
    }
         
     static void getLead(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
         account = new Account();
         account.Name = 'account name';
         account.Phone = '10096';
         account.Area_Code__c = '010';
         account.Dealer_Allocation__c='MBAuP';
         account.Activation_Date__c=system.today();
         account.Fax = '10076';
         account.BillingCity = 'San Francisco';
         account.BillingCountry = 'USA';
         account.BillingPostalCode = '94105';
         account.BillingState = 'CA';
         account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
         account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         insert account;
        
            personaccount1 = testData.standardPersonAccount;
        insert personaccount1;
         
        
      
    }
    static Lead__c createLead(User usr){
        
         Vehicle__c vehicles1 = new Vehicle__c(EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222');
        insert vehicles1;
        
        lead = new Lead__c();
        lead.Current_Vehicle__c=vehicles1.id;
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadFinanceRT;
        lead.Lead_Type__c = LeadTypeValue1;
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c=FinanceLeadType;
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
        insert lead;
         //lead.CAC_Lead_Status__c = 'Qualified';
        
        
        return lead;
        
    }  
 
    static Lead__c getLead1(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        account = new Account();
        account.Name = 'account name';
        account.Phone = '10786';
        account.Area_Code__c = '010';
        account.Fax = '10086';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
        
        customer = new Account();
        customer.Allow_Data_Sharing__c = 'Yes'; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = 'English';
        customer.Dealer_Lead_System__c = 'Salesforce';
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '200235';
        customer.Type = '0=Company';
        customer.Phone = '12332111'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId = PersonRecordtypeid;
        customer.Dealer_Lead_Gate_Keeper__c = usr.id;
        customer.Area_Code__c = '010';
        customer.PC_Status__c = 'Prospect';
        customer.VAN_Status__c = 'Prospect';
        customer.CV_Status__c = 'Prospect';
        insert customer;
        
        Account acc1 = new Account();
        acc1.Salutation = 'Lord';
        acc1.FirstName = 'Jon' ;
        acc1.LastName = 'Snow' ;
        acc1.Gender__c = '0=Male';
        acc1.ZipCode__c = '200235';
        acc1.Type = '0=Company';
        acc1.Phone = '12332111'; 
        acc1.Status__c = '0=Customer';
        acc1.RecordTypeId = PersonRecordtypeid;
        acc1.Area_Code__c = '010';
        acc1.PC_Status__c = 'Prospect';
        acc1.VAN_Status__c = 'Prospect';
        acc1.CV_Status__c = 'Prospect';
        insert acc1;
        
        Lead__c lead1 = new Lead__c();
        lead1.Contact__c = acc1.Id;
        lead1.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        lead1.Lead_Source__c = LeadSourceValue;
        lead1.Nature_of_Request__c='Test Drive Request';
        lead1.Business_Unit__c= BusinessUnitValue;
        lead1.Sub_BusinessUnit__c='Parts';
        lead1.CAC_Lead_Status__c = CACLeadStatusValue1;
		lead1.MB_Vehicle_Interest__c = 'G-Class';
		lead1.Purchase_Time__c = '24 Hours';
		lead1.Assigned_Dealer__c = account.Id;
        lead1.MD__c = 'AU';
        insert lead1;
        
        lead = new Lead__c();
        lead.Contact__c = customer.Id;
        lead.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        lead.CAC_Lead_Status__c = 'Qualified';
       
         lead.Assigned_Dealer__c = account.Id;
         lead.Lead_Source__c = LeadSourceValue;
         lead.Nature_of_Request__c='Brochure Request';
         lead.Business_Unit__c= BusinessUnitValue;
         lead.Sub_BusinessUnit__c='Parts';
         lead.CAC_Lead_Status__c = CACLeadStatusValue1;

        insert lead;
        return lead;
          
    }    
}