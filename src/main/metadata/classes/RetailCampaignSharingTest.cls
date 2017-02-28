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
    private static Retail_Campaign__c retailCampaignStarElite;
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
                Username = 'test-daimler-APAC'+System.now().millisecond()+'@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
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
                    retailCampaign = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'MB');
                    retailCampaigns.add(retailCampaign);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignsmart = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'smart');
                    retailCampaigns.add(retailCampaignsmart);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignAMG = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'AMG');
                    retailCampaigns.add(retailCampaignAMG);
                }
                for(RecordType retailCampaignType :listRecordType) {
                    retailCampaignStarElite = new Retail_Campaign__c(Dealer_Name__c = dealer.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'StarElite');
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
        
         retailCampaign = new Retail_Campaign__c(Dealer_Name__c = dealer1.Id,Region_Recommendation__c=false,Y_Apply_Deadline__c=system.today(), Y_Dealer_Name__c = dealer1.Id, RecordTypeId = RecordTypeIdRC, Brand__c = 'MB');
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
}