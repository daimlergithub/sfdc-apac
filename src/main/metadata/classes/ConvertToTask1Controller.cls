public class ConvertToTask1Controller
{
     private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignMemberId');
    private String objectAPIName;
    public List<Campaign_Member__c> campmembertoupdate=new List<Campaign_Member__c>();
    public User usr;
    public account contactList=new account();
    public List<Campaign_Member__c> campaignMembers {get; set;}
    public static Id OB_Call = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public ConvertToTask1Controller()
    {usr=[select market__c from user where id=:userinfo.getuserid()];
      String query;     
           if(String.isNotBlank(campaignId)) 
           {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
             if(usr.Market__c=='TH'){
             /*List<Retail_Campaign__c> retcamp =[select id,createdby.usertype from Retail_Campaign__c where id=:campaignId];
             system.debug(retcamp[0].createdby.usertype+'dhanamjayausertype');*/
               query = 'SELECT Id,Retail_Campaign_Id__r.Campaign_Code__c,Contact_Id__r.Work_Phone__c,Contact_Id__r.Mobile__c,Contact_Id__r.Primary_Phone__c,Contact_Id__r.Individual_Home_Phone__c,Name,md__c,Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
               query += ' FROM Campaign_Member__c WHERE Auto_creation_of_tasks__c=false AND Id =: campaignId and ';
               query +='(Status__c = \'Ready\' OR Status__c = \'Executed\' ) AND (Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Submitted\' AND Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Rejected\')';
      system.debug('Query'+query);
      }else{
     query = 'SELECT Id,Name,md__c,Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
      
      query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND Id =: campaignId';
      
      }
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<Campaign_Member__c>();
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
            if(campmembertoupdate.size()>0){
                update campmembertoupdate;
            }
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
        //Adding Null check 
        if(campaignMember.Contact_Id__c!=null){
        contactList=[select id,PersonContactId from account where id=:campaignMember.Contact_Id__c];
        }
        
        //contactList=[select id,PersonContactId from account where id=:campaignMember.Contact_Id__c];
        
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
      if(usr.market__c=='TH' && campaignMember.md__c=='TH'){
        campaignMember.Auto_creation_of_tasks__c=true;
         taskRec.Phone_number__c=campaignMember.Contact_Id__r.Primary_Phone__c=='Home Phone'?campaignMember.Contact_Id__r.Individual_Home_Phone__c:campaignMember.Contact_Id__r.Primary_Phone__c=='Work Phone'?campaignMember.Contact_Id__r.Work_Phone__c:campaignMember.Contact_Id__r.Primary_Phone__c=='Mobile'?campaignMember.Contact_Id__r.Mobile__c:'';
        campmembertoupdate.add(campaignMember);
        taskRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
        taskRec.Campaign_Name__c=campaignMember.Retail_Campaign_Id__r.Campaign_Code__c;
        taskRec.whatid=campaignMember.id;
        }

  
  
        if(objectAPIName == 'Campaign' || objectAPIName == 'Retail_Campaign__c' && usr.market__c!='TH')
         {
           taskRec.whatID=campaignId;
           taskRec.OwnerId = UserInfo.getUserId();//campaignMember.Campaign_ID__r.OwnerId;
        }
         else if(objectAPIName == 'Retail_Campaign__c')
          { 
            taskRec.whatID=campaignId;
            if(usr.market__c!='TH'){
            taskRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
             taskRec.whatid = campaignMember.Retail_Campaign_Id__r.id;
            taskRec.ActivityDate=System.today()+3;
            }
            else{
            taskRec.OwnerId = UserInfo.getUserId();//campaignMember.Retail_Campaign_Id__r.OwnerId;
            }
        }  
        
        if(OB_Call!= null) {
            taskRec.RecordTypeId = OB_Call;
        }
        return taskRec;
    }
}
