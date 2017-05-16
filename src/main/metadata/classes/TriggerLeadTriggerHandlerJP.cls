/*
    Type:       Trigger HAndler class for Lead object
    Created By : Narasimha 
    Created Date : 1/20/2016
*/
public class TriggerLeadTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];   
        System.debug('Handletrigger----->');
        
        if(isAfter && isUpdate)
        {
            if(LeadUtil.handleAfterInsert)
            {
                System.debug('welcome');
                LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            }
          LeadUtil.handleAfterInsert = false;
        }
        
        if(isBefore && isInsert && usr.Profile.Name != 'IntegrationAPI')
        {           
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate); 
              LeadHelperJP.createContactToContactAccounlink(trigger.new);               
        }
        if(isBefore && isUpdate && usr.Profile.Name != 'IntegrationAPI')
        {
            LeadHelperJP.updateCustomerStage(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, (Map<Id,Lead__C>)Trigger.NewMap);
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate);
            // LeadHelperAccountLinkCreateJP.updatingleadcontactDetails(trigger.new,isInsert, isUpdate);
             LeadHelperJP.createContactToContactAccounlink(trigger.new);  
                        
        }
        system.debug('LeadUtil.isCreated-->'+LeadUtil.isCreated);
        system.debug('insert-->'+isInsert);
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated){
            
            //LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadUtil.isCreated = false;
        }
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI'){
           LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
        }

        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI'&& LeadUtil.LeadTrigger ){
            system.debug('Isafter is');
            //LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
           // LeadUtil.isCreated = false;
           LeadUtil.LeadTrigger = false;
            
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI' ){
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            //LeadUtil.leadAccountlnktrigger = false;
         }
         if(isAfter && isInsert){
           //LeadHelperJP.populateRetailCompany(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
        }
        if(isAfter && isUpdate && LeadUtil.isupdated){
            system.debug('#####$$$$$$$'+isUpdate);
            LeadHelperJP.populateRetailCompany(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            if(Userinfo.getUserType() != 'PowerPartner')
                LeadUtil.isupdated = false;
        }

        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
          if(isAfter && (isUpdate || isInsert)){
        System.debug('welcome');
          LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);}
    }

}