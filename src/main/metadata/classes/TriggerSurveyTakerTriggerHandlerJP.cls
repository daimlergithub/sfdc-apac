/*
Created by suryavarma
date:1/11/2017
*/



public class TriggerSurveyTakerTriggerHandlerJP implements TriggerHandlerIf {
   public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
         if(Trigger.isAfter && Trigger.isInsert){
             
        Map<Id,SurveyTaker__c> oldmap = (Map<Id,SurveyTaker__c>)Trigger.oldmap;
          SurveyTakerHelperJP.afterInsertEvent(trigger.new);
        }
       
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,SurveyTaker__c> oldmap = (Map<Id,SurveyTaker__c>)Trigger.oldmap;
           SurveyTakerHelperJP.afterUpdateEvent(trigger.new,oldmap);

        }
        
       
    }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,SurveyTaker__c> oldmap = (Map<Id,SurveyTaker__c>)Trigger.oldmap;
           SurveyTakerHelperJP.afterUpdateEvent(trigger.new,oldmap);
            
        }
         if(Trigger.isAfter && Trigger.isInsert)
          {
            Map<Id,SurveyTaker__c> oldmap = (Map<Id,SurveyTaker__c>)Trigger.oldmap;
            SurveyTakerHelperJP.afterInsertEvent(trigger.new);
          }
          
        

    }
}