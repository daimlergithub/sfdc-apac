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
*/
trigger UserBeforeInsertUpdate on User (before insert, before update) {  

   if (!UtilCustomSettings.isEnabled('UserBeforeInsertUpdate')) {
        return;
    }

    //Map portal user profile ids
    /*
    Profile DealerComplaintManager = [select Id from Profile where Name = 'Dealer Community Complaint Manager'];
    Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Community Delegate Admin'];
    Profile DealerLeadComplaintManager = [select Id from Profile where Name = 'Dealer Community Lead Complaint Manager'];
    Profile DealerLeadManager = [select Id from Profile where Name = 'Dealer Community Lead Manager'];
    Profile DealerMarketingManager = [select Id from Profile where Name = 'Dealer Community Marketing Manager'];
    Profile DealerComplaintUser = [select Id from Profile where Name = 'Dealer Community Complaint User'];
    Set<Id> profileIds = new Set<Id>();
    profileIds.add(DealerComplaintManager.Id);
    profileIds.add(DealerDelegatedAdmin.Id);
    profileIds.add(DealerLeadComplaintManager.Id);
    profileIds.add(DealerLeadManager.Id);
    profileIds.add(DealerMarketingManager.Id);
    profileIds.add(DealerComplaintUser.Id);
    if(Trigger.isInsert || Trigger.isUpdate) {
        // if create user is a portal user, Validate NoOfLicense
        if(profileIds.contains(Trigger.new[0].ProfileId)) {
            UserHelper.ValidateUser(Trigger.new[0]);
            UserHelper.ValidateProfile(Trigger.new[0]);
        }
    }*/
    
    Profile DealerUser = [select Id from Profile where Name = 'Dealer Community User'];
    //modified the query
    Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Delegate Admin'];
    Set<Id> profileIds = new Set<Id>();
    profileIds.add(DealerUser.Id);
    profileIds.add(DealerDelegatedAdmin.Id);
    if(Trigger.isInsert || Trigger.isUpdate) {
        // if create user is a portal user, Validate NoOfLicense
        if(profileIds.contains(Trigger.new[0].ProfileId)) {
            UserHelper.ValidateUser(Trigger.new[0]);
        }
    }
}