public with sharing class CampaignOfferingHelper
{
	public static void GenerateCampaignOfferingHistoryLOG(list<Campaign_Offering__c> campaignOfferNew,list<Campaign_Offering__c> campaignOfferOld, boolean isInsert, boolean isUpdate,boolean isDelete)
    {
    	Id cId;
    	
    	if(isDelete)
    	{
	        // Get Current Reocrd ID
	        cId = campaignOfferOld[0].Id;
	    } else
	    {
	        cId = campaignOfferNew[0].Id;
	    }
	    if(cId!=null)
	    {
	    	Campaign_Offering__c co = [Select Id, Name, Campaign__c, Campaign__r.Name From Campaign_Offering__c Where Id = :cId];
		    String type = 'Campaign Offering';
		    String action = '';
		    Id cm = co.Campaign__c;
		    String objName = co.Name;
		    Id us = Userinfo.getUserId();
		    // LOG Generation Class initialize
		    campaignHistoryLogGeneration chlg = new campaignHistoryLogGeneration();
		    
		    if(isInsert){
		        // INSERT LOG
		        action = 'Add campaign offering ' + String.valueof(cId);
		    }
		    if(isUpdate){
		        // UPDATE LOG
		        action = 'Update campaign offering to ' + String.valueof(cId);
		    }
		    if(isDelete){
		        // DELETE LOG
		        action = 'Delete campaign offering ' + String.valueof(cId);
		    }
			
		    chlg.logGeneration(type, action, cm, us, objName);
	    }
    }
}