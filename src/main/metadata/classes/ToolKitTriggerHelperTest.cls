@istest
public class ToolKitTriggerHelperTest {
  public static Account accobj;
  public static Account accobj1;
  public static Tool_Kit__c tollkitobjevent;
  public static Tool_Kit__c tollkitobjevent1;
  public static Tool_Kit__c tollkitobjmedia;
  public static Tool_Kit__c tollkitobjsmartevent;
  public static List<Tool_Kit__c> tollkitlist;
  public static List<Tool_Kit__c> tollkitlistnew;
  public static Task taskobj;
  public static List<Task> tasklist;
  public static User usr;
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id EventRecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(); 
  public static Id MediaRecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Media').getRecordTypeId(); 
  public static Id smartEventRecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
  public static Id genraltaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
  
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
    
    accobj1 = new Account();
    accobj1.RecordTypeId = DealerRecordTypeId;
    accobj1.Name = 'accountone';

    accobj1.Phone = '000-0000-9333';
    accobj1.MBK_Data_Source__c='Campaign';
    accobj1.Mobile__c = '000-0000-9333';

    accobj1.ZipCode__c= '3333333';
    insert accobj1;
    system.debug('$$$$$$$$$$$$'+accobj1);
    system.debug('$$$$$$$$$$$$'+accobj1.id);
    
    taskobj = new Task();
    taskobj.RecordTypeId = genraltaskRecordTypeId;
    taskobj.Status='open';
    taskobj.Activity_Status__c='Successful';
    taskobj.Generate_QC__c = true;
    //insert taskobj;
    tasklist = new List<Task>();
    tasklist.add(taskobj);
    insert tasklist;
    system.debug('$$$$$$$$$$$$'+taskobj);
    system.debug('$$$$$$$$$$$$'+taskobj.id);
    system.debug('$$$$$$$$$$$$'+tasklist);
  
    tollkitobjmedia = new Tool_Kit__c();
    tollkitobjmedia.RecordTypeId = MediaRecordTypeId;
    tollkitobjmedia.Name = 'TestMediatoolkit';
    tollkitobjmedia.Dealer_Name__c = accobj.id;
    tollkitobjmedia.Plan_Start_Date__c = System.today();
    tollkitobjmedia.Plan_End_Date__c = System.today();
    tollkitobjmedia.Original_Plan_Start_Date__c = System.today();
    tollkitobjmedia.Brand__c = 'MB';
    tollkitobjmedia.Media_Type__c = 'Broadcast';
    tollkitobjmedia.Media_Name__c = 'TestBroadcast';
    tollkitobjmedia.Deliver_Date__c = System.today();
    tollkitobjmedia.Plan_Expense__c = 33;
    tollkitobjmedia.Ad_Color__c = 'Colour';
    tollkitobjmedia.Ad_Format__c = 'Picture';
    tollkitobjmedia.Ad_Copy__c = 'picturebanner';
    tollkitobjmedia.Ad_Size_Width__c = 33;
    tollkitobjmedia.Ad_Size_Height__c = 33;
    tollkitobjmedia.Ad_Banner__c = 'Full Page';
    tollkitobjmedia.Bleed_Size_Width__c = 33;
    tollkitobjmedia.Bleed_Size_Height__c = 33;
    tollkitobjmedia.Bleed_Banner__c = 'Full Page (Vertical Layout)';
    //insert tollkitobjmedia;
    system.debug('$$$$$$$$$$$$$$'+tollkitobjmedia);
    system.debug('$$$$$$$$$$$$$$'+tollkitobjmedia.id);
    tollkitlist = new List<Tool_Kit__c>();
    tollkitlist.add(tollkitobjmedia);
    
    tollkitobjevent = new Tool_Kit__c();
    tollkitobjevent.RecordTypeId = EventRecordTypeId;
    tollkitobjevent.Name = 'TestEventtoolkit';
    tollkitobjevent.Dealer_Name__c = accobj1.id;
    tollkitobjevent.Plan_Start_Date__c = System.today();
    tollkitobjevent.Plan_End_Date__c = System.today();
    tollkitobjevent.Original_Plan_Start_Date__c = System.today();
    tollkitobjevent.Brand__c = 'AMG';
    tollkitobjevent.Event_Type__c = 'Road Show';
    tollkitobjevent.Event_Director__c = 'Testeventdir';
    tollkitobjevent.Event_Participant__c = 'Media';
    tollkitobjevent.Location__c = 'Outdoor';
    tollkitobjevent.Location_Size__c = 3;
    //insert tollkitobjevent;
    system.debug('$$$$$$$$$$$$$$'+tollkitobjevent);
    system.debug('$$$$$$$$$$$$$$'+tollkitobjevent.id);
    tollkitlist.add(tollkitobjevent);
    
    tollkitobjsmartevent = new Tool_Kit__c();
    tollkitobjsmartevent.Name = 'Testsmarteventtoolkit';
    //insert tollkitobjsmartevent;
    system.debug('$$$$$$$$$$$$$$'+tollkitobjsmartevent);
    system.debug('$$$$$$$$$$$$$$'+tollkitobjsmartevent.id);
    tollkitlist.add(tollkitobjsmartevent);
    insert tollkitlist;
    system.debug('$$$$$$$$$$$$$$'+tollkitlist);
    
    tollkitobjevent1 = new Tool_Kit__c();
    tollkitobjevent1.RecordTypeId = EventRecordTypeId;
    tollkitobjevent1.Name = 'TestEventtoolkitnew';
    tollkitobjevent1.Dealer_Name__c = accobj.id;
    tollkitobjevent1.Plan_Start_Date__c = System.today();
    tollkitobjevent1.Plan_End_Date__c = System.today();
    tollkitobjevent1.Original_Plan_Start_Date__c = System.today();
    tollkitobjevent1.Brand__c = 'smart';
    tollkitobjevent1.Event_Type__c = 'Test Drive';
    tollkitobjevent1.Event_Director__c = 'Testeventdir';
    tollkitobjevent1.Event_Participant__c = 'Media';
    tollkitobjevent1.Location__c = 'Outdoor';
    tollkitobjevent1.Location_Size__c = 3;
    
    tollkitlistnew = new List<Tool_Kit__c>();
    tollkitlistnew.add(tollkitobjevent1);
    insert tollkitlistnew;
    system.debug('$$$$$$$$$$$$$$$$$'+tollkitlistnew);
    
   Profile prof = [select Id from Profile where Name = 'IntegrationAPI'];
   usr = new User (ProfileId = prof.Id, isActive = true, Username='lai1@nttdata.com',LastName='sichaof',Email='sichao.lai@nttdata.com',Alias='laisc',CommunityNickname='barney1',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
  }
  
 /* static void createTestDataone() {
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
    
    accobj1 = new Account();
    accobj1.RecordTypeId = DealerRecordTypeId;
    accobj1.Name = 'accountone';
    accobj1.Phone = '000-0000-9333';
    accobj1.MBK_Data_Source__c='Campaign';
    accobj1.Mobile__c = '000-0000-9333';
    accobj1.ZipCode__c= '3333333';
    insert accobj1;
    system.debug('$$$$$$$$$$$$'+accobj1);
    system.debug('$$$$$$$$$$$$'+accobj1.id);

    tollkitobjme = new Tool_Kit__c();
    tollkitobjme.RecordTypeId = MediaRecordTypeId;
    tollkitobjme.Name = 'TestMediatool';
    tollkitobjme.Dealer_Name__c = accobj.id;
    tollkitobjme.Plan_Start_Date__c = System.today();
    tollkitobjme.Plan_End_Date__c = System.today();
    tollkitobjme.Original_Plan_Start_Date__c = System.today();
    tollkitobjme.Brand__c = 'StarElite';
    tollkitobjme.Media_Type__c = 'Broadcast';
    tollkitobjme.Media_Name__c = 'TestBroadcast';
    tollkitobjme.Deliver_Date__c = System.today();
    tollkitobjme.Plan_Expense__c = 33;
    tollkitobjme.Ad_Color__c = 'Colour';
    tollkitobjme.Ad_Format__c = 'Picture';
    tollkitobjme.Ad_Copy__c = 'picturebanner';
    tollkitobjme.Ad_Size_Width__c = 33;
    tollkitobjme.Ad_Size_Height__c = 33;
    tollkitobjme.Ad_Banner__c = 'Full Page';
    tollkitobjme.Bleed_Size_Width__c = 33;
    tollkitobjme.Bleed_Size_Height__c = 33;
    tollkitobjme.Bleed_Banner__c = 'Full Page (Vertical Layout)';
    insert tollkitobjme;
    
    tollkitobjmedi = new Tool_Kit__c();
    tollkitobjmedi.Dealer_Name__c = accobj1.id;
    update tollkitobjmedi;
  }*/
  public static testmethod void beforeInsertUpdateDeleteEventsTest() {
    createTestData();
    test.starttest();
      ToolKitTriggerHelper.beforeInsertUpdateDeleteEvents(tollkitlist,true);
      system.debug('$$$$$$$$$$$$$$$$$'+tollkitlist);
    test.stoptest();
    system.assertEquals(tollkitobjevent.Original_Plan_Start_Date__c,System.today());
  }
  public static testmethod void afterInsertUpdateDeleteEventsTest() {
    createTestData();
    test.starttest();
      Map<id,Tool_Kit__c> toolKitOldmap = new Map<id,Tool_Kit__c>();
      toolKitOldmap.put(tollkitobjmedia.id,tollkitobjmedia);
      system.debug('$$$$$$$$$$$$$$$$$'+toolKitOldmap);
      Map<id,Tool_Kit__c> toolKitNewmap = new Map<id,Tool_Kit__c>();
      toolKitNewmap.put(tollkitobjevent.id, tollkitobjevent);
      system.debug('$$$$$$$$$$$$$$$$$'+toolKitNewmap);
      ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(tollkitlist,tollkitlistnew,toolKitOldmap,toolKitNewmap,true,true,true);
      //ToolKitTriggerHelper.shareToolKit(toolKitOldmap,toolKitNewmap);
    test.stoptest();
    //system.assertEquals(tollkitobjevent.Original_Plan_Start_Date__c,System.today());
  }
  /*public static testmethod void shareToolKitTest() {
    createTestDataone();
    test.starttest();
      Map<id,Tool_Kit__c> toolKitOldmap = new Map<id,Tool_Kit__c>();
      toolKitOldmap.put(tollkitobjme.id,tollkitobjme);
      system.debug('$$$$$$$$$$$$$$$$$'+toolKitOldmap);
      Map<id,Tool_Kit__c> toolKitNewmap = new Map<id,Tool_Kit__c>();
      toolKitNewmap.put(tollkitobjmedi.id, tollkitobjmedi);
      system.debug('$$$$$$$$$$$$$$$$$'+toolKitNewmap);
      ToolKitTriggerHelper.shareToolKit(toolKitOldmap,toolKitNewmap);
    test.stoptest();
    //system.assertEquals(tollkitobjevent.Original_Plan_Start_Date__c,System.today());
  }*/
  public static testmethod void tollkiwrapandhandlerTest() {
    createTestData();
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
    //createTestDataone();
    test.starttest();
      TookKitSharingWrapService tsws = new TookKitSharingWrapService();
      tsws.wrapToolKits(tollkitlist);
      tsws.wrapBrandToolKits(tollkitlist);
      tsws.wrapToolKitsFor3rdPartyUsers(tollkitlist);

     /* ToolKitTriggerHandler tth = new ToolKitTriggerHandler();
      tth.handleTrigger(true,true,true,true,true);
      tth.handleIntegrationTrigger(true,true,true,true,true);*/
    test.stoptest();
    //system.assertEquals(tollkitobjevent.Original_Plan_Start_Date__c,System.today());
  }
}