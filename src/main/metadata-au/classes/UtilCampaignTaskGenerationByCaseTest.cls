@isTest
public class UtilCampaignTaskGenerationByCaseTest
{
	private static Campaign childCampaign;
	private static Campaign parentCampaign;
	private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
	private static List<Campaign> campaignList = new List<Campaign>();
	private static List<case> listcase = new List<case>();
	private static List<CampaignMember> campaignMemberList = new List<CampaignMember>();
	private static Batch_Job__c batchJob;
	private static Account dealer;
	private static Contact contact;
	private static set<id> setCamId= new set<id>();
	private static Template__c tempObj;
	static user objUsr;
	static Account personAccount;
	static string BY_CAC_CAMPAIGN='By CAC Campaign';
	private static string smsRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
	private static string eDMRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
	private static string MMSRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
	private static string CallscriptRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Callscript').getRecordTypeId();
	private static string strVeriStatus = 'Need Verification';
	static{
		Profile objProfile = [ select Id from profile where Name='System Administrator'];
        objUsr = new User();
        objUsr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daicampaignLister.com';
        objUsr.ProfileId = objProfile.Id;
        objUsr.LastName = 'Test User';
        objUsr.Email = 'test001@daicampaignLister.com.full';
        objUsr.Alias = 'test';
        objUsr.TimeZoneSidKey = 'Asia/Shanghai';
        objUsr.EmailEncodingKey = 'UTF-8';
        objUsr.LanguageLocaleKey = 'en_US';
        objUsr.localesidkey='en_US';
        insert objUsr;      
    } 
	
    public static testMethod void testUtilCampaignTaskGenerationByCase()
    {
    	system.runAs(objUsr){
    		createTemplate(CallscriptRecordTypeId);
    		createCampaignParent(BY_CAC_CAMPAIGN);
	        createCampaign('By Campaign Execution');
	    	createAccount_Contact();
	    	createCampaign_Case('OB Call');
	    	createCampaign_Member();
	    	createBatchJob();
	        test.startTest();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(campaignList,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        task objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,RecordTypeId,Campaign_Member_ID__c,WhatId,DUP_Number__c from task limit 1];
	        system.assertEquals(campaignMemberList.size(),lstCM.size());
	        system.assertEquals(objTask.DUP_Number__c,contact.DUP_Number__c);
	        system.assertEquals(objTask.UniqueCampaignGenerateTask__c,childCampaign.Id+''+contact.Id+''+listcase[0].id+'OB Call');
	        system.assertEquals(objTask.RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId());
	        system.assertEquals(objTask.Activity_Status__c,'not started');
    	}
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeSMS()
    {
        system.runAs(objUsr){
        	createTemplate(smsRecordTypeId);
        	createCampaignParent(BY_CAC_CAMPAIGN);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('SMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        test.startTest();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(campaignList,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
        	task objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,WhatId,SMSTemplateID__c from task limit 1];
	        system.assertEquals(campaignMemberList.size(),lstCM.size());
	        system.assertEquals(objTask.UniqueCampaignMobile__c,campaignMemberList[0].CampaignId+'-'+personAccount.PersonMobilePhone);
	        system.assertEquals(objTask.UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+listcase[0].id+'SMS');
	        system.assertEquals(objTask.RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId());
	        system.assertEquals(objTask.Activity_Status__c,strVeriStatus);
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeMMS()
    {
        system.runAs(objUsr){
        	createTemplate(MMSRecordTypeId);
        	createCampaignParent(BY_CAC_CAMPAIGN);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('MMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        test.startTest();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(campaignList,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        task objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,SMSTemplateID__c,RecordTypeId,Campaign_Member_ID__c,WhatId from task limit 1];
	        system.assertEquals(campaignMemberList.size(),lstCM.size());
	        system.assertEquals(objTask.UniqueCampaignMobile__c,campaignMemberList[0].CampaignId+'-'+personAccount.PersonMobilePhone);
	        system.assertEquals(objTask.UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+listcase[0].id+'MMS');
	        system.assertEquals(objTask.RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('MMS').getRecordTypeId());
	        system.assertEquals(objTask.Activity_Status__c,strVeriStatus);
	        system.assertEquals(objTask.SMSTemplateID__c,campaignList[0].Template__c);
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeEDM()
    {
        system.runAs(objUsr){
        	createTemplate(eDMRecordTypeId);
        	createCampaignParent(BY_CAC_CAMPAIGN);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('eDM');
	    	createCampaign_Member();
	    	createBatchJob();
	        test.startTest();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(campaignList,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        task objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,eDM_Template__c,WhatId,SMSTemplateID__c from task limit 1];
	        system.assertEquals(campaignMemberList.size(),lstCM.size());
	        system.assertEquals(objTask.UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+listcase[0].id+'eDM');
	        system.assertEquals(objTask.RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('eDM').getRecordTypeId());
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_ExecutionTypeDM()
    {
        system.runAs(objUsr){
        	createTemplate(eDMRecordTypeId);
        	createCampaignParent(BY_CAC_CAMPAIGN);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('DM');
	    	createCampaign_Member();
	    	createBatchJob();
        	test.startTest();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(campaignList,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        task objTask=[select id,UniqueCampaignGenerateTask__c,Vehicle_Case_ID__c,Activity_Status__c,UniqueCampaignMobile__c,RecordTypeId,Campaign_Member_ID__c,WhatId,SMSTemplateID__c from task limit 1];
	        system.assertEquals(campaignMemberList.size(),lstCM.size());
	        system.assertEquals(objTask.UniqueCampaignGenerateTask__c,parentCampaign.Id+''+contact.Id+''+listcase[0].id+'DM');
	        system.assertEquals(objTask.RecordTypeId,Schema.SObjectType.Task.getRecordTypeInfosByName().get('DM').getRecordTypeId());
	        system.assertEquals(objTask.Activity_Status__c,'Open');
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
    	dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        contact = new Contact(
          AccountId = dealer.Id, 
          Salutation='Attorney',
             FirstName='testFirstname',
            LastName = 'testLastname',  
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='1236547890'
        );
        insert contact;
    }
    static void createpersonAccount()
    {
    	personAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
    	personAccount.PersonMobilePhone = '1301111111';
    	update personAccount;
    }
    
    static void createCampaign_Case(string executionType)
    {
        DM_Material__c dm = new DM_Material__c();
        dm.Name = 'Test DM for Campaign';
        dm.Type__c = 'Car Book';
        insert dm;
    	createpersonAccount();
	    Campaign m = new Campaign();
	    m.Name = 'top';
	    m.Status= 'Started';
	    m.StartDate = System.today();
	    m.parentid=childCampaign.Id;
	    m.EndDate = System.today();
	    m.Content_Preview__c='Test';
	    m.Execution_Type__c=executionType;
	    m.Flow_URL__c='test url';
        m.DM_Material__c = dm.Id;
	    if(executionType!='DM')
	    m.Template__c=tempObj.id;
	    campaignList.add(m);
        insert campaignList;
        
        Case c1 = new Case(Subject='',Status='Open',Case_Type__c='Others',Priority='yellow =3',Mileage__c=2,AccountId=personAccount.id);
        listcase.add(c1);
        insert listcase; 
    }
    
    static void createCampaign_Member()
    {
    	CampaignMember ob1Member = new CampaignMember();
        for (Campaign objCamp:campaignList)
        {
        	for (Case objCase:listcase)
        	{
			    ob1Member.CampaignId = objCamp.Id;
			    ob1Member.ContactId = contact.Id;
			    ob1Member.Status = 'Send';
			    ob1Member.Task_Generated__c=false;
			    ob1Member.Vehicle_Case_ID__c=objCase.id+';';
	            campaignMemberList.add(ob1Member);
        	}
        	setCamId.add(objCamp.Id);
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