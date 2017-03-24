@istest
public class AttachmentAfterTriggerHandlerTest {
  public static Account accobj;
  public static Account accobj1;
  public static Case Caseobj;
  public static Case Caseobj1;
  public static List<Case> Caselist;
  public static Attachment attach;
  public static List<Attachment> attachlist;
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
  
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'galaxy1';
    accobj.ZipCode__c= '1002347';
    accobj.MBK_Data_Source__c='Email';
    //accobj.Mobile__c = '000-0000-9642';
    insert accobj;  
    
    accobj1 = new Account();
    accobj1.RecordTypeId = DealerRecordTypeId ;
    accobj1.Name = 'Testacc2';
    accobj1.ZipCode__c= '1002345';
    accobj1.MBK_Data_Source__c='Campaign';
    //accobj1.Mobile__c = '000-0000-9642';
    insert accobj1; 
    
    Caseobj = new Case();
    Caseobj.RecordTypeId = MBRecordTypeId;
    Caseobj.Case_Department__c = 'testcase';
    Caseobj.Description = 'testdes';
    Caseobj.Case_Type__c = 'testcasetype';
    Caseobj.Case_SubType__c = 'test case subtype';
    Caseobj.Case_Source__c = 'test case source';
    Caseobj.Accountid = accobj.id;
    Caseobj.Urgent__c = true;
    insert Caseobj;
    
    Caseobj1 = new Case();
    Caseobj1.RecordTypeId = MBRecordTypeId;
    Caseobj1.Case_Department__c = 'testcase1';
    Caseobj1.Description = 'testdes1';
    Caseobj1.Case_Type__c = 'testcasetype';
    Caseobj1.Case_SubType__c = 'test case subtype';
    Caseobj1.Case_Source__c = 'test case source';
    Caseobj1.Accountid = accobj.id;
    Caseobj1.Urgent__c = true;
    insert Caseobj1;
    Caselist = new List<Case>();
    Caselist.add(Caseobj1);
    system.debug('$$$$$$$$$$$$$$$$$'+Caselist);
    system.debug('$$$$$$$$$$$$$$$$$'+accobj.id);
    
    attach=new Attachment();    
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId=Caseobj.id;
    //insert attach;   
    attachlist = new List<Attachment>();
    attachlist.add(attach);
    insert attachlist;  
    system.debug('$$$$$$$$$$$$$$$$$'+attach.parentId);
    system.debug('$$$$$$$$$$$$$$$$$'+Caseobj.id);
    system.debug('$$$$$$$$$$$$$$$$$'+attach);
    system.debug('$$$$$$$$$$$$$$$$$'+attach.id);
    system.debug('$$$$$$$$$$$$$$$$$'+attachlist);
    
    /*attachlist = new List<Attachment>();
    attachlist.add(attach);
    insert attachlist;
    List<Attachment> attachments=[select id, name from Attachment where parent.id=:Caseobj.id];*/
  }
  public static testMethod void AttachmentAfterTriggerHandlerTest1() {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
    insert updatecustomsettings;

    Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
    User usr = new User(Alias = 'standt', Email='test@mbj.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id, 
                       TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
    //System.runAs(usr) {          
      test.startTest();    
        createTestData();   
        /*AttachmentAfterTriggerHandler ath = new AttachmentAfterTriggerHandler();
        ath.handleTrigger(true,true,true,true,true);
        ath.handleIntegrationTrigger(true,true,true,true,true);*/
        AttachmentAfterTriggerHandlerJP athJP = new AttachmentAfterTriggerHandlerJP();
        athJP.handleTrigger(true,true,true,true,true);
        athJP.handleIntegrationTrigger(true,true,true,true,true);
      test.stoptest();
      List<Attachment> attachments=[select id, name from Attachment where parent.id=:Caseobj.id];
      System.assertEquals(1, attachments.size());
    //} 
  }    
}