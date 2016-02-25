/*
    Type:       Trigger on Account
    Purpose:    1. Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are updated. 
                2. Upadte Primary address display field based on primary address reference lookup field.
                3. Upadte Primary contact information based on corresponding picklist values.
    Created By: Sudhir
    Date: 2015-12-22
    User Story: US-DS-001, US-Lead-009
    Used By:    
    ---------------------------------------------------------------
*/
public class TriggerAccountTriggerHandlerJP 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
        if(isBefore && isInsert )
            {
                system.debug('*****');
                AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperJP.updatePrimaryContactInformationBeforeInsert(Trigger.new,trigger.isInsert);
            }
        if(isBefore && isUpdate)
        	{
            	AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            	AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            	AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,trigger.isUpdate);
        	}
        if(isAfter && isInsert)
        	{
            	system.debug('#######');
	            AccountHelperJP.createUCID(Trigger.new,trigger.isInsert);
        	} 
    }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(isBefore && isInsert )
            {
                system.debug('*****');
                AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperJP.updatePrimaryContactInformationBeforeInsert(Trigger.new,trigger.isInsert);
            }
        if(isBefore && isUpdate)
        	{
            	AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            	AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            	AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,trigger.isUpdate);
        	}
    }
}