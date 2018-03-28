/************************************************************************************
* Created By:Sarath kumar M
* Created Date:12-Mar-18
* Company:Infosys Ltd
* Description:Trigger on referral Object which calls the handler class BbqTriggerHandler
*************************************************************************************/
trigger TriggerReferral on Referral__c (after insert,after update) {    
  TriggerUtil.handleTrigger('TriggerReferral');
}