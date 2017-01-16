/*
    Type:       Trigger
    Purpose:    Every insert / delete on pack item will do same operation on dealer offering record. 
    User Story: US-Cpn-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    29-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerPackageItemTriggerHandler
*/
trigger TriggerPackageItem on Package_Item__c (before delete, after insert) 
{
    TriggerUtil.handleTrigger('TriggerPackageItem');
}