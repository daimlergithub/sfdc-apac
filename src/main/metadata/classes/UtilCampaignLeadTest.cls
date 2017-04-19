@istest
public class UtilCampaignLeadTest {
  public static Account accobj;
  public static Campaign camobj;
  public static Lead__c leadobj;
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
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
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
}