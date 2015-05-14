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
    public void handleTrigger()
    {
        Map<Id,CampaignMember> oldmap = (Map<Id,CampaignMember>)trigger.oldmap;
        Map<Id,CampaignMember> newmap = (Map<Id,CampaignMember>)trigger.newmap;
        list<CampaignMember> listCMNew=(list<CampaignMember>)trigger.new;
        //TODO - commented kernel functionality ..Need to add trigger switching mechanism
        /*Set<Id> cmIds = newMap.keySet();
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
        
        //Existing au functionality starts here
        Id cId;
	    Datetime DateofChange;
	    Id us = Userinfo.getUserId();
	    String action = '';
	    
	    for(CampaignMember campaignMember : listCMNew) {
	        if(trigger.isInsert){
	            cId = campaignMember.Id;
	            DateofChange = campaignMember.LastModifiedDate;
	            action = 'Created.';
	        }else if(trigger.isUpdate){
	            action = 'Changed ';
	            if(oldmap.get(campaignMember.id).Lodgement_Date__c != campaignMember.Lodgement_Date__c){
	                cId = campaignMember.Id;
	                action = action + 'Lodgement Date to ' + datetime.newInstance(campaignMember.Lodgement_Date__c, time.newInstance(0,0,0,0)).format('yyyy/MM/dd') +'\n';
	            }
	            if (oldmap.get(campaignMember.id).Status != campaignMember.Status){
	                cId = campaignMember.Id;
	                action = action + 'Status to ' + campaignMember.Status;
	            }
	            DateofChange = campaignMember.LastModifiedDate;
	        }
	        
	        // LOG Record
	        Audit_Trail__c objAT = new Audit_Trail__c();
	        objAT.CampaignMember__c = cId;    // CampaignMember id
	        objAT.Action__c = action;     // What operation
	        objAT.User__c = us;           // Who makes the operation
	        objAT.Date_of_Change__c = DateofChange;           // Who makes the operation
	        if(cId != null){
	            insert objAT;
	        }
	    }
        //existing au functionality ends here
    }
}