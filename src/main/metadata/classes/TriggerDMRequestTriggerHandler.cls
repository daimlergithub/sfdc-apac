/**
    Type:       Trigger
    Purpose:    Auto modify SentTotal field on DM Material when DM Request Status changed to 'Sent'
    User Story: US-DM-004
    11-Mar-2013 Chris Huang (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerDMRequestTriggerHandler
**/
public class TriggerDMRequestTriggerHandler 
    implements TriggerHandlerIf
{
/**
*@description implements the trigger interface and updating the DM_Request sent total.
*@author 
*@date 10/26/2015(mm/dd/yyyy)
  *@param trigger.new a list containing new records of DM_Request
  *@param trigger.oldmap  containing old records of DM_Request with their ID's
  *@see DMRequestTriggerHandler
  */
    public void handleTrigger()
    {
        
        DMRequestTriggerHandler.updateDaterialSentTotal(trigger.new, (Map<Id,DM_Request__c>)trigger.oldmap);         
  /**
*@description implements the trigger interface and updating the DM_Request activity status.
*@author Kaushik Mahanty
*@date 10/26/2015(mm/dd/yyyy)
  *@param trigger.newmap  containing new records of DM_Request with their ID's
  *@see DMRequestTriggerHandler
  */      
        if(trigger.isUpdate){
            DMRequestTriggerHandler.updateActivityStatus((Map<Id,DM_Request__c>)trigger.newmap);            
        }  
    }
}