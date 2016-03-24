/**
** Shares new retail tasks to dealers
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: CC
** Date: 2014-6-15
**/
public class TriggerRetailTaskTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        Map<Id,Retail_Task__c> oldmap = (Map<Id,Retail_Task__c>)trigger.oldmap;
        Map<Id,Retail_Task__c> newmap = (Map<Id,Retail_Task__c>)trigger.newmap;
        
        if(Trigger.isInsert && Trigger.isAfter){
          /*TODO -commented need to add trigger switching mechanism
            RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
            SharingService.shareRetailTasks(wrapService.wrapRetailTasks(Trigger.new));*/
            
            //existing au functionality
            RetailTaskHelper.au_After_Insert_Update_Events(trigger.new,newmap,oldmap,Trigger.isInsert,Trigger.isUpdate);
        }
        //existing au functionality
        if(Trigger.isUpdate && Trigger.isAfter){
            RetailTaskHelper.au_After_Insert_Update_Events(trigger.new,newmap,oldmap,Trigger.isInsert,Trigger.isUpdate);
            RetailTaskHelper.sentEmailAfterStatusToCurrent(trigger.new,oldmap,newmap,Trigger.isInsert,Trigger.isUpdate);
        }
    }
}