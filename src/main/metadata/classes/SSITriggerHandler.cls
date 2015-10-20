/*
    Type:       Apex Class
    Purpose:    Define methods used in SSITrigger
    User Story: US-SSI-007
    Used By:    SSITrigger.trigger
    ---------------------------------------------------------------
    History:
    
    22-Apr-2013 Chris Huang (Breakingpoint)    Created
    2015-04-21 Gerhard Henning (NTTData)  Moved code to SSITriggerHandler
*/

public class SSITriggerHandler 
    implements TriggerHandlerIf
{ 
    public void handleTrigger()
    {
        if(trigger.isAfter && trigger.isUpdate)
        {
            // auto generate 2nd survey tasks when user upload ssi record by data loader, related US-SSI-014
            SsiHelper.autoGenerate2ndSurveyTasks((Map<Id,SSI__c>)Trigger.newMap, (Map<Id,SSI__c>)Trigger.oldMap);
            
            // auto calculate ssi data cleansing result
            //calculateDataCleansingResult((Map<Id,SSI__c>)Trigger.newMap, (Map<Id,SSI__c>)Trigger.oldMap);   
        }
        
        if(trigger.isBefore && trigger.isUpdate)
        {
            SsiHelper.fieldUpdates((Map<Id,SSI__c>)Trigger.newMap, (Map<Id,SSI__c>)Trigger.oldMap);
            // field validate    
            SsiHelper.fieldsValidationRule((Map<Id,SSI__c>)Trigger.newMap, (Map<Id,SSI__c>)Trigger.oldMap);
        }
    }

    
}