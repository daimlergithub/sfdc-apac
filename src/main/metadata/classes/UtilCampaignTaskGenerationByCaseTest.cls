@isTest
public class UtilCampaignTaskGenerationByCaseTest {

    public static testMethod void testUtilCampaignTaskGenerationByCase() {
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
    
Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
          AccountId = dealer.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
        );
        insert contact;
  
                     
                     
                     List<Campaign> ml = new List<Campaign>();
       for (Integer i=0;i<10;i++) {
           Campaign m = new Campaign(Name = 'top',Status = 'Started',StartDate = System.today(), EndDate = System.today(),Content_Preview__c='Test',Execution_Type__c='Segmentation Only',Flow_URL__c='test url');
           ml.add(m);
       }
       insert ml;
         
                     
                     List<CampaignMember> listcamp = new List<CampaignMember>();
                     for (Integer i=0;i<1;i++) {
                     CampaignMember ob1Member = new CampaignMember(
      CampaignId = top.Id,
      ContactId = contact.Id,
      Status = 'Send',Task_Generated__c=false
    );
          listcamp.add(ob1Member);
       }
       insert listcamp;
                            List<case> listcase = new List<case>();
for (Integer i=0;i<1;i++) {
                     Case c1 = new Case(Subject='',Status='Open',Case_Type__c='Others',Priority='yellow =3',Mileage__c=2);
          listcase.add(c1);
       }
       insert listcase;
       
                 Id jobId;
                 test.startTest();
          UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,jobId);
          Database.executeBatch(batcher);
          //Database.QueryLocator ql = batcher.start(null);
batcher.execute(null,listcase);

          test.stopTest();

          //     ID batchprocessid = Database.executeBatch(batcher);
        }
       }