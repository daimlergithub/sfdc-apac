Global class generateTaskClass 
{
    webservice static void taskGenerationForCM(Id campnId)
    {
    	list<Campaign> campaignList = new list<Campaign>();    	
		Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c='Pending');
    	campaignList = [select Id, Create_Task__c from Campaign where Id =: campnId];	
			if(!campaignList.isEmpty() && campaignList != null) 
			{          
	            database.executeBatch(new UtilCampaignTaskGenerationByAccount(campaignList), 200);
	            accJob.Campaign_Set__c = string.valueOf(campnId);
	            if(accJob!=Null)
	            {
	           		 insert accJob;
				}
	        }
    }
}