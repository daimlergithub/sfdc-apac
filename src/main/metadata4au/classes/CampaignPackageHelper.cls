public with sharing class CampaignPackageHelper
{
	public static void GenerateCampaignOfferingHistoryLOG(list<Campaign_Package__c> campaignPackageNew,list<Campaign_Package__c> campaignPackageOld, boolean isInsert, boolean isUpdate,boolean isDelete)
    {
    	Id cId;
    	
    	if(isDelete)
    	{
	        // Get Current Reocrd ID
	        cId = campaignPackageOld[0].Id;
	    } else
	    {
	        cId = campaignPackageNew[0].Id;
	    }
	    if(cId!=null)
	    {
	    	Campaign_Package__c co = [Select Id, Name, Campaign__c From Campaign_Package__c Where Id = :cId];
		    String type = 'Campaign Package';
		    String action = '';
		    String cm = co.Campaign__c;
		    String objName = co.Name;
		    Id us = Userinfo.getUserId();
		    
		    // LOG Generation Class initialize
		    campaignHistoryLogGeneration chlg = new campaignHistoryLogGeneration();
		    
		    if(trigger.isInsert){
		        // INSERT LOG
		        action = 'INSERT';
		    }
		    
		    if(trigger.isUpdate){
		        // UPDATE LOG
		        action = 'UPDATE';
		    }
		    
		    if(trigger.isDelete){
		        // DELETE LOG
		        action = 'DELETE';
		    }
		    chlg.logGeneration(type, String.valueof(cId), action, cm, us, objName);
	    }
    }	
}