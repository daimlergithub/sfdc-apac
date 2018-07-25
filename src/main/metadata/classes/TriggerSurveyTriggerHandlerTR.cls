/*
Created by Hildaa
date:
*/

public class TriggerSurveyTriggerHandlerTR implements TriggerHandlerIf {
   public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
         if(Trigger.isAfter && Trigger.isInsert){
             
        Map<Id,Survey__c> oldmap = (Map<Id,Survey__c>)Trigger.oldmap;
          SurveyHelperTR.handleInsertOrUpdateEvent(trigger.new,oldmap);
        }
       
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Survey__c> oldmap = (Map<Id,Survey__c>)Trigger.oldmap;
           SurveyHelperTR.handleInsertOrUpdateEvent(trigger.new,oldmap);

        }
       
    }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Survey__c> oldmap = (Map<Id,Survey__c>)Trigger.oldmap;
             SurveyHelperTR.handleInsertOrUpdateEvent(trigger.new,oldmap);
            
        }
         if(Trigger.isAfter && Trigger.isInsert)
          {
            Map<Id,Survey__c> oldmap = (Map<Id,Survey__c>)Trigger.oldmap;
            SurveyHelperTR.handleInsertOrUpdateEvent(trigger.new,oldmap);
          }
        

    }
}