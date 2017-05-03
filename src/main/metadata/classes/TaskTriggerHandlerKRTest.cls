@isTest
public Class TaskTriggerHandlerKRTest {
  Public Static Campaign camp;
  Public Static CampaignMember member;
  public static Contact contobj;
  public Static list<CampaignMember> cammemberlist = new list<CampaignMember>();
  //Static String centralmarkcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id peraccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static List<Campaign> camplist;
  Public Static Account customer;
  private static Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
  private static Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
  private static Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
  private static Id obrtid = rtMap.get('OB Call').getRecordTypeId();
  private static Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
  private static Id eDMrtid = rtMap.get('eDM').getRecordTypeId();
  private static Task accobTask;
  private static Task obTask;
  
  Static void createtestdata() {
        //customer = [Select Name,Id,PersonContactId From Account Where Id =: customer.Id];
        
         customer = new Account(Name='TEST ACC',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='1004468',Home_Phone_2__c = '00000009642',
                                      RecordTypeId=DealerRecordTypeId,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',MBK_Data_Source__c ='Email',Mobile__c = '00000009642'
                                     ); 
        insert customer;
        
        obTask = new Task(RecordTypeId = obtrtid, WhoId = customer.PersonContactId, WhatId = customer.Id, Subject = 'Campaign Task');
        insert obTask;

        String callObject = 'CALLOBJECT123456789';
        String UCID = 'test123456789';
        DateTime Start_call_time = Datetime.now();
        DateTime End_call_time = Datetime.now().addMinutes(10);

        Task obCall = new Task(RecordTypeId = obrtid, callObject = callObject, WhatId = customer.Id, UCID__c = UCID, Start_call_time__c = Start_call_time, End_call_time__c = End_call_time);
        insert obCall;

        Task obCall1 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject);
        insert obCall1;

        Task obCall2 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject+'1');
        insert obCall2;

        
        System.assertEquals(obTask.WhoId, customer.PersonContactId);
        System.assertEquals(obTask.WhatId, customer.Id);
        System.assertEquals(obCall1.Related_Task_Id__c, obTask.Id);
        System.assertEquals(obCall1.RecordTypeId, obrtid);
    
    camp= new Campaign();
    camp.RecordTypeId =centmarcampRecordTypeId;
    camp.Name = 'TestCamp'; 
    camp.Status = 'Started'; 
    camp.StartDate = System.today();
    camp.EndDate = System.today();
    camp.Execution_Type__c ='OB_Call';
    insert camp;
    //camplist= new List<Campaign>();
    //camplist.add(camp);
    //insert camplist;
    system.debug('$$$$$$$$$$$$'+camp);
    system.debug('$$$$$$$$$$$$'+camp.id);
    //system.debug('$$$$$$$$$$$$'+camplist);
    
    contobj = new Contact(AccountId = customer.Id, LastName = 'b', Phone = '1212313', MobilePhone='1236547890',email = 's@s.s',DUP_Number__c='test dup');
    insert contobj;
    Map <String,Schema.RecordTypeInfo> fetchrecordTypes = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    Id personAccRecordTypeId = fetchrecordTypes.get('Person Account').getRecordTypeId();
    Account newPersonAccount = new Account();
     newPersonAccount.FirstName = 'Fred';
     newPersonAccount.LastName = 'Smith';
     newPersonAccount.RecordTypeid = personAccRecordTypeId;
     insert newPersonAccount;
    Contact conId = [select id from Contact where AccountId =: newPersonAccount.id];
    member = new CampaignMember();
    member.CampaignId = camp.Id;
    member.ContactId = conId.Id;
    member.MD__c='KR';
    member.Status = 'Sent';
    member.Task_Generated__c=false;
    insert member;
   
    system.debug('$$$$$$$$$$$$'+camp.id);
    system.debug('$$$$$$$$$$$$'+member.CampaignId);
    system.debug('$$$$$$$$$$$$'+member);
    system.debug('$$$$$$$$$$$$'+member.id);
    //cammemberlist = new List<Campaignmember>();
    //cammemberlist.add(cammember);
    //insert cammemberlist;
  }
  public static testmethod void updateCampaignMemberStatus() {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
    
    customer = new Account(Name='TEST ACC',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='1004468',Home_Phone_2__c = '00000009642',
                                      RecordTypeId=DealerRecordTypeId,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',MBK_Data_Source__c ='Email',Mobile__c = '00000009642'
                                     ); 
        insert customer;
        
        obTask = new Task(RecordTypeId = obtrtid, WhoId = customer.PersonContactId, WhatId = customer.Id, Subject = 'Campaign Task');
        insert obTask;

        String callObject = 'CALLOBJECT123456789';
        String UCID = 'test123456789';
        DateTime Start_call_time = Datetime.now();
        DateTime End_call_time = Datetime.now().addMinutes(10);

        Task obCall = new Task(RecordTypeId = obrtid, callObject = callObject, WhatId = customer.Id, UCID__c = UCID, Start_call_time__c = Start_call_time, End_call_time__c = End_call_time);
        insert obCall;

        Task obCall1 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject);
        insert obCall1;

        Task obCall2 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject+'1');
        insert obCall2;

        
        System.assertEquals(obTask.WhoId, customer.PersonContactId);
        System.assertEquals(obTask.WhatId, customer.Id);
        System.assertEquals(obCall1.Related_Task_Id__c, obTask.Id);
        System.assertEquals(obCall1.RecordTypeId, obrtid);
    
    camp= new Campaign();
    camp.RecordTypeId =centmarcampRecordTypeId;
    camp.Name = 'TestCamp'; 
    camp.Status = 'Started'; 
    camp.StartDate = System.today();
    camp.EndDate = System.today();
    camp.Execution_Type__c ='OB_Call';
    insert camp;
    //camplist= new List<Campaign>();
    //camplist.add(camp);
    //insert camplist;
    system.debug('$$$$$$$$$$$$'+camp);
    system.debug('$$$$$$$$$$$$'+camp.id);
    //system.debug('$$$$$$$$$$$$'+camplist);
    
    contobj = new Contact(AccountId = customer.Id, LastName = 'b', Phone = '1212313', MobilePhone='1236547890',email = 's@s.s',DUP_Number__c='test dup');
    insert contobj;
    /*Map <String,Schema.RecordTypeInfo> fetchrecordTypes = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    Id personAccRecordTypeId = fetchrecordTypes.get('Person Account').getRecordTypeId();
    Account newPersonAccount = new Account();
     newPersonAccount.FirstName = 'Fred';
     newPersonAccount.LastName = 'Smith';
     newPersonAccount.RecordTypeid = personAccRecordTypeId;
     insert newPersonAccount;
    Contact conId = [select id from Contact where AccountId =: newPersonAccount.id];
    member = new CampaignMember();
    member.CampaignId = camp.Id;
    member.ContactId = conId.Id;
    member.MD__c='KR';
    member.Status = 'Sent';
    member.Task_Generated__c=false;
    insert member;
   
    system.debug('$$$$$$$$$$$$'+camp.id);
    system.debug('$$$$$$$$$$$$'+member.CampaignId);
    system.debug('$$$$$$$$$$$$'+member);
    system.debug('$$$$$$$$$$$$'+member.id);*/
    
  }
}