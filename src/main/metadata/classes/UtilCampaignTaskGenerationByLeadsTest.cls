@isTest
public class UtilCampaignTaskGenerationByLeadsTest {

 Private static string retailLeadType =Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
 Private static string accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();     // Dealer.
 Private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
 Private static Account account2;
 Private static Contact contact;
 Private static List<Campaign> ml;
 Private static Account dealer;
 Private static List<Campaign_Lead__c> listcamplead = new List<Campaign_Lead__c>();
 private static List<Lead__c> listlead = new List<Lead__c>();
 private static Lead__C lead;

//SKM
private static Campaign childCampaign;
    private static Campaign parentCampaign;
    private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static List<Campaign> campaignList = new List<Campaign>();
    private static List<CampaignMember> campaignMemberList = new List<CampaignMember>();
    private static set<id> setCamId= new set<id>();
    private static Batch_Job__c batchJob;
     private static Template__c tempObj;
    static user objUsr;
    static Account personAccount;
    static string BY_CAC_CAMPAIGN='By CAC Campaign';
    static string BY_CAM_EXECUTION='By Campaign Execution';
    private static string smsRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static string eDMRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    private static string MMSRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
    static{
        Profile objProfile = [ select Id from profile where Name='IntegrationAPI'];
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
    
        public static testMethod void testUtilCampaignTaskGenerationByLeadsSMS() {
            system.runAs(objUsr){
            createTemplate(smsRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign('By Campaign Execution');
            createAccount_Contact();
            createCampaign_Lead('SMS');
            createCampaign_Member();
            createBatchJob();
            
            test.startTest();
            listcamplead =[select id,Campaign__c,Campaign__r.ParentId, Campaign__r.Content_Preview__c, Campaign__r.Parent.Task_De_dup_Range__c, Campaign__r.Template__c, Campaign__r.Previous_Campaign_Execution__c, Lead__c, Campaign__r.Execution_Type__c, Lead__r.Contact__r.PersonMobilePhone , Lead__r.Contact__r.PersonContactId from Campaign_Lead__c];
            
            UtilCampaignTaskGenerationByLeads batcher= new UtilCampaignTaskGenerationByLeads(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            batcher.execute(null,listcamplead);
            test.stopTest();
              }
        }
        
        public static testMethod void testUtilCampaignTaskGenerationByLeadsMMS() {
            system.runAs(objUsr){
            createTemplate(MMSRecordTypeId);
            createCampaignParent('By Campaign Execution');
            createCampaign(BY_CAC_CAMPAIGN);
            createAccount_Contact();
            createCampaign_Lead('MMS');
            createCampaign_Member();
            createBatchJob();
            
            test.startTest();
            listcamplead =[select id,Campaign__c,Campaign__r.ParentId, Campaign__r.Parent.ParentId, Campaign__r.Parent.Task_De_dup_Range__c, Campaign__r.Previous_Campaign_Execution__c, Lead__c, Campaign__r.Execution_Type__c, Lead__r.Contact__r.PersonMobilePhone, Campaign__r.Template__c, Campaign__r.Template__r.Subject__c, Campaign__r.Template__r.Template_ID__c, Lead__r.Contact__r.PersonContactId from Campaign_Lead__c];
            System.debug('listcamplead Phone ->'+listcamplead[0].Lead__r.Contact__r.PersonMobilePhone);
            UtilCampaignTaskGenerationByLeads batcher= new UtilCampaignTaskGenerationByLeads(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            batcher.execute(null,listcamplead);
            test.stopTest();
              }
        }
        
        public static testMethod void testUtilCampaignTaskGenerationByLeadsEDM() {
            system.runAs(objUsr){
            createTemplate(eDMRecordTypeId);
            createCampaignParent(BY_CAC_CAMPAIGN);
            createCampaign('By Campaign Execution');
            createAccount_Contact();
            createCampaign_Lead('eDM');
            createCampaign_Member();
            createBatchJob();
            
            test.startTest();
            listcamplead =[select id,Campaign__c,Campaign__r.ParentId, Campaign__r.Parent.Task_De_dup_Range__c, Campaign__r.Previous_Campaign_Execution__c, Lead__c, Campaign__r.Execution_Type__c, Lead__r.Contact__r.PersonMobilePhone, Campaign__r.Template__c, Campaign__r.Template__r.Subject__c, Campaign__r.Template__r.Template_ID__c, Lead__r.Interested_Vehicle_Model__c,Campaign__r.Template_Name__c, Lead__r.Contact__r.PersonContactId, Lead__r.Contact__r.PersonEmail from Campaign_Lead__c];
            
            UtilCampaignTaskGenerationByLeads batcher= new UtilCampaignTaskGenerationByLeads(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            batcher.execute(null,listcamplead);
            test.stopTest();
              }
        }
        /*
        public static testMethod void testUtilCampaignTaskGenerationByLeadsMMS() {
              system.runAs(objUsr){
                  createTemplate(mmsRecordTypeId);
            createCampaignParent(BY_CAM_EXECUTION);
            createCampaign(BY_CAM_EXECUTION);
            createAccount_Contact();
            createCampaign_Lead('MMS');
            createCampaign_Member();
            createBatchJob();
            test.startTest();
            UtilCampaignTaskGenerationByLeads batcher= new UtilCampaignTaskGenerationByLeads(campaignList,batchJob.Id);
            Database.executeBatch(batcher);
            batcher.execute(null,listcamplead);
            test.stopTest();
              }
        }
        */
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
    static void createCampaign_Lead(string executionType)
    {
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
        if(executionType!='DM')
        m.Template__c=tempObj.id;
        campaignList.add(m);
        insert campaignList;
        
        lead = new Lead__c();
       lead.Assigned_Dealer__c = dealer.Id;
       lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Allow_Data_Sharing__c=true;
        lead.Relation_With_The_Leads__c = 'tester';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testtrade';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.RecordTypeId=retailLeadType;
        lead.Contact__c = personAccount.Id;
        listlead.add(lead);
        insert listlead;
    }
    
    static void createCampaign_Member()
    {
       for (Campaign objCamp:campaignList)
        {
            for (Lead__c objLead:listlead)
            {
                Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Campaign__c=objCamp.Id,Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true);
                listcamplead.add(ob1Member);
            }
            setCamId.add(objCamp.Id);
       }
       insert listcamplead;
       Campaign_Lead__c ledc=[select id,Campaign__c,Campaign__r.ParentId from Campaign_Lead__c];
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
          LastName = 'b', 
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