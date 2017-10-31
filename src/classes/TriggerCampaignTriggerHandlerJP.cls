/*
    Type:       Trigger
    Purpose:    Create Task when campaign is active and recordtype = Campaign Execution  
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    28-May-2013 Stephano Shi (Breakingpoint)  Created
    23-Sept-2013 Tony Li (Breakingpoint)      Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignTriggerHandler
*/
public class TriggerCampaignTriggerHandlerJP 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      if(Trigger.isBefore && Trigger.isInsert)
        {
           CampaignHelper.validationParentCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
           CampaignHelper.validationChildCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
           CampaignHelper.useSegmentationCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
            
        }
        if(Trigger.isBefore && Trigger.isUpdate)
        {
           CampaignHelper.validationParentCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
           CampaignHelper.validationChildCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
           CampaignHelper.useSegmentationCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
        }
        if(Trigger.isAfter && Trigger.isInsert || Trigger.isAfter && Trigger.isUpdate ){
        
        CampaignHelper.validationChildCampaign(Trigger.New,(Map<Id,Campaign>)Trigger.OldMap, isInsert, isUpdate);
        
        }
             
         if(Trigger.isBefore && Trigger.isDelete){
             CampaignHelper.beforeDeleteEvents(Trigger.old);
         }
               
        if(Trigger.isAfter && Trigger.isDelete )
        {
            //CampaignHelper.beforeDeleteEvents(Trigger.old);
            CampaignHelper.beforeDeleteCampaignStatus(Trigger.old);
            
            
        }
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            CampaignHelper.emailNotificationToDealer (Trigger.New,(Map<ID,Campaign>)trigger.oldMap);
            CampaignHelper.copyCampaignToRetailCampaign(Trigger.New);
            CampaignHelper.parentCampaignSatus(Trigger.New,(Map<ID,Campaign>)trigger.oldMap);
            CampaignHelper.updateLogic(Trigger.New);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}