/*
    Type:       Trigger
    Purpose:    Campaign Member  
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignMembersTriggerHandler
*/
public class TriggerCampaignMembersTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        /*Map<Id,CampaignMember> oldmap = (Map<Id,CampaignMember>)trigger.oldmap;
        Map<Id,CampaignMember> newmap = (Map<Id,CampaignMember>)trigger.newmap;
        
        Set<Id> cmIds = newMap.keySet();
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
        
        Database.update(accList,false);*/
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}