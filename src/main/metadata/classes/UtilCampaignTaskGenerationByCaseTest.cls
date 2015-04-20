@isTest
public class UtilCampaignTaskGenerationByCaseTest
{
	private static Campaign top;
	private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
	private static List<Campaign> ml = new List<Campaign>();
	private static List<case> listcase = new List<case>();
	private static List<CampaignMember> listcamp = new List<CampaignMember>();
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
	
    public static testMethod void testUtilCampaignTaskGenerationByCase()
    {
    	system.runAs(objUsr){
	        test.startTest();
	        createTemplate(CallscriptRecordTypeId);
	        createCampaign('By Campaign Execution');
	    	createAccount_Contact();
	    	createCampaign_Case('OB Call');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
    	}
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_SMScondition()
    {
        system.runAs(objUsr){
	        test.startTest();
	        createTemplate(smsRecordTypeId);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('SMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
        	system.assertEquals(listcamp.size(),lstCM.size());
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_MMScondition()
    {
        system.runAs(objUsr){
	        test.startTest();
	        createTemplate(MMSRecordTypeId);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('MMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_eDMcondition()
    {
        system.runAs(objUsr){
	        test.startTest();
	        createTemplate(eDMRecordTypeId);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('eDM');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
        }
    }
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_DMcondition()
    {
        system.runAs(objUsr){
        	test.startTest();
        	createTemplate(eDMRecordTypeId);
	        createCampaign(BY_CAC_CAMPAIGN);
	    	createAccount_Contact();
	    	createCampaign_Case('DM');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByCase  batcher= new UtilCampaignTaskGenerationByCase(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcase);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
        }
    }
    
    static void createCampaign(string str)
    {
    	top = new Campaign();
	    top.IsActive = true; 
	    top.Name = 'top';
	    top.Status = 'Started'; 
	    top.StartDate = System.today();
	    top.EndDate = System.today();
	    top.RecordTypeId = topCampRecordTypeId;
	    top.Previous_Campaign_Execution__c=null;
	    top.Task_De_dup_Range__c=str;
    	insert top;
    }
    
    static void createAccount_Contact()
    {
    	dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        contact = new Contact(
          AccountId = dealer.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
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
    	createpersonAccount();
	    Campaign m = new Campaign();
	    m.Name = 'top';
	    m.Status = 'Started';
	    m.StartDate = System.today();
	    m.parentid=top.Id;
	    m.EndDate = System.today();
	    m.Content_Preview__c='Test';
	    m.Execution_Type__c=executionType;
	    m.Flow_URL__c='test url';
	    if(executionType!='DM')
	    m.Template__c=tempObj.id;
	    ml.add(m);
        insert ml;
        
        Case c1 = new Case(Subject='',Status='Open',Case_Type__c='Others',Priority='yellow =3',Mileage__c=2,AccountId=personAccount.id);
        listcase.add(c1);
        insert listcase; 
    }
    
    static void createCampaign_Member()
    {
    	CampaignMember ob1Member = new CampaignMember();
        for (Campaign objCamp:ml)
        {
        	for (Case objCase:listcase)
        	{
			    ob1Member.CampaignId = objCamp.Id;
			    ob1Member.ContactId = contact.Id;
			    ob1Member.Status = 'Send';
			    ob1Member.Task_Generated__c=false;
			    ob1Member.Vehicle_Case_ID__c=objCase.id+';';
	            listcamp.add(ob1Member);
        	}
        	setCamId.add(objCamp.Id);
       }
       insert listcamp;
    }
    
    static void createBatchJob()
    {
    	batchJob= new Batch_Job__c(
    		Status__c='In Progress',
    		Campaign_Set__c=ml[0].id+';'
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