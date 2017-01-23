@istest
public class LeadSharingforDealerJPTest {
  public static Account accobj;
  public static Contact contobj;
  public static Lead__c leadobj;
  public static List<Lead__c> leadlist;
  public static map<id,Lead__c> leadOldMap;
  public static Account_Link__c acclink;
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(); 
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
  public static Id retailpersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
  public static Id ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(); 
  
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId;
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
    contobj.Accountid = accobj.Id;
    insert contobj;
    system.debug('$$$$$$$$$$$$'+contobj);
    system.debug('$$$$$$$$$$$$'+contobj.id);
    
    leadobj = new Lead__c();
    leadobj.RecordTypeId = salesleadRecordTypeId;
    leadobj.CAC_Lead_Status__c = 'Approved';
    leadobj.Lead_Type__c = 'New Car';
    leadobj.MD__c = 'KR';
    leadobj.Assigned_Dealer__c = accobj.Id;
    //insert leadobj;
    system.debug('$$$$$$$$$$$$'+leadobj);
    leadlist = new LIst<Lead__c>();
    leadlist.add(leadobj);
    insert leadlist;
    system.debug('$$$$$$$$$$$$'+leadlist);
    
    acclink = new Account_Link__c(); 
    acclink.RecordTypeId = retailpersonRecordTypeId;
    acclink.Name = 'testaccounlink';
    acclink.fromRole__c = accobj.Id;
    acclink.toRole__c = accobj.Id;
    insert acclink;
    system.debug('$$$$$$$$$$$$'+acclink);
    system.debug('$$$$$$$$$$$$'+acclink.id);
  }
  public static testmethod void LeadSharingforDealerTest() {
    leadOldMap = new map<id,Lead__c>();
    createTestData();
    test.starttest();
      LeadSharingforDealerJP.LeadSharingforDealer(leadlist,leadOldMap,true,true);
    test.stoptest();
    system.assertEquals(leadobj.Lead_Type__c,'New Car');
  }
  public static testmethod void createAccountLinkRecordTest() {
    set<String> contactId = new set<String>();
    createTestData();
    test.starttest();  
      LeadSharingforDealerJP.LeadSharing_Dealer(leadlist);
    test.stoptest();
    system.assertEquals(leadobj.Lead_Type__c,'New Car'); 
  }   
}