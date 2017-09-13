/***********************************************************************************
Created By          :    DINESH C G   
Created Date        :    30.01.2017
Company             :    NTT Data,Inc.
Usage               :    Convert to DM Request button in campaign execution                       
                                          
************************************************************************************/


public class ConvertToDMRequest{
 
    //Our collection of the class/wrapper objects wrapAccount
   
    public List<Campaign_Member__c > selectedAccounts{get;set;}
    Public Static Id camId;
    private String objectAPIName;
    public List<CampaignMemberInfo> campaignMembers {get; set;}
 List<DM_Request__c> dmrec = New List<DM_Request__c>(); 
    public ConvertToDMRequest(){
    
        camId = ApexPages.currentPage().getParameters().get('id');
        if(camId!=null)
        {
         objectAPIName = (Id.valueOf(camId)).getSObjectType().getDescribe().getName();
              String query = 'SELECT Name, Campaign_ID__r.OwnerId, Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c, Vehicle__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            
          query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND ';
            
            if(objectAPIName == 'Campaign')
            {
                query += ' Campaign_ID__c =: camId ';
            }
            else if(objectAPIName == 'Retail_Campaign__c') 
            {
                query += ' Retail_Campaign_Id__c =: camId ';
            }
            else if(objectAPIName == 'Account') 
            {
                query += 'Contact_Id__c =: camId ';
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
    public void  processSelected() {
    //objectAPIName = (Id.valueOf(camId)).getSObjectType().getDescribe().getName();
     for(CampaignMemberInfo campaignMemberObj : campaignMembers) 
        {
           
            
          if(campaignMemberObj.isSelected)
            {
            
              if(objectAPIName == 'Campaign')
              {
                    System.debug('inserting>>1');
                    dmrec.add(setDMRequestRecordFields(camId, campaignMemberObj.campaignMember));
              }
              else if(objectAPIName == 'Retail_Campaign__c') 
              {
              System.debug('inserting>>2');
                        dmrec.add(setDMRequestRecordFields(camId, campaignMemberObj.campaignMember));
              }
              else if(objectAPIName == 'Account') 
              {
              System.debug('inserting>>3');
                        dmrec.add(setDMRequestRecordFields(camId, campaignMemberObj.campaignMember));
              }
            }   
           
            
         }
      if(dmrec.size()>0)
      {
         insert dmrec;
      }
    }
     public PageReference cancel() 
      {
        
        camId = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+ camId  );
      }
      @TestVisible   private DM_Request__c setDMRequestRecordFields(String campaignId, Campaign_Member__c campaignMember) 
     {
        DM_Request__c dmrequestRecord = new DM_Request__c();
         if(campaignMember.Contact_Id__c != null)
         {
            dmrequestRecord .Customer_Name__c = campaignMember.Contact_Id__c;
         }
         dmrequestRecord .Sending_Address__c = 'Temporary';
         dmrequestRecord .TitleOfHonor__c = 'To person';
         dmrequestRecord .Channel__c = 'Campaign' ;
         if(campaignMember.Campaign_ID__c != null)
         {
           dmrequestRecord .Campaign__c = campaignMember.Campaign_ID__c; 
         }
         return dmrequestRecord;
     }
}