/**
* Test class for RetailCampaignHelperBase
* Author:Sushma Bharti
* Created Date : 16-02-2018
*/

@isTest
public with sharing class RetailCampaignHelperBaseTest{

    public static User user1;
    public static User user2;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj; 
    
    static testMethod void testRetailCampaignHelperBase1() {
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
            
            test.starttest();
            
            List<String> AccountFields=new List<String>();
            AccountFields.add('Name');
            AccountFields.add('Individual_Home_Phone__c');
            AccountFields.add('Work_Phone__c');
            AccountFields.add('fax');
            AccountFields.add('Mobile__c');
            AccountFields.add('MD__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
            AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.Dealer_RecordType);
            AccountFieldsList[0].Name='DealerAcc';
            AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
            AccountFieldsList[0].Work_Phone__c='+60825634789541';
            AccountFieldsList[0].fax='+60827896541';
            AccountFieldsList[0].Mobile__c='+609856321478';
            AccountFieldsList[0].MD__c='MY';
            insert AccountFieldsList;
            List<String> RetailCampaignFields=new List<String>();
            RetailCampaignFields.add('Name');
            RetailCampaignFields.add('MD__c');
            List<Retail_Campaign__c> RetailCampaignFieldsList=DataFactoryServices.createRecords('Retail_Campaign__c',RetailCampaignFields,'',5);
            RetailCampaignFieldsList[0].RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
            RetailCampaignFieldsList[0].Name='PD1';
            RetailCampaignFieldsList[0].Start_Date__c=Date.today();
            RetailCampaignFieldsList[0].MD__c='MY';   
            RetailCampaignFieldsList[0].Close_Date__c=Date.today()+5;
            RetailCampaignFieldsList[0].Status__c='Draft';
            RetailCampaignFieldsList[1].RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
            RetailCampaignFieldsList[1].Name='CE1';
            RetailCampaignFieldsList[1].Parent_Campaign1__c=RetailCampaignFieldsList[0].id;
            RetailCampaignFieldsList[1].Start_Date__c=Date.today();
            RetailCampaignFieldsList[1].MD__c='MY';   
            RetailCampaignFieldsList[1].Close_Date__c=Date.today()+3; 
            RetailCampaignFieldsList[1].Execution_Type__c='DM';
            RetailCampaignFieldsList[1].Execution_Start_Date__c=Date.today()+1;
            RetailCampaignFieldsList[1].Segmentation_Base__c='Customer';
            RetailCampaignFieldsList[1].Segmentation_Date__c=Date.today()+1;
            RetailCampaignFieldsList[1].Response_Date__c=Date.today()+1;
            RetailCampaignFieldsList[1].child_campaign_status__c='Planning';
            RetailCampaignFieldsList[1].Dealer_Name__c=AccountFieldsList[0].id;
            insert RetailCampaignFieldsList;
            system.assertEquals(RetailCampaignFieldsList[0].id,[select id from Retail_Campaign__c where id=:RetailCampaignFieldsList[0].id limit 1].id);
            
            List<Retail_Campaign__c> rclist1=new List<Retail_Campaign__c>();
            rclist1.add(RetailCampaignFieldsList[0]);
            List<Retail_Campaign__c> rclist2=new List<Retail_Campaign__c>();
            rclist2.add(RetailCampaignFieldsList[1]);           
            RetailCampaignHelperBase.parentCampaingStatusChange(RetailCampaignFieldsList,true);
            RetailCampaignHelperBase.UpdateDealerEmail(RetailCampaignFieldsList,'Dealer Community MB Malaysia');
            RetailCampaignHelperBase.deleteParentCampaignsandRelatedChildcampaigns(rclist1);
            RetailCampaignHelperBase.deleteParentCampaignsandRelatedChildcampaigns(rclist2);            
            test.stoptest();
              
            }   
          
    }
}