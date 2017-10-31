/**
** Description :  Controller for the convert to Task functionality for Campaign Member Records.
** Created By  : Shikha
** Date        : 2017-08-02
**/

public  class ConvertToTaskController
{
    private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignId');
    private String objectAPIName;
    public account contactList=new account();
    public List<CampaignMemberInfo> campaignMembers {get; set;}
    Public User usr{get;set;}
    public static Id OB_Call = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public Set<Campaign_member__C> campmembertoupdate=new Set<Campaign_member__c>();
    public List<Campaign_member__C> updatelst=new List<Campaign_member__C>();
    public ConvertToTaskController()
    {String query;
    usr=[select market__c from user where id=:userinfo.getuserid()];
           if(String.isNotBlank(campaignId)) 
           {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
            if(usr.Market__c=='TH'){
               query = 'SELECT Name,md__c,Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            
          query += ' FROM Campaign_Member__c WHERE Auto_creation_of_tasks__c=false AND ';
              query +=' (Status__c = \'Ready\' OR Status__c = \'Executed\' ) AND md__c=\'TH\' AND (Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Submitted\' AND Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Rejected\') and ';
              }else{
            
            query = 'SELECT Name, Campaign_ID__r.OwnerId,md__c,Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            
          query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND ';
              }
               
                           
          }
            system.debug(query+'%%%%');
            if(objectAPIName == 'Campaign')
            {
                query += ' Campaign_ID__c =: campaignId ';
            }
            else if(objectAPIName == 'Retail_Campaign__c') 
            {
                query += ' Retail_Campaign_Id__c =: campaignId ';
            }
            else if(objectAPIName == 'Account') 
            {
                query += 'Contact_Id__c =: campaignId ';
            }
            system.debug(query+'%%%%');
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<CampaignMemberInfo>();
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) 
            {
                campaignMembers.add(new CampaignMemberInfo(campaignMemberRec));
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
      /*  List<Task> existingTaskList;
         if(objectAPIName == 'Campaign') {
            existingTaskList= [Select id,whoid,whatid from task where whatid=:campaignId];
        } else if(objectAPIName == 'Retail_Campaign__c') {
            existingTaskList= [Select id,whoid,whatid from task where whatid=:campaignId];
        }else if(objectAPIName == 'Account') {
            existingTaskList= [Select id,whoid,whatid from task where whatid=:campaignId];
        }*/
        for(CampaignMemberInfo campaignMemberObj : campaignMembers) 
        {
           
            
          if(campaignMemberObj.isSelected)
            {
            
              if(objectAPIName == 'Campaign')
              {
                    System.debug('inserting>>1');
                    taskListToInsert.add(setTaskRecordFields(campaignId, campaignMemberObj.campaignMember));
              }
              else if(objectAPIName == 'Retail_Campaign__c') 
              {
              System.debug('inserting>>2');
                        taskListToInsert.add(setTaskRecordFields(campaignId, campaignMemberObj.campaignMember));
              }
              else if(objectAPIName == 'Account') 
              {
              System.debug('inserting>>3');
                        taskListToInsert.add(setTaskRecordFields(campaignId, campaignMemberObj.campaignMember));
              }
            }   
           
            
         }
        if(taskListToInsert.size() > 0)
        {
            insert taskListToInsert;
            system.debug('$%$%$%$%taskListToInsert'+taskListToInsert);
        }
        if(campmembertoupdate.size()>0)
        
        //updateset.addall(campmembertoupdate);
        //update updateset;
        updatelst.addAll(campmembertoupdate);
        if(updatelst.size()>0){
        update updatelst;
        }
     }
 
  @TestVisible   private Task setTaskRecordFields(String campaignId, Campaign_Member__c campaignMember) 
     {
        Task taskRec = new Task(RecordTypeId = OB_Call);
        contactList=[select id,PersonContactId from account where id=:campaignMember.Contact_Id__c];
        taskRec.status= 'New';
        taskRec.Priority='Low';
        taskRec.subject = 'Campaign Executed';
        taskRec.whoid = contactList.PersonContactId;
        if(objectAPIName == 'Campaign' && campaignMember.Campaign_Id__c != null){
        taskRec.Whatid = campaignMember.Campaign_Id__c ;
        }
        else if(objectAPIName == 'Retail_Campaign__c' && campaignMember.Retail_Campaign_Id__c != null){
        taskRec.Whatid = campaignMember.Retail_Campaign_Id__c;
        }
        if(usr.market__c=='TH' && campaignMember.md__c=='TH'){
        campaignMember.Auto_creation_of_tasks__c=true;
        campmembertoupdate.add(campaignMember);
        taskRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
        taskRec.whatid = campaignMember.id;
        taskRec.ActivityDate=System.today()+3;
        }
        
        taskRec.Contract__c = campaignMember.Contract__c ;
        taskRec.Related_Vehicle__c= campaignMember.Vehicle__c;    
        taskRec.Account_Name__c =campaignMember.Company_Name__c;
        taskRec.Phone__c = campaignMember.Contract_Phone1_1__c;
        taskRec.Phone_number__c= campaignMember.Contract_Phone2_2__c;
        taskRec.Campaign_Member_ID__c = campaignMember.Name; 

  
  
        if((objectAPIName == 'Campaign' || objectAPIName == 'Retail_Campaign__c' || objectAPIName == 'Account') && usr.market__c!='TH')
         {
           taskRec.whatID=campaignId;
           taskRec.OwnerId = UserInfo.getUserId();//campaignMember.Campaign_ID__r.OwnerId;
        }
         
        
        if(OB_Call!= null) {
            taskRec.RecordTypeId = OB_Call;
        }
        return taskRec;
    }
}