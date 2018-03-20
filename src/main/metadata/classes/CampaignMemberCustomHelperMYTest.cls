@isTest
public class CampaignMemberCustomHelperMYTest {
	Private static User user1;
    public static void createTestData()
    {
		Trigger__C CampaignMembersCustomMY=new Trigger__C(name='CampaignMembersCustomMY',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='MY',Trigger_Handler__c='TriggerCampaignMembersCustomMY',Trigger_Name__c='TriggerCampaignmembersCustom',update__c=true);
        insert CampaignMembersCustomMY; 
        String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
   		profile p1=[select id from profile where Name='Malaysia Dealer Delegate Admin'];
        Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='MY', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
        user1 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    	insert user1;
    }
    
    static testMethod void CampaignmemberssharewithsubDealers_Test()
    {
        Test.startTest();
        createTestData();
        List<Group> groupLst=new List<Group>();
        groupLst.add(new Group(Name='1235'));
        insert groupLst;
        Id retailExecutionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    
        System.runAs(user1)
        {
            Retail_campaign__c retcampchild=new Retail_Campaign__C(name='test123',recordtypeid=retailExecutionRecordId,Child_Campaign_Status__c='Planning',start_date__c=system.today()+2,close_Date__C=system.today()+2);
            insert retcampchild;
            Campaign_member__c campMember=new Campaign_member__c(Gaurantor_1_Name__c='TestMember',Retail_Campaign_Id__c=retcampchild.Id);
            insert campMember;
            List<Campaign_member__share> campaingMemberShareLst=[select id from Campaign_member__share];
            System.assert(campaingMemberShareLst.size()>0);
            delete campMember;
            

        }
        Test.stopTest();
    }
}