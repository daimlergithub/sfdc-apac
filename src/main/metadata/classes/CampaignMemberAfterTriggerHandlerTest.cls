@istest
public class CampaignMemberAfterTriggerHandlerTest {
  public static Account accobj;
  public static Contact contobj;
  public static Campaign camobj;
  public static Campaign campobj;
  public static CampaignMember member;
  public static CampaignMember member1;
  public static List<CampaignMember> memberlist;
  public static List<Participating_Dealer__c> padealerlist;
  public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  
  static void createTestData() {  
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
    accobj = new Account();
    accobj.RecordTypeId = DealerAccRecordTypeId;
    accobj.Name = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    //accobj.Mobile__c = '000-0000-9642';
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
    
    campobj= new Campaign();
    campobj.RecordTypeId = centmarcampRecordTypeId;
    campobj.Name = 'camptest1';
    campobj.Type = 'Other';
    campobj.Status = 'Planned';
    campobj.StartDate = System.today();
    campobj.EndDate = System.today();
    campobj.Campaign_Objectives__c = 'camobjectives';
    campobj.Description = 'testdescrip';
    insert campobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    //system.debug('$$$$$$$$$$$$'+camobj.id);
    
    member = new CampaignMember();
    member.Status = 'New';
    member.ContactId = contobj.id;
    member.CampaignId = campobj.id;
    insert member;
    
    /*member1 = new CampaignMember();
    member1.Status = 'Sent';
    member1.ContactId = contobj.id;
    member1.CampaignId = campobj.id;*/
    
    //insert member1;
    //memberlist = new List<CampaignMember>();
    //memberlist.add(member);
    //insert 
    //database.insert (memberlist,false);
  }
  
  public static testMethod void updateContactTest() {
    createTestData();
    test.startTest();
     
      CampaignMemberAfterTriggerHandler cth = new CampaignMemberAfterTriggerHandler();
      //cth.handleTrigger(true,true,true,true,true);
      cth.handleIntegrationTrigger(true,true,true,true,true);
    test.stoptest();
    //system.assertEquals(camobj.Name,'camptest1');
  }
}