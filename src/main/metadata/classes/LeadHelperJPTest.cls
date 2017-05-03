@istest
public class LeadHelperJPTest 
{
  public Static Account objAccount;
  public static Account objAccount2;  
  public static Account objAccount3; 
  public Static Account DealerAccount;
  public static Lead__C lead1;
  public static Lead__C lead2;
  public static Lead__c lead3;  
  public static Account_Link__c AccLink;
  public static list<Lead__c> leadList = new list<Lead__c>(); 
  public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static String LeadObjectRecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
  public static final String aftersalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    
    
    public static testMethod void test_updateCustomerStage1()
    {  
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI'];
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        //System.runAs(u) {
            createTestData();
            test.startTest();
            //lead3.CAC_Lead_Status__c = 'Approved';
            update lead3;
            lead1.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            
            update lead1;
            
            Account testAcc = [Select Customer_Lifecycle_Phase__c from Account Where Id =:objAccount2.Id];
            TriggerLeadTriggerHandlerJP TriggerLeadHandlerJP = new TriggerLeadTriggerHandlerJP();
            TriggerLeadHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
            test.stopTest();
            //system.assertEquals('Sales Lead', testAcc.Customer_Lifecycle_Phase__c);
        //}
        
    }
    public static testMethod void test_updateCustomerStage2()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        //System.runAs(u) {
            createTestData();
            test.startTest();
            lead1.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            lead2.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            update lead1;
            update lead2;            
            Account testAcc = [Select Customer_Lifecycle_Phase__c from Account Where Id =:objAccount.Id];
            test.stopTest();
            system.assertEquals('Care', testAcc.Customer_Lifecycle_Phase__c);
        //}
    }
    
    public static testMethod void test_createAccountLinkFromDealer()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        System.runAs(u) {
        createTestData();
        test.startTest();
        lead1.Contact__c = objAccount3.id;
        lead1.CAC_Lead_Status__c = 'Approved';
        try{
        update lead1;
        }catch(exception e){}
        
       // Account_Link__c testAccLink = [Select id from Account_Link__c Where fromRole__c =: objAccount3.id and toRole__c =: DealerAccount.id LIMIT 1];
        test.stopTest();
        //system.assertNotEquals(null, testAccLink);
        }
        
                
    }
    
    
    
    static void createTestData()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
        Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
        Trigger__c newtrg1 = new Trigger__c(Name= 'TriggerLead',Trigger_Name__c = 'TriggerLead',Trigger_Handler__c = 'TriggerLeadTriggerHandlerJP',Market__c ='JP',
                               enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert newtrg1;
         DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        //inserted new address record
        Address__c addr = new Address__c(Customer__c = objAccount.id, Address_Type__c = 'Home', Province__c = 'Hokkaido');
        insert addr;
        //added address reference to address 
        Account objacc = new Account(id = objAccount.id, Primary_Address_Reference__c = addr.id); 
        update objacc;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        objAccount3= new Account();
        objAccount3.RecordtypeId=personAccRecordTypeId;
        objAccount3.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount3.Status__c='Active';
        objAccount3.Province__c='Province1';
        objAccount3.City__c='Test';
        objAccount3.ZipCode__c = '1063723';
        objAccount3.Email__c='test@mbj.com';
        objAccount3.Mobile__c ='0435488899';
        objAccount3.Phone = '08022420181';
        objAccount3.Main_Dealer__c = DealerAccount.id;
        objAccount3.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount3;
        
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        insert lead1;
        
        
        lead2 = new lead__C();
        lead2.MD__c = 'JP';
        lead2.Contact__c = objAccount.id;
        lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'New';
        insert lead2;
        
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'Approved';
        lead3.Lead_Assignment_Notification_Done__c = false;
        insert lead3;
           
        
        AccLink = new Account_Link__c();
        AccLink.fromRole__c = objAccount.id;
        AccLink.toRole__c = DealerAccount.id;        
        
        insert AccLink; 
        
    }
    
     public static testMethod void testupdateCustomerStage()
    {  
       Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
      insert u;
      System.runAs(u){
      Test.StartTest();
       List<Lead__C> listNewLeads=new List<Lead__C>();
     
       map<id,Lead__C> LeadNewMap=new map<id,Lead__C>();
       
        DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        listNewLeads.add(lead1);
        insert listNewLeads;
        
       lead__C listCampaign =[select id,Name,CAC_Lead_Status__c,Assigned_Dealer__c ,Contact__c,MD__c from lead__C where id IN:listNewLeads ];
         list<lead__C> oldList = new  list<lead__C>();
         oldList.add(listCampaign);
        map<id,lead__C> oldMap = new map<id,lead__C>();
         oldMap.put(listCampaign.id, listCampaign);
         
           lead1.CAC_Lead_Status__c = 'Approved';
           update lead1;
           update listNewLeads;
           
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'Approved';
        lead3.Lead_Assignment_Notification_Done__c = false;
        insert lead3;
           
        LeadNewMap.put(lead3.id,lead3);
        
        LeadHelperJP.updateCustomerStage(listNewLeads,oldMap,LeadNewMap);
         Test.StopTest();
       }
       
    }
     public static testMethod void createContactToContactAccounlinkTest()
    {  
       
     
       List<Lead__C> listNewLeads=new List<Lead__C>();
     
       map<id,Lead__C> LeadNewMap=new map<id,Lead__C>();
       
       set<id> contactIds=new set<id>();
       set<id> DealerIds=new set<id>();
       map<id,id> ContactDealerMap=new map<id,id>();
        Account companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                               
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
        insert companyacc;
        
       
        DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        DealerIds.add(DealerAccount.id);
        ContactDealerMap.put(DealerAccount.id,DealerAccount.id);
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        contactIds.add(objAccount.id);
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=objAccount.id,fromRole__c=DealerAccount.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Company_Account__c= companyacc.id;
        lead1.CAC_Lead_Status__c = 'New';
        listNewLeads.add(lead1);
        insert listNewLeads;
        
       lead__C listCampaign =[select id,Name,CAC_Lead_Status__c,Assigned_Dealer__c ,Contact__c,MD__c from lead__C where id IN:listNewLeads ];
         list<lead__C> oldList = new  list<lead__C>();
         oldList.add(listCampaign);
        map<id,lead__C> oldMap = new map<id,lead__C>();
         oldMap.put(listCampaign.id, listCampaign);
         
           
           
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'Approved';
        lead3.Lead_Assignment_Notification_Done__c = false;
        insert lead3;
           
        LeadNewMap.put(lead3.id,lead3);
        
        LeadHelperJP.createContactToContactAccounlink(listNewLeads);
       
       
    }
    
    public static testMethod void handleAfterInsertOrUpdateTest()
    {  
       Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
      insert u;
      System.runAs(u){
      
       List<Lead__C> listNewLeads=new List<Lead__C>();
     
       map<id,Lead__C> LeadNewMap=new map<id,Lead__C>();
       
        DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.Dealer_GC_Code__c='12345';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.salesLead_Notification_Timing__c='Immediately';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.Lead_Assignment_Notification_Done__c=false;
        lead1.Person_Assign_Notificaton_Done__c=false;
        lead1.Service_Advisor__c=u.id;
        lead1.recordTypeId =Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        listNewLeads.add(lead1);
        insert listNewLeads;
        
       lead__C listCampaign =[select id,Name,CAC_Lead_Status__c,Assigned_Dealer__c ,Contact__c,MD__c from lead__C where id IN:listNewLeads ];
         list<lead__C> oldList = new  list<lead__C>();
         oldList.add(listCampaign);
        map<id,lead__C> oldMap = new map<id,lead__C>();
         oldMap.put(listCampaign.id, listCampaign);
         system.debug('oldMap'+oldMap);
          system.debug('listNewLeads'+listNewLeads);
           lead1.CAC_Lead_Status__c = 'Approved';
           update lead1;
           update listNewLeads;
           
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'Approved';
        lead3.Lead_Assignment_Notification_Done__c = false;
        insert lead3;
           
        LeadNewMap.put(lead3.id,lead3);
        Test.StartTest();
        LeadHelperJP.EmailnotificationforLeads(listNewLeads,oldMap,true,false);
      
         Test.StopTest();
       }
       
    }
    public static testMethod void handleAfterInsertOrUpdateTest1()
    {  
       Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
      insert u;
      System.runAs(u){
      
       List<Lead__C> listNewLeads=new List<Lead__C>();
     
       map<id,Lead__C> LeadNewMap=new map<id,Lead__C>();
       
        DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.Dealer_GC_Code__c='12345';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.salesLead_Notification_Timing__c='Immediately';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.Lead_Assignment_Notification_Done__c=false;
        lead1.Person_Assign_Notificaton_Done__c=false;
        lead1.Service_Advisor__c=u.id;
        lead1.recordTypeId =Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        listNewLeads.add(lead1);
        insert listNewLeads;
        
       lead__C listCampaign =[select id,Name,CAC_Lead_Status__c,Assigned_Dealer__c ,Contact__c,MD__c from lead__C where id IN:listNewLeads ];
         list<lead__C> oldList = new  list<lead__C>();
         oldList.add(listCampaign);
        map<id,lead__C> oldMap = new map<id,lead__C>();
         oldMap.put(listCampaign.id, listCampaign);
         system.debug('oldMap'+oldMap);
          system.debug('listNewLeads'+listNewLeads);
           lead1.CAC_Lead_Status__c = 'Approved';
           update lead1;
           update listNewLeads;
           
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'Approved';
        lead3.Lead_Assignment_Notification_Done__c = false;
        insert lead3;
           
        LeadNewMap.put(lead3.id,lead3);
        Test.StartTest();
        LeadHelperJP.EmailnotificationforLeads(listNewLeads,oldMap,true,false);
        //LeadHelperJP.handleAfterInsertOrUpdate(listNewLeads,oldMap);
         Test.StopTest();
       }
       
    }
    
    
    
}