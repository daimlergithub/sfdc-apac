/**
** Shares new retail tasks to dealers
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: CC
** Date: 2014-6-15
**/
trigger RetailTaskAfter on Retail_Task__c (after insert) {
    if (!UtilCustomSettings.isEnabled('RetailTaskAfter')) {
        return;
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
        RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
        SharingService.shareRetailTasks(wrapService.wrapRetailTasks(Trigger.new));
    }
}