/*
    Type:       Utility for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City CN and Province 
    User Story: US-DS-001, US-Lead-009
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28 for US-DS-OO1
    2. Mouse Updated on 2013-07-04 for US-Lead-009
    3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
*/
trigger TriggerAccount on Account (before update,after update) {
    if (!TriggerUtil.isTriggerEnabled('TriggerAccount')) {
        return;
    }

   If(Trigger.isAfter || Trigger.isBefore &&Trigger.isUpdate){
    // Get the Record Type Id of 'Dealer'
    Id dealerRecordTypeId = UtilRecordType.getRecordTypeIdByName('Account', 'Dealer');
    if (trigger.isUpdate && trigger.isBefore) {
        // US-DS-001, link dealer to Dealer City by City CN and Province
        UtilAccount.linkDealerCity(trigger.new,dealerRecordTypeId,Trigger.oldMap,Trigger.isUpdate,Trigger.isBefore,Trigger.isExecuting);
     }
    if (trigger.isAfter && trigger.isUpdate) {
        UtilAccount.accountSetForUpdateLead(trigger.new,Trigger.oldMap);
    }
  }
  /*
    Type:       Trigger
    Purpose:    1. If customer has no vehicle relationship, Status must not be ‘Customer’ 
                2. Update dealer record in salesforce manually check
                3. When city change , update look up
                
    User Story: US-CP-010 , US-CP-016  ,US-CP-017 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-06-05
*/
   If(Trigger.isBefore){
     UtilAccount.beforeAccDealerInfo(Trigger.new,Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);
   }
 }