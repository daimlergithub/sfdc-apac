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
        System.debug('*******************************handleTrigger initiated****************************************');
        //user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];
        
        if(isBefore && isInsert)
        {         
                LeadHelperJP.InsertAssignedDealer(trigger.new);     
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate); 
              LeadHelperJP.createContactToContactAccounlink(trigger.new);               
        }
        if(isBefore && isUpdate)
        {
            LeadHelperBase.updatemarket(Trigger.New);
            LeadHelperJP.updateCustomerStage(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, (Map<Id,Lead__C>)Trigger.NewMap);
            LeadLatestPhaseUpdateJP.LeadLatestPhaseUpdate(trigger.new,isInsert,isUpdate);
            // LeadHelperAccountLinkCreateJP.updatingleadcontactDetails(trigger.new,isInsert, isUpdate);
             LeadHelperJP.createContactToContactAccounlink(trigger.new);  
             LeadHelperJP.deleteSharingTODealers((list<Lead__C>)trigger.new,(Map<Id,Lead__C>)Trigger.OldMap); 
             //LeadHelperJP.sharingTOJapanDataManagement((list<Lead__C>)trigger.new,(Map<Id,Lead__C>)Trigger.OldMap);          
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
                LeadHelperJP.sharingTOJapanDataManagement((list<Lead__C>)trigger.new,(Map<Id,Lead__C>)Trigger.OldMap);
            
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
        System.debug('*******************************handleIntegrationTrigger initiated****************************************');
        for (Lead__c lead:(List<Lead__c>)Trigger.new){
            system.debug('******************************************Target Lead No.:' + lead.Name + '*************************************');
            system.debug('******************************************Target Lead Assigned Dealer.:' + lead.Assigned_Dealer__c + '*************************************');
        }
        // Implementation to addedd as required in market
          if(isAfter &&  isInsert)
        {
        System.debug('*******************************isAfterisInsert part initiated****************************************');           
            //LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
            //if(LeadUtil.handleAfterInsert)
            //{
        System.debug('*******************************handleAfterInsertOrUpdate part initiated****************************************');           
                System.debug('welcome');
                LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            //}
        System.debug('*******************************afterInsertUpdateEvent part initiated****************************************');           
             LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
         // LeadUtil.handleAfterInsert = false;
        }
        
         if(isAfter && isUpdate )
        {
        System.debug('*******************************isAfterisUpdate part initiated****************************************');           
      
            //if(LeadUtil.handleAfterInsert)
            //{
        System.debug('*******************************handleAfterInsertOrUpdate part initiated****************************************');           
                System.debug('welcome');
                LeadHelperJp.handleAfterInsertOrUpdate(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap);
            //}
          //LeadUtil.handleAfterInsert = false;
        System.debug('*******************************afterInsertUpdateEvent part initiated****************************************');           
            LeadHelperJp.afterInsertUpdateEvent(Trigger.new,(Map<Id,Lead__C>)Trigger.oldMap,isInsert,isUpdate);
        }
          
          if(isAfter && isInsert && LeadUtil.isCreated){      
        System.debug('*******************************isAfterisUpdateisCreated part initiated****************************************');           
             
            LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);
            LeadUtil.isCreated = false;
        }
        
         if(isAfter && isUpdate){
         //&& LeadUtil.LeadTrigger
        System.debug('*******************************isAfterisUpdateLeadTrigger part initiated****************************************');           
             LeadHelperJP.EmailnotificationforLeads(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, isInsert, isUpdate);          
           //LeadUtil.LeadTrigger = false;
            
        }
    }

}