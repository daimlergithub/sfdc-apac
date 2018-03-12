/* Purpose: Test class for Batch_AutoTaskANDLead_Generic
   Date: 06/03/2018
   Created By: Sushma */

@isTest
public class Batch_AutoTaskANDLead_GenericTest {

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
    static testMethod void Batch_AutoTaskANDLead_Generic_Execute_Test()
    {
        Test.startTest();
        createTestData();
        String market=System.Label.MarketMY;
        Database.BatchableContext bc;
        List<Retail_Campaign__c> rcList=[select id from Retail_Campaign__c];
        List<Campaign_Member__c> cmList=[SELECT id,Contact_Id__r.Work_Phone__c,Retail_Campaign_Id__r.Campaign_Code__c,Contact_Id__r.Mobile__c,Contact_Id__r.Primary_Phone__c,Contact_Id__r.Individual_Home_Phone__c,Auto_creation_of_tasks__c,Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype,Name,Convert_To_Lead_Flag__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c,Contract_Number__c,Contact_Id__r.Name,Campaign_ID__r.Name,UsVIN__c,Contact_Id__r.OwnerId,Model__c,Vehicle__c,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Preferred_Dealer__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Retail_Campaign_Id__r.Execution_Type__c,Campaign_ID__r.OwnerId,Contact_Id__r.personcontactid,Retail_Campaign_Id__c,Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c FROM Campaign_Member__c];
        Batch_AutoTaskANDLead_Generic ba=new Batch_AutoTaskANDLead_Generic();
        ba.method1(bc,market);   
        ba.method2(bc,cmList);
        List<Task> taskLst=[select id from task];
        System.assert(taskLst.size()>0);
    }
}