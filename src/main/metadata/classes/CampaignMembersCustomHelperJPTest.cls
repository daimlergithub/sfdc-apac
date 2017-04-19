@istest
public class CampaignMembersCustomHelperJPTest
{
 public static Account accobj;
  public static Contact contobj;
  public static Campaign camobj;
  public static Retail_Campaign__c campobj;
  public static Campaign_Member__c cm;
  public static List<Participating_Dealer__c> padealerlist;
  public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id RetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  static void createTestData() {  
 
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
    accobj = new Account();
    accobj.FirstName = 'testaccount';
    accobj.lastName = 'testaccount';
    accobj.Email__c = 'Test@test.com';
    accobj.RecordTypeId = personAccRecordTypeId;
    //accobj.Name = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    campobj= new Retail_Campaign__c();
    campobj.RecordTypeId = RetailcentmarcampRecordTypeId;
    campobj.Name = 'camptest1';
    //campobj.Type = 'Other';
    //campobj.Status = 'Planned';
    //campobj.StartDate = System.today();
    //campobj.EndDate = System.today();
    //campobj.Campaign_Objectives__c = 'camobjectives';
    //campobj.Description = 'testdescrip';
    
    insert campobj;
    cm=new Campaign_Member__c();
    cm.Retail_Campaign_Id__c=campobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
  }
    
  public static testMethod void updateContactTest() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm);
    cm.Response_FirstName__c ='testaccount';
    cm.Response_LastName__c = 'testaccount';
    cm.Response_Email__c = 'Test@test.com';
   cm.Status__c = 'Responded';
   update cm;
 newMap.put(cm.Id , cm);
 newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
  public static testMethod void updateContactTest1() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm);   
      cm.Retail_Campaign_Id__c = campobj.Id;
       cm.Status__c = 'Responded';
       update cm;
     newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
  public static testMethod void updateContactTest2() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm); 
   cm.Response_FirstName__c ='testaccount1t';
    cm.Response_LastName__c = 'testaccount1s';
    cm.Response_Email__c = 'Testtre@test.com';
    update cm;
   newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
}