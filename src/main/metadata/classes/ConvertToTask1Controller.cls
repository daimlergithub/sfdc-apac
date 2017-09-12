public class ConvertToTask1Controller
{
     private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignMemberId');
    private String objectAPIName;
    public account contactList=new account();
    public List<Campaign_Member__c> campaignMembers {get; set;}
    public static Id OB_Call = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public ConvertToTask1Controller()
    {
           
           if(String.isNotBlank(campaignId)) 
           {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
            String query = 'SELECT Id,Name, Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
      
      query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND Id =: campaignId';
            
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<Campaign_Member__c>();
            system.debug('cms>>>'+campaignMemberList);
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) 
            {
                campaignMembers.add(campaignMemberRec);
            }
          }
    }
    
      public PageReference cancel() 
      {
        return new PageReference('/' + campaignId);
      }
    
     public PageReference convertToTask() 
     {
        List<Task> taskList = new List<Task>();
        List<Task> taskListToInsert = new List<Task>();
        for(Campaign_Member__c campaignMemberObj : campaignMembers) 
        { 
                if(campaignMemberObj.Campaign_ID__c != null && campaignMemberObj.Retail_Campaign_Id__c == null) 
                {
                        taskListToInsert .add(setTaskRecordFields(campaignMemberObj.Campaign_ID__c, campaignMemberObj));
                        
                } else if(campaignMemberObj.Campaign_ID__c == null && campaignMemberObj.Retail_Campaign_Id__c != null) 
                {
                        taskListToInsert .add(setTaskRecordFields(campaignMemberObj.Retail_Campaign_Id__c, campaignMemberObj));
                        
                }
         }
        if(taskListToInsert.size() > 0)
        {
            insert taskListToInsert;
            system.debug('$%$%$%$%taskListToInsert'+taskListToInsert);
        }
        
      return new PageReference('/' + taskListToInsert[0].id);
     }
     
  @TestVisible   private Task setTaskRecordFields(String campaignId, Campaign_Member__c campaignMember) 
     {

        System.debug('camid<<<'+campaignMember.Campaign_Id__c);
        System.debug('camid<<<'+campaignMember.Company_Name__c);
        System.debug('camid<<<'+campaignMember.Contract_Phone1_1__c);
        System.debug('camid<<<'+campaignMember.Contract_Phone2_2__c);
        System.debug('camid<<<'+campaignMember.Contact_Id__c);
        Task taskRec = new Task(RecordTypeId = OB_Call);
        contactList=[select id,PersonContactId from account where id=:campaignMember.Contact_Id__c];
        taskRec.status= 'New';
        taskRec.Priority='Low';
        taskRec.subject = 'Campaign Executed';
        taskRec.Whatid = campaignMember.Campaign_Id__c ;
        taskRec.whoid = contactList.PersonContactId;
        taskRec.Contract__c = campaignMember.Contract__c ;
        taskRec.Related_Vehicle__c= campaignMember.Vehicle__c;    
        taskRec.Account_Name__c =campaignMember.Company_Name__c;
       taskRec.Phone__c = campaignMember.Contract_Phone1_1__c;
      taskRec.Phone_number__c= campaignMember.Contract_Phone2_2__c;
     taskRec.Campaign_Member_ID__c = campaignMember.Name; 

  
  
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