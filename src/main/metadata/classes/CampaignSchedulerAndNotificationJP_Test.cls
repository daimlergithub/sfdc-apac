@istest
public class CampaignSchedulerAndNotificationJP_Test {
  public static Campaign camobj;
 public static Campaign_Member__c cm;
  public static Campaign camobj1;
 public static Campaign_Member__c cm1;
 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  

  static void createTestData() {
  
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+10;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Execution_Start_Date__c = Date.Today()+4;
    camobj.Segmentation_Date__c= Date.Today();
    camobj.Execution_Type__c =  'OB Call';
    camobj.Child_Campaign_Status__c = 'Segmentation';
    camobj.Description = 'testdescrip';
    camobj.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj;
   //camobj.Child_Campaign_Status__c = 'Segmentation';
   //update camobj;
    cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = centmarcampRecordTypeId;
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Status = 'Planned';
    camobj1.StartDate = System.today();
    camobj1.EndDate = System.today()+10;
    camobj1.Campaign_Objectives__c = 'camobjectives';
    camobj1.Execution_Start_Date__c = Date.Today()+4;
    camobj1.Segmentation_Date__c=system.today();
    camobj1.Execution_Type__c =  'Lead';
    camobj1.Child_Campaign_Status__c = 'Segmentation';
    camobj1.Description = 'testdescrip';
    camobj1.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj1;
  // camobj1.Child_Campaign_Status__c = 'Segmentation';
   //update camobj1;
    cm1=new Campaign_Member__c();
    cm1.Campaign_ID__c =camobj1.id;
    cm1.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm1;    
  }
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest() {
    
    test.starttest();
createTestData();
     CampaignSchedulerAndNotificationJP batcher = new CampaignSchedulerAndNotificationJP();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
  
 
    
  }
  
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest1() {
     
         test.starttest();
         
  
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+10;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Segmentation_Date__c=system.today();
    camobj.Execution_Start_Date__c = Date.Today()+4;
    camobj.Execution_Type__c =  'eMail';
    camobj.Child_Campaign_Status__c = 'Segmentation';
    camobj.Description = 'testdescrip';
    camobj.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj;
  
    cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = centmarcampRecordTypeId;
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Status = 'Planned';
    camobj1.StartDate = System.today();
    camobj1.EndDate = System.today()+10;
    camobj1.Campaign_Objectives__c = 'camobjectives';
    camobj1.Execution_Start_Date__c = Date.Today()+4;
    camobj1.Segmentation_Date__c=system.today();
    camobj1.Execution_Type__c =  'eMail';
    camobj1.Child_Campaign_Status__c = 'Segmentation';
    camobj1.Description = 'testdescrip';
    camobj1.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj1;
   
    cm1=new Campaign_Member__c();
    cm1.Campaign_ID__c =camobj1.id;
    cm1.Status__c = 'Ready';
    cm1.Auto_creation_of_leads__c=true;
    //cm.contact_Id__c = accobj.Id;   
    insert cm1;    

     CampaignSchedulerAndNotificationJP batcher = new CampaignSchedulerAndNotificationJP();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
  
 
    
  }
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest2() {
     
         test.starttest();
         
  
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+10;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Segmentation_Date__c=system.today();
    camobj.Execution_Start_Date__c = Date.Today();
    camobj.Execution_Type__c =  'eMail';
    camobj.Child_Campaign_Status__c = 'Segmentation';
    camobj.Description = 'testdescrip';
    camobj.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj;
  
    cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = centmarcampRecordTypeId;
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Status = 'Planned';
    camobj1.StartDate = System.today();
    camobj1.EndDate = System.today()+10;
    camobj1.Campaign_Objectives__c = 'camobjectives';
    camobj1.Execution_Start_Date__c = Date.Today();
    camobj1.Segmentation_Date__c=system.today();
    camobj1.Execution_Type__c =  'eMail';
    camobj1.Child_Campaign_Status__c = 'planning';
    camobj1.Description = 'testdescrip';
    camobj1.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj1;
   
    cm1=new Campaign_Member__c();
    cm1.Campaign_ID__c =camobj1.id;
    cm1.Status__c = 'Ready';
    cm1.Auto_creation_of_leads__c=true;
    //cm.contact_Id__c = accobj.Id;   
    insert cm1;    
    
    camobj1.Child_Campaign_Status__c ='Segmentation';
    update camobj1;
     CampaignSchedulerAndNotificationJP batcher = new CampaignSchedulerAndNotificationJP();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
  
 
    
  }
}
