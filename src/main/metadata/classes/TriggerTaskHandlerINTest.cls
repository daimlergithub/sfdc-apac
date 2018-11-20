/**
** Class:TriggerTaskHandlerINTest
** Description: Test Class for TriggerTaskHandlerIN
** Created By: Sravanthi Gudibandi
** Date: 22-05-2018
**/
@isTest
public with sharing class TriggerTaskHandlerINTest{

public static string parentCampRecordTypeId= RecordTypeAccessService.getRecordTypeId('Campaign',Label.Planning_Design_Campaign);
public static string childCampRecordTypeId= RecordTypeAccessService.getRecordTypeId('Campaign',Label.Campaign_Execution_Simple);
public static User user1;
public static User user2;
public static User user3;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 
public static Task t=new Task();

public static void setupTestData(){
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    Profile p2 = [SELECT Id,Name FROM Profile WHERE Name=:Label.IntProfileName];

    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
    
    System.runAs (user1) {
        PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
    
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INGeneric ];

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
        user3 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser3@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user3 );
        
      
        Trigger__c TaskTriggerIN= new Trigger__c(Name='TaskTriggerIN',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TriggerTaskHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
        insert TaskTriggerIN;
        
        Contact contact = new Contact(LastName = 'test Contact');
        insert contact;
        system.assertEquals(contact.id,[select id from contact where id=:contact.id limit 1].id);
        Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            IsActive=false,
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
        
        t.Whatid=child.id;
    }
    }
    
    static testMethod void testTaskHandler1() {
    setupTestData();
        System.runAs (user2) {       
        test.starttest(); 
                      
        insert t;
        t.priority__c='Low';
        update t;
        test.stoptest();          
        }   
       } 
       
       static testMethod void testTaskHandler2() {
       setupTestData();
        System.runAs (user3) {    
        test.starttest();   
        
        t.MD__c='IN';
        TriggerUtil.userCreate=false;                  
        insert t;
        t.priority__c='Low';
        update t;
        test.stoptest();
          
        }      
     }   
}