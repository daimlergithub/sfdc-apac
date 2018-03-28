@isTest
public with sharing class LeadHelperMYTest {

private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
public static Id retailpersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
public static Id AccountCompanyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
public static Id retailCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
public static List<Lead> l1 ;   
public static String testEmail = 'test@test.com';
public static Contact contact;
public static Contact contact1;
public static Account_Link__c acclink;
public static List<Contact> contacts;
public static User user1;
public static User user2;
public static User portaluser;
public static User portaluser1;    
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testAccAssignment() {
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
   user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='',
              TimeZoneSidKey='America/Los_Angeles', 
              UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true, Active__c=true);
    insert user1;
    System.runAs (user1) {
        PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
 Set<String> customperms = new Set<String>{Label.MYRetail, Label.MYGeneric, Label.CreateRetailCopy,Label.LeadShareRecordswithDealers,Label.LeadAL};
        List<CustomPermission> lcps = new List<CustomPermission>([SELECT ID From CustomPermission WHERE MasterLabel IN :customperms]);
        List<SetupEntityAccess> lsetupentity = new List<SetupEntityAccess>();

          for(CustomPermission cps: lcps){
            SetupEntityAccess sea = new SetupEntityAccess();
        	sea.ParentId = ps.Id;
        	sea.SetupEntityId = cps.id;
            lsetupentity.add(sea);
        }
       
      if(!lsetupentity.isEmpty())
        DMLManagerService.insertAsSystem(lsetupentity);
		
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
       
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
      //  Contact con=  [Select id from contact  Limit 1];
        user2 = UtilTestData.createPersornaUser(ps, p1);
      //  User2.ContactId=con.id;
         
        user2.userroleid = portalRole.id;
        insert user2;
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
        dealer.Dealer_ND_Code__c = '12345';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = DealerRecordTypeId;
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
        dealer.Dealer_Active__c = True;
        dealer.Dealer_Rollout_Status__c = 'Done';
        insert dealer;
        system.assertEquals(dealer.id,[select id from account where id=:dealer.id limit 1].id);
    
        Account dealer1 = new Account();
        dealer1.Dealer_Alternate_Name__c = 'Test Alternate';
        
        dealer1.Phone = '12332121';
        dealer1.Dealer_GC_Code__c = 'gc code';
        dealer1.Dealer_GS_Code__c = 'gs code';
        dealer1.Dealer_ND_Code__c = '12345';
        dealer1.Name = 'test dealer';
      //  dealer1.Primary_Address_Reference__c=dealer.id;
        dealer1.RecordTypeId = DealerRecordTypeId;
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
        dealer1.Dealer_Active__c = True;
        dealer1.Dealer_Rollout_Status__c = 'Done';
            
        insert dealer1;
        system.assertNotEquals([select id from account where id=:dealer1.id limit 1].id,[select id from account where id=:dealer.id limit 1].id);
          contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = testEmail;
           
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = dealer1.Id;
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
            contact1.AccountId = dealer1.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;
            
            Id p = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' Limit 1].id;
            portaluser = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[0].Id,
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
            
            portaluser1 = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[1].Id,
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser1;
        
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
        Account company1 = new Account();
        company1.Dealer_Alternate_Name__c = 'Test Alternate';
        company1.Phone = '12332121';
       // company1.LastName='dealer';
       // company1.FirstName='test';
        company1.ID_Type__c='Passport';
        company1.Country__c='India';
        company1.ID_Number__c='National ID';
        company1.Dealer_GC_Code__c = 'gc code';
        company1.Dealer_GS_Code__c = 'gs code';
        company1.Name = 'test dealer';
        company1.RecordTypeId = AccountCompanyRecordTypeId;
        company1.Star_Elite_Account_Owner__c = user1.Id;
        company1.LastName_Native_1__c='test';
        company1.Smart_Account_Owner__c = user1.Id;
        company1.Dealer_Lead_System__c = 'salesforce';
        company1.Dealer_Lead_Gate_Keeper__c = user1.id;
        company1.Allow_Data_Sharing__c = 'yes';
        company1.Province__c = 'jiangsu';
        company1.City__c = 'nanjing';
        company1.Preferred_Language__c = 'english';
        company1.Dealer_Lead_System__c = 'salesforce';
        company1.Gender__c = '0=Male';
        company1.ZipCode__c = '200235';
        company1.Type = '0=Company';
        company1.Status__c = '0=contac1';
        company1.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        company1.Dealer_Region__c = 'EAST';
        company1.Dealer_Active__c = True;
        //company1.Sales_Address_Type__c = perAcc.id;
        insert company1;
        Address__c address2=new Address__c();
        address2.Address_Type__c='Home';
        address2.Province__c='test1';
        address2.City__c='bangalore';
        address2.District__c='test2';
        address2.Block__c='test3';
        address2.Address_Line_1__c='testaddress1';
        address2.Address_Line_2__c='testaddress2';
        address2.Customer__c=perAcc.id;
        address2.TitleOfHonor__c = 'To Person'; 
        address2.Preferred__c = true;
        address2.country__c = 'Malaysia';
        address2.ZipCode__c = '12345';
        insert address2;
        //company1.Primary_Address_Reference__c = perAcc.Id;
        //update company1;
        Contact con3 = new Contact(id = contacts[0].Id, Dealer_Lead_Gate_Keeper__c = true);        
              update con3;
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = perAcc.Id;
        lead.CAC_Lead_Status__c = 'New';
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
        Boolean flag = true;
        lead.Received_Date_Time__c=system.today();
        lead.Accepted_Date_Time__c=system.today();
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer1.Id;
     //   lead.CAC_Lead_Status__c ='Assigned';
     
            try{
        		insert lead;
                lead.CAC_Lead_Status__c ='Purchased';
                update lead;
                lead.Purchased_CAC_Date__c=system.today();
                    }
            catch(DMLexception ex)
            {
                Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
				System.assertEquals(expectedExceptionThrown, false);
//OR
//System.assertEquals(expectedExceptionThrown, true);
         //   system.assertEquals(ex.getMessage(), ex.getMessage());
             }
            
             acclink = new Account_Link__c(); 
    		acclink.RecordTypeId = retailpersonRecordTypeId;
    		acclink.Name = 'testaccounlink';
    		acclink.fromRole__c = perAcc.Id;
            acclink.toRole__c = dealer1.Id;
    		acclink.Retail_PersonBirthdate__c=system.today();
    		acclink.Retail_Special_Care__c='testing';
    		acclink.Retail_Individual_Home_Phone__c='045878956';
    		acclink.Retail_Work_Phone__c='0455862358';
    		acclink.Retail_Mobile__c='076-789-1452';
    		acclink.Retail_Email__c='asdfg@gmail.com';
    		acclink.Retail_Gender__c='female';
    		acclink.Retail_Occupation__c='Business';
    		acclink.Retail_Preferred_Language__c='english';
    		acclink.Retail_Preferred_Contact_Method__c='phone';
           // acclink.Market__c='MY';
            insert acclink;
         Lead__c lead1 = new Lead__c();
         //lead1.Contact__c = company1.Id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.Company_Account__c=company1.id;
        lead1.Lead_Type__c = 'New Car';
        lead1.RecordTypeId=afterSalesRecordTypeId;
        lead1.Dealer_Lead_Status__c='Order Placed';
        lead1.Order_Placed_Date__c=system.today();
        Boolean flag1=false;
        lead1.Purchased_CAC_Date__c=null;
        lead1.Bought_Vehicle_Brand__c=null;
        lead1.Bought_Vehicle_Class__c=null;
        lead1.Relation_With_The_Leads__c = 'testR';
        lead1.Lead_Desired_Service__c = 'Trade-In';
        lead1.Purchase_Time__c = '0 - 3 months';
        lead1.Interested_Vehicle_Brand__c = 'testI';
        lead1.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead1.Trade_In_Vehicle_Brand__c = 'c230';
        lead1.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead1.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead1.Interested_Vehicle_Brand__c = 'Smart';
        lead1.md__c='MY';
        lead1.Received_Date_Time__c=system.today();
        lead1.Accepted_Date_Time__c=system.today();
        lead1.Retail_Contact__c=acclink.id;
        //lead1.Retail_Company__c=acclink.id;
        
        lead1.Assigned_Dealer__c = null;

        insert lead1;
       // lead1.CAC_Lead_Status__c = 'Purchased';
     //   lead1.Purchased_CAC_Date__c=system.today();
        
       // update lead1;
        lead1.Assigned_Dealer__c = dealer1.Id;
        update lead1;
        lead1.CAC_Lead_Status__c = 'Accepted';
        update lead1;
       // LeadHelperBase lhb= new LeadHelperBase();
      // LeadHelperBase.Leadvalidation(l1,'MY');
        test.stoptest();
          
        }     
        }
}