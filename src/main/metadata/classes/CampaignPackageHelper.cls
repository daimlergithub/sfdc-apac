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
		    Id cm = co.Campaign__c;
		    String objName = co.Name;
		    Id us = Userinfo.getUserId();
		    
		    // LOG Generation Class initialize
		    campaignHistoryLogGeneration chlg = new campaignHistoryLogGeneration();
		    
		    if(trigger.isInsert){
		        // INSERT LOG
		        action = 'Add campaign package ' + String.valueof(cId);
		    }
		    
		    if(trigger.isUpdate){
		        // UPDATE LOG
		        action = 'Update campaign package to ' + String.valueof(cId);
		    }
		    
		    if(trigger.isDelete){
		        // DELETE LOG
		        action = 'Delete campaign package ' + String.valueof(cId);
		    }
			
		    chlg.logGeneration(type, action, cm, us, objName);
	    }
    }	
}