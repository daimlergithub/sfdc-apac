/* ***********************************************************************************
* Created By:Kavya Bondada
* Project: RCP Indoensia
* Created Date: July-2018
* Company:Infosys Ltd
* Description: Trigger  on News__c.
* **********************************************************************************/

trigger approvedNewsStartDateCheck on News__c (before update,after update) {
    if(trigger.isbefore && trigger.isupdate)        
        newsController.onBeforeupdate(Trigger.New); 
    if(Trigger.isAfter && Trigger.isUpdate)
        newsController.onAfterupdate(Trigger.New);
}