/*
    Type:       Trigger
    Purpose:    1. Calculate Total amount when settlement is changed
    User Story: US-DPCR-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    15-July-2013 Sinow Zhang (NTTData) Created
    6-May-2014   Cyril Huang (NTTData) Updated
*/
/*
    Type:       Trigger
    Purpose:    1. if Settlement Type = "No Settlement". Disable these fields in that case and default to 0 when saving.
    User Story: Defect#1487
    Used By:    Fanny
    ---------------------------------------------------------------
    History:
    
    15-Oct-2013 Fanny Tang (NTTData) Created
    28-Apr-2014 Cyril Huang (NTTData) Updated
*/
trigger TriggerSettlementManagement on Settlement_Management__c (after update, after insert,after delete,before update, before insert)
{
	if(trigger.isAfter && trigger.isInsert)
    {
    	if(UtilCustomSettings.isEnabled('TriggerSettlementAfterInsertUpdateDelete'))
    	{
    		SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,trigger.oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);	
    	}	
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
    	if(UtilCustomSettings.isEnabled('TriggerSettlementAfterInsertUpdateDelete'))
    	{
            SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,trigger.oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);
    	}	
    }
    if(trigger.isAfter && trigger.isdelete)
    {
    	if(UtilCustomSettings.isEnabled('TriggerSettlementAfterInsertUpdateDelete'))
    	{
            SettlementHelper.CalculateTotalAmountWhenSettlementIsChanged(Trigger.new,Trigger.old,trigger.oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);	
    	}	
    }
    if(trigger.isBefore && trigger.isInsert)
    {
    	 if (UtilCustomSettings.isEnabled('TriggerSettlementBeforeInsertUpdate'))
    	 {
        	SettlementHelper.setFieldvaluestoDefault_0(Trigger.new);	
    	 }
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
    	 if (UtilCustomSettings.isEnabled('TriggerSettlementBeforeInsertUpdate'))
    	 {
    	 	SettlementHelper.setFieldvaluestoDefault_0(Trigger.new);	
    	 }
    }
}