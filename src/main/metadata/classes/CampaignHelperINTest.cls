/**
** Class: CampaignHelperINTest
** Description: Test Class for CampaignHelperIN 
** Created By: Sravanthi Gudibandi
** Date: 22-05-2018
**/
@isTest
public class CampaignHelperINTest {
public static User user1;
public static User user_Obj;   
public static User user3;
public static User integrationAPI;
public static List<Campaign> listcampaigns;  
public static List<Campaign> CampaignList;    
public static string topCampRecordTypeId1 = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId(); 
public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();     
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj;
@testSetup    
static void setupTestData(){ 
Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
Profile p2 = [SELECT Id,Name FROM Profile WHERE Name=:Label.IntProfileName];
PermissionSet ps = new PermissionSet();
ps.Name = 'Test';
ps.Label = 'Test';
insert ps;  
CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INGeneric ];
system.debug('harshit@@@@'+cps);    
SetupEntityAccess sea = new SetupEntityAccess();
sea.ParentId = ps.Id;
sea.SetupEntityId = cps.id;
insert sea;

  
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='IN',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        user3 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser3@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user3 );
    

system.runas(user1){
  Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaignIN',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
  insert TriggerCampaign;   
    SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
      
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh); 
      
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user_Obj.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
    
      listcampaigns=new list<Campaign>();
       
       Contact contact = new Contact(
           LastName = 'test Contact'
       );
       insert contact;
       
       Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
                IsActive=true,
            RecordTypeId = topCampRecordTypeId
        );
        insert top1;
                    
       Campaign cac= new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = topCampRecordTypeId1,
            ParentId = top1.Id
        );
        listcampaigns.add(cac);       
        market_Obj = new Market__c(Market_Code__c = 'IN', Market__c = 'India');
    Insert market_Obj; 
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
   persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
    Insert persona_Obj; 
 
   
}     
}

static testMethod void testTriggerCampaignHandlerIN1() {
        try{
        
           system.runas(user_Obj){
                test.starttest();
                TriggerCampaignTriggerHandlerIN tdc=new TriggerCampaignTriggerHandlerIN();
                CampaignHelperIN ch=new CampaignHelperIN();
                System.assertEquals(true,listcampaigns != null );  
                insert listcampaigns;
                test.stoptest();
           }
          }
        catch(Exception e){}
    }    
static testMethod void testTriggerCampaignHandlerIN1INT() {
        try{
        
          setupTestData();
         
           System.runAs (user3) {  
                   TriggerUtil.userCreate=false;
              
                TriggerCampaignTriggerHandlerIN tdc=new TriggerCampaignTriggerHandlerIN();
                CampaignHelperIN ch=new CampaignHelperIN();
                System.assertEquals(true,listcampaigns != null );  
                insert listcampaigns;
               
           }
          }
        catch(Exception e){}
    }    
    
    
}