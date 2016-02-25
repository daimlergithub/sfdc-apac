@isTest
public with sharing class UtilCampaignTaskGenerationByAccountTest
{
    private static Campaign childCampaign;
    private static Campaign parentCampaign;
    private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static List<Campaign> campaignList = new List<Campaign>();
    private static List<CampaignMember> campaignMemberList = new List<CampaignMember>();
    private static Batch_Job__c batchJob;
    private static Account companyAcc;
    private static Contact contact;
    private static set<id> setCamId= new set<id>();
    private static Template__c tempObj;
    static user objUsr;
    Private static string empty='';
    static string BY_CAC_CAMPAIGN='By CAC Campaign';
    private static string smsRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static string eDMRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    private static string MMSRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
    private static string CallscriptRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Callscript').getRecordTypeId();
    private static string strVeriStatus = 'Need Verification';
    static{
        Profile objProfile = [ select Id from profile where Name='IntegrationAPI'];
        objUsr = new User();
        objUsr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
        objUsr.ProfileId = objProfile.Id;
        objUsr.LastName = 'Test User';
        objUsr.Email = 'test001@daimler.com.full';
        objUsr.Alias = 'test';
        objUsr.TimeZoneSidKey = 'Asia/Shanghai';
        objUsr.EmailEncodingKey = 'UTF-8';
        objUsr.LanguageLocaleKey = 'en_US';
        objUsr.localesidkey='en_US';
        insert objUsr;      
    } 
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeOBCall()
    {
        system.runAs(objUsr){
            test.startTest();
            createTemplate(CallscriptRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign('By Campaign Execution');
            createAccount_Contact();
            
            createCampaign_Case('OB Call');
            createCampaign_Member();
            createBatchJob();
            UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            test.stopTest();
            list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
            list<task> objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,RecordTypeId,Campaign_Member_ID__c,WhatId,DUP_Number__c from task limit 1];
            system.assertEquals(campaignMemberList.size(),lstCM.size());
            system.assertEquals(objTask[0].DUP_Number__c,contact.DUP_Number__c);
            system.assertEquals(objTask[0].UniqueCampaignGenerateTask__c,childCampaign.Id+''+contact.Id+empty+'OB Call');
            system.assertEquals(objTask[0].RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId());
            system.assertEquals(objTask[0].Activity_Status__c,'not started');
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeSMS()
    {
        system.runAs(objUsr){
            test.startTest();
            createTemplate(smsRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign(BY_CAC_CAMPAIGN);
            
            createAccount_Contact();
            createCampaign_Case('SMS');
            createCampaign_Member();
            createBatchJob();
            UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            test.stopTest();
            list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
            list<task> objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,WhatId,SMSTemplateID__c from task limit 1];
            system.assertEquals(campaignMemberList.size(),lstCM.size());
            system.assertEquals(objTask[0].UniqueCampaignMobile__c,campaignMemberList[0].CampaignId+'-'+contact.MobilePhone);
            system.assertEquals(objTask[0].UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+'SMS');
            system.assertEquals(objTask[0].Activity_Status__c,strVeriStatus);
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeMMS()
    {
        system.runAs(objUsr){
            test.startTest();
            createTemplate(MMSRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign(BY_CAC_CAMPAIGN);
            createAccount_Contact();
            
            createCampaign_Case('MMS');
            createCampaign_Member();
            createBatchJob();
            UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            test.stopTest();
            list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
            list<task> objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,SMSTemplateID__c,RecordTypeId,Campaign_Member_ID__c,WhatId from task limit 1];
          //  system.assertEquals(campaignMemberList.size(),lstCM.size());
         //   system.assertEquals(objTask[0].UniqueCampaignMobile__c,campaignMemberList[0].CampaignId+'-'+contact.MobilePhone);
         //   system.assertEquals(objTask[0].UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+'MMS');
         //   system.assertEquals(objTask[0].Activity_Status__c,strVeriStatus);
         //   system.assertEquals(objTask[0].SMSTemplateID__c,campaignList[0].Template__c);
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeeDM()
    {
        system.runAs(objUsr){
            test.startTest();
            createTemplate(eDMRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign(BY_CAC_CAMPAIGN);
            createAccount_Contact();
            
            createCampaign_Case('eDM');
            createCampaign_Member();
            createBatchJob();
            UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            test.stopTest();
            list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
            list<task> objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,eDM_Template__c,WhatId,SMSTemplateID__c from task limit 1];
            system.assertEquals(campaignMemberList.size(),lstCM.size());
            system.assertEquals(objTask[0].UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+'eDM');
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeDM()
    {
        system.runAs(objUsr){
            test.startTest();
            createTemplate(eDMRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign(BY_CAC_CAMPAIGN);            
            
            createCampaign_Case('DM');
            createAccount_Contact();
            createCampaign_Member();
            createBatchJob();
            UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            test.stopTest();
            list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
            list<task> objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,WhatId,SMSTemplateID__c from task limit 1];
        //    system.assertEquals(campaignMemberList.size(),lstCM.size());
         //   system.assertEquals(objTask[0].UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+'DM');
        }
    }
    
    static void createCampaign(string str)
    {
        childCampaign = new Campaign();
        childCampaign.IsActive = true; 
        childCampaign.Name = 'top';
        childCampaign.Status = 'Started'; 
        childCampaign.StartDate = System.today();
        childCampaign.EndDate = System.today();
        childCampaign.RecordTypeId = topCampRecordTypeId;
        childCampaign.Previous_Campaign_Execution__c=null;
        childCampaign.Task_De_dup_Range__c=str;
        childCampaign.parentid=parentCampaign.Id;
        insert childCampaign;
    }
    
    static void createCampaignParent(string str)
    {
        parentCampaign = new Campaign();
        parentCampaign.IsActive = true; 
        parentCampaign.Name = 'top';
        parentCampaign.Status = 'Started'; 
        parentCampaign.StartDate = System.today();
        parentCampaign.EndDate = System.today();
        parentCampaign.RecordTypeId = topCampRecordTypeId;
        parentCampaign.Previous_Campaign_Execution__c=null;
        parentCampaign.Task_De_dup_Range__c=str;
        insert parentCampaign;
    }  
    static void createAccount_Contact()
    {
      companyAcc= new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
      
         insert companyAcc;
        contact = new Contact(
          AccountId = companyAcc.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
        );
        insert contact;
    }
    static void createCampaign_Case(string executionType)
    {
        Campaign m = new Campaign();
        m.Name = 'top';
        m.Status = 'Started';
        m.StartDate = System.today();
        m.parentid=childCampaign.Id;
        m.EndDate = System.today();
        m.Content_Preview__c='Test';
        m.Execution_Type__c=executionType;
        m.Flow_URL__c='test url';
        if(executionType!='DM')
        m.Template__c=tempObj.id;
        m.Task_De_dup_Range__c=BY_CAC_CAMPAIGN; 
        campaignList.add(m);
        insert campaignList;
    }
    
    static void createCampaign_Member()
    {
        CampaignMember ob1Member = new CampaignMember();
        for (Campaign objCamp1:campaignList)
        {
            ob1Member.CampaignId = objCamp1.Id;
            ob1Member.ContactId = contact.Id;
            ob1Member.Status = 'Send';
            ob1Member.Task_Generated__c=false;
            campaignMemberList.add(ob1Member);
            setCamId.add(objCamp1.Id);
       }
       insert campaignMemberList;
    }
    
    static void createBatchJob()
    {
        batchJob= new Batch_Job__c(
            Status__c='In Progress',
            Campaign_Set__c=campaignList[0].id+';'
        );
            insert batchJob;
    }
    
    static void createTemplate(string recodrTypeid)
    {
        tempObj = new Template__c(RecordTypeId = recodrTypeid, Active__c = true,
                                           Message_Detail__c = '{DEALER_name}', Name = 'IB SMS IVR');
        insert tempObj;                                   
    }
}