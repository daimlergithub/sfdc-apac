/*
    Type:       Trigger
    Purpose:    1. Validate NoOfLicense when create a Portal user
                2. If 'Dealer Lead Gate Keeper' is checked, the profile selected must be 'Dealer-Lead Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin' 
-                  If 'Dealer Complaint Gate Keeper' is checked, the profile selected must be 'Dealer-Complaint Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin'
                3. Copy Funderation Id from Contact
    User Story: US-DP-007, US-DP-004, Release1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    19-April-2013 Sinow Zhang (NTTData)  Created
    
    Type:       Trigger
    Purpose:    1. When disable a portal user, update contact's portal user to false.
    User Story: US-DP-006
    Used By:
    ---------------------------------------------------------------
    History:

    21-May-2013 Sinow Zhang (NTTData)  Created
    26-Aug-2013 Chris Huang (Breakingpoint) Created
    8-May-2014  Cyril Huang (NTTData)  Modified
*/
trigger UserTrigger on User (after update, after insert,before update, before insert) {
	
	if(trigger.isAfter && trigger.isInsert)
    {
    	if(UtilCustomSettings.isEnabled('UserAfterInsertUpdate'))
    	{
    		UserHelper.AfterInsert_UpdateMethod(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);		
    	}	
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
    	if(UtilCustomSettings.isEnabled('UserAfterInsertUpdate'))
    	{
            UserHelper.AfterInsert_UpdateMethod(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);	
    	}	
    }
    if(trigger.isBefore && trigger.isInsert)
    {
    	 if (UtilCustomSettings.isEnabled('UserBeforeInsertUpdate'))
    	 {
        	UserHelper.ValidateUser(Trigger.new);	
    	 }
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
    	 if (UtilCustomSettings.isEnabled('UserBeforeInsertUpdate'))
    	 {
    	 	UserHelper.ValidateUser(Trigger.new);	
    	 }
    }
}