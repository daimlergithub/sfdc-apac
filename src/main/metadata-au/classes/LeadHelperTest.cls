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
    private static final String leadSPRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Service Lead').getRecordTypeId();
    private static final String ContractRTid = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
    private static final String ServiceRTid = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    private static final String InsuranceRTid = Schema.sObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Insurance').getRecordTypeId();
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String VehRTid = Schema.sObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    private static final String VehrelRTid = Schema.sObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    private static TestDataUtil testData = TestDataUtil.getInstance();
    private static string localeSideKeyValue = 'en_US';
    //add in 11/27
    private static string BusinessUnitValue = 'Alliance';
    private static string EOCRecipientTypeValue = '60 days primary';
    private static string LeadEscalationRecipientTypeValue ='Immediate Notice';
    private static string LeadEscalationRecipientTypeValue1 ='CC Lead Escalation Recipient';
     private static string SubBusinessUnitValue = 'Finance';
    private static string SubBusinessUnitValue1 = 'Finance & Insurance';
    private static string LeadTypeValue1 = 'New Car';
     private static string FinanceLeadType = 'Key 2 Key';
     private static string CACLeadStatusValue1='New Enquiry';
    private static string LeadSourceValue = 'Campaign';
    
    private static User user;
     private static User user1;
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
       
      
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Service Lead').getRecordTypeId();
       
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

   /* @istest(seealldata = false)
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
		lead.Purchase_Time__c = 'Not sure';
        lead.MB_Vehicle_Interest__c ='Actros';
		lead.Assigned_Dealer__c=dealer.id;
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
        
        
    }  */
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
    public static void LeadHelperTestAssign() {
        
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
        lead.Purchase_Time__c = 'Not sure';
        lead.MB_Vehicle_Interest__c ='Actros';
        lead.X72H_Untouched__c=false;
        lead.Assigned_Dealer__c=dealer.id;
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

@istest(seealldata = false)
    public static void LeadHelperTest9(){
	
   Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MBFS Cars';
   deal.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal;
	
   Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   
   insert Cus;
	
	EmailTemplate temp=[select id,developername from EmailTemplate where developername = 'Finance_Leads_Only'];    
    
    Contact con=new Contact();
	con.Salutation='DRM MBFS';
	con.FirstName = 'lai';
    con.LastName = 'sichao11';
	con.AccountId = deal.id;
    con.Email = 'sichao11.lai@nttdata.com';
    con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
	con.Dealer_Lead_Gate_Keeper__c=false;
	con.Finance_Lead_Type__c ='Agility';
    con.Business_Unit__c = 'MBFS Cars';	
	con.Sub_BusinessUnit__c = 'Finance';
	con.Inactive__c = false ;
	
	insert con; 
        
    con.Lead_Escalation_Recipient_Type__c='24H Untouched Notice';
	update con;   
      
    Test.startTest();      
  
    Lead__c Flead = new Lead__c();
	Flead.RecordTypeId = leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Assigned_Dealer__c = deal.id;
	Flead.X24H_Untouched__c = false;
	Flead.X72H_Untouched__c = false;
	
    insert Flead;
   
	Flead.X24H_Untouched__c = true;
	Flead.X72H_Untouched__c = false;
	
    update Flead;    
         
    Test.stopTest();
	
     
	}
 @istest(seealldata = false)
public static void LeadHelperTest8(){
	
   Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MBFS Cars';
   deal.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal;
    
    
   Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   Cus.Email__c='abc@nttdata.com';
   
   insert Cus;

   Contact con=new Contact();
    con.Salutation='DRM MBFS';
    con.FirstName = 'lai';
    con.LastName = 'sichao11';
    con.AccountId = deal.id;
    con.Email = 'sichao11.lai@nttdata.com';
    con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
    con.Dealer_Lead_Gate_Keeper__c=false;
    con.Finance_Lead_Type__c ='Agility';
    con.Business_Unit__c = 'MBFS Cars';	
    con.Sub_BusinessUnit__c = 'Finance';
    con.Inactive__c = false ;
	
	insert con;
    
    Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Assigned_Dealer__c = deal.id;
	Flead.X24H_Untouched__c = false;
	Flead.X72H_Untouched__c = false;
	
    insert Flead;
   
    
    List<Lead__c> leads=new List<Lead__c>();
    leads.add(Flead);
    List<String> con1= new List<String>();
      con1.add(con.id);
    Map<String,List<String>> mailinfos = new Map<String,List<String>>();
        mailinfos.put('abc@nttdata.com',con1);	
    Map<id,Map<String,List<String>>> initialEmail = new Map<id,Map<String,List<String>>>();
          initialEmail.put(Flead.id,mailinfos);

   Test.startTest();      

    LeadHelper.initialEmail(leads);
	
   Test.stopTest();     	   
}

    @istest(seealldata = false)
public static void LeadHelperTest10(){
	
   Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MBFS Cars';
   deal.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal;
    
    
   Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   Cus.Email__c='abc@nttdata.com';
   
   insert Cus;

   Contact con=new Contact();
    con.Salutation='DRM MBFS';
    con.FirstName = 'lai';
    con.LastName = 'sichao11';
    con.AccountId = deal.id;
    con.Email = 'sichao11.lai@nttdata.com';
    con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
    con.Dealer_Lead_Gate_Keeper__c=false;
    con.Finance_Lead_Type__c ='Agility';
    con.Business_Unit__c = 'MBFS Cars';	
    con.Sub_BusinessUnit__c = 'Finance';
    con.Inactive__c = false ;
	
	insert con;
    
    Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Assigned_Dealer__c = deal.id;
	Flead.X24H_Untouched__c = false;
	Flead.X72H_Untouched__c = false;
	Flead.Is_Finance_Send_Email_Before_60_Days__c = true;
    Flead.Is_Finance_Send_Email_Before_20_Days__c = true;
    Flead.Is_Finance_Send_Email_Before_15_Days__c = true;
    Flead.Is_Fleet_Send_Email_Before_45_Days__c = true; 
    Flead.Is_Finance_Send_Email_Before_150_Days__c = true;
    insert Flead;
   
    
    
    List<String> con1= new List<String>();
      con1.add(con.id);
    Map<id,Account> ContactMap=new Map<id,Account>();
	    ContactMap.put(deal.id,deal);
	Map<String,List<String>> mailinfos = new Map<String,List<String>>();
        mailinfos.put('abc@nttdata.com',con1);	
    Map<id,Map<String,List<String>>> initialEmail = new Map<id,Map<String,List<String>>>();
          initialEmail.put(Flead.id,mailinfos);

   Test.startTest();      

    LeadHelper.getMailAddress(Flead,ContactMap);
	
   Test.stopTest();     	   
 }  
  
  @istest(seealldata = false)
public static void LeadHelperTest11()
{   
   Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MBFS Cars';
   deal.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal;
   
   Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   Cus.Email__c='abc@nttdata.com';
   
   insert Cus;
     
    Retail_Task__c Contr=new Retail_Task__c();
   Contr.RecordTypeId =ContractRTid;
   Contr.Name = '1234';
   Contr.Related_Dealer__c = Deal.id;
   
	insert Contr;
	
	Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Existing_Contract__c = Contr.id;
    
	insert Flead;
     
	 List<Lead__c> newLeads = new List<Lead__c>();
	 newLeads.add(Flead);
     Map<Id,Id> ldContrctMap = new Map<Id,Id>();
	 ldContrctMap.put(newLeads[0].id,newLeads[0].Existing_Contract__c);
	 
	 Test.startTest();
	 
	 LeadHelper.autoFillAssignedDealer(newLeads);
	 
	 Test.stopTest();
	 
	 }  
    
    @istest(seealldata = false)
public static void LeadHelperTest12()
{
   Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MB Trucks';
      
	
   insert deal;
   
   Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   
   insert Cus;
   
   EmailTemplate VehicleTemplate = [select id ,developername from EmailTemplate where developername = 'EMC_Qualified_Vehicle_Lead'];
   
   Contact con=new Contact();
	con.Salutation='DRM MBFS';
	con.FirstName = 'lai';
    con.LastName = 'sichao11';
	con.AccountId = deal.id;
    con.Email = 'sichao11.lai@nttdata.com';
    con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue1; 
	con.Dealer_Lead_Gate_Keeper__c=false;
    con.Business_Unit__c = 'MB Trucks';	
	con.Sub_BusinessUnit__c = 'Service';
	con.Inactive__c = false ;
	
	insert con;
	
	Contact con1=new Contact();
	con1.Salutation='DRM MBFS';
	con1.FirstName = 'lai';
    con1.LastName = 'sichao12';
	con1.AccountId = deal.id;
    con1.Email = 'sichao12.lai@nttdata.com';
    con1.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con1.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
	con1.Dealer_Lead_Gate_Keeper__c=false;
    con1.Business_Unit__c = 'MB Trucks';	
	con1.Sub_BusinessUnit__c = 'Service';
	con1.Inactive__c = false ;
	
	insert con1;

	
	Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadSPRt ;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'Walk-In';
	Flead.Nature_of_Request__c = 'Service Booking';
	Flead.Business_Unit__c = 'MB Trucks';
	Flead.Sub_BusinessUnit__c = 'Service';
	Flead.CAC_Lead_Status__c = 'Qualified';
	Flead.Assigned_Dealer__c = deal.id;
	Flead.X24H_Untouched__c = false;
	Flead.X72H_Untouched__c = false;
	Flead.Preferred_Date__c = system.today();
	Flead.Preferred_Drop_off_Time__c = '6:00 pm';
	Flead.Preferred_Pickup_Time__c = '9:00 am';
	Flead.MB_Vehicle_Interest__c = 'A-Class';
	Flead.Vehicle_Registration_No__c = '1111';
	
    insert Flead;
	
	
	
	List<Lead__c> leadsForSend = new List<Lead__c>();
	    leadsForSend.add(Flead);
	set<id> DealerIds = new Set<id>();
		DealerIds.add(deal.id);
	String EmailType = 'Immediate Notice';
	List<String> CCemails = new List<String>();
	    CCemails.add(con.id);
	Map<Lead__c,List<String>> leadContactCCEmails = new Map<Lead__c,List<String>>();	
	     leadContactCCEmails.put(Flead,CCemails);
    List<String> TOemails = new List<String>();
	     Toemails.add(con1.id);
	Map<Lead__c,List<String>> leadContactTOEmails = new Map<Lead__c,List<String>>();
          leadContactTOEmails.put(Flead,TOEmails);	
	
	Test.startTest();
	
	LeadHelper.sendServicePartsEmail (leadsForSend,DealerIds,EmailType);
	
	Test.stopTest();
	
	} 
    
 @istest(seealldata = false)
public static void LeadHelperTest13()
{
    Profile profile = [select Id from Profile where Name = 'System Administrator'];
         createUser1(profile);
        
      

        system.runAs( user1 )
    

{

 Account fdeal = new Account(); // for Finance Lead //
   fdeal.RecordTypeId = dealerRecordtypeid;
   fdeal.Name = 'testdealer1';
   fdeal.Phone = '58396247'; 
   fdeal.Active__c='yes';
   fdeal.Dealer_Allocation__c='MBAuP';
   fdeal.Activation_Date__c=system.today();
   fdeal.Business_Unit__c='MBFS Cars';
      	
   insert fdeal;

    Account sdeal = new Account(); // for service Lead //
   sdeal.RecordTypeId = dealerRecordtypeid;
   sdeal.Name = 'testdealer3';
   sdeal.Phone = '58396248'; 
   sdeal.Active__c='yes';
   sdeal.Dealer_Allocation__c='MBAuP';
   sdeal.Activation_Date__c=system.today();
   sdeal.Business_Unit__c='MB Trucks';
      	
   insert sdeal;
     
   Account vdeal = new Account(); // for vehicle Lead //
   vdeal.RecordTypeId = dealerRecordtypeid;
   vdeal.Name = 'testdealer5';
   vdeal.Phone = '58396248'; 
   vdeal.Active__c='yes';
   vdeal.Dealer_Allocation__c='MBAuP';
   vdeal.Activation_Date__c=system.today();
   vdeal.Business_Unit__c='MB Trucks';
      
   insert vdeal;
  
   Account pdeal = new Account(); // for parts Lead //
   pdeal.RecordTypeId = dealerRecordtypeid;
   pdeal.Name = 'testdealer5';
   pdeal.Phone = '58396248'; 
   pdeal.Active__c='yes';
   pdeal.Dealer_Allocation__c='MBAuP';
   pdeal.Activation_Date__c=system.today();
   pdeal.Business_Unit__c='MB Vans';
      	
   insert pdeal;
    
   Account Comp = new Account(); // for finance,service,Vehicle Lead //
   Comp.Name='ABC Pvt Ltd';
   Comp.Phone='2132123';
   
   insert Comp;
    
   Account Cus=new Account(); // for finance lead //
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396201';
   Cus.Email__c='abc@nttdata.com';
   
   insert Cus;
   
   Account Cus1=new Account(); // for service lead //
   Cus1.RecordTypeId = PersonRecordtypeid;
   Cus1.Salutation='Lord';
   Cus1.FirstName='Mount1';
   Cus1.LastName='Batten';
   Cus1.City__c='England';
   Cus1.Phone='58396202';
   Cus1.Email__c='abc@nttdata.com';
   
   insert Cus1;
   
   Account Cus2=new Account(); //for vehicle Lead //
   Cus2.RecordTypeId = PersonRecordtypeid;
   Cus2.Salutation='Lord';
   Cus2.FirstName='Mount2';
   Cus2.LastName='Batten';
   Cus2.City__c='England';
   Cus2.Phone='58396203';
   Cus2.Email__c='abc@nttdata.com';
   
   insert Cus2;
   
   Account Cus3=new Account(); //for parts Lead //
   Cus3.RecordTypeId = PersonRecordtypeid;
   Cus3.Salutation='Lord';
   Cus3.FirstName='Mount3';
   Cus3.LastName='Batten';
   Cus3.City__c='England';
   Cus3.Phone='58396204';
   Cus3.Email__c='abc@nttdata.com';
   
   insert Cus3;
     
   Contact con=new Contact();
    con.Salutation='DRM MBFS';
    con.FirstName = 'lai';
    con.LastName = 'sichao11';
    con.AccountId = fdeal.id;
    con.Email = 'sichao11.lai@nttdata.com'; 
    con.Dealer_Lead_Gate_Keeper__c=True;
    con.Finance_Lead_Type__c ='Agility';
    con.Business_Unit__c = 'MBFS Cars';	
    con.Sub_BusinessUnit__c = 'Finance';
    con.Inactive__c = false ;
	
	insert con;
	
	Contact con1=new Contact();
	con1.Salutation='DRM MBFS';
	con1.FirstName = 'lai';
    con1.LastName = 'sichao11';
	con1.AccountId = sdeal.id;
    con1.Email = 'sichao11.lai@nttdata.com';
    con1.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con1.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue1; 
	con1.Dealer_Lead_Gate_Keeper__c=false;
    con1.Business_Unit__c = 'MB Trucks';	
	con1.Sub_BusinessUnit__c = 'Service';
	con1.Inactive__c = false ;
	
	insert con1;
    
    Contact con2=new Contact();
	con2.Salutation='DRM MBFS';
	con2.FirstName = 'lai';
    con2.LastName = 'sichao11';
	con2.AccountId = vdeal.id;
    con2.Email = 'sichao11.lai@nttdata.com';
    con2.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con2.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue1; 
	con2.Dealer_Lead_Gate_Keeper__c=false;
    con2.Business_Unit__c = 'MB Trucks';	
	con2.Sub_BusinessUnit__c = 'Service';
	con2.Inactive__c = false ;
	
	insert con2;
    
	Contact con3=new Contact();
	con3.Salutation='DRM MBFS';
	con3.FirstName = 'lai';
    con3.LastName = 'sichao11';
	con3.AccountId = pdeal.id;
    con3.Email = 'sichao11.lai@nttdata.com';
    con3.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con3.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue1; 
	con3.Dealer_Lead_Gate_Keeper__c=false;
    con3.Business_Unit__c = 'MB Vans';	
	con3.Sub_BusinessUnit__c = 'parts';
	con3.Inactive__c = false ;
	
	insert con3;
	
	Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Company_Account__c = comp.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Assigned_Dealer__c = fdeal.id;
	Flead.Sales_Consultant__c =con.id; 
	Flead.Dealer_Assignment_Date__c = system.today();
	Flead.Source_System__c='DLM';
    Flead.OwnerId = user1.id;
     
	insert Flead;
   
   Lead__c slead = new Lead__c();
	slead.RecordTypeId = leadSPRt ;
	slead.Contact__c = Cus1.id;
	slead.Company_Account__c =Comp.id ;
	slead.Lead_Source__c = 'Walk-In';
	slead.Nature_of_Request__c = 'Service Booking';
	slead.Business_Unit__c = 'MB Trucks';
	slead.Sub_BusinessUnit__c = 'Service';
	slead.CAC_Lead_Status__c = 'Qualified';
	slead.Assigned_Dealer__c = sdeal.id;
	slead.X24H_Untouched__c = false;
	slead.X72H_Untouched__c = false;
	slead.Preferred_Date__c = system.today();
	slead.Preferred_Drop_off_Time__c = '6:00 pm';
	slead.Preferred_Pickup_Time__c = '9:00 am';
	slead.MB_Vehicle_Interest__c = 'A-Class';
	slead.Vehicle_Registration_No__c = '1111';
	slead.Source_System__c ='DLM';
	slead.Sales_Consultant__c =con1.id;
    slead.OwnerId = user1.id;
    
	insert slead;
	
	Lead__c vlead = new Lead__c();
	vlead.RecordTypeId = leadVehicleRt;
	vlead.Contact__c = Cus2.id;
	vlead.Company_Account__c =Comp.id ;
	vlead.Nature_of_Request__c = 'Request a Quote';
	vlead.Lead_Source__c = 'Walk-In';
	vlead.Business_Unit__c = 'MB Trucks';
	vlead.Sub_BusinessUnit__c = 'Service';
	vlead.CAC_Lead_Status__c = 'Qualified';
	vlead.Assigned_Dealer__c = vdeal.id;
	vlead.Test_Drive_Date__c = system.today();
    vlead.MB_Vehicle_Interest__c = 'Atego';
	vlead.Purchase_Time__c = '24 Hours';
	vlead.Source_System__c = 'DLM';
	vlead.Sales_Consultant__c =con2.id;
    vlead.OwnerId = user1.id;
	
    insert vlead;
		
	Lead__c plead = new Lead__c();
	plead.Contact__c = Cus3.id ;
    plead.Company_Account__c =Comp.id ;
	plead.Nature_of_Request__c = 'Parts Enquiries';
	plead.Lead_Source__c = 'Walk-In';
	plead.CAC_Lead_Status__c = 'Qualified';
	plead.Business_Unit__c = 'Vans';
	plead.Sub_BusinessUnit__c = 'Parts';
	plead.Assigned_Dealer__c = pdeal.id;
	plead.MB_Vehicle_Interest__c = 'Citan';
	plead.UsVIN__c = '1212';
	plead.Description__c='Its regarding the Parts Enquiry';
	plead.Source_System__c = 'DLM';
	plead.Sales_Consultant__c =con3.id;
    plead.OwnerId = user1.id;
	
	insert plead;

   Map<id,Lead__c> newMap=new Map<id,Lead__c>();
        newMap.put(Flead.id,Flead);
	Map<id,Lead__c> oldMap=new Map<id,Lead__c>();
         oldMap.put(Flead.id,Flead);
	Map<id,Lead__c> newMap1=new Map<id,Lead__C>();
         newMap1.put(slead.id,slead);
    Map<id,Lead__c> oldMap1=new Map<id,Lead__c>();
          oldMap1.put(slead.id,slead);	
	Map<id,Lead__c> newMap2=new Map<id,Lead__c>();
          newMap2.put(vlead.id,vlead);
    Map<id,Lead__c> oldMap2=new Map<id,Lead__c>();
           oldMap2.put(vlead.id,vlead);	
	Map<id,Lead__c> newMap3=new Map<id,Lead__c>();
          newMap3.put(plead.id,plead);
    Map<id,Lead__c> oldMap3=new Map<id,Lead__c>();
           oldMap3.put(plead.id,plead);
		   
	Test.startTest();

	LeadHelper.autoAssignLeads(newMap,oldMap,true,false);
	LeadHelper.autoAssignLeads(newMap,oldMap,false,true);
	LeadHelper.autoAssignLeads(newMap1,oldMap1,true,false);
	LeadHelper.autoAssignLeads(newMap1,oldMap1,false,true);
	LeadHelper.autoAssignLeads(newMap2,oldMap2,true,false);
	LeadHelper.autoAssignLeads(newMap2,oldMap2,false,true);
    LeadHelper.autoAssignLeads(newMap3,oldMap3,true,false);
	LeadHelper.autoAssignLeads(newMap3,oldMap3,false,true);
	
	Test.stopTest(); 
   }    
}
    @istest(seealldata = false)
public static void LeadHelperTest14()
{
Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
         createUser(profile);
        
        system.runAs( user ) {


Account deal = new Account();
   deal.RecordTypeId = dealerRecordtypeid;
   deal.Name = 'testdealer';
   deal.Phone = '58396243'; 
   deal.Active__c='yes';
   deal.Dealer_Allocation__c='MBAuP';
   deal.Activation_Date__c=system.today();
   deal.Business_Unit__c='MBFS Cars';
   deal.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal;
   
   Account deal1 = new Account();
   deal1.RecordTypeId = dealerRecordtypeid;
   deal1.Name = 'testdealer';
   deal1.Phone = '58396243'; 
   deal1.Active__c='yes';
   deal1.Dealer_Allocation__c='MBAuP';
   deal1.Activation_Date__c=system.today();
   deal1.Business_Unit__c='MBFS Cars';
   deal1.Cars_Offered_Service__c='Finance & Insurance';    
	
   insert deal1;
            Account Cus=new Account();
   Cus.RecordTypeId = PersonRecordtypeid;
   Cus.Salutation='Lord';
   Cus.FirstName='Mount';
   Cus.LastName='Batten';
   Cus.City__c='England';
   Cus.Phone='58396200';
   Cus.Email__c='abc@nttdata.com';
   
   insert Cus;
    
	Lead__c Flead = new Lead__c();
	Flead.RecordTypeId =leadFinanceRT;
	Flead.Contact__c = Cus.id;
	Flead.Lead_Source__c = 'LiveChat';
	Flead.Nature_of_Request__c = 'Agility';
	Flead.Business_Unit__c = 'MBFS Cars';
	Flead.Sub_BusinessUnit__c = 'Finance & Insurance';
	Flead.CAC_Lead_Status__c = 'Sold Finance';
	Flead.Assigned_Dealer__c = deal.id;
    Flead.OwnerID = user.id;       
	insert Flead;
	
	Contact con=new Contact();
    con.Salutation='DRM MBFS';
    con.FirstName = 'lai';
    con.LastName = 'sichao11';
    con.AccountId = deal.id;
    con.Email = 'sichao11.lai@nttdata.com';
    con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
    con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
    con.Dealer_Lead_Gate_Keeper__c=true;
    con.Finance_Lead_Type__c ='Agility';
    con.Business_Unit__c = 'MBFS Cars';	
    con.Sub_BusinessUnit__c = 'Finance';
    con.Inactive__c = false ;
	
	insert con;
	
	List<Lead__c> newlist=new List<Lead__c>();
	newlist.add(Flead);	
	Map<id,Lead__c> newLeadMap = new Map<id,Lead__c>();
	newLeadMap.put(Flead.id,Flead);
	Map<id,Lead__c> leadoldMap = new Map<id,Lead__c>();
	leadoldMap.put(Flead.id,Flead);
	
	Test.startTest();
	
	LeadHelper.updateDealerAssignmentDate(newlist,newLeadMap,leadoldMap,true,false);
	LeadHelper.updateDealerAssignmentDate(newlist,newLeadMap,leadoldMap,false,true);
	
	Test.stopTest();
        }
}    
    
 private static void createUser1(Profile profile){        
 
		Account ac1=new Account();
		ac1.RecordTypeId = dealerRecordtypeid;
         ac1.Name = 'testdealer';
         ac1.Phone = '58396243'; 
         ac1.Active__c='yes';
         ac1.Dealer_Allocation__c='MBAuP';
         ac1.Activation_Date__c=system.today();
         ac1.Business_Unit__c='MBFS Cars';
         ac1.Cars_Offered_Service__c='Finance & Insurance';    
	
          insert ac1;
		  
		  Contact con=new Contact();
          con.Salutation='DRM MBFS';
          con.FirstName = 'lai';
          con.LastName = 'sichao11';
          con.AccountId = ac1.id;
          con.Email = 'sichao11.lai@nttdata.com';
          con.EOC_Recipient_Type__c = EOCRecipientTypeValue;
          con.Lead_Escalation_Recipient_Type__c=LeadEscalationRecipientTypeValue; 
          con.Dealer_Lead_Gate_Keeper__c=true;
          con.Finance_Lead_Type__c ='Agility';
          con.Business_Unit__c = 'MBFS Cars';	
          con.Sub_BusinessUnit__c = 'Finance';
          con.Inactive__c = false ;
		  
		  insert con;
		
		 user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao7',
                                  Email = 'sichao7.lai@nttdata.com', Alias = 'laisc',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = localeSideKeyValue,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = localeSideKeyValue);
         insert user1;        
    }   
    

@istest(seealldata = false)
public static void LeadHelperTest16()
{        
    Test.startTest();
    Account deal = new Account();
    deal.RecordTypeId = dealerRecordtypeid;
    deal.Name = 'testdealer';
    deal.Phone = '58396243'; 
    deal.Active__c='yes';
    deal.Dealer_Allocation__c='MBAuP';
    deal.Activation_Date__c=system.today();
    deal.Business_Unit__c='MBFS Cars';
    deal.MBFS_Car_Offered_Service__c='Service';    
        
    insert deal;
    
    Account Comp = new Account(); // for finance,service,Vehicle Lead //
    Comp.Name='ABC Pvt Ltd';
    Comp.Phone='2132123';
    
    insert Comp;
       
    Account Cus=new Account();  // Customer Account hot lead
    Cus.RecordTypeId = PersonRecordtypeid;
    Cus.Company__c = deal.id;   
    Cus.Salutation='Lord';
    Cus.FirstName='Mount';
    Cus.LastName='Batten';
    Cus.City__c='England';
    Cus.Phone='58396200';
    Cus.PC_Status__c = 'Customer'; // Prospect,Service Only,Complaintant //
    Cus.CV_Status__c = 'Customer'; // Customer,Service Only	 //
    Cus.VAN_Status__c = 'Customer'; // Prospect,Service Only,Complaintant //
    Cus.Behavioural_group__c = 'Revolver'; // New to the brand,Attriter,Keeper //
       
    insert Cus;
        
    Account Cus2=new Account(); // Customer Account warm lead
    Cus2.RecordTypeId = PersonRecordtypeid;
    Cus2.Company__c = deal.id;   
    Cus2.Salutation='Lord';
    Cus2.FirstName='Mount';
    Cus2.LastName='Batten';
    Cus2.City__c='England';
    Cus2.Phone='58396200';
    Cus2.PC_Status__c = 'Customer'; // Prospect,Service Only,Complaintant //
    Cus2.CV_Status__c = 'Customer'; // Customer,Service Only	 //
    Cus2.VAN_Status__c = 'Customer'; // Prospect,Service Only,Complaintant //
    Cus2.Behavioural_group__c = 'Keeper'; // New to the brand,Attriter,Revolver //
       
    insert Cus2;
    
    Account Cus1=new Account(); //Prospect Account
    Cus1.RecordTypeId = PersonRecordtypeid;
    Cus1.Company__c = deal.id;   
    Cus1.Salutation='Lord';
    Cus1.FirstName='Mount';
    Cus1.LastName='Batten';
    Cus1.City__c='England';
    Cus1.Phone='58396200';
    Cus1.PC_Status__c = 'Prospect'; // Customer,Service Only,Complaintant //
    Cus1.CV_Status__c = 'Prospect'; // Customer,Service Only	 //
    Cus1.VAN_Status__c = 'Prospect'; // Customer,Service Only,Complaintant //
    Cus1.Behavioural_Group__c = 'Revolver'; // New to the brand,Attriter,Keeper //
       
    insert Cus1;
    
     Account Cus3=new Account(); //Prospect Account
    Cus3.RecordTypeId = PersonRecordtypeid;
    Cus3.Company__c = deal.id;   
    Cus3.Salutation='Lord1';
    Cus3.FirstName='Mount';
    Cus3.LastName='Batten';
    Cus3.City__c='England';
    Cus3.Phone='58396200';
    Cus3.PC_Status__c = 'Prospect'; // Customer,Service Only,Complaintant //
    Cus3.CV_Status__c = 'Prospect'; // Customer,Service Only	 //
    Cus3.VAN_Status__c = 'Prospect'; // Customer,Service Only,Complaintant //
    Cus3.Behavioural_Group__c = 'Keeper'; // New to the brand,Attriter,Keeper //
       
    insert Cus3;
    
    Vehicle__c veh= new Vehicle__c(); //hot lead
    veh.RecordTypeId = VehRTid;
    veh.UsVIN__c = '1212';
    veh.Class__c = 'A-Class';
    veh.Related_contact__c = Cus.id;
    
    insert veh;
    
    Vehicle__c veh1= new Vehicle__c(); //warm lead
    veh1.RecordTypeId = VehRTid;
    veh1.UsVIN__c = '1212';
    veh1.Class__c = 'A-Class';
    veh1.Related_contact__c = Cus2.id;
    
    insert veh1;
    
    Vehicle_Relationship__c	vehrel = new Vehicle_Relationship__c(); //hot lead
    vehrel.RecordTypeId = VehrelRTid;
    vehrel.Car_Relation__c = 'Owner';
    vehrel.Status__c = 'Currently Owned';
    vehrel.Contact__c = Cus.id;
    vehrel.Vehicle_ID__c = veh.id;
    
    insert vehrel;
    
    Vehicle_Relationship__c	vehrel1 = new Vehicle_Relationship__c(); //warm lead
    vehrel1.RecordTypeId = VehrelRTid;
    vehrel1.Car_Relation__c = 'Owner';
    vehrel1.Status__c = 'Currently Owned';
    vehrel1.Contact__c = Cus2.id;
    vehrel1.Vehicle_ID__c = veh1.id;
    
    insert vehrel1;
    
    Retail_Task__c rtask = new Retail_Task__c(); //hot lead Service Contract 
    rtask.RecordTypeId = ServiceRTid;
    rtask.Service_Dealer__c = deal.Id; 
    rtask.Related_Vehicle__c = veh.Id;
    rtask.Account__c = Cus.id;
    
    insert rtask;
      
     Retail_Task__c Contr=new Retail_Task__c();  //hot lead Contract
   Contr.RecordTypeId = ContractRTid;
   Contr.Name = '1234';
   Contr.Related_Dealer__c = Deal.id;
   Contr.Account__c = Cus.id;
   Contr.Related_Vehicle__c = veh.id;
	
	insert Contr;
   	
	Retail_Task__c Insur = new Retail_Task__c(); //hot lead insurance contract
	Insur.RecordTypeId = InsuranceRTid;
	Insur.Name = 'Vehicle1';
	Insur.Account__c = Cus.id;
	
	insert Insur;
       
    Lead__c vlead = new Lead__c(); // Customer hot lead
        vlead.RecordTypeId = leadVehicleRt;
        vlead.Contact__c = Cus.id;
        vlead.Company_Account__c =Comp.id ;
        vlead.Nature_of_Request__c = 'Test Drive Request';
        vlead.Lead_Source__c = 'Walk-In';
        vlead.Business_Unit__c = 'Cars';
        vlead.Sub_BusinessUnit__c = 'Service';
        vlead.CAC_Lead_Status__c = 'Qualified';
        vlead.Assigned_Dealer__c = deal.id;
        vlead.Test_Drive_Date__c = system.today();
        vlead.MB_Vehicle_Interest__c = 'A-Class';
        vlead.Purchase_Time__c = '24 Hours';
        
        insert vlead;
    
    Lead__c vlead2 = new Lead__c(); //customer warm lead
        vlead2.RecordTypeId = leadVehicleRt;
        vlead2.Contact__c = Cus2.id;
        vlead2.Nature_of_Request__c = 'Brochure Request';
        vlead2.Lead_Source__c = 'Walk-In';
        vlead2.Business_Unit__c = 'Cars';
        vlead2.Sub_BusinessUnit__c = 'Service';
        vlead2.CAC_Lead_Status__c = 'Qualified';
        vlead2.Assigned_Dealer__c = deal.id;
        vlead2.MB_Vehicle_Interest__c = 'B-Class';
        vlead2.Purchase_Time__c = 'Not sure';  
        
        insert vlead2;	
        
     Lead__c vlead1 = new Lead__c();  //Prospect
        vlead1.RecordTypeId = leadVehicleRt;
        vlead1.Contact__c = Cus1.id;
        vlead1.Nature_of_Request__c = 'Test Drive Request';
        vlead1.Lead_Source__c = 'Walk-In';
        vlead1.Business_Unit__c = 'Cars';
        vlead1.Sub_BusinessUnit__c = 'Service';
        vlead1.CAC_Lead_Status__c = 'Qualified';
        vlead1.Assigned_Dealer__c = deal.id;
        vlead1.Test_Drive_Date__c = system.today();
        vlead1.MB_Vehicle_Interest__c = 'B-Class';
        vlead1.Purchase_Time__c = '24 Hours';
             
        insert vlead1;
    
     Lead__c vlead3 = new Lead__c(); //Prospect warm lead
        vlead3.RecordTypeId = leadVehicleRt;
        vlead3.Contact__c = Cus3.id;
        vlead3.Nature_of_Request__c = 'Brochure Request';
        vlead3.Lead_Source__c = 'Walk-In';
        vlead3.Business_Unit__c = 'Cars';
        vlead3.Sub_BusinessUnit__c = 'Service';
        vlead3.CAC_Lead_Status__c = 'Qualified';
        vlead3.Assigned_Dealer__c = deal.id;
        vlead3.MB_Vehicle_Interest__c = 'B-Class';
        vlead3.Purchase_Time__c = 'Not sure';  
        
        insert vlead3;
             
	Test.stopTest();
}    

@istest(seealldata = false)
public static void LeadHelperTest17()
{
Account deal = new Account();
deal.RecordTypeId = dealerRecordtypeid;
deal.Name = 'testdealer';
deal.Phone = '58396243'; 
deal.Active__c='yes';
deal.Dealer_Allocation__c='MBAuP';
deal.Activation_Date__c=system.today();
deal.Business_Unit__c='MBFS Cars';
deal.Cars_Offered_Service__c='Finance & Insurance';    
	
insert deal;

Account Cus=new Account();
Cus.RecordTypeId = PersonRecordtypeid;
Cus.Salutation='Lord';
Cus.FirstName='Mount';
Cus.LastName='Batten';
Cus.City__c='England';
Cus.Phone='58396200';
   
insert Cus;

Lead__c vlead = new Lead__c();
	vlead.RecordTypeId = leadVehicleRt;
	vlead.Contact__c = Cus.id;
	vlead.Nature_of_Request__c = 'Request a Quote';
	vlead.Lead_Source__c = 'Walk-In';
	vlead.Business_Unit__c = 'Cars';
	vlead.Sub_BusinessUnit__c = 'Service';
	vlead.CAC_Lead_Status__c = 'Qualified';
	vlead.Assigned_Dealer__c = deal.id;
	vlead.Test_Drive_Date__c = system.today();
    vlead.MB_Vehicle_Interest__c = 'A-Class';
	vlead.Purchase_Time__c = '24 Hours';
	vlead.Dealer_Assignment_Date__c = system.now();
	vlead.Consultant_Assignment_Date__c = system.now();
    vlead.Lead_Priority__c = 'Hot';
	
    insert vlead;

	List<Lead__c> list_leads_new = new List<Lead__c>();
	list_leads_new.add(vlead);
	
	Test.startTest();
	
	LeadHelper.DueDateForAssignedDealer(list_leads_new);
	
	Test.stopTest();

}  
@istest(seealldata = false)
public static void LeadHelperTest18()
{
Account deal = new Account();
deal.RecordTypeId = dealerRecordtypeid;
deal.Name = 'testdealer';
deal.Phone = '58396243'; 
deal.Active__c='yes';
deal.Dealer_Allocation__c='MBAuP';
deal.Activation_Date__c=system.today();
deal.Business_Unit__c='MBFS Cars';
deal.Cars_Offered_Service__c='Finance & Insurance';    
	
insert deal;

Account Comp = new Account(); // for finance,service,Vehicle Lead //
Comp.Name='ABC Pvt Ltd';
Comp.Phone='2132123';

insert Comp;

Account Cus=new Account();
Cus.RecordTypeId = PersonRecordtypeid;
Cus.Company__c = deal.id;
Cus.Salutation='Lord';
Cus.FirstName='Mount';
Cus.LastName='Batten';
Cus.City__c='England';
Cus.Phone='58396200';
   
insert Cus;

Vehicle__c veh= new Vehicle__c();
veh.RecordTypeId = VehRTid;
veh.UsVIN__c = '1212';
veh.Class__c = 'A-Class';

insert veh;

Retail_Task__c rtask = new Retail_Task__c();
rtask.RecordTypeId = ContractRTid;
rtask.Related_Dealer__c = deal.Id; 
rtask.Related_Vehicle__c = veh.Id;
rtask.Account__c = Cus.id;

insert rtask;

Lead__c vlead = new Lead__c();
	vlead.RecordTypeId = leadVehicleRt;
	vlead.Contact__c = Cus.id;
	vlead.Company_Account__c = Comp.id;
	vlead.Nature_of_Request__c = 'Brochure Request';
	vlead.Lead_Source__c = 'Walk-In';
	vlead.Business_Unit__c = 'Cars';
	vlead.Sub_BusinessUnit__c = 'Service';
	vlead.CAC_Lead_Status__c = 'Qualified';
	vlead.Assigned_Dealer__c = deal.id;
	vlead.Test_Drive_Date__c = system.today();
    vlead.MB_Vehicle_Interest__c = 'A-Class';
	vlead.Purchase_Time__c = '24 Hours';
    vlead.Lead_Priority__c = 'Hot';
	vlead.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead;
	
Lead__c vlead1 = new Lead__c();
	vlead1.RecordTypeId = leadVehicleRt;
	vlead1.Contact__c = Cus.id;
	vlead1.Company_Account__c = Comp.id;
	vlead1.Nature_of_Request__c = 'Test Drive Request';
	vlead1.Lead_Source__c = 'Walk-In';
	vlead1.Business_Unit__c = 'Cars';
	vlead1.Sub_BusinessUnit__c = 'Service';
	vlead1.CAC_Lead_Status__c = 'Qualified';
	vlead1.Assigned_Dealer__c = deal.id;
	vlead1.Test_Drive_Date__c = system.today();
    vlead1.MB_Vehicle_Interest__c = 'A-Class';
	vlead1.Purchase_Time__c = '24 Hours';
    vlead1.Lead_Priority__c = 'Hot';
	vlead1.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead1.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead1;

Lead__c vlead2 = new Lead__c();
	vlead2.RecordTypeId = leadVehicleRt;
	vlead2.Contact__c = Cus.id;
	vlead2.Company_Account__c = Comp.id;
	vlead2.Nature_of_Request__c = 'Request a Quote';
	vlead2.Lead_Source__c = 'Walk-In';
	vlead2.Business_Unit__c = 'Cars';
	vlead2.Sub_BusinessUnit__c = 'Service';
	vlead2.CAC_Lead_Status__c = 'Qualified';
	vlead2.Assigned_Dealer__c = deal.id;
	vlead2.Test_Drive_Date__c = system.today();
    vlead2.MB_Vehicle_Interest__c = 'A-Class';
	vlead2.Purchase_Time__c = '24 Hours';
    vlead2.Lead_Priority__c = 'Hot';
	vlead2.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead2.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead2;

Lead__c vlead3 = new Lead__c();
	vlead3.RecordTypeId = leadVehicleRt;
	vlead3.Contact__c = Cus.id;
	vlead3.Company_Account__c = Comp.id;
	vlead3.Nature_of_Request__c = 'Corporate Programme';
	vlead3.Lead_Source__c = 'Walk-In';
	vlead3.Business_Unit__c = 'Cars';
	vlead3.Sub_BusinessUnit__c = 'Service';
	vlead3.CAC_Lead_Status__c = 'Qualified';
	vlead3.Assigned_Dealer__c = deal.id;
	vlead3.Test_Drive_Date__c = system.today();
    vlead3.MB_Vehicle_Interest__c = 'A-Class';
	vlead3.Purchase_Time__c = '24 Hours';
    vlead3.Lead_Priority__c = 'Hot';
	vlead3.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead3.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead3;

Lead__c vlead4 = new Lead__c();
	vlead4.RecordTypeId = leadVehicleRt;
	vlead4.Contact__c = Cus.id;
	vlead4.Company_Account__c = Comp.id;
	vlead4.Nature_of_Request__c = 'Fleet Programme';
	vlead4.Lead_Source__c = 'Walk-In';
	vlead4.Business_Unit__c = 'Cars';
	vlead4.Sub_BusinessUnit__c = 'Service';
	vlead4.CAC_Lead_Status__c = 'Qualified';
	vlead4.Assigned_Dealer__c = deal.id;
	vlead4.Test_Drive_Date__c = system.today();
    vlead4.MB_Vehicle_Interest__c = 'A-Class';
	vlead4.Purchase_Time__c = '24 Hours';
    vlead4.Lead_Priority__c = 'Hot';
	vlead4.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead4.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead4;

Lead__c vlead5 = new Lead__c();
	vlead5.RecordTypeId = leadVehicleRt;
	vlead5.Contact__c = Cus.id;
	vlead5.Company_Account__c = Comp.id;
	vlead5.Nature_of_Request__c = 'Parts Enquiries';
	vlead5.Lead_Source__c = 'Walk-In';
	vlead5.Business_Unit__c = 'Cars';
	vlead5.Sub_BusinessUnit__c = 'Service';
	vlead5.CAC_Lead_Status__c = 'Qualified';
	vlead5.Assigned_Dealer__c = deal.id;
	vlead5.Test_Drive_Date__c = system.today();
    vlead5.MB_Vehicle_Interest__c = 'A-Class';
	vlead5.Purchase_Time__c = '24 Hours';
    vlead5.Lead_Priority__c = 'Hot';
	vlead5.Preferred_Drop_off_Time__c = '6:00 pm';
	vlead5.Vehicle_Registration_No__c = 'TN30BC7101' ;
	
    insert vlead5;

	List<Lead__c> deDupleadList = new List<Lead__c>();
	deDupleadList.add(vlead);
	List<Lead__c> deDupleadList1 = new List<Lead__c>();
	deDupleadList1.add(vlead1);
	List<Lead__c> deDupleadList2 = new List<Lead__c>();
	deDupleadList2.add(vlead2);
	List<Lead__c> deDupleadList3 = new List<Lead__c>();
	deDupleadList3.add(vlead3);
	List<Lead__c> deDupleadList4 = new List<Lead__c>();
	deDupleadList4.add(vlead4);
	List<Lead__c> deDupleadList5 = new List<Lead__c>();
	deDupleadList5.add(vlead5);
	
	Test.startTest();
	
	LeadHelper.leaddeDuplication(deDupleadList);
	LeadHelper.leaddeDuplication(deDupleadList1);
	LeadHelper.leaddeDuplication(deDupleadList2);
	LeadHelper.leaddeDuplication(deDupleadList3);
	LeadHelper.leaddeDuplication(deDupleadList4);
	LeadHelper.leaddeDuplication(deDupleadList5);
		
	Test.stopTest();    
}
}