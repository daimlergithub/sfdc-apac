public class ConvertToDMRequestController1
{
   private final String Id = ApexPages.currentPage().getParameters().get('CampaignMemberId');
    private String objectAPIName;
    public account contactList=new account();
    public List<Campaign_Member__c> campaignMembers {get; set;}
    public ConvertToDMRequestController1()
    {
           
           if(String.isNotBlank(Id)) 
           {
            
            String query = 'SELECT Id,Name, Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
      
      query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND Id =: Id';
            
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
        return new PageReference('/' + Id);
      }
    
     public PageReference convertToDMRequest() 
     {
        List<DM_Request__c> dmList = new List<DM_Request__c>();
        List<DM_Request__c> dmListToInsert = new List<DM_Request__c>();
        for(Campaign_Member__c campaignMemberObj : campaignMembers) 
        { 
                if(campaignMemberObj.Campaign_ID__c != null && campaignMemberObj.Retail_Campaign_Id__c == null) 
                {
                        dmListToInsert .add(setDMRecordFields(campaignMemberObj.Campaign_ID__c, campaignMemberObj));
                        
                } else if(campaignMemberObj.Campaign_ID__c == null && campaignMemberObj.Retail_Campaign_Id__c != null) 
                {
                        dmListToInsert .add(setDMRecordFields(campaignMemberObj.Retail_Campaign_Id__c, campaignMemberObj));
                        
                }
         }
        if(dmListToInsert .size() > 0)
        {
            insert dmListToInsert ;
            system.debug('$%$%$%$%taskListToInsert'+dmListToInsert );
        }
        
      return new PageReference('/' + dmListToInsert [0].id);
     }
     
   private DM_Request__c setDMRecordFields(String campaignId, Campaign_Member__c campaignMember) 
     {
         DM_Request__c dm = New DM_Request__c ();
              dm.Customer_Name__c =campaignMember.Contact_Id__c;
              dm.Sending_Address__c = 'Temporary';
              dm.TitleOfHonor__c = 'To person';
              dm.Channel__c = 'Campaign' ;
              dm.Campaign__c = campaignMember.Campaign_ID__c ; 
        return dm;
    }
}