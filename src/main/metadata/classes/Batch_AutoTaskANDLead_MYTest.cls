/* Purpose: Test class for Batch_AutoTaskANDLead_MY
   Date: 06/03/2018
   Created By: Sushma */

@isTest
public class Batch_AutoTaskANDLead_MYTest {

  //method to setup data
  private static void createTestData()
  {
        Date todaydate=System.today();
        Account personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='MY', Individual_Home_Phone__c='+6034125852', RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account'));
        insert personAccount;
        Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',RecordTypeId=RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Planning & Design Campaign'));
        insert parentCampaignObj;
        Retail_Campaign__c retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='MY',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,RecordTypeId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution'));
        insert retailCampaignObj;
        Retail_Campaign__c retailCampaignObj2=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='MY',Execution_Type__c='Lead',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,RecordTypeId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution'));
        insert retailCampaignObj2;
        Campaign_Member__c campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Auto_creation_of_tasks__c=false,Status__c='Ready',md__c='MY',Contact_Id__c=personAccount.Id);
        insert campaignMemberObj;
        Campaign_Member__c campaignMemberObj2=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj2.Id,Convert_To_Lead_Flag__c=false,Auto_creation_of_tasks__c=false,Status__c='Ready',md__c='MY',Contact_Id__c=personAccount.Id);
        insert campaignMemberObj2;
        Lead__c leadObj=new Lead__c(Retail_Campaign_Name__c=retailCampaignObj.Id,Contact__c=personAccount.Id);
        insert leadObj;
    }
    
    //method for test coverage 
    static testMethod void Batch_AutoTaskANDLead_MY_Execute_Test()
    {
        Test.startTest();
        createTestData();
        Database.executeBatch(new Batch_AutoTaskANDLead_MY(), 2); 
        Test.stopTest();
        List<Task> taskLst=[select id from task];
        System.assert(taskLst.size()>0);
    }
}