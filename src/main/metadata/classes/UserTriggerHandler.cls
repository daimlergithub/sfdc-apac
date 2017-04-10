/*
    Type:       Trigger
    Purpose:    1. Validate NoOfLicense when create a Portal user
                2. If 'Dealer Lead Gate Keeper' is checked, the profile selected must be 'Dealer-Lead Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin' 
-                  If 'Dealer Complaint Gate Keeper' is checked, the profile selected must be 'Dealer-Complaint Manager' or 'Dealer-Lead+Complaint Manager' or 'Dealer-Delegated Admin'
                3. Copy Funderation Id from Contact
                4. When disable a portal user, update contact's portal user to false.
    User Story: US-DP-007, US-DP-004, Release1.2, US-DP-006
    Used By:    
    ---------------------------------------------------------------
    History:
    
    19-April-2013 Sinow Zhang (NTTData)  Created
    21-May-2013 Sinow Zhang (NTTData)  Created
    26-Aug-2013 Chris Huang (Breakingpoint) Created
    8-May-2014  Cyril Huang (NTTData)  Modified
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to UserTriggerHandler
*/
public class UserTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,User> oldmap = (Map<Id,User>)trigger.oldmap;
        Map<Id,User> newmap = (Map<Id,User>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
        
        System.debug('@$@$@$@$ user trigger');
        UserHelper.createGroup(trigger.new);
        System.debug('@$@$@$@$ user trigger'+trigger.new);
        }
        
        if (trigger.isAfter && trigger.isInsert) {
            UserHelper.AfterInsert_UpdateMethod(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
             UserHelper.UserShareforDealers(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);            
        }
        if (trigger.isAfter && trigger.isUpdate) {
            UserHelper.AfterInsert_UpdateMethod(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);  
              System.debug('@$@$@$@$ user trigger');
            UserHelper.UserShareforDealers(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);
            UserHelper.createGroup(trigger.new);
        }
        if (trigger.isBefore && trigger.isInsert) {
            UserHelper.ValidateUser(Trigger.new);   
        }
        if (trigger.isBefore && trigger.isUpdate) {
            UserHelper.ValidateUser(Trigger.new);   
        }
        if ((trigger.isAfter  && trigger.isInsert)) {
            UserHelper.ApexShare((List<User>)trigger.new);   
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}