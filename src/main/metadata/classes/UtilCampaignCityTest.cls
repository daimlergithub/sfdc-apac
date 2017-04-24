@istest
public class UtilCampaignCityTest {
  public static Account accobj;
  public static Campaign camobj;
  public static Campaign_Package__c campack;
  public static Campaign_City__c campcity;
  public static List<Campaign_City__c> campcitylist;
  public static Participating_Dealer__c padealer;
  public static List<Participating_Dealer__c> padealerlist;
  public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerAccRecordTypeId;
    accobj.Name = 'testaccount';
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
    
    campcity = new Campaign_City__c();
    campcity.Campaign__c = camobj.id;
    campcity.Start_Date__c = system.today();
    campcity.End_Date__c = system.today();
    campcitylist = new List<Campaign_City__c>();
    campcitylist.add(campcity);
    insert campcitylist;
    system.debug('$$$$$$$$$$$$'+campcity);
    system.debug('$$$$$$$$$$$$'+campcitylist);
    
    padealer = new Participating_Dealer__c();
    padealer.Campaign__c = camobj.id;
    padealer.Dealer__c = accobj.id;
    padealer.Session_Start_Date__c = system.today();
    padealer.Session_End_Date__c = system.today();
    insert padealer;
   
    system.debug('$$$$$$$$$$$$'+padealer);
    system.debug('$$$$$$$$$$$$'+padealer);
  }
  
  public static testmethod void deleteParticipatingDealerTest() {
    createTestData();
    test.starttest();
      UtilCampaignCity.deleteParticipatingDealer(campcitylist);
    test.stoptest();
    system.assertEquals(camobj.Name,'camptest1');
  }
}