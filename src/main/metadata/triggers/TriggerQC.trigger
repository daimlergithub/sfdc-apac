/*
    Type:       Trigger
    Purpose:    1. Calculate total scores when qc is updated.
                2. Update Qualified value
                3. Set Total Score/Total Score1/Total Score2 to 0 when the status is Cancel or Disqualified
    User Story: US-QC-005, US-QC-021, CR-131111
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-April-2013 Sinow Zhang (NTTData)  Created
    Patrick Zhang add new logic branch on 2013-12-03
    2014-2-26 Updated by Justin Yu
*/
/*
    Type:       Trigger
    Purpose:    1. Share with QC record's CSR Name with Read only
                2. Update QC Approved of Survey Result to true if QC's Survey Result is not null and approved is true.
                3.  Auto track field history when QC record be changed.
    User Story: US-QC-012, US-QC-021, US-QC-011
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-April-2013 Sinow Zhang (NTTData)  Created
*/
trigger TriggerQC on QC__c (after insert,after Update) {
    if (!TriggerUtil.isTriggerEnabled('TriggerQC')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        QCHelper.afterInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        QCHelper.afterInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
        QCHelper.beforeInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        QCHelper.beforeInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
    }
}