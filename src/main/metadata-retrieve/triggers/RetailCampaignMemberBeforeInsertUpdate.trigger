/*
    Type:       Trigger
    Purpose:    1. Retail Campaign Member can not dup.
                
    User Story: Release 1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2014-06-019
*/
trigger RetailCampaignMemberBeforeInsertUpdate on Retail_Campaign_Member__c (before insert) 
{
    if (!UtilCustomSettings.isEnabled('RetailCampaignMemberBeforeInsertUpdate')) {
        return;
    }
    
    Set<Id> campaignIds = new Set<Id>();
    Map<Id, list<Retail_Campaign_Member__c> > campaignIdExistContactIds = new Map<Id, list<Retail_Campaign_Member__c> >();
    Map<Id, list<account> > campaignIdNewContactIds = new Map<Id, list<account> >();
    Map<Id, set<id>> RetailCampaignAccountIds = new Map<Id, set<id>>();
    
    for(Retail_Campaign_Member__c rcm : trigger.new) {
        campaignIds.add(rcm.Retail_Campaign__c);

        if(!RetailCampaignAccountIds.containsKey(rcm.Retail_Campaign__c)) {
            RetailCampaignAccountIds.put(rcm.Retail_Campaign__c, new set<id>());
        }
        RetailCampaignAccountIds.get(rcm.Retail_Campaign__c).add(rcm.Contact__c );
    }
    for(id rcId : RetailCampaignAccountIds.keyset()) {
        for(Account acc : [select id, name, PersonMobilePhone from account where id in :RetailCampaignAccountIds.get(rcId)]) {
            if(!campaignIdNewContactIds.containsKey(rcId)) {
                campaignIdNewContactIds.put(rcId, new list<account>());
            }
            campaignIdNewContactIds.get(rcId).add(acc);
        }
    }
    
    for(Retail_Campaign_Member__c rcm : [select Retail_Campaign__c, Contact__c ,Contact__r.name, Contact__r.PersonMobilePhone from Retail_Campaign_Member__c  where Retail_Campaign__c in :campaignIds]) {
        if(!campaignIdExistContactIds.containsKey(rcm.Retail_Campaign__c)) {
            campaignIdExistContactIds.put(rcm.Retail_Campaign__c, new list<Retail_Campaign_Member__c>());
        }
        campaignIdExistContactIds.get(rcm.Retail_Campaign__c).add(rcm);
    }
    for(list<Retail_Campaign_Member__c> rcmList: campaignIdExistContactIds.values()) {
        for(Retail_Campaign_Member__c rcm: rcmList) {
            for(account acc : campaignIdNewContactIds.get(rcm.Retail_Campaign__c)) {
                    if(acc.PersonMobilePhone == rcm.Contact__r.PersonMobilePhone && acc.name == rcm.Contact__r.name) {
                        for(Retail_Campaign_Member__c rcmc : trigger.new) {
                            if(rcmc.Contact__c == acc.id && rcmc.Retail_Campaign__c == rcm.Retail_Campaign__c){
                                if(UserInfo.getLanguage() != 'English') {
                                    rcmc.addError('不允许添加重复的联系人, 请重新检查.');
                                }
                                else {
                                    rcmc.addError('You could not add same contact in one Retail Campaign, Please try again.');
                                }
                            }
                        }
                    }
            }
         }
    }
}