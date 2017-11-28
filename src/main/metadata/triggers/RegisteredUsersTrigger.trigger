/************************************************************************************
* Created By:Sarath M
* Created Date:23-Sept-2017
* Company:Infosys Ltd
* Description: trigger to submit the request to approval process and create community user once it is approved.         
* **********************************************************************************/

trigger RegisteredUsersTrigger on Registered_Users__c(after insert,after update) {
    TriggerUtil.handleTrigger('RegisteredUsersTrigger');
}