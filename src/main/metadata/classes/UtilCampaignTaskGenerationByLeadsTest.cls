@isTest
public class UtilCampaignTaskGenerationByLeadsTest {

 Private static string retailLeadType =Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
 Private static string accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();     // Dealer.
 Private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
  Private static Account account2;
 Private static Contact contact;
 Private static Lead__c lead;
 Private static List<Campaign> ml;
Private static Account dealer;
Private static List<Campaign_Lead__c> listcamplead ;

    public static void preparedTestData()
    {
        
    dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
    account a=new account();
    a.name='test';
    a.Allow_Data_Sharing__c='no';
    a.RecordTypeId=accPerson_RecordTypeId;
    insert a; 
    
    account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '080101189',
                                    Area_Code__c = '010',            
                                    lastName = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='1001014',
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
        lead.Relation_With_The_Leads__c = 'tester';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testtrade';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.RecordTypeId=retailLeadType;
        insert lead;
                     
                     
                      ml = new List<Campaign>();
       for (Integer i=0;i<10;i++) {
           Campaign m = new Campaign(Name = 'top',Status = 'Started',StartDate = System.today(), EndDate = System.today(),Content_Preview__c='Test cont',Execution_Type__c='Segmentation Only',Flow_URL__c='test url');
           ml.add(m);
       }
       insert ml;
         
                     
                      listcamplead = new List<Campaign_Lead__c>();
                     for (Integer i=0;i<1;i++) {
                     Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true);
          listcamplead.add(ob1Member);
       }
       insert listcamplead;
       
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
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                 
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                newUsers.add(usr);
            }
            
            insert newUsers;
        }
    
           String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();

            Campaign top = new Campaign(
      IsActive = true, 
      Name = 'top', 
      Status = 'Started', 
      StartDate = System.today(), 
      EndDate = System.today(),
      RecordTypeId = topCampRecordTypeId
    );
    insert top;
   preparedTestData();

                 Id jobId;
                 test.startTest();
          UtilCampaignTaskGenerationByLeads  batcher= new UtilCampaignTaskGenerationByLeads(ml,jobId);
          Database.executeBatch(batcher);
          batcher.execute(null,listcamplead);
          test.stopTest();       
          System.assertNotEquals(null,listcamplead);   
        }
       }