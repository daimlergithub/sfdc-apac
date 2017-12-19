@isTest
public with sharing class LeadHelperMYTest {

private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
public static User user1;
public static User user2;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testAccAssignment() {
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
			  EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
			  LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
			  TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
	
    System.runAs (user1) {
        PermissionSet ps = new PermissionSet();
			ps.Name = 'Test';
			ps.Label = 'Test';
			insert ps;
    
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
		cs.DEFAULT_CALLOUT_TIME__c='1000';
		cs.MAX_CALLOUT_TIME__c='5000';
		cs.Name='CalloutValues';
		insert cs;
		
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
		sysSet.Debug__c =true;
		sysSet.Error__c = true;
		sysSet.Info__c= true;
		sysSet.Warning__c = true;
		sysSet.Log_Purge__c =10;
		sysSet.Name=p1.Name;
		DMLManagerService.insertAsSystem(sysSet);
        
        user2 = UtilTestData.createPersornaUser(ps, p1);
    }
        System.runAs (user2) {
		Trigger__c leadtrigger=new Trigger__c(name='TriggerLeadMY',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='MY',Trigger_Handler__c='LeadTriggerHandlerMY',Trigger_Name__c='TriggerLead',update__c=true);
		insert leadtrigger;
		test.starttest();
        set<id> accid=new set<id>();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = user1.Id;
        dealer.Smart_Account_Owner__c = user1.Id;
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'english';
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
        insert dealer;
        system.assertEquals(dealer.id,[select id from account where id=:dealer.id limit 1].id);
       
        Account dealer1 = new Account();
        dealer1.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer1.Phone = '12332121';
        dealer1.Dealer_GC_Code__c = 'gc code';
        dealer1.Dealer_GS_Code__c = 'gs code';
        dealer1.Name = 'test dealer';
        dealer1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer1.Star_Elite_Account_Owner__c = user2.Id;
        dealer1.Smart_Account_Owner__c = user2.Id;
        dealer1.Dealer_Lead_System__c = 'salesforce';
        dealer1.Dealer_Lead_Gate_Keeper__c = user2.id;
        dealer1.Allow_Data_Sharing__c = 'yes';
        dealer1.Province__c = 'jiangsu';
        dealer1.City__c = 'nanjing';
        dealer1.Preferred_Language__c = 'english';
        dealer1.Dealer_Lead_System__c = 'salesforce';
        dealer1.Gender__c = '0=Male';
        dealer1.ZipCode__c = '200235';
        dealer1.Type = '0=Company';
        dealer1.Status__c = '0=contac1';
        dealer1.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer1.Dealer_Region__c = 'EAST';
        insert dealer1;
        system.assertNotEquals([select id from account where id=:dealer1.id limit 1].id,[select id from account where id=:dealer.id limit 1].id);
       
        
        Account perAcc= new Account();
        perAcc.Allow_Data_Sharing__c = 'yes'; 
        perAcc.Province__c = 'jiangsu'; 
        perAcc.City__c = 'nanjing';
        perAcc.Preferred_Language__c = 'english';
        perAcc.Dealer_Lead_System__c = 'salesforce';
        perAcc.LastName = 'Customer';
        perAcc.Gender__c = '0=Male';
        perAcc.ZipCode__c = '2002351';
        perAcc.Type = '0=Company';
        perAcc.Phone = '01233214'; 
        perAcc.Status__c = '0=Customer';
        perAcc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        perAcc.Dealer_Lead_Gate_Keeper__c = user1.Id;
        perAcc.Area_Code__c = '030';
       
        insert perAcc;

        accid.add(perAcc.id);
        
        
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = perAcc.Id;
        
        //lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.md__c='MY';
        lead.Received_Date_Time__c=system.today();
        lead.Accepted_Date_Time__c=system.today();
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.id;
        insert lead;
        lead.Assigned_Dealer__c = null;
        update lead;
        lead.Assigned_Dealer__c = dealer1.Id;
        update lead;
        
        test.stoptest();
          
        }     
        }
}