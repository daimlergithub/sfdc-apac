/**
** Created By  : Mrinalini Chandra
** Date        : 2017-12-15
**/

@isTest
public class ConvertToTask1ControllerTest
{
    public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static Id childCampaign_RecordTypeID= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    
    public static Id rtparentCampaign_RecordTypeID = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static Id rtchildCampaign_RecordTypeID= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    
    public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public static User usr;
    public static testMethod void CampaignTest()
    {
        Test.startTest();
        
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = p.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                DMS_UserID__c='venky4'
            );
        }
        insert usr; 
        Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                        Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                        Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                        City__c='Beijing',
                                        Gender__c = 'Male',
                                        Phone = '0801801110',
                                        Area_code__c = '0101',
                                        MD__c = 'TH',
                                        LastName = '刈乾冠寒刊勘',
                                        FirstName = '刈乾冠寒刊勘',
                                        Salutation = 'Unknown',      
                                        Province__c = 'Shanghai',
                                        ZipCode__c= '02347',
                                        Mobile__c = '023482832',
                                        Mobile2__c = '035456232',
                                        Primary_Email__c = 'Email1',
                                        Primary_Fax__c = 'FAX2',
                                        Primary_Phone__c ='Other2',
                                        
                                        RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        
        insert personAcc;  
        
        Campaign parentCamp=new Campaign(
            Name='test par',
            EndDate=System.Today()+50,
            StartDate=System.Today(),
            OwnerId=Userinfo.getUserId(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Status='Draft');
        insert parentCamp;
        
        Campaign ChildCamp=new Campaign(
            Name='Sam',
            EndDate=System.Today()+10,
            Segmentation_Date__c= Date.Today(),
            Execution_Start_Date__c = Date.Today()+4,
            StartDate=System.Today(),
            RecordtypeID=childCampaign_RecordTypeID,
            OwnerId=Userinfo.getUserId(),
            Child_Campaign_Status__c='Executed',
            parentID=parentCamp.id);
        insert ChildCamp;
        
        Retail_Campaign__c rtparentCamp=new Retail_Campaign__c(
            Name='test par',
            Close_Date__c=System.Today()+20,
            Start_Date__c=System.Today()+2,
            RecordtypeID=rtparentCampaign_RecordTypeID,
            MBTH_Approval_Status__c='ABC',
            OwnerId=Userinfo.getUserId(),
            Status__c='Draft',Campaign_Execution_Channels__c='eEmail');
        insert rtparentCamp;
        
        Retail_Campaign__c rtChildCamp=new Retail_Campaign__c(
            Name='Sam',
            Close_Date__c=System.Today()+6,
            Start_Date__c=System.Today()+3,
            RecordtypeID=rtchildCampaign_RecordTypeID,
            MBTH_Approval_Status__c='ABC',
            Child_Campaign_Status__c='Execution',
            Parent_Campaign1__c=rtparentCamp.id,
            Campaign_Execution_Channels__c='eEmail',
            OwnerId=usr.id);
        insert rtChildCamp;
        
        Campaign_Member__c cmm=new Campaign_Member__c(     
            Status__c='Executed',
            md__c = 'TH',
            Auto_creation_of_tasks__c=false,
            OwnerId=Userinfo.getUserId(),
            Retail_Campaign_Id__c=rtChildCamp.Id,
            Campaign_ID__c=ChildCamp.id,Contact_Id__c=personAcc.id);
        insert cmm;
        
        List<Campaign_Member__c> cmmembers=new List<Campaign_Member__c>();
        Campaign_Member__c cmm1=new Campaign_Member__c(     
            Status__c='Executed',
            md__c = 'TH',
            OwnerId=Userinfo.getUserId(),
            Campaign_ID__c=ChildCamp.id);
        cmmembers.add(cmm1);
        Campaign_Member__c cmm2=new Campaign_Member__c(md__c = 'TH',     
                                                       Status__c='Executed');
        cmmembers.add(cmm2);
        insert cmmembers;     
        
        
        Task rt = new Task();
        rt.RecordtypeID=OBTaskRecordTypeId;
        rt.OwnerId = UserInfo.getUserId();
        rt.Status='New';
        rt.Priority='Low';
        rt.OwnerId = usr.id;
        rt.whatID=ChildCamp.id;
        insert rt;
        string campaignId;
        campaignId=ChildCamp.id;
        PageReference pageRef = Page.ConvertToTask;
        pageRef.getParameters().put('CampaignMemberId', cmm.Id);
        Test.setCurrentPage(pageRef); 
        
        ConvertToTask1Controller controller = new ConvertToTask1Controller();
        controller.cancel();
        controller.convertToTask();
        controller.setTaskRecordFields(campaignId,cmm);
        
        Test.stopTest();
    }
    
    
    public static testMethod void RetailCampaignTest()
    {
        Test.startTest();
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerddddUser@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = p.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                DMS_UserID__c='venky4'
            );
            
            
        }
        insert usr; 
        
        Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                        Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                        Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                        City__c='Beijing',
                                        Gender__c = 'Male',
                                        Phone = '0801801110',
                                        Area_code__c = '0101',
                                        MD__c = 'TH',
                                        LastName = '刈乾冠寒刊勘',
                                        FirstName = '刈乾冠寒刊勘',
                                        Salutation = 'Unknown',      
                                        Province__c = 'Shanghai',
                                        ZipCode__c= '02347',
                                        Mobile__c = '023482832',
                                        Mobile2__c = '035456232',
                                        Primary_Email__c = 'Email1',
                                        Primary_Fax__c = 'FAX2',
                                        Primary_Phone__c ='Other2',
                                        RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        
        insert personAcc;  
        
        Retail_Campaign__c rtparentCamp=new Retail_Campaign__c(
            Name='test par',
            Close_Date__c=System.Today()+20,
            Start_Date__c=System.Today()+2,
            RecordtypeID=rtparentCampaign_RecordTypeID,
            MBTH_Approval_Status__c='ABC',
            OwnerId=Userinfo.getUserId(),
            Status__c='Draft',Campaign_Execution_Channels__c='eEmail');
        insert rtparentCamp;
        
        Retail_Campaign__c rtChildCamp=new Retail_Campaign__c(
            Name='Sam',
            Close_Date__c=System.Today()+6,
            Start_Date__c=System.Today()+3,
            RecordtypeID=rtchildCampaign_RecordTypeID,
            MBTH_Approval_Status__c='ABC',
            //OwnerId=Userinfo.getUserId(),
            Child_Campaign_Status__c='Execution',
            Parent_Campaign1__c=rtparentCamp.id,
            Campaign_Execution_Channels__c='eEmail',
            OwnerId=usr.id);
        insert rtChildCamp;
        
        
        Campaign_Member__c cmm = new Campaign_Member__c(     
            Status__c='Executed',md__c = 'TH',Contact_Id__c=personAcc.id,
            Retail_Campaign_Id__c=rtChildCamp.id
        );
        insert cmm;
        
        List<Campaign_Member__c> cmmembers=new List<Campaign_Member__c>();
        Campaign_Member__c cmm1=new Campaign_Member__c(  
            md__c = 'TH',
            Status__c='Executed',
            Retail_Campaign_Id__c=rtChildCamp.id
        );
        cmmembers.add(cmm1);
        
        Campaign_Member__c cmm2=new Campaign_Member__c( md__c = 'TH',    
                                                       Status__c='Ready' ,
                                                       //Campaign_ID__c =  rtChildCamp.id          
                                                       Retail_Campaign_Id__c=rtChildCamp.id
                                                      );
        cmmembers.add(cmm2);
        insert cmmembers;     
        
        
        
        Task rt = new Task();
        rt.RecordtypeID=OBTaskRecordTypeId;
        rt.OwnerId = UserInfo.getUserId();
        rt.Status='New';
        rt.Priority='Low';
        rt.OwnerId = usr.id;
        rt.whatID=rtChildCamp.id;
        insert rt;
        string campaignId;
        campaignId=rtChildCamp.id;
        
        PageReference pageRef = Page.ConvertToTask;
        pageRef.getParameters().put('CampaignMemberId', cmm.Id);
        
        Test.setCurrentPage(pageRef); 
        
        ConvertToTask1Controller controller = new ConvertToTask1Controller();
        controller.cancel();
        controller.convertToTask();
        controller.setTaskRecordFields(campaignId,cmm);
        
        Test.stopTest();
    }
    
/* public static testMethod void CampaignTaskTest()
{
Test.startTest();

Task t = new Task();
t.RecordtypeID=OBTaskRecordTypeId;
t.OwnerId = UserInfo.getUserId();
t.Status='New';
t.Priority='Low';
//  t.OwnerId = campaignMember.Campaign_ID__r.OwnerId;

insert t;

PageReference pageRef = Page.ConvertToTask;
pageRef.getParameters().put('CampaignId', String.valueOf(t.Id));

Test.setCurrentPage(pageRef); 

ConvertToTaskController controller = new ConvertToTaskController();
// controller.setTaskRecordFields();
controller.Cancel();
controller.convertToTask();

Test.stopTest();
}   

public static testMethod void RetailcampaignTaskTest()
{
Test.startTest();

Task rt = new Task();
rt.RecordtypeID=OBTaskRecordTypeId;
rt.OwnerId = UserInfo.getUserId();
rt.Status='New';
rt.Priority='Low';
//  rt.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;

insert rt;

PageReference pageRef = Page.ConvertToTask;
pageRef.getParameters().put('CampaignId', String.valueOf(rt.Id));

Test.setCurrentPage(pageRef); 

ConvertToTaskController controller = new ConvertToTaskController();
//  controller.setTaskRecordFields();
controller.Cancel();
controller.convertToTask();

Test.stopTest();
}   */
    
}