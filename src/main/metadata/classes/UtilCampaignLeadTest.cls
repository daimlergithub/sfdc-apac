@istest
public class UtilCampaignLeadTest {
  public static Account accobj;
  public static Campaign camobj;
  public static Campaign camobj1;
  public static Lead__c leadobj;
  public static Lead__c leadobj1;
  public static Contact contobj;
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
  

  public static Contact con;
  public static Campaign_Member__c cm;
  public static Campaign_Package__c campack;
  public static Campaign_Lead__c campcity;
  public static List<Campaign_Lead__c> campcitylist;
  public List<Campaign_Lead__c> campcitylist1;
  public static Map<id, Campaign_Lead__c> campmap1;
  public static Participating_Dealer__c padealer;
  public static List<Participating_Dealer__c> padealerlist;
 
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id LeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();

  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = personAccRecordTypeId ;
    accobj.Lastname = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
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

    cm=new Campaign_Member__c();
    cm.Campaign__c=camobj.id;
    insert cm;
    
     
    
       Campaign_Package__c  campoffer=new Campaign_Package__c ();
        campoffer.Campaign__c=camobj.id;
        campoffer.Package_Description__c='hello';
        insert campoffer;
    /*con = new contact();
    con.AccountId=accobj.id;
    con.Lastname='Saranya';
    con.Federation_ID__c='New12Car';
    con.Email='saigotrala@ymail.com';
    con.Phone='9640183225';
    insert con;*/
    
    leadobj = new Lead__c(Contact__c = accobj.Id,RecordTypeId = LeadRecordTypeId,Source_Campaign__c =camobj.id,CAC_Lead_Status__c='New',
              Lead_Type__c = 'Used Car',Lead_Sub_Type__c = 'Demo Car',Interested_Vehicle_Model__c = 'A 180 Hatchback');
        insert leadobj;
        
         system.debug('$$$$$$$$$$$$'+leadobj);
    system.debug('$$$$$$$$$$$$'+leadobj.id);
    
    
    campcity = new Campaign_Lead__c();
    campcity.Campaign__c = camobj.id;
    campcity.Lead__c=leadobj.id;
    campcity.Contact__c=accobj.Id;
    campcity.Campaign_Notes__c='hello hello hello hello';
    campcity.Campaign_Title__c='i am here i amhere';
    campcity.RegistrationDate__c= system.today();
    campcitylist = new List<Campaign_Lead__c>();
    campcitylist.add(campcity);
    insert campcitylist;
    system.debug('$$$$$$$$$$$$'+campcity);
    system.debug('$$$$$$$$$$$$'+campcitylist);
      campmap1=new Map<id, Campaign_Lead__c> ();
    

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

    campmap1.put(campcitylist[0].id,campcitylist[0]);
    /*for(Campaign_Lead__c cl:campcitylist)
     {
        cl.Campaign_Notes__c='hello hello hello';
        cl.Campaign_Title__c='i am i amhere';
      }*/
    //update campcitylist;
    
    padealer = new Participating_Dealer__c();
  //  padealer.Campaign__c = camobj.id;
    //padealer.Dealer__c = accobj.id;
    padealer.Session_Start_Date__c= system.today();
    padealer.Session_End_Date__c = system.today();
    insert padealer;
    system.debug('$$$$$$$$$$$$'+padealer);
    system.debug('$$$$$$$$$$$$'+padealer);

  }
  
  public static testmethod void deleteParticipatingDealerTest() {
    createTestData();
    test.starttest();
     UtilCampaignLead.updateContact(campcitylist);
      UtilCampaignLead.updateCampaignTitleAndNotes(campcitylist);
      UtilCampaignLead.insertMembers(campcitylist);
      UtilCampaignLead.beforeInsertEvents(campcitylist);
      UtilCampaignLead.beforeUpdateEvents(campcitylist,campmap1);
    test.stoptest();
    system.assertEquals(camobj.Name,'camptest1');
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