/**
* Test class for TriggerRetailCampaignHandlerMY
* Author:Sushma Bharti
* Created Date : 16-02-2018
*/

@isTest
public with sharing class TriggerRetailCampaignHandlerMYTest{

public static User user1;
public static User user2;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testTriggerRetailCampaignHandlerMY1() {
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
        Trigger__c TriggerRetailCampaignMY= new Trigger__c(Name='TriggerRetailCampaignMY',Trigger_Name__c='RetailCampaignTrigger',Trigger_Handler__c='TriggerRetailCampaignHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
        insert TriggerRetailCampaignMY;
        test.starttest();
    
        List<String> RetailCampaignFields=new List<String>();
        RetailCampaignFields.add('Name');
        RetailCampaignFields.add('MD__c');
        List<Retail_Campaign__c> RetailCampaignFieldsList=DataFactoryServices.createRecords('Retail_Campaign__c',RetailCampaignFields,'',1);
        RetailCampaignFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c',Label.Planning_Design_Campaign);
        RetailCampaignFieldsList[0].Name='PD1';
        RetailCampaignFieldsList[0].Start_Date__c=Date.today();
        RetailCampaignFieldsList[0].MD__c='MY';   
        RetailCampaignFieldsList[0].Close_Date__c=Date.today()+5; 
        insert RetailCampaignFieldsList;
        system.assertEquals(RetailCampaignFieldsList[0].id,[select id from Retail_Campaign__c where id=:RetailCampaignFieldsList[0].id limit 1].id);
    
        update RetailCampaignFieldsList;
        delete RetailCampaignFieldsList;
        test.stoptest();
          
        }     
        }
}