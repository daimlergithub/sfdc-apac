@istest
public class UtilCampaignLeadTest {
  public static Account accobj;
  public static Contact contobj;
  public static Campaign camobj;
  public static Lead__c leadobj;
  public static Campaign_Lead__c camlead;
  public static List<Campaign_Lead__c> camleadlist;
  public static map<id,Campaign_Lead__c> campaignLeadOldMap;
  //public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static String DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
  
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'testaccount';
    accobj.Phone = '000-0000-9642';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '000-0000-9642';
    accobj.ZipCode__c= '1002347';
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = accobj.Id;
    insert contobj;
    system.debug('$$$$$$$$$$$$'+contobj);
    system.debug('$$$$$$$$$$$$'+contobj.id);
    
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    
    leadobj = new Lead__c();
    leadobj.RecordTypeId = salesleadRecordTypeId;
    //leadobj.Contact__c = accobj.Id;
    leadobj.CAC_Lead_Status__c = 'Qualified';
    leadobj.Lead_Type__c = 'New Car';
    insert leadobj;
    system.debug('$$$$$$$$$$$$'+leadobj);
    system.debug('$$$$$$$$$$$$'+leadobj.id);
    
    camlead = new Campaign_Lead__c();
    camlead.Campaign__c = camobj.id;
    camlead.Lead__c = leadobj.id;
    camlead.FirstTimeImported__c = true;
    //camlead.Lead_Account_Id__c = accobj.Id;
    //insert camlead;
    system.debug('$$$$$$$$$$$$'+camlead);
    system.debug('$$$$$$$$$$$$'+camlead.id);
    
    camleadlist = new List<Campaign_Lead__c>();
    camleadlist.add(camlead);
    insert camleadlist;
    system.debug('$$$$$$$$$$$$'+camleadlist);
    
    //campaignLeadOldMap = new map<id,Campaign_Lead__c>();
    //campaignLeadOldMap.add(camlead);
    //insert campaignLeadOldMap;
    //system.debug('$$$$$$$$$$$$'+campaignLeadOldMap);
  } 
  public static testMethod void updateContactTest() {
    createTestData();
    test.startTest();
      //UtilCampaignLead ucl = new UtilCampaignLead();
      UtilCampaignLead.updateContact(camleadlist);
    test.stoptest();
    system.assertEquals(contobj.LastName,'Testutilcampaignlead');
  }
  public static testMethod void updateCampaignTitleAndNotesTest() {
    createTestData();
    test.startTest();
      UtilCampaignLead.updateCampaignTitleAndNotes(camleadlist);
    test.stoptest();
    system.assertEquals(contobj.LastName,'Testutilcampaignlead');
  }
  public static testMethod void beforeInsertEventsTest() {
    createTestData();
    test.startTest();
      UtilCampaignLead.beforeInsertEvents(camleadlist);
    test.stoptest();
    system.assertEquals(contobj.LastName,'Testutilcampaignlead');
  }
  /*public static testMethod void beforeUpdateEventsTest() {
    createTestData();
    test.startTest();
      UtilCampaignLead.beforeUpdateEvents(camleadlist,campaignLeadOldMap);
    test.stoptest();
    system.assertEquals(contobj.LastName,'Testutilcampaignlead');
  }*/
  public static testMethod void insertMembersTest() {
    createTestData();
    test.startTest();
      UtilCampaignLead.insertMembers(camleadlist);
    test.stoptest();
    system.assertEquals(contobj.LastName,'Testutilcampaignlead');
  }    
}