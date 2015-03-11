/*
  Name                 : TriggerCase
  Object               : Case
  Requirement          : US-Cpn-010
  Refer classes        : UtilCase.cls
  Author               : Mouse Liu
  Create Date          : 2013/7/9
  Modify History       : 
 
 */
trigger TriggerCase on Case(before insert,before update,after insert,after update,after delete, after undelete) {
    
       if(trigger.isBefore){        
          if (!UtilCustomSettings.isEnabled('CaseBeforeInsertUpdate')) {
                return;
            }
          CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new, Trigger.isInsert,Trigger.isUpdate, Trigger.oldMap);
       }
      
       if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){            
            if (!UtilCustomSettings.isEnabled('CaseAfterInsertOrUpdate')) {
                return;
            }        
            CaseHelper.handleCaseAfterInsertOrUpdateEvents(Trigger.new, trigger.isInsert, trigger.isUpdate, trigger.oldMap, trigger.newMap);
        }
    
       if(trigger.isAfter || trigger.isDelete || trigger.isUnDelete) {
          if (!UtilCustomSettings.isEnabled('TriggerCase')) {
              return;
          }
       }   
    
       if(trigger.isAfter && (trigger.isInsert || trigger.isUnDelete)) {
            UtilCase.rollupAccountComplaintAmount(trigger.new);
        }

       if(trigger.isAfter && trigger.isDelete) {
            UtilCase.rollupAccountComplaintAmount(trigger.old);
        }
}