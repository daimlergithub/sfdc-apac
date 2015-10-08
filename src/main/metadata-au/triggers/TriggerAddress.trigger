trigger TriggerAddress on Address__c (before insert, before update,after insert, after update, after delete) 
{     
     TriggerUtil.handleTrigger('TriggerAddress');   
        
}