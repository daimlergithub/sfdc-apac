/*
    Type:       Trigger
    Purpose:    Campaign Member  
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
*/
trigger TriggerCampaignMembers on CampaignMember (after insert) {
    if (!TriggerUtil.isTriggerEnabled('TriggerCampaignMembers')) {
        return;
    }
    
    Set<Id> cmIds = Trigger.newMap.keySet();
    List<Id> ctIds = new List<Id>();
    List<CampaignMember> cps = [SELECT Id, ContactId, CreatedDate FROM CampaignMember WHERE Id IN :cmIds];
    Map<Id, Date> cmMap = new Map<Id, Date>();
    
    for(CampaignMember cm : cps){
        ctIds.add(cm.ContactId);
        cmMap.put(cm.ContactId, cm.CreatedDate.date());
    }
    
    List<Account> accList = [SELECT Id, PersonContactId, Last_Campaign_Date__c FROM Account Where PersonContactId in :ctIds];
    Map<Id, Id> accMap = new Map<Id, Id>();
    for(Account acc : accList){
        acc.Last_Campaign_Date__c = cmMap.get(acc.PersonContactId);
    }
    
    Database.update(accList,false);
    
}