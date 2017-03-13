/**
** Description :  Controller for the convert to Task functionality for Campaign Member Records.
** Created By  : Shikha
** Date        : 2017-08-02
**/

public with sharing class ConvertToTaskController
{
    private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignId');
    private String objectAPIName;
    public List<CampaignMemberInfo> campaignMembers {get; set;}
    public static Id OB_Call = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public ConvertToTaskController()
    {
           if(String.isNotBlank(campaignId)) 
           {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
            String query = 'SELECT Name, Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId, Contact_Id__c, Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND ';
            
            if(objectAPIName == 'Campaign')
            {
                query += ' Campaign_ID__c =: campaignId ';
            }
            else if(objectAPIName == 'Retail_Campaign__c') 
            {
                query += ' Retail_Campaign_Id__c =: campaignId ';
            }
            
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<CampaignMemberInfo>();
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) 
            {
                campaignMembers.add(new CampaignMemberInfo(campaignMemberRec));
            }
          }
    }
    
       public class CampaignMemberInfo
       {
          public Campaign_Member__c campaignMember { get; set; }
          public Boolean isSelected { get; set; }
          public CampaignMemberInfo(Campaign_Member__c campaignMemberRec)
         {
            this.campaignMember = campaignMemberRec;
            this.isSelected = false;
         }
       }
    
      public PageReference cancel() 
      {
        return new PageReference('/' + campaignId);
      }
    
     public void convertToTask() 
     {
        List<Task> taskList = new List<Task>();
        List<Task> taskListToInsert = new List<Task>();
        for(CampaignMemberInfo campaignMemberObj : campaignMembers) 
        {
            if(campaignMemberObj.isSelected)
            {
              if(objectAPIName == 'Campaign')
              {
                    taskListToInsert.add(setTaskRecordFields(campaignId, campaignMemberObj.campaignMember));
              }
              else if(objectAPIName == 'Retail_Campaign__c') 
              {
                        taskListToInsert.add(setTaskRecordFields(campaignId, campaignMemberObj.campaignMember));
              }
            }
         }
        if(taskListToInsert.size() > 0)
        {
            insert taskListToInsert;
            system.debug('$%$%$%$%taskListToInsert'+taskListToInsert);
        }
        
      //return new PageReference('/' + campaignId);
     }
     
  @TestVisible   private Task setTaskRecordFields(String campaignId, Campaign_Member__c campaignMember) 
     {
        Task taskRec = new Task(RecordTypeId = OB_Call);
        taskRec.status= 'New';
        taskRec.Priority='Low';
        taskRec.subject = 'Campaign Executed';
  
        if(objectAPIName == 'Campaign' || objectAPIName == 'Retail_Campaign__c')
         {
           taskRec.whatID=campaignId;
           taskRec.OwnerId = UserInfo.getUserId();//campaignMember.Campaign_ID__r.OwnerId;
        }
         else if(objectAPIName == 'Retail_Campaign__c')
          { 
            taskRec.whatID=campaignId;
            taskRec.OwnerId = UserInfo.getUserId();//campaignMember.Retail_Campaign_Id__r.OwnerId;
        }  
        
        if(OB_Call!= null) {
            taskRec.RecordTypeId = OB_Call;
        }
        return taskRec;
    }
}