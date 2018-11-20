/*
Type:      class
Purpose:   Update Relation of customer/vr on response 

*/
public class InsightResponseTriggerHandlerAU implements TriggerHandlerIf{
    list<Insights_Response__c> ListRespOld = (list<Insights_Response__c>)trigger.old;
    list<Insights_Response__c> ListRespNew = (list<Insights_Response__c>)trigger.new;


  public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){   

  
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric) || Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric) )  {
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
        InsightResponseHelperAU.UpdateRelation(Trigger.New); 
        }
          if ((isAfter && isUpdate)||(isAfter && isInsert)){ 
        InsightResponseHelperAU.afterInsertEventShareInsightResponse(Trigger.New); 
      }
    
        }
    
    }   
    
        public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
         list<Insights_Response__c> ListRespNew = (list<Insights_Response__c>)trigger.new;
        if (((isBefore && isUpdate)||(isBefore && isInsert)) &&  ( ListRespNew[0].Market__c == System.Label.AU ||  ListRespNew[0].Market__c == System.Label.NZ)){
            InsightResponseHelperAU.UpdateRelation(Trigger.New); 
            }
            
            if (((isAfter && isUpdate)||(isAfter && isInsert)) &&  ( ListRespNew[0].Market__c == System.Label.AU ||  ListRespNew[0].Market__c == System.Label.NZ)){            
            InsightResponseHelperAU.afterInsertEventShareInsightResponse(Trigger.New); 
            
        }
    }

}