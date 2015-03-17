@isTest
public class UtilCampaignTaskGenerationByVehicleTest {

    public static testMethod void testUtilCampaignTaskGenerationByVehicle() {
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
   String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
Account account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '80801011',
                                    Area_Code__c = '010',            
                                    Name = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    RecordTypeId=accPerson_RecordTypeIdp);
                                    insert account2;
  
                     
                     
                     List<Campaign> ml = new List<Campaign>();
       for (Integer i=0;i<10;i++) {
           Campaign m = new Campaign(Name = 'top',Status = 'Started',StartDate = System.today(), EndDate = System.today(),Content_Preview__c='Test',Execution_Type__c='Segmentation Only',Flow_URL__c='test url');
           ml.add(m);
       }
       insert ml;
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
                                                insert vehicles;
         
                     
                     List<Vehicle_Relationship__c> listcamp = new List<Vehicle_Relationship__c>();
                     for (Integer i=0;i<1;i++) {
                     Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
          listcamp.add(ob1Member);
       }
       insert listcamp;
       
       
                 Id jobId;
                 test.startTest();
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(ml,jobId);
          Database.executeBatch(batcher);
          //Database.QueryLocator ql = batcher.start(null);
batcher.execute(null,listcamp);

          test.stopTest();

          //     ID batchprocessid = Database.executeBatch(batcher);
        }
       }