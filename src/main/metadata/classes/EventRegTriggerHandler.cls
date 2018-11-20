/**
Type:       Class    
Purpose:    1. System should not allow user to register multiple times to event with the same email address

User Story: RCP-83
Used By:    
---------------------------------------------------------------
History:

30-August-2018 Surendranath  Created
*/
public with sharing class EventRegTriggerHandler {
    /*This method will take List of Registration records to check 
whether email id already exists or not.  */
    public void validateEventReg(List<Registration__c> erlst) {
        Set<String> allEmails = new Set<String>();        
        for(Registration__c er: erlst){
            allEmails.add(er.Email_Id__c);
        }
        List<Registration__c> erResults = [select Id,Email_Id__c,Related_Event__c FROM Registration__c where Email_Id__c IN: allEmails];
        if(erResults.size() > 0){
            for(Registration__c er1: erlst){
                for(Registration__c erS: erResults){
                    if(er1.Email_Id__c == erS.Email_Id__c && er1.Related_Event__c == erS.Related_Event__c && er1.Id != erS.Id){
                        er1.addError('You are not allowed to register with the same email Id. Please use different email Id.');
                        break;
                    }
                }
            }
        }
    }
}