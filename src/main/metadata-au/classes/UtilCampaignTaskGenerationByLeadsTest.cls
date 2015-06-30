@isTest
public with sharing class UtilCampaignTaskGenerationByLeadsTest {
    private static string retailLeadType =Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();    
    private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Lead__c lead;
    private static Account dealer;
    private static Account account2;
    private static Contact contact;
    static{
       dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);  
   
       account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '80801011',
                                    Area_Code__c = '010',            
                                    lastName = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    Salutation='Brother',
                                    FirstName='Test',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413',
                                    RecordTypeId=accPerson_RecordTypeIdp);
                                    insert account2;
    
      contact = new Contact(
          AccountId = dealer.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
        );
        insert contact;
  
        lead = new Lead__c();
       lead.Assigned_Dealer__c = dealer.Id;
       lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Allow_Data_Sharing__c=true;
        lead.Relation_With_The_Leads__c = 'test1';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'test2';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'test5';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.RecordTypeId=retailLeadType;
        lead.Contact__c=account2.id;
      // lead.Company_Account__c=dealer.Id;
        insert lead;
                     
        
    }

    public static testMethod void testUtilCampaignTaskGenerationByLeads() {
     List<User> newUsers = new List<User>();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        
            String[] csrProfiles = new String[]{'IntegrationAPI'};
            List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name In :csrProfiles];
            
            for(Profile p : profileIds){
                User usr = new User();
                usr.UserName = 'test3' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                 
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test7';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                newUsers.add(usr);
            }
            
            insert newUsers;
        }
    
          

            Campaign top = new Campaign(
      Name = 'top', 
      Status = 'Started', 
      StartDate = System.today(), 
      EndDate = System.today(),
      RecordTypeId = topCampRecordTypeId
    );
    insert top;
    

    

                     
                     List<Campaign> ml = new List<Campaign>();
       for (Integer i=0;i<10;i++) {
           Campaign m = new Campaign(Name = 'top',Status = 'Started',StartDate = System.today(), EndDate = System.today(),Content_Preview__c='Test',Execution_Type__c='Segmentation Only',Flow_URL__c='test url');
           ml.add(m);
       }
       insert ml;
         
                     
                     List<Campaign_Lead__c> listcamplead = new List<Campaign_Lead__c>();
                     for (Integer i=0;i<1;i++) {
                     Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true);
          listcamplead.add(ob1Member);
       }
       insert listcamplead;
       
                 Id jobId;
                 test.startTest();
          UtilCampaignTaskGenerationByLeads  batcher= new UtilCampaignTaskGenerationByLeads(ml,jobId);
          Database.executeBatch(batcher);
          //Database.QueryLocator ql = batcher.start(null);
          batcher.execute(null,listcamplead);

          test.stopTest();
        system.assertNotEquals(null, ml);

          //     ID batchprocessid = Database.executeBatch(batcher);
        }
    
    
    
       }