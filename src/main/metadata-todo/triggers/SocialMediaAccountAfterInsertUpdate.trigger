trigger SocialMediaAccountAfterInsertUpdate on Social_Media_Account__c  (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('SocialMediaAccountAfterInsertUpdate')) {
        return;
    }
    
    List<Account_Link__c> newAccLinks = new List<Account_Link__c>();
    List<Account_Link__c> updateLinks = new List<Account_Link__c>();
    Map<Id, Social_Media_Account__c> socialMediaAccMap = new Map<Id, Social_Media_Account__c>();
    Set<String> changedSocialMediaAccIds = new Set<String>();
    Id recordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ExternalLink').getRecordTypeId();
    
    for(Social_Media_Account__c smaNew : Trigger.new) {
        if (trigger.isInsert) {
            Account_Link__c accLink = new Account_Link__c();
            accLink.Position__c = smaNew.Name;
            accLink.fromRole__c = smaNew.Account__c;
            accLink.System__c = smaNew.Type__c;
            accLink.Name = smaNew.Nick_Name__c;
            accLink.RecordTypeId = recordTypeId;
            accLink.SocialMediaAccount_ID__c = smaNew.Id;
            newAccLinks.add(accLink);
        }
        
        if (trigger.isUpdate) {
            Social_Media_Account__c smaOld = Trigger.oldMap.get(smaNew.Id);
            if (smaOld.Name != smaNew.Name || smaOld.Account__c != smaNew.Account__c || smaOld.Type__c != smaNew.Type__c || smaOld.Nick_Name__c != smaNew.Nick_Name__c) {
                socialMediaAccMap.put(smaNew.Id, smaNew);
                changedSocialMediaAccIds.add(smaNew.Id);
            }
        }
    }
    
    if (newAccLinks.size() > 0) {
        try {
            insert newAccLinks;
        } catch (DMLException ex) {
            System.debug('DMLException Exception occured when creating Account accLink records: ' + ex.getMessage());
        }
    }
    
    for (Account_Link__c accLink : [Select Id, Position__c, fromRole__c, System__c, Name, SocialMediaAccount_ID__c from Account_Link__c where RecordTypeId = :recordTypeId And SocialMediaAccount_ID__c in :changedSocialMediaAccIds]) {
        Social_Media_Account__c socialMediaAcc = socialMediaAccMap.get(accLink.SocialMediaAccount_ID__c);
        accLink.Position__c = socialMediaAcc.Name;
        accLink.fromRole__c = socialMediaAcc.Account__c;
        accLink.System__c = socialMediaAcc.Type__c;
        accLink.Name = socialMediaAcc.Nick_Name__c;
        updateLinks.add(accLink);
    }
    
    if (updateLinks.size() >0) {
        try {
            update updateLinks;
            system.debug('step 03');
        } catch (DMLException ex) {
            System.debug('DMLException Exception occured when updating Account accLink records: ' + ex.getMessage());
        }
    }
}