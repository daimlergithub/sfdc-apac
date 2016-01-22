/*
    Type:       Trigger
    Purpose:    1. Calculate Total amount when settlement is changed
                2. if Settlement Type = "No Settlement". Disable these fields in that case and default to 0 when saving.
    User Story: US-DPCR-001, Defect#1487
    Used By:    
    ---------------------------------------------------------------
    History:
    
    15-July-2013 Sinow Zhang (NTTData) Created
    6-May-2014   Cyril Huang (NTTData) Updated
    15-Oct-2013 Fanny Tang (NTTData) Created
    28-Apr-2014 Cyril Huang (NTTData) Updated
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerSettlementManagementHandler
*/
public class TriggerSettlementManagementHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Settlement_Management__c> oldmap = (Map<Id,Settlement_Management__c>)trigger.oldmap;
        Map<Id,Settlement_Management__c> newmap = (Map<Id,Settlement_Management__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);    
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);
        }
        if(trigger.isAfter && trigger.isdelete)
        {
            SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);    
        }
        if(trigger.isBefore && trigger.isInsert)
        {
            SettlementHelper.setFieldvaluestoDefault_0(Trigger.new);    
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            SettlementHelper.setFieldvaluestoDefault_0(Trigger.new);    
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}