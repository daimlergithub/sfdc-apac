/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.08.15
Company             :    NTT Data,Inc.
Usage               :     This Batch class will delete the invalid campaign member records(where invalid campaign member field is true) that are created through CSV parser..
JIRA NO             :                                                  
Bug JIRA NO         :     

MODIFICATION DETAILS:

1. Modified By      :    
Modifide Date    :    
************************************************************************************/
global class DeleteInvalidCSVCampaignMembers implements Database.Batchable<sObject> ,Database.stateful  {

public id retcampid;
 global DeleteInvalidCSVCampaignMembers (Id retcampid){
     this.retcampid= retcampid;
    }

     global Database.QueryLocator start(Database.BatchableContext bc){
       
      return Database.getQueryLocator([select Id,Contact_Id__c,Invalid_campaign_Member__c,Csv_Parser_Number__c,Vehicle__c,Vehicle_Relationship__c,Retail_Task__c,Preferred_Dealer__c,Retail_Campaign_Id__c,Status__c,Created_By_CSV__c,Market__c  from Campaign_Member__c where Invalid_campaign_Member__c=true and  Market__c='JP' and Created_By_CSV__c=true and Retail_Campaign_Id__c=:retcampid ]);
    }
     //execute method 
    global void execute(Database.BatchableContext bc,List<Campaign_Member__c> scope){
        List<Campaign_Member__c> invalidCmm=new List<Campaign_Member__c>();
        if(retcampid !=null)
        {
        scope=[select Id,Contact_Id__c,Invalid_campaign_Member__c,Csv_Parser_Number__c,Vehicle__c,Vehicle_Relationship__c,Retail_Task__c,Preferred_Dealer__c,Retail_Campaign_Id__c,Status__c,Created_By_CSV__c,Market__c  from Campaign_Member__c where Invalid_campaign_Member__c=true and  Market__c='JP' and Retail_Campaign_Id__c=:retcampid];
     if(scope !=null || scope.size()>0)
     {
      DataBase.delete(scope,false);
      }
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
    
    if(retcampid !=null)
    {
    if(!test.isrunningtest())
                {
     Batch_RefreshButtonRetail batcher = new Batch_RefreshButtonRetail (retcampid);
                Database.executeBatch(batcher, 50);
                }
                
                
    }
    }
    
     global void execute(SchedulableContext ctx) {
        Database.executeBatch(new DeleteInvalidCSVCampaignMembers(retcampid), 1);
    }
}