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
        //user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
        
        if(isBefore && isInsert)
        {           
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate); 
              LeadHelperJP.createContactToContactAccounlink(trigger.new);               
        }
        if(isBefore && isUpdate)
        {
            LeadHelperJP.updateCustomerStage(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, (Map<Id,Lead__C>)Trigger.NewMap);
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate);
            // LeadHelperAccountLinkCreateJP.updatingleadcontactDetails(trigger.new,isInsert, isUpdate);
             LeadHelperJP.createContactToContactAccounlink(trigger.new);  
                        
        }
        System.debug('Handletrigger----->');
        
        if(isAfter &&  isInsert)
        {
            System.debug('welcome');
            LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            if(!system.isFuture() && LeadUtil.createAccountLinkRecord)
            {
                LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            }
            LeadHelperAccountLinkCreateJP.populateRetailCompany(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            
                LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
        }
        
        if(isAfter && isUpdate )
        {
            System.debug('welcome');
            LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
            if(!system.isFuture() && LeadUtil.createAccountLinkRecord)
            {
                LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            }
            LeadHelperAccountLinkCreateJP.populateRetailCompany(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            
                LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            
        }
        
        system.debug('LeadUtil.isCreated-->'+LeadUtil.isCreated);
        system.debug('insert-->'+isInsert);
        /*if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI' && LeadUtil.isCreated){
            
            //LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadUtil.isCreated = false;
        }
        if(isAfter && isInsert && usr.Profile.Name != 'IntegrationAPI'){
           LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
        }

        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI'){
            //if(LeadUtil.LeadTrigger)
            //{
                LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            //}
            //LeadUtil.LeadTrigger = false;
            
        }
        if(isAfter && isUpdate && usr.Profile.Name != 'IntegrationAPI' ){
            //if(LeadUtil.leadAccountlnktrigger)
            LeadHelperAccountLinkCreateJP.leadAccountDetails(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);            
           //if(Userinfo.getUserType() != 'PowerPartner')
               //LeadUtil.leadAccountlnktrigger = false;
         }
         if(isAfter && (isInsert||isUpdate)){
            LeadHelperAccountLinkCreateJP.populateRetailCompany(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
        }*/
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
          if(isAfter &&  isInsert)
        {
            LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
            if(LeadUtil.handleAfterInsert)
            {
                System.debug('welcome');
                LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            }
         // LeadUtil.handleAfterInsert = false;
        }
        
         if(isAfter && isUpdate )
        {
        LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
            if(LeadUtil.handleAfterInsert)
            {
                System.debug('welcome');
                LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            }
          LeadUtil.handleAfterInsert = false;
        }
          
          if(isAfter && isInsert && LeadUtil.isCreated){      
             
            LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadUtil.isCreated = false;
        }
        
         if(isAfter && isUpdate && LeadUtil.LeadTrigger ){
             LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);          
           LeadUtil.LeadTrigger = false;
            
        }
    }

}