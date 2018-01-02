@isTest
public with sharing class TriggerTaskHelperMYTest{

public static string parentCampRecordTypeId= RecordTypeAccessService.getRecordTypeId('Campaign',Label.Planning_Design_Campaign);
public static string childCampRecordTypeId= RecordTypeAccessService.getRecordTypeId('Campaign',Label.Campaign_Execution_Simple);
public static User user1;
public static User user2;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testTriggerTaskHelperMY1() {
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
    
    System.runAs (user1) {
        PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
    
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
        
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        user2 = UtilTestData.createPersornaUser(ps, p1);
    }
        System.runAs (user2) {
        Trigger__c TaskTriggerMY= new Trigger__c(Name='TaskTriggerMY',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TriggerTaskHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
        insert TaskTriggerMY;
        test.starttest();
        Contact contact = new Contact(LastName = 'test Contact');
        insert contact;
        system.assertEquals(contact.id,[select id from contact where id=:contact.id limit 1].id);
        Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = parentCampRecordTypeId
        );
        insert top1;
        system.assertEquals(top1.id,[select id from campaign where id=:top1.id limit 1].id);
        Campaign child= new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = childCampRecordTypeId,
            ParentId = top1.Id
        );
        insert child;
        system.assertEquals(child.id,[select id from campaign where id=:child.id limit 1].id);
        Task t=new Task(
            Whatid=child.id);           
        List<Task> taskList=new List<Task>();
        taskList.add(t);
        insert taskList;
        Map<Id, Task> taskOldMap=new Map<Id, Task>();
        taskOldMap.put(taskList[0].id,taskList[0]);
        TriggerTaskHelperMY.updateCampaignMemberStatus(taskList,taskOldMap,true,true);
        test.stoptest();
          
        }     
        }
}