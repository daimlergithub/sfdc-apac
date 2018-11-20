@isTest

public class Batch_RetailCampaignNotificationTest
{
    static String ParentCampID= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    static Id RetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Set<Id> RetailChildcampId = new Set<Id>();
    public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static Profile DealerProfile= [select Id from Profile where Name = 'Japan Dealer Sales Manager' limit 1];
    public static testmethod void executeBatch_RetailCampaignNotification()
    {
        test.starttest();
        
        Account DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Dealer_GC_Code__c='12345';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        insert DealerAccount;
        
         Contact   con = new Contact(AccountId = DealerAccount.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
       User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerProfile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            Market__c = 'JP',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,   
            Notification_Campaign__c='long text'         
        );
        Insert usr;
        
        Campaign camobj12 = new Campaign();
        camobj12.RecordTypeId = camIdPlan;
        camobj12.Name = 'camptest1';
        camobj12.Type = 'Other';
        camobj12.Status = 'Draft';
        camobj12.StartDate = System.today();
        camobj12.EndDate = System.today()+30;
        camobj12.Campaign_Executer__c='Retail';
        camobj12.Campaign_Objectives__c = 'camobjectives';
        camobj12.Description = 'testdescrip';
        camobj12.Campaign_Execution_Channels__c='eMail';
        camobj12.Campaign_Type__c = 'After Sales';
        insert camobj12;
        
         Retail_Campaign__c RParentCamp = new Retail_Campaign__c(
            name='ParentCamp',
            Start_Date__c=System.Today(),
            Close_Date__c=System.Today()+4,
            Status__c='Draft',
            RecordTypeId=ParentCampID
         );
         insert RParentCamp;
        Retail_Campaign__c RChildCamp = new Retail_Campaign__c(
            Name='ChildCamp',
            Parent_Campaign__c = camobj12.id,
            Execution_Start_Date__c=System.Today()+1,
             Segmentation_Date__c=System.Today(),
             Parent_Campaign1__c=RParentCamp.Id,
             Segmentation_Base__c='Customer',
             Execution_Type__c='eMail',
             RecordTypeId=RetailcentmarcampRecordTypeId,
             Dealer_Name__c=DealerAccount.id             
             );
             insert RChildCamp;
      
     RetailChildcampId.add(RChildCamp.Id);
    
      Batch_RetailCampaignNotification batcherntwo = new Batch_RetailCampaignNotification(RetailChildcampId);
       Database.executeBatch(batcherntwo, 1);
       test.stoptest();
    }
}