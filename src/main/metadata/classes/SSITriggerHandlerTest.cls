@istest
public class SSITriggerHandlerTest {
  public static Account accobj;
  public static Account customer;
  public static Contact contobj;
  public static Task taskobj;
  public static List<Task> taskobjlist;
  public static SSI__c ssiold;
  public static Map<Id,SSI__c> ssinewmap;
  public static Map<Id,SSI__c> ssioldmap;
  
  public static User usr;
  public static User ssi_sv;
  public static Id ssitaskid = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
  public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
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
    
    contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = accobj.id;
    insert Contobj;
    system.debug('$$$$$contobj$$$$$$$'+contobj);
    system.debug('$$$$$contobj.id$$$$$$$'+contobj.id);
 
    // SSI Old Map
      
    ssiold = new SSI__c();
    ssiold.CustomerName__c = 'testcustomerold'; 
    ssiold.DealerName__c = 'Test Dealerold';
    ssiold.Status__c = 'Matched';
    ssiold.DealerCheck_Status__c = 'Pending';
    ssiold.CarModelCheck_Status__c = 'Pending';
    ssiold.Need_2nd_Survey__c = false;
    ssiold.HomeMobilePhone__c = '000-0000-8888';
    ssiold.OfficePhone__c = '000-0000-9999';
    ssiold.Mark__c = 'test';
    insert ssiold;
	 // SSI New Map

    
    ssiold.CustomerName__c = 'testcustomernew'; 
    ssiold.Status__c = 'Matched';
    ssiold.DealerCheck_Status__c = 'valid';
    ssiold.CarModelCheck_Status__c = 'valid';
    ssiold.HomeMobilePhone__c = '000-0000-9562';
    ssiold.OfficePhone__c = '000-0000-9842';
    ssiold.Mark__c = '';
    update ssiold;
    
    system.debug('$$$$$ssiold$$$$$'+ssiold);
    system.debug('$$$$$ssiold.id$$$$$'+ssiold.id);
    
    taskobj = new Task();
    taskobj.recordtypeid = ssitaskid;
    taskobj.Subject = '2nd Survey Call';
    taskobj.WhatId = ssiold.id;
    taskobj.HomeMobilePhone__c = '000-0000-9999';
    taskobj.OfficePhone__c = '000-0000-8888';
    taskobj.Status = 'Open';
    system.debug('$$$$$$taskobj$$$$$$'+taskobj);
    
    taskobjlist = new List<Task>();
    taskobjlist.add(taskobj);
    insert taskobjlist;
    system.debug('$$$$$$taskobjlist$$$$$$'+taskobjlist);
    
    Profile prof = [select Id from Profile where Name = 'System Administrator'];
    usr = new User (ProfileId = prof.Id, isActive = true, Username='lai1@nttdata.com',LastName='sichaof',Email='sichao.lai@nttdata.com',Alias='laisc',CommunityNickname='barney1',
                    TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
  }
    

    static testMethod void myUnitTest1() {
        
        ssi_sv = UtilTestData.createUser('SSI Supervisor','System Administrator');
        
        System.runAs ( ssi_sv ) {
                    
           
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;
            
            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched');
            insert ssi;
            Map<Id,SSI__c> newMap = new Map<Id,SSI__c>();
            Map<Id,SSI__c> oldMap = new Map<Id,SSI__c>();
            Test.startTest();
            SSITriggerHandler ssith = new SSITriggerHandler();
            //ssith.handleTrigger(true,true,true,true,true);
            //ssith.handleIntegrationTrigger(true,true,true,true,true);
            SSITriggerHandler.autoGenerate2ndSurveyTasks(newMap, oldMap);
           SSITriggerHandler.fieldsValidationRule(newMap, oldMap);
            SSITriggerHandler.fieldUpdates(newMap, oldMap);
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          insert updatecustomsettings;
            // create ssi task related to ssi record
            Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = 'Welcome Call');
            insert ssiTask;
            
            ssiTask = [Select Id,Subject, OwnerId From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.OwnerId, ssi_sv.Id);
            
           
            ssiTask = [Select Id, OwnerId From Task Where Id=:ssiTask.Id];
            ssi.Need_2nd_Survey__c = true;         
            
            ssiTask = [Select Id, Status,Subject From Task Where WhatId=:ssi.Id And recordtypeid =:recordtype];
            Test.stopTest();
            System.assertEquals(ssiTask.Subject, 'Welcome Call');
            
        }  
        
    }
   
  
  /*public static testmethod void handleTriggerTest() {
    createTestdata();
    test.starttest();
    SSITriggerHandler ssith = new SSITriggerHandler();
    ssith.handleTrigger(true,true,true,true,true);
    ssith.handleIntegrationTrigger(true,true,true,true,true);
    test.stoptest();
  }*/
  
  public static testmethod void autoGenerate2ndSurveyTasksTest() {
    createTestdata();
    ssinewmap = new Map<Id,SSI__c>();
    ssinewmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssinewmap$$$$$'+ssinewmap);
    ssioldmap = new Map<Id,SSI__c>();
    ssioldmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssioldmap$$$$$'+ssioldmap);
    test.starttest();
      SSITriggerHandler.autoGenerate2ndSurveyTasks(ssinewmap,ssioldmap);
    test.stoptest();
  }
  public static testmethod void fieldUpdatesTest() {
    createTestdata();
    ssinewmap = new Map<Id,SSI__c>();
    ssinewmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssinewmap$$$$$'+ssinewmap);
    ssioldmap = new Map<Id,SSI__c>();
    ssioldmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssioldmap$$$$$'+ssioldmap);
    test.starttest();
      SSITriggerHandler.fieldUpdates(ssinewmap,ssioldmap);
    test.stoptest();
  }
  public static testmethod void fieldsValidationRuleTest() {
    createTestdata();
    ssinewmap = new Map<Id,SSI__c>();
    ssinewmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssinewmap$$$$$'+ssinewmap);
    ssioldmap = new Map<Id,SSI__c>();
    ssioldmap.put(ssiold.Id,ssiold);
    system.debug('$$$$$ssioldmap$$$$$'+ssioldmap);
    test.starttest();
      SSITriggerHandler.fieldsValidationRule(ssinewmap,ssioldmap);
    test.stoptest();
  }
}