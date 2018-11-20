/**
Type:       Trigger    
Purpose:    1. System should not allow user to register multiple times to event with the same email address

User Story: RCP-83
Used By:    
---------------------------------------------------------------
History:

30-August-2018 Surendranath  Created
*/
trigger EventRegTrigger on Registration__c (before insert, before update,after update, after insert) {    
    /*Get list of Registration records to check 
whether email id already exists or not. */
    if(trigger.isbefore ){
        EventRegTriggerHandler ER = new EventRegTriggerHandler();
        if(trigger.isinsert || trigger.isupdate){ 
            ER.validateEventReg(Trigger.New);
        }        
    }
    // RCP-83 send email to register user about event
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        EventsEmail.eventsRegHandle(Trigger.new); 
}