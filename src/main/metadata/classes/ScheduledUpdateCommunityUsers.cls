/*
    Type:       Schedule For Update Community Users
    Purpose:    1. For filling in the FederationIdentifier with Federation ID from Contact.
                2. Update UserPermissionsSFContentUser field for commmunity user.
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
        1. Cyril Huang Created on 2014-07-04
*/

global class ScheduledUpdateCommunityUsers implements Schedulable{

    global void execute(SchedulableContext SC) 
    {
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            
            Date previousDay = System.today().addDays(-1);
            Id licenseId = [Select Id From UserLicense Where Name = 'Partner Community'].Id;
            List<user> newCommunityUsers = [Select Id, FederationIdentifier, Contact.Federation_ID__c, UserPermissionsSFContentUser, Contact.Permission_Set_Settings__c from user where IsActive = true AND Profile.UserLicenseId = :licenseId AND Contact.LastModifiedDate >= :previousDay];
            List<user> updateList = new List<user>();
            Boolean needUpdate = false;
            
            for (user u : newCommunityUsers ) {
                needUpdate = false;
                if (u.Contact.Federation_ID__c != '' && u.Contact.Federation_ID__c != null && u.FederationIdentifier != u.Contact.Federation_ID__c) {
                    u.FederationIdentifier = u.Contact.Federation_ID__c;
                    needUpdate = true;
                }
                
                if (u.Contact.Permission_Set_Settings__c != null && u.Contact.Permission_Set_Settings__c.contains('Info_Center') && u.UserPermissionsSFContentUser == false) {
                    u.UserPermissionsSFContentUser = true;
                    needUpdate = true;
                }
                
                if (needUpdate) updateList.add(u);
            }
            
            if (updateList.size() > 0) {
                try {
                    update updateList;
                }
                catch (DMLException e) {
                    System.debug('Error occured when updating new Community Users :' + e.getDMLMessage(0));
                }
            }
        }
    }
}