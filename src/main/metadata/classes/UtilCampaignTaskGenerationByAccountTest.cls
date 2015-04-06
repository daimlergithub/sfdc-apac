/*@isTest
public class UtilCampaignTaskGenerationByAccountTest {

    public static testMethod void testUtilCampaignTaskGenerationByAccount() {
     List<User> newUsers = new List<User>();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        
            String[] csrProfiles = new String[]{'IntegrationAPI'};
            List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name In :csrProfiles];
            
            for(Profile p : profileIds){
                User usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                 
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                newUsers.add(usr);
            }
            
            insert newUsers;
        }
    
           String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();

            Campaign top = new Campaign(
      IsActive = true, 
      Name = 'top', 
      Status = 'Started', 
      StartDate = System.today(), 
      EndDate = System.today(),
      RecordTypeId = topCampRecordTypeId
    );
    insert top;
    
Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
          AccountId = dealer.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
        );
        insert contact;
  
                     
                     
                     List<Campaign> ml = new List<Campaign>();
       for (Integer i=0;i<10;i++) {
           Campaign m = new Campaign(Name = 'top',Status = 'Started',StartDate = System.today(), EndDate = System.today(),Content_Preview__c='Test',Execution_Type__c='Segmentation Only',Flow_URL__c='test url');
           ml.add(m);
       }
       insert ml;
         
                     
                     List<CampaignMember> listcamp = new List<CampaignMember>();
                     for (Integer i=0;i<1;i++) {
                     CampaignMember ob1Member = new CampaignMember(
      CampaignId = top.Id,
      ContactId = contact.Id,
      Status = 'Send',Task_Generated__c=false
    );
          listcamp.add(ob1Member);
       }
       insert listcamp;
       
                 Id jobId;
                 test.startTest();
          UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,jobId);
          Database.executeBatch(batcher);
          //Database.QueryLocator ql = batcher.start(null);
batcher.execute(null,listcamp);

          test.stopTest();

          //     ID batchprocessid = Database.executeBatch(batcher);
        }
       }
*/       
@isTest
public class UtilCampaignTaskGenerationByAccountTest
{
	private static Campaign top;
	private static Campaign objCamp;
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
	
    /*public static testMethod void testUtilCampaignTaskGenerationByCase()
    {
    	system.runAs(objUsr){
	        test.startTest();
	        createTemplate(CallscriptRecordTypeId);
	        createCampaign('By Campaign Execution');
	    	createAccount_Contact();
	    	createCampaign_Case('OB Call');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcamp);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
    	}
    }*/
    
    public static testMethod void testUtilCampaignTaskGenerationByCase_SMScondition()
    {
        system.runAs(objUsr){
	        test.startTest();
	        createTemplate(smsRecordTypeId);
	        createCampaign('By CAC Campaign');
	    	createAccount_Contact();
	    	createCampaign_Case('SMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcamp);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
        	system.assertEquals(listcamp.size(),lstCM.size());
        }
    }
    
    /*public static testMethod void testUtilCampaignTaskGenerationByCase_MMScondition()
    {
        system.runAs(objUsr){
	        test.startTest();
	        createTemplate(MMSRecordTypeId);
	        createCampaign('By CAC Campaign');
	    	createAccount_Contact();
	    	createCampaign_Case('MMS');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcamp);
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
	        createCampaign('By CAC Campaign');
	    	createAccount_Contact();
	    	createCampaign_Case('eDM');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcamp);
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
	        createCampaign('By CAC Campaign');
	    	createAccount_Contact();
	    	createCampaign_Case('DM');
	    	createCampaign_Member();
	    	createBatchJob();
	        UtilCampaignTaskGenerationByAccount  batcher= new UtilCampaignTaskGenerationByAccount(ml,batchJob.Id);
	        Database.executeBatch(batcher);
			batcher.execute(null,listcamp);
	        test.stopTest();
	        list<CampaignMember> lstCM=[select id from CampaignMember where Task_Generated__c=true and CampaignId in: setCamId];
	        system.assertEquals(listcamp.size(),lstCM.size());
        }
    }*/
    
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
       objCamp = new Campaign();
       objCamp.Name = 'top';
       objCamp.Status = 'Started';
       objCamp.StartDate = System.today();
       objCamp.parentid=top.Id;
       objCamp.EndDate = System.today();
       objCamp.Content_Preview__c='Test';
       objCamp.Execution_Type__c=executionType;
       objCamp.Flow_URL__c='test url';
       if(executionType!='DM')
       objCamp.Template__c=tempObj.id;
       objCamp.Previous_Campaign_Execution__c=null;
	   objCamp.Task_De_dup_Range__c='By CAC Campaign';
       insert objCamp;
    }
    
    static void createCampaign_Member()
    {
        for (integer i=0;i<1;i++)
        {
         	CampaignMember ob1Member = new CampaignMember();
		    ob1Member.CampaignId = objCamp.Id;
		    ob1Member.ContactId = contact.Id;
		    ob1Member.Status = 'Send';
		    ob1Member.Task_Generated__c=false;
            listcamp.add(ob1Member);
        	setCamId.add(objCamp.Id);
       }
       insert listcamp;
    }
    
    static void createBatchJob()
    {
    	batchJob= new Batch_Job__c(
    		Status__c='In Progress',
    		Campaign_Set__c=objCamp.id+';'
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