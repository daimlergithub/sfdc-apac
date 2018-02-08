@isTest
public class Batch_CreateCampaignNotificationTest
{
    static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    static String topCampRecordTypeId1 = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    static String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    static Id RetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static testMethod void testAfterInsert()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        Test.startTest();       
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c = 'Email',
            Child_Campaign_Status__c = 'Segmentation',
            Execution_Start_Date__c = Date.Today(),
            RecordTypeId = topCampRecordTypeId1
        );
        
        insert top;
        
        Campaign cac = new Campaign(
            Name = 'cac', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = cacCampRecordTypeId,
            ParentId = top.Id
        );
        insert cac;
         
            Batch_CreateCampaignNotification batcher = new Batch_CreateCampaignNotification();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
         
    }
    public static testMethod void Batch_CampaignmemberInsertion_test()
    {
      Map<Id,Retail_campaign__c> retCamp = new Map<Id,Retail_campaign__c>();
      Set<id>cempId = new Set<id>();
      Account   DealerAccount= new Account();
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
        
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c = 'Email',
            
            Child_Campaign_Status__c = 'Segmentation',
            Execution_Start_Date__c = Date.Today(),
            RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
        cempId.add(top.id);
      
      Retail_Campaign__c campobj= new Retail_Campaign__c();
    campobj.RecordTypeId = RetailcentmarcampRecordTypeId;
    campobj.Name = 'camptest1';
   // campobj.Parent_Campaign1__c = top.id;
    campobj.MD__C = 'JP';
    
    
    insert campobj;
  Campaign_Member__c  cm=new Campaign_Member__c();
    cm.Retail_Campaign_Id__c=campobj.id;
    cm.Status__c = 'Ready';
    cm.Preferred_Dealer__c = DealerAccount.id;
    cm.Campaign_ID__c = top.id;
    //cm.contact_Id__c = accobj.Id;   
    insert cm;   
    test.starttest();
    retCamp.put(DealerAccount.id,campobj);
    Batch_CampaignmemberInsertion batcher = new Batch_CampaignmemberInsertion(retCamp,cempId);
            Database.executeBatch(batcher, 300);
     test.stoptest();
    }
}