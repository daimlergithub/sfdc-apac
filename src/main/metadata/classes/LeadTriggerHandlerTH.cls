/**
* Utility for lead trigger handler for TH(Thailand)
* Author: Dhanamjaya
* Created Date : 2017-01-23
*/
public class LeadTriggerHandlerTH implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
    boolean flag=true;
        LeadHelperTH leadRS= new LeadHelperTH();
                
        if(Trigger.isbefore && Trigger.isUpdate){
        LeadHelperBase.updatemarket(Trigger.New);
        leadRS.updateAllWorkflowsActionsAfterInsert(Trigger.new,trigger.isupdate);
            leadRS.leadValidation(Trigger.new);
            
            leadRS.updateOwner(Trigger.new);   
        }
        
        if(Trigger.isbefore && Trigger.isinsert){
            leadRS.leadValidation(trigger.new);
            leadRS.updateOwnerwithDealer(Trigger.new);   
        }
       if (Trigger.isafter && (Trigger.isinsert || Trigger.isUpdate) && usr.Profile.Name != 'IntegrationAPI') {

            if (LeadHelperTH.booleanCampaignUpdate) {
                LeadHelperTH.booleanCampaignUpdate = false;
                leadRS.updateAllWorkflowsActionsAfterInsert(Trigger.new, trigger.isupdate);
                LeadHelperTH.ShareRecordswithDealers(Trigger.new, Trigger.isupdate);
                leadRS.CreateRetailCopy(trigger.new, (Map < Id, Lead__C > ) Trigger.OldMap, isInsert, isUpdate);
                if (Trigger.isUpdate) 
                {
                    leadRS.CdmLeadcreate(trigger.new, (Map < Id, Lead__C > ) Trigger.OldMap);
                    
                }
            }
        }
  
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}