/*
  Name                 : TriggerCase
  Object               : Case
  Requirement          : US-Cpn-010
  Refer classes        : UtilCase.cls
  Author               : Mouse Liu
  Create Date          : 2013/7/9
  Modify History       : 
 
 */
trigger TriggerCase on Case(after insert, after delete, after undelete) {
    if (!TriggerUtil.isTriggerEnabled('TriggerCase')) {
        return;
    }
    
    if (trigger.isAfter && (trigger.isInsert || trigger.isUnDelete)) {
        UtilCase.rollupAccountComplaintAmount(trigger.new);
    }

    if (trigger.isAfter && trigger.isDelete) {
        UtilCase.rollupAccountComplaintAmount(trigger.old);
    }
}