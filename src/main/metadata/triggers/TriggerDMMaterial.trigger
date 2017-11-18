/*
    Type:       Trigger
    Purpose:    
    User Story: SFDCKR-1558
    Used By:    Korea Market
    ---------------------------------------------------------------
    History:    
    16-Nov-2017 NTT Data - Created
*/
trigger TriggerDMMaterial on DM_Material__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{	
    TriggerUtil.handleTrigger('TriggerDMMaterial'); 
}