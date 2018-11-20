/**
Type:       Apex trigger for Event Emails    
Purpose:    1. Send email alerts to Users

User Story: RCP-83
Used By:    
---------------------------------------------------------------
History:

05-Sep-2018 Infosys Ltd  Created
*/
trigger EventCustomTrigger on Events__c (after update) {
    /*Get list of Updated Event records to send email to register user about event changes */
    if(Trigger.isAfter && Trigger.isUpdate)
    	EventsEmail.eventsHandle(Trigger.new,Trigger.old);    
}