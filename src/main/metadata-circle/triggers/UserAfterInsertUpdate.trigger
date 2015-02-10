/*
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
trigger UserAfterInsertUpdate on User (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('UserAfterInsertUpdate')) {
        return;
    }

    //Map portal user profile ids
    Profile DealerDelegatedAdmin = null;
    Profile DealerCommunityUser = null;

    Profile CACSSICSR = null;
    Profile CACSSIQC = null;
    Profile CACSSISV = null;
    Profile CACSSITL = null;
    Profile CACSSITR = null;

    Set<String> profileNames = new set<String> {'Dealer Community User','Dealer Community Delegate Admin',
                                                'CAC SSI CSR','CAC SSI QC','CAC SSI SV','CAC SSI TL','CAC SSI Trainer'};
    for (Profile pro : [select Id, Name from Profile where Name in :profileNames]) {
        if (pro.Name == 'Dealer Community User') {
            DealerCommunityUser = pro;
        } else if (pro.Name == 'Dealer Community Delegate Admin') {
            DealerDelegatedAdmin = pro;
        } else if (pro.Name == 'CAC SSI CSR') {
            CACSSICSR = pro;
        } else if (pro.Name == 'CAC SSI QC') {
            CACSSIQC = pro;
        } else if (pro.Name == 'CAC SSI SV') {
            CACSSISV = pro;
        } else if (pro.Name == 'CAC SSI TL') {
            CACSSITL = pro;
        } else if (pro.Name == 'CAC SSI Trainer') {
            CACSSITR = pro;
        }
    }

    Set<Id> profileIds = new Set<Id>();
    profileIds.add(DealerCommunityUser.Id);
    profileIds.add(DealerDelegatedAdmin.Id);

    Set<Id> SSIprofileIds = new Set<Id>();
    if(CACSSIQC!=null)//TODO--added null check
    	SSIprofileIds.add(CACSSIQC.Id);
    if(CACSSISV!=null)//TODO--added null check	
    	SSIprofileIds.add(CACSSISV.Id);
    if(CACSSITL!=null)//TODO--added null check	
    	SSIprofileIds.add(CACSSITL.Id);
    if(CACSSITR!=null)//TODO--added null check	
    SSIprofileIds.add(CACSSITR.Id);

    if(Trigger.isUpdate) {
        // if update user is a portal user
        if(profileIds.contains(Trigger.new[0].ProfileId) && !Trigger.new[0].IsPortalEnabled && Trigger.oldMap.get(Trigger.new[0].Id).IsPortalEnabled) {
            UserHelper.updateContact(Trigger.new[0].ContactId, false);
        }
    }

    // [Start] Added by Cyril on 2014-05-08 (Release1.1b)
    if(Trigger.isInsert) {
        if(profileIds.contains(Trigger.new[0].ProfileId)) {
            //when the user insert, share the account, vehicle and vehicle relation to the user
            UserHelper.ShareAllDataToNewUserBatch(Trigger.new[0].AccountId, Trigger.new[0].Id);
        }
    }
    // [End] Added by Cyril on 2014-05-08 (Release1.1b)

    User user = [Select Username, UserRole.Name, UserRoleId, Profile.Name, ProfileId, Phone, Email, IsActive From User Where Id = :Trigger.new[0].Id];
    if((user.Profile.Name.startsWith('CAC E-') || user.Profile.Name.equals('CAC IB OM')) && user.IsActive == true){
        UserTriggerCallout.syncUser(user.Id, user.Username, user.UserRole.Name, user.Profile.Name, user.Phone, user.Email);
    }

    // By Shuang Li BRD-AS-CAC-007---- strart
    if(Trigger.isUpdate) {
        Set<Id> userIds = new Set<Id>();
        Set<Id> userPermissionSetIds = new Set<Id>();
        for(User userNew : Trigger.new) {//TODO--added null check
            if(CACSSICSR!=null && CACSSICSR.id == Trigger.oldMap.get(userNew.Id).ProfileId && userNew.ProfileId != Trigger.oldMap.get(userNew.Id).ProfileId && SSIprofileIds!=null && !SSIprofileIds.contains(userNew.ProfileId)) {
                userIds.add(userNew.Id);
            }
            if(userNew.Active_Permission_Set__c && userNew.Active_Permission_Set__c != Trigger.oldMap.get(userNew.Id).Active_Permission_Set__c) {
                userPermissionSetIds.add(userNew.Id);
            }
        }
        TaskHelper.autoUpdateSSITask(userIds);

        if(userPermissionSetIds.size() > 0) {
            UserHelper.AssignPermissionSetForPortalUser(userPermissionSetIds);
            UserHelper.ShareAllDataToNewUser(Trigger.new[0].AccountId, Trigger.new[0].Id, Trigger.new[0].ProfileId);
        }
    }
    // By Shuang Li BRD-AS-CAC-007---- end
}