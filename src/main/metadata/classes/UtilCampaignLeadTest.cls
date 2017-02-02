@istest
public class UtilCampaignLeadTest {
  public static Account accobj;
  public static Contact contobj;
  public static Campaign camobj;
  public static Campaign camobj1;
  public static Lead__c leadobj;
  public static Lead__c leadobj1;
  public static Campaign_Lead__c camlead;
  public static Campaign_Lead__c camlead1;
  public static Campaign_Lead__c camlead2;
  public static List<Campaign_Lead__c> camleadlist;
  public static List<Campaign_Lead__c> camleadlist1;
  public static CampaignMember member;
  public static List<CampaignMember> memberlist;
  public static String DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id aftersalesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
  
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
    leadobj.CAC_Lead_Status__c = 'Qualified';
    leadobj.Lead_Type__c = 'New Car';
    insert leadobj;
    system.debug('$$$$$$$$$$$$'+leadobj);
    system.debug('$$$$$$$$$$$$'+leadobj.id);
    
    camlead = new Campaign_Lead__c();
    camlead.Campaign__c = camobj.id;
    camlead.Lead__c = leadobj.id;
    camlead.FirstTimeImported__c = true;
    system.debug('$$$$$$$$$$$$'+camlead);
    system.debug('$$$$$$$$$$$$'+camlead.id);
    
    camleadlist = new List<Campaign_Lead__c>();
    camleadlist.add(camlead);
    insert camleadlist;
    system.debug('$$$$$$$$$$$$'+camleadlist);
    
    member = new CampaignMember();
    member.CampaignId = camobj.id;
    member.ContactId = contobj.id;
    member.Status = 'Send';
    member.Task_Generated__c=false;
    member.Registration_Notes__c='Testmember';
    insert member;
    system.debug('$$$$$$$$$$$$'+member);
    system.debug('$$$$$$$$$$$$'+member.id);
  } 
  public static testMethod void updateContactTest() {
    createTestData();
    test.startTest();
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
    camlead1 = new Campaign_Lead__c();
    camlead1.Campaign__c = camobj.id;
    camlead1.Lead__c = leadobj.id;
    camlead1.FirstTimeImported__c = true;
    insert camlead1;
    system.debug('$$$$$$$$$$$$'+camlead1);
    system.debug('$$$$$$$$$$$$'+camlead1.id);
    Map<id,Campaign_Lead__c> campaignLeadOldMap = new Map<id,Campaign_Lead__c>();
    campaignLeadOldMap.put(camlead1.id,camlead1);
    
    leadobj1 = new Lead__c();
    leadobj1.RecordTypeId = salesleadRecordTypeId;
    leadobj1.CAC_Lead_Status__c = 'Qualified';
    leadobj1.Lead_Type__c = 'New Car';
    insert leadobj1;
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = centmarcampRecordTypeId;
    camobj1.Name = 'camptestone';
    camobj1.Type = 'Other';
    camobj1.Status = 'Planned';
    camobj1.StartDate = System.today();
    camobj1.EndDate = System.today();
    camobj1.Campaign_Objectives__c = 'camobjectives';
    camobj1.Description = 'testdescrip';
    insert camobj1;
    
    camlead2 = new Campaign_Lead__c();
    camlead2.Campaign__c = camobj1.id;
    camlead2.Lead__c = leadobj1.id;
    camlead2.FirstTimeImported__c = true;
    system.debug('$$$$$camlead2$$$$$$$'+camlead2);
    
    camleadlist1 = new List<Campaign_Lead__c>();
    camleadlist1.add(camlead2);
    insert camleadlist1;
    system.debug('$$$$$$$$campaignlist1'+camleadlist1);
    system.debug('$$$$$$$$campaignLeadOldMap'+campaignLeadOldMap);
    test.startTest();
      UtilCampaignLead.beforeUpdateEvents(camleadlist1,campaignLeadOldMap);
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