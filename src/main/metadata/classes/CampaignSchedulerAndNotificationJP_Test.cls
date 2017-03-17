@istest
public class CampaignSchedulerAndNotificationJP_Test {
  public static Campaign camobj;
  public static Campaign_Package__c campacknew;
  public static Campaign_Package__c campackold;
  public static List<Campaign_Package__c> campacklistnew;
  public static List<Campaign_Package__c> campacklistold;
  public static User usr;
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  
  static void createTestData() {
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Execution_Start_Date__c = Date.Today();
    camobj.Execution_Type__c =  'OB Call';
    camobj.Child_Campaign_Status__c = 'Planning';
    camobj.Description = 'testdescrip';
    camobj.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj;
   camobj.Child_Campaign_Status__c = 'Segmentation';
   update camobj;
  }
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest() {
    
    test.starttest();
createTestData();
     CampaignSchedulerAndNotificationJP batcher = new CampaignSchedulerAndNotificationJP();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
  
 
    
  }
}