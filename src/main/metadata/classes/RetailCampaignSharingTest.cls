@isTest
private class RetailCampaignSharingTest {
    
    private static String RecordTypeIdRC = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
    private static Account dealer;
        private static Account dealer1;
    private static String en_US='en_US';
    private static List<RecordType> listRecordType;
    private static Retail_Campaign__c retailCampaign;
    private static Retail_Campaign__c retailCampaign1;
    private static Retail_Campaign__c retailCampaignsmart;
    private static Retail_Campaign__c retailCampaignAMG;
    public static Campaign camobj;
    public static Set<String> topCampaignIds;
    public static List<Retail_Campaign__c> listcampaigns;
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static set<Id> campid;
        private static List<Retail_Campaign__c> rclist; 
    private static Retail_Campaign__c retailCampaignStarElite;
     public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
       public static Id CampaignPlan = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
         public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();  
          public static Id MRID= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
         public static Id MonID=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Monthly TA').getRecordTypeId();
        public static Id ARID=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
    static {
        
          /* User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
            dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer',OwnerId = thisUser.Id);
            insert dealer;
    
            List<Contact> dealerContacts = new List<Contact>();
            Contact asContact = new Contact(FirstName = 'ASTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
            dealerContacts.add(asContact);
            Contact smContact = new Contact(FirstName = 'SMTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
            dealerContacts.add(smContact);
            Contact adminContact = new Contact(FirstName = 'AdminTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
            dealerContacts.add(adminContact);
            insert dealerContacts;*/
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2345@test.com',
                Alias = 'batman',
                Email='sai.waynedsse@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
             Database.insert(portalAccountOwner1);
             
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            //Create account
            List<Contact> dealerContacts = new List<Contact>();
            System.runAs(thisUser){
                RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
                dealer= new Account(
                    Name = 'TestAccount',
                    OwnerId = portalAccountOwner1.Id,
                    RecordTypeId = dealerType.Id
                );
                 dealer1= new Account(
                    Name = 'TestAccount',
                    OwnerId = portalAccountOwner1.Id,
                    RecordTypeId = dealerType.Id,
                     Retail_MB_Owner__c=portalAccountOwner1.id
                );
                Database.insert(dealer1);
                Database.insert(dealer);
                     
                //Create contact
                
                Contact asContact = new Contact(FirstName = 'ASTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
                dealerContacts.add(asContact);
                Contact smContact = new Contact(FirstName = 'SMTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
                dealerContacts.add(smContact);
                Contact adminContact = new Contact(FirstName = 'AdminTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
                dealerContacts.add(adminContact);
                insert dealerContacts;
                
            }
            List<User> userPortal = new List<User>();
            Profile portalProfile = [SELECT Id FROM Profile where Name ='Dealer Community User' Limit 1];
            User portalUser1 = new User(
            Username = System.now().millisecond() + 'test12Z345@test.com',
            ContactId = dealerContacts.get(0).Id,
            ProfileId = portalProfile.Id,
            Alias = 'test1234',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test1234510',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            userPortal.add(portalUser1 );
            portalUser1 = new User(
            Username = System.now().millisecond() + 'test123Y45@test.com',
            ContactId = dealerContacts.get(1).Id,
            ProfileId = portalProfile.Id,
            Alias = 'test1235',
            Email = 'test123456@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test123459',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            userPortal.add(portalUser1 );
            portalProfile = [SELECT Id FROM Profile where Name ='Dealer Delegate Admin' Limit 1];
            portalUser1 = new User(Username = System.now().millisecond() + 'test12348X5@test.com',
            ContactId = dealerContacts.get(2).Id,
            ProfileId = portalProfile.Id,
            Alias = 'test1236',
            Email = 'test1234568@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test123458',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            );
            userPortal.add(portalUser1 );
            
            
            insert userPortal;
            System.runAs(thisUser){
                 dealer.Retail_MB_Owner__c = userPortal.get(0).Id;
                 dealer.Retail_AS_Owner__c = userPortal.get(1).Id;
                 dealer.Retail_AMG_Owner__c = userPortal.get(2).Id;
                 //dealer.Retail_Star_Elite_Owner__c = userPortal.get(2).Id;
                 update dealer;
            }
        
        
       /* User smUser;
        User asUser;
        User adminUser;
        System.runAs ( thisUser ) {
            List<User> dealerUsers = new List<User>();
            Id UserRoleId=UtilTestData.getUserRoleId('Dealer User');
            system.debug('$$Role$$'+UserRoleId);
            Profile smProfile = [SELECT Id FROM Profile WHERE Name = 'Dealer Community User' Limit 1];
            smUser = new User(Username = 'test12345testsm@test.com', ContactId = smContact.Id, ProfileId = smProfile.Id,UserRoleId=userRoleId,Alias = 'testsm', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345m', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US, LanguageLocaleKey = en_US);       
            Profile asProfile = [SELECT Id FROM Profile WHERE Name = 'Dealer Community User' Limit 1];
            asUser = new User(Username = 'test12345testas@test.com',ContactId = asContact.Id,ProfileId = asProfile.Id,UserRoleId=userRoleId,Alias = 'testas', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345s', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US, LanguageLocaleKey = en_US);  
            dealerUsers.add(asUser);
            Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'Dealer Delegate Admin' Limit 1];
            adminUser = new User(Username ='test12345testadmin@test.com', ContactId = adminContact.Id,ProfileId =adminProfile.Id,UserRoleId=userRoleId,Alias = 'testadm', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345a', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US, LanguageLocaleKey = en_US);
            dealerUsers.add(adminUser);       
            insert dealerUsers;
        }
        dealer.Retail_MB_Owner__c = smUser.Id;
        dealer.Retail_AS_Owner__c = asUser.Id;
        dealer.Retail_AMG_Owner__c = adminUser.Id;
        dealer.Retail_Star_Elite_Owner__c = adminUser.Id;
        update dealer;*/
        
    }
    public static void preparedTestDataCustomsettings()
     {
        Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.Enable__c=true;
        cls.name='Community Enabled';
        insert cls;
    }
    
     public static void preparedTestData(){      
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
       insert updatecustomsettings;
       topCampaignIds = new Set<String>();
       listcampaigns=new list<Retail_Campaign__c>();
       
       Contact contact = new Contact(
           LastName = 'test Contact'
       );
       insert contact;
       
       Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),Segmentation_Date__c= System.today()+4,
            RecordTypeId = topCampRecordTypeId,
            Child_Campaign_Status__c = 'Execution' ,
            Set_List_Maintenance_Flag__c = false
        );
        insert top1;
                    
        Retail_Campaign__c rcobj=new Retail_Campaign__c();
        rcobj.Name='Test Campaign';
        rcobj.RecordTypeId=parentCampaignId;
        rcobj.Campaign_Execution_Channels__c='eMail';
        rcobj.Status__c='Draft';
        
        listcampaigns.add(rcobj);       
        insert listcampaigns;
        
        Retail_Campaign__c c = [Select Id from Retail_Campaign__c  Where Id =: listcampaigns[0].Id];
        /*Inserting Campaign member status*/
        CampaignMember cms = new CampaignMember(
            CampaignId = top1.Id,
            ContactId = contact.Id
            
        );
        insert cms;
    }
    @isTest 
    static void testWrapRetailCampaigns() {
        

     string strSubject;
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser ){
        Set<Id> campaignIDS = new Set<Id>(); 
        List<Campaign> camplst = new List<Campaign>();
        camplst = [select Id, BP_Quarter__c from Campaign];
        for(Campaign cp : camplst)  {
            campaignIDS.add(cp.Id);
        } 
        List<Retail_Campaign__c> retailCampaignck = new List<Retail_Campaign__c>();
        retailCampaignck = [select Dealer_Name__c,Y_Dealer_Name__c,Brand__c from Retail_Campaign__c]; 
        Map<id,Retail_Campaign__c> retailCampaignMap = new Map<id,Retail_Campaign__c>();
        Map<id,Retail_Campaign__c> retailCampaignMaps = new Map<id,Retail_Campaign__c>();
        
      //  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          //      insert updatecustomsettings;
        List<Trigger__c> updatecustomsettings = UtilCustomSettingsKernel.customSettingDetails();
insert updatecustomsettings;

        
            List<Retail_Campaign__c> retailCampaigns = new List<Retail_Campaign__c>();
            listRecordType= [select Id, DeveloperName from RecordType where SObjectType = 'Retail_Campaign__c'];
            system.debug('$$$listRecordType$$'+listRecordType);
            if(listRecordType != null && listRecordType.size() > 0){
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaign = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'MB',Campaign_Execution_Channels__c = 'eEmail');
                    retailCampaigns.add(retailCampaign);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignsmart = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'smart',Campaign_Execution_Channels__c = 'eEmail');
                    retailCampaigns.add(retailCampaignsmart);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignAMG = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'AMG',Campaign_Execution_Channels__c = 'eEmail');
                    retailCampaigns.add(retailCampaignAMG);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignStarElite = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'StarElite',Campaign_Execution_Channels__c = 'eEmail');
                    retailCampaigns.add(retailCampaignStarElite);
                }
                insert retailCampaigns;
            }
            
            Test.startTest();
            RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();        
            List<SharingWrapper> wrapRetailCampaigns=wrapService.wrapRetailCampaigns(retailCampaigns);
            RetailCampaignHelper RetailCampaigntest = new RetailCampaignHelper();
            RetailCampaignHelper.updateParentCampaignStatus(campaignIDS);
            RetailCampaignHelper.updateParentCampaignQuarter(campaignIDS);
            RetailCampaignHelper.ShareRecordToDealer_BeforeInsert(retailCampaignck);
            RetailCampaignHelper.ShareRecordToDealer_AfterUpdate(retailCampaignck, retailCampaignMap, retailCampaignMaps, false);
            RetailCampaignHelper.afterInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, false);
            RetailCampaignHelper.afterInsertUpdateEvents(retailCampaignck, retailCampaignMap, true, false);
            RetailCampaignHelper.afterInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, true);
            RetailCampaignHelper.afterInsertUpdateEvents(retailCampaignck, retailCampaignMap, true, true);
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, false);
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, true, false);
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, true);
            RetailCampaignHelper.parentRetailCampaignSatusChange(retailCampaignck, retailCampaignMap);
            RetailCampaignHelper.validationParentRetailCampaign(retailCampaignck, retailCampaignMap, false, true);
            RetailCampaignHelper.validationChildRetailCampaign(retailCampaignck, retailCampaignMap, false, true);
             RetailCampaignHelper.generateTask(thisUser, retailCampaign, strSubject);
           RetailCampaignHelper.generateHighPrioTask(thisUser, retailCampaign, strSubject);
        
            Test.stopTest();    
            system.assertNotEquals(null, wrapRetailCampaigns);
             //verify        
             Retail_Campaign__c retailCampaignCheck = [select Dealer_Name__c,Y_Dealer_Name__c,Brand__c from Retail_Campaign__c where id IN:retailCampaigns limit 1];  
                   system.assertEquals(retailCampaignCheck.Dealer_Name__c, retailCampaign.Dealer_Name__c);
        }
    }
    
     @isTest 
    static void testWrapRetailCampaigns2() {
        

     string strSubject;
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser ){
        Set<Id> campaignIDS = new Set<Id>(); 
        List<Campaign> camplst = new List<Campaign>();
        camplst = [select Id, BP_Quarter__c from Campaign];
        for(Campaign cp : camplst)  {
            campaignIDS.add(cp.Id);
        } 
        List<Retail_Campaign__c> retailCampaignck = new List<Retail_Campaign__c>();
        retailCampaignck = [select Dealer_Name__c,Y_Dealer_Name__c,Brand__c from Retail_Campaign__c]; 
        Map<id,Retail_Campaign__c> retailCampaignMap = new Map<id,Retail_Campaign__c>();
        Map<id,Retail_Campaign__c> retailCampaignMaps = new Map<id,Retail_Campaign__c>();
        
      //  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          //      insert updatecustomsettings;
        List<Trigger__c> updatecustomsettings = UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;
        
         retailCampaign = new Retail_Campaign__c(Dealer_Name__c = dealer1.Id,Region_Recommendation__c=false,Campaign_Execution_Channels__c = 'eEmail',Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer1.Id, RecordTypeId = RecordTypeIdRC, Brand__c = 'MB');
         insert retailCampaign;
        
         retailCampaign.Region_Recommendation__c=true;
         update retailCampaign; 
        
         //retailCampaign1= new Retail_Campaign__c(Yearly_TA__c=retailCampaign.id,Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer1.Id, RecordTypeId = RecordTypeIdRC, Brand__c = 'MB');
         //insert retailCampaign1;
        
        retailCampaignck.add(retailCampaign);
        
        for(Retail_Campaign__c rc :retailCampaignck )  {
            retailCampaignMap.put(rc.id, rc);
        }  
        
            Test.startTest();
            RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();        
            
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, false);
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, true, false);
            RetailCampaignHelper.beforeInsertUpdateEvents(retailCampaignck, retailCampaignMap, false, true);
            
            
             RetailCampaignHelper.generateTask(thisUser, retailCampaign, strSubject);
           RetailCampaignHelper.generateHighPrioTask(thisUser, retailCampaign, strSubject);
        
            Test.stopTest();
        }
    }
    
     static testmethod void MethodTest1(){
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
    campid =new set<Id>();
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.Segmentation_Date__c= System.today()+4;
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    campid.add(camobj.id);    
    
     Campaign_Member__c topMember = new Campaign_Member__c(
            Campaign_ID__c= camobj.Id,
                    
            Status__c = 'Ready'
        );
    
     insert topMember;
    
   Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rclist=new List<Retail_Campaign__c>();
    rclist.add(rcobj);
    
    Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign__c=camobj.id;
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rclist.add(rcobj1);
    insert rclist;
    
     Test.startTest();
     RetailCampaignHelper.afterInsertCopyRetailCampaign(rclist);
     RetailCampaignHelper.updateParentCampaignStatus(campid);
     RetailCampaignHelper.updateParentCampaignQuarter(campid);
     Test.stopTest();
    }
  } 
  static testmethod void MethodTestbefore(){
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
    campid =new set<Id>();
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.Segmentation_Date__c= System.today()+4;
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    campid.add(camobj.id);    
    
   
    
   Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rclist=new List<Retail_Campaign__c>();
    rclist.add(rcobj);
    
    Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rclist.add(rcobj1);
    insert rclist;
    
     Test.startTest();
     RetailCampaignHelper.beforeDeleteRetailCampaignStatus(rclist);
     RetailCampaignHelper.updateParentCampaignStatus(campid);
     RetailCampaignHelper.updateParentCampaignQuarter(campid);
     Test.stopTest();
    }
  }  
  
   static testmethod void MethodTest2()
   {
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
    campid =new set<Id>();
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.Segmentation_Date__c= System.today()+4;
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    campid.add(camobj.id);    
    
   
    
   Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=childCampaign;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Child_Campaign_Status__c='Execution';
    rclist=new List<Retail_Campaign__c>();
    rclist.add(rcobj);
    
    Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Status__c='Ongoing';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=parentCampaignId;
    rclist.add(rcobj1);
    insert rclist;
    
     Test.startTest();
     RetailCampaignHelper.beforeDeleteEvents(rclist);
     RetailCampaignHelper.updateParentCampaignStatus(campid);
     RetailCampaignHelper.updateParentCampaignQuarter(campid);
     Test.stopTest();
    }
  } 
  
  static testmethod void EmailMethodTest()
  {
    User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
    campid =new set<Id>();
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.Segmentation_Date__c= System.today()+4;
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    campid.add(camobj.id);    
    
   
    
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.OwnerId = thisUser.id;
    rclist=new List<Retail_Campaign__c>();
    
    
    Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign__c=camobj.id;
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rcobj1.OwnerId = thisUser.Id;
    rclist.add(rcobj1);
    insert rclist;
    
     Test.startTest();
     RetailCampaignHelper.emailNotificationRetail(rclist);
     RetailCampaignHelper.updateParentCampaignStatus(campid);
     RetailCampaignHelper.updateParentCampaignQuarter(campid);
     Test.stopTest();
    }
  }  
  
  @isTest static void testparent()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.OwnerId = thisUser.id;
    insert rcobj;
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rcobj1.OwnerId = thisUser.id;
    insert rcobj1;
      
     
        listcampaigns.add(rcobj1);
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN:listcampaigns ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
        rcobj1.Name='Response collection';
        update rcobj1;
      
     

     
        
        RetailCampaignHelper.parentRetailCampaignSatusChange(listcampaigns,oldMap);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
     
      @isTest static void testparent1()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.OwnerId = thisUser.id;
    insert rcobj;
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rcobj1.OwnerId = thisUser.id;
    insert rcobj1;
      
     
        listcampaigns.add(rcobj);
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN:listcampaigns ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
        rcobj.Status__c='Completed';
        update rcobj;
      
     

     
        
        RetailCampaignHelper.parentRetailCampaignSatusChange(listcampaigns,oldMap);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
     
     
      @isTest static void validationParentRetailCampaignTest()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.Start_Date__c=system.today()-1;
    rcobj.Close_Date__c=system.today()-2;
    rcobj.OwnerId = thisUser.id;
    
    insert rcobj;
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign__c=top2.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today();
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rcobj1.OwnerId = thisUser.id;
    insert rcobj1;
      
     
        listcampaigns.add(rcobj);
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN:listcampaigns ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
        rcobj.Status__c='Completed';
        update rcobj;
      
     

     
        
        RetailCampaignHelper.validationParentRetailCampaign(listcampaigns,oldMap,True,False);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
     
     
       @isTest static void validationChildRetailCampaignTest()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.Start_Date__c=system.today()+1;
    rcobj.Close_Date__c=system.today()+4;
    rcobj.OwnerId = thisUser.id;
    
    insert rcobj;
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today();
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=childCampaign;
    rcobj1.Response_Date__c=system.today()-1;
    rcobj1.OwnerId = thisUser.id;
    
    insert rcobj1;
      
     
        listcampaigns.add(rcobj1);
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN:listcampaigns ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
        rcobj1.Status__c='Completed';
        update rcobj1;
      
     

     
        
        RetailCampaignHelper.validationChildRetailCampaign(listcampaigns,oldMap,True,False);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
     
      @isTest static void afterInsertUpdateEventsTest()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
         insert dealer;
           Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2345@test.com',
                Alias = 'batman',
                Email='test1@gmail.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
                
            );
            insert portalAccountOwner1;
        
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        MonthlyRule__c MR= new MonthlyRule__c(Name='MonthlyRule',ATL_BTL__c='MRRRR',Brand__c='BMWW',Driven__c='YESSS',KPI_Type__c='True');
         insert MR;
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=parentCampaignId;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.Start_Date__c=system.today()+1;
    rcobj.Close_Date__c=system.today()+4;
    rcobj.OwnerId = thisUser.id;
    
    insert rcobj;
    
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today();
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=MRID;
    rcobj1.Response_Date__c=system.today()-1;
    rcobj1.OwnerId = thisUser.id;
    rcobj1.Y_Dealer_Name__c=dealer.id;
    insert rcobj1;
      
     
        listcampaigns.add(rcobj1);
         
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN:listcampaigns ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
        rcobj1.Status__c='Completed';
        update rcobj1;
      
     

     
        
        RetailCampaignHelper.afterInsertUpdateEvents(listcampaigns,oldMap,false,False);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
    /*@isTest static void afterInsertUpdateEventsTest1()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
         insert dealer;
          preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        MonthlyRule__c MR= new MonthlyRule__c(Name='MonthlyRule',ATL_BTL__c='MRRRR',Brand__c='BMWW',Driven__c='YESSS',KPI_Type__c='True');
         insert MR;
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=MRID;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.M_KPI_Type__c = 'Marketing Budget';
    rcobj.M_Brand__c = 'MB + StarElite';
    rcobj.Driven__c = 'Joint';
    rcobj.Start_Date__c=system.today()+1;
    rcobj.Close_Date__c=system.today()+4;
    rcobj.OwnerId = thisUser.id;
    
    insert rcobj;
    
    Retail_Campaign__c rcobj2=new Retail_Campaign__c();
    rcobj2.Name='Test Campaign';
    rcobj2.RecordTypeId=MRID;
    rcobj2.Campaign_Execution_Channels__c='eMail';
    rcobj2.Status__c='Draft';
    rcobj2.M_KPI_Type__c = 'Marketing Budget';
    rcobj2.M_Brand__c = 'MB + StarElite';
    rcobj2.Driven__c = 'Joint';
    rcobj2.Start_Date__c=system.today()+1;
    rcobj2.Close_Date__c=system.today()+4;
    rcobj2.OwnerId = thisUser.id;
    
   insert rcobj2;
   system.debug('rcobj2'+rcobj2);
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    //rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today();
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=MonID;
    rcobj1.M_KPI_Type__c = 'Marketing Budget';
    rcobj1.M_YearlyTA__c=rcobj2.id;
    rcobj1.M_Brand__c = 'MB + StarElite';
    rcobj1.Driven__c = 'Joint';
    rcobj1.Response_Date__c=system.today()-1;
    rcobj1.OwnerId = thisUser.id;
    rcobj1.Y_Dealer_Name__c=dealer.id;
   
      
        system.debug('rcobj1'+rcobj1);
        listcampaigns.add(rcobj1);
        
         insert listcampaigns;
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id =:listcampaigns[0].id ];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         
         system.debug('oldMap'+oldMap);
         system.debug('listcampaigns'+listcampaigns);
        
       RetailCampaignHelper.afterInsertUpdateEvents(listcampaigns,oldMap,true,False);
       
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }*/
      @isTest static void afterInsertUpdateEventsTest2()
     {
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
         insert dealer;
          preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
        listcampaigns=new List<Retail_Campaign__c>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = 'top', 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampaignPlan,
            IsActive = true
        );
        
        MonthlyRule__c MR= new MonthlyRule__c(Name='MonthlyRule',ATL_BTL__c='MRRRR',Brand__c='BMWW',Driven__c='YESSS',KPI_Type__c='True');
         insert MR;
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
    Retail_Campaign__c rcobj=new Retail_Campaign__c();
    rcobj.Name='Test Campaign';
    rcobj.RecordTypeId=MRID;
    rcobj.Campaign_Execution_Channels__c='eMail';
    rcobj.Status__c='Draft';
    rcobj.M_KPI_Type__c = 'Marketing Budget';
    rcobj.M_Brand__c = 'MB + StarElite';
    rcobj.Driven__c = 'Joint';
    rcobj.Start_Date__c=system.today()+1;
    rcobj.Close_Date__c=system.today()+4;
    rcobj.OwnerId = thisUser.id;
    
    insert rcobj;
    
    Retail_Campaign__c rcobj2=new Retail_Campaign__c();
    rcobj2.Name='Test Campaign';
    rcobj2.RecordTypeId=MRID;
    rcobj2.Campaign_Execution_Channels__c='eMail';
    rcobj2.Status__c='Draft';
    rcobj2.M_KPI_Type__c = 'Marketing Budget';
    rcobj2.M_Brand__c = 'MB + StarElite';
    rcobj2.Driven__c = 'Joint';
    rcobj2.Start_Date__c=system.today()+1;
    rcobj2.Close_Date__c=system.today()+4;
    rcobj2.OwnerId = thisUser.id;
    
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    //rcobj1.Parent_Campaign1__c=rcobj.id;
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today();
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=ARID;
    rcobj1.M_KPI_Type__c = 'Marketing Budget';
    rcobj1.Yearly_TA__c=rcobj.id;
    rcobj1.Apply_Status__c = 'Approved';
    rcobj1.Plan_Expense__c=58;
    rcobj1.M_Brand__c = 'MB + StarElite';
    rcobj1.Driven__c = 'Joint';
    rcobj1.Response_Date__c=system.today()-1;
    rcobj1.OwnerId = thisUser.id;
    rcobj1.Y_Dealer_Name__c=dealer.id;
    rcobj1.Plan_Start_Date__c=System.today();
    
      
     
        listcampaigns.add(rcobj1);
        listcampaigns.add(rcobj2);
         insert listcampaigns;
         
        Retail_Campaign__c listCampaign =[select Name,Status__c,Parent_Campaign__c,Execution_Start_Date__c,Execution_Type__c,Segmentation_Date__c,RecordTypeId,OwnerId,Campaign_Execution_Channels__c from Retail_Campaign__c where id =:listcampaigns[0].id];
         list<Retail_Campaign__c> oldList = new  list<Retail_Campaign__c>();
         oldList.add(listCampaign);
        map<id,Retail_Campaign__c> oldMap = new map<id,Retail_Campaign__c>();
         oldMap.put(listCampaign.id, listCampaign);
         system.debug('oldMap'+oldMap);
         system.debug('listcampaigns'+listcampaigns);
         if(listcampaigns==null)
         {
         RetailCampaignHelper.afterInsertUpdateEvents(listcampaigns,oldMap,true,False);
          }
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }

}
