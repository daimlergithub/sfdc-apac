@isTest
public class CampaignHelperBaseTest {

public static User user1;
public static List<Campaign> listcampaigns;  
public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();    
public static string topCampRecordTypeId1 = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();    

//Campaign Execution , Central Marketing Campaign
public static Campaign c;
public static List<Campaign> listcampaigns2;     
public static map<id,Campaign> campaignOldMap;   
public static Campaign top1;    
//public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();    
@testSetup    
static void setupTestData(){ 
Profile p1 = [select id from profile where Name='System Administrator' limit 1];
user1 = new User(LastName='User'+System.Now(),Market__c='MY',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M123@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
insert user1;
system.runas(user1){
  //Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaign',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
  //insert TriggerCampaign;   
  listcampaigns=new list<Campaign>();
       
       Contact contact = new Contact(
           LastName = 'test Contact'
       );
       insert contact;
       
    
       top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId,
            Create_Task__c=false
        );
    
        insert top1;
                    
       Campaign cac= new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = topCampRecordTypeId1,
            ParentId = top1.Id,
            Create_Task__c=false
        );
         
        listcampaigns.add(cac);  
        insert listcampaigns;
       //system.debug('********'+topCampRecordTypeId1 + cac.RecordTypeId ); 
       campaignOldMap= new Map<id,Campaign>();
        campaignOldMap.put(cac.id, cac);
}     
}
    

static testMethod void testTriggerCampaignHandlerMY2() {
        try{
                setupTestData();
                system.runas(user1){
                test.starttest();
                Campaign c=[Select id, Create_Task__c from Campaign where id=: listcampaigns[0].id][0];
                c.Create_Task__c=true; 
                c.Name = 'top1';
                c.Task_Created_By__c='Contact';    
                c.RecordTypeId=topCampRecordTypeId1;    
                listcampaigns2= new List<Campaign>();
                listcampaigns2.add(c);
                System.assertEquals(true,listcampaigns2 != null );     
                update c;
               // system.debug('!!!!HK2!!!');    
                CampaignHelperBase.afterInsertUpdateEvents(listcampaigns2,campaignOldMap,True,'MY','Planning & Design Campaign');
                CampaignHelperBase.beforeUpdateEvents(listcampaigns2,campaignOldMap,'MY','Planning & Design Campaign');
                test.stoptest(); 
             }
            }
            catch(Exception e){
            //system.debug(e+'harshit@@@'+e.getMessage()+e.getLineNumber());
            
        }
    }  
    
static testMethod void testTriggerCampaignHandlerMY3() {
        try{
                setupTestData();
                system.runas(user1){
                test.starttest();
                Campaign c=[Select id, Create_Task__c from Campaign where id=: listcampaigns[0].id][0];
                c.Create_Task__c=true; 
                c.Name = 'top1';
                c.Task_Created_By__c='Lead';    
                c.RecordTypeId=topCampRecordTypeId1;    
                listcampaigns2= new List<Campaign>();
                listcampaigns2.add(c); 
                System.assertEquals(true,listcampaigns2 != null );    
                update c;
                CampaignHelperBase.afterInsertUpdateEvents(listcampaigns2,campaignOldMap,True,'MY','Planning & Design Campaign');
                CampaignHelperBase.beforeUpdateEvents(listcampaigns2,campaignOldMap,'MY','Planning & Design Campaign');
                test.stoptest(); 
             }
            }
            catch(Exception e){
            //system.debug(e+'harshit@@@'+e.getMessage()+e.getLineNumber());
            
        }
    }      

static testMethod void testTriggerCampaignHandlerMY4() {
        try{
                setupTestData();
                system.runas(user1){
                test.starttest();
                Campaign c=[Select id, Create_Task__c from Campaign where id=: listcampaigns[0].id][0];
                c.Create_Task__c=true; 
                c.Name = 'top1';
                c.Task_Created_By__c='Vehicle';    
                c.RecordTypeId=topCampRecordTypeId1;    
                listcampaigns2= new List<Campaign>();
                listcampaigns2.add(c);  
                System.assertEquals(true,listcampaigns2 != null );    
                update c;
                CampaignHelperBase.afterInsertUpdateEvents(listcampaigns2,campaignOldMap,True,'MY','Planning & Design Campaign');
                CampaignHelperBase.beforeUpdateEvents(listcampaigns2,campaignOldMap,'MY','Planning & Design Campaign');
                test.stoptest(); 
             }
            }
            catch(Exception e){
            //system.debug(e+'harshit@@@'+e.getMessage()+e.getLineNumber());
            
        }
    }      
    
static testMethod void testTriggerCampaignHandlerMY5() {
        try{
                setupTestData();
                system.runas(user1){
                test.starttest();
                Campaign c=[Select id, Create_Task__c from Campaign where id=: listcampaigns[0].id][0];
                c.Create_Task__c=true; 
                c.Name = 'top1';
                c.Task_Created_By__c='Case';    
                c.RecordTypeId=topCampRecordTypeId1;    
                listcampaigns2= new List<Campaign>();
                listcampaigns2.add(c);    
                System.assertEquals(true,listcampaigns2 != null );    
                update c;
                  
                CampaignHelperBase.afterInsertUpdateEvents(listcampaigns2,campaignOldMap,True,'MY','Planning & Design Campaign');
                CampaignHelperBase.beforeUpdateEvents(listcampaigns2,campaignOldMap,'MY','Planning & Design Campaign');
                CampaignHelperBase.updatemarket(listcampaigns2);    
                test.stoptest(); 
             }
            }
            catch(Exception e){
           // system.debug(e+'harshit@@@'+e.getMessage()+e.getLineNumber());
            
        }
    }      
        

          
    
 }