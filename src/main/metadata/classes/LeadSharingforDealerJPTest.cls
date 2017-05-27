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
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
  public static Id retailpersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
  public static Id ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(); 
  
  static void createTestData() {
  Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System administrator' LIMIT 1];
    
    User u = new User(LastName = 'testUser',
    FirstName='first',
    Alias = 'fTest',
    Email = 'testUser@test.com',
    Username = 'testclassdata-daimler-APAC'+System.now().millisecond()+'@test.com',
    ProfileId = profileId.id,
    TimeZoneSidKey = 'GMT',
    LanguageLocaleKey = 'en_US',
    EmailEncodingKey = 'UTF-8',
    LocaleSidKey = 'en_US'
    );
    
    insert u; 
    
    User testUser2 = new User(LastName = 'testUser2',
    FirstName='first',
    Alias = 'fTest',
    Email = 'testUser2@test.com',
    Username = 'testClassUser2@test.com',
    ProfileId = profileId.id,
    TimeZoneSidKey = 'GMT',
    LanguageLocaleKey = 'en_US',
    EmailEncodingKey = 'UTF-8',
    LocaleSidKey = 'en_US'
    );
    insert testUser2;
    
    //user u = [select id from user where profile.Name = 'system administrator' and id !=:userinfo.getuserid() LIMIT 1 ] ;
    system.runas(u){
        accobj = new Account();
        accobj.RecordTypeId = DealerRecordTypeId;
        accobj.Name = 'testaccount';
        accobj.Phone = '000-0000-9642';
        accobj.MBK_Data_Source__c='Email';
        accobj.Mobile__c = '000-0000-9642';
        accobj.ZipCode__c= '1002347';
        accobj.OwnerId = UserInfo.getUserId();
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
        
      }  
        
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
      LeadSharingforDealerJP.LeadSharing_Dealer(leadlist,leadOldMap,true,true);
    test.stoptest();
    system.assertEquals(leadobj.Lead_Type__c,'New Car'); 
  } 
  
  //Code added By Bharath Reddy 
  public static testmethod void TestLeadSharingforDealer() {
    leadOldMap = new map<id,Lead__c>();
    createTestData();
    test.starttest();
      //for Insert
      list<Lead__c> lstLead = [Select id,CAC_Lead_Status__c,Recordtype.Name ,RecordtypeId,Assigned_Dealer__r.OwnerId,Assigned_Dealer__c FROM Lead__c ];
      LeadSharingforDealerJP.LeadSharingforDealer(lstLead ,null,true,false);
      //for Update
      user ui = [select id from user where email = 'testUser2@test.com'];
      accobj.OwnerId = ui.Id;
      update accobj;
      list<Lead__c> lstLeadUpdate = [Select id,CAC_Lead_Status__c,Recordtype.Name ,RecordtypeId,Assigned_Dealer__r.OwnerId,Assigned_Dealer__c FROM Lead__c ];
      
      for(Lead__c objlead : lstLead ){
          leadOldMap.put(objlead.Id,objlead  );
      }
      
      LeadSharingforDealerJP.LeadSharingforDealer(lstLeadUpdate ,leadOldMap,false,true);
    test.stoptest();
    list<Lead__Share > lstLeadsare = [select id from Lead__Share ];
    system.assert(lstLeadsare.size() > 0); 
      
  } 
  
   
}