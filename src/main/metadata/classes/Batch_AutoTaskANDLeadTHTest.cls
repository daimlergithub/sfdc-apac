@isTest
public class Batch_AutoTaskANDLeadTHTest {
	private static void createTestData()
	{
        Date todaydate=System.today();
        Account personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        insert personAccount;
        Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
    	insert parentCampaignObj;
        Retail_Campaign__c retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='TH',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
		insert retailCampaignObj;
        Retail_Campaign__c retailCampaignObj2=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='TH',Execution_Type__c='Lead',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
		insert retailCampaignObj2;
        Campaign_Member__c campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Auto_creation_of_tasks__c=false,Status__c='Ready',md__c='TH',Contact_Id__c=personAccount.Id);
        insert campaignMemberObj;
        Campaign_Member__c campaignMemberObj2=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj2.Id,Convert_To_Lead_Flag__c=false,Auto_creation_of_tasks__c=false,Status__c='Ready',md__c='TH',Contact_Id__c=personAccount.Id);
        insert campaignMemberObj2;
        Lead__c leadObj=new Lead__c(Retail_Campaign_Name__c=retailCampaignObj.Id,Contact__c=personAccount.Id);
        insert leadObj;
    }
    
    static testMethod void Batch_AutoTaskANDLeadTH_Execute_Test()
    {
        Test.startTest();
        createTestData();
        Database.executeBatch(new Batch_AutoTaskANDLeadTH(), 2); 
        Database.Executebatch(new CampaignExecutionStatusBatchUpdateTH(),2);
        Test.stopTest();
        List<Task> taskLst=[select id from task];
        System.assert(taskLst.size()>0);
    }
}