/*
    Type:       Trigger
    Purpose:    1. Calculate total scores when qc is updated.
                2. Update Qualified value
                3. Set Total Score/Total Score1/Total Score2 to 0 when the status is Cancel or Disqualified
                4. Share with QC record's CSR Name with Read only
                5. Update QC Approved of Survey Result to true if QC's Survey Result is not null and approved is true.
                6.  Auto track field history when QC record be changed.
    User Story: US-QC-005, US-QC-021, CR-131111, US-QC-012, US-QC-021, US-QC-011
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-April-2013 Sinow Zhang (NTTData)  Created
    Patrick Zhang add new logic branch on 2013-12-03
    2014-2-26 Updated by Justin Yu
    08-April-2013 Sinow Zhang (NTTData)  Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerQCTriggerHandler
*/
public class TriggerQCTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,QC__c> oldmap = (Map<Id,QC__c>)trigger.oldmap;
        Map<Id,QC__c> newmap = (Map<Id,QC__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            QCHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            QCHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
        }
        if(trigger.isBefore && trigger.isInsert)
        {
            QCHelper.beforeInsertUpdateEvents(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            QCHelper.beforeInsertUpdateEvents(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}