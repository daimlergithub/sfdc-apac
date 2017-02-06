@istest
public class ShareAccountRecordTest {
  public static Account accobj;
  public static case caseobj;
  public static List<Case> caselist;
  public static Group groupobj;
  public static List<Group> grouplist;
  public static Accountshare accsha;
  public static List<AccountShare> accshrList;
  public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
  
  static void createTestdata() {
    accobj = new Account();
    accobj.RecordTypeId = dealerRecordtypeid;
    accobj.Name = 'testaccount';
    accobj.Phone = '000-0000-9842';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '000-0000-9642';
    insert accobj;
    system.debug('$$$$$accobj$$$$$$$'+accobj);
    system.debug('$$$$$accobj.id$$$$$$$'+accobj.id);
  
    caseobj = new Case();
    caseobj.RecordTypeId = MBRecordTypeId;
    caseobj.Case_Department__c = 'testcase';
    caseobj.Case_Dealer__c = accobj.id;
    caseobj.Description = 'testdes';
    caseobj.Case_Type__c = 'testcasetype';
    caseobj.Case_SubType__c = 'test case subtype';
    caseobj.Case_Source__c = 'test case source';
    caseobj.Accountid = accobj.id;
    //insert Caseobj;
    system.debug('$$$$$$$$caseobj$$$$$$$$$'+caseobj);
    //system.debug('$$$$$$$$$$$$$$$$$'+caseobj.id);
    caselist = new list<case>();
    caselist.add(caseobj);
    insert caselist;
    system.debug('$$$$$$$$caselist$$$$$$$$$'+caselist);
    
    groupobj = new Group();
    groupobj.Name = 'testaccount';
    //insert groupobj;
    grouplist = new List<Group>();
    grouplist.add(groupobj);
    insert grouplist;
    system.debug('$$$$$$$$groupobj$$$$$$$$$'+groupobj);
    system.debug('$$$$$$$grouplist$$$$$$$$$$'+grouplist);
    
    accsha = new Accountshare();
    accsha.AccountAccessLevel = 'Read';
    accsha.OpportunityAccessLevel = 'Read';
    accsha.caseAccessLevel = 'Edit';
    accsha.AccountId = accobj.id;
    accsha.UserOrGroupId = groupobj.id;
    //insert accsha;
    accshrList = new List<AccountShare>();
    accshrList.add(accsha);
    insert accshrList;
    system.debug('$$$$$$$$accsha$$$$$$$$$'+accsha);
    system.debug('$$$$$$$accshrList$$$$$$$$$$'+accshrList);
  }
  public static testmethod void shareAccountRecordNowTest() {
    createTestData();
    List<Id> caseIds = new List<Id>();
    caseIds.add(caseobj.id);
    system.debug('$$$$$$$$caseIds$$$$$$$$$'+caseIds);
    test.starttest();
      shareAccountRecord.shareAccountRecordNow(caseIds);
    test.stoptest();
  }
}