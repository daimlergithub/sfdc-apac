/*
    Type:       Trigger on Campaign Member
    Purpose:    To be added 
    Date: 2017-1-31
    User Story:
    Used By:    
    ---------------------------------------------------------------
*/

public class TriggerCampaignMembersCustomHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       if(isAfter && isInsert){
           CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection(Trigger.new);
                     // CampaignMembersCustomHelperJP.batchbounce(trigger.new);
                      CampaignMembersCustomHelperJP.addSalesCampaignMember(Trigger.new);
                      CampaignMembersCustomHelperJP.afterInsertSharing(Trigger.new);
                      CampaignMembersCustomHelperJP.wholesaleCampaignSharing(Trigger.new);
                       CampaignMembersCustomHelperJP.CmSharingForDealer(Trigger.new);
        }
       if(Trigger.isAfter && Trigger.isUpdate) {
            CampaignMembersCustomHelperJP.afterUpdateOperation((Map<Id, Campaign_Member__c>)trigger.oldMap, (Map<Id, Campaign_Member__c>)trigger.newMap, (List<Campaign_Member__c>)trigger.new);
            CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(Trigger.New);
       }
       if(Trigger.isBefore && Trigger.isDelete) {
            CampaignMembersCustomHelperJP.beforeDeleteOperation((List<Campaign_Member__c>)trigger.old);
       }
       if(Trigger.isBefore && Trigger.isUpdate){
          CampaignMemberHelperBase.updateCampaignMemberCustommarket(Trigger.New);
       }
       
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
                          
                           if(isAfter && isInsert){
                           
                      CampaignMembersCustomHelperJP.afterInsertSharing(Trigger.new);
                      CampaignMembersCustomHelperJP.wholesaleCampaignSharing(Trigger.new);
                      }
    }
}