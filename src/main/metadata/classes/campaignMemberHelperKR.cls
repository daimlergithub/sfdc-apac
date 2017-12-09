/*********************************************************************************
Name         : campaignMemberHelperKR
Created By   : 
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 25th July 2017
Modified Date:
Requirement  : SFDCKR - 1388
Usages       : Helper class for campaignMember trigger flow
			   To update Create Task field on Campaign for newly added campaign members 
*********************************************************************************/
public with sharing class campaignMemberHelperKR 
{    
	/*********************************************************************************
	Method Name  : setCreateTaskFieldFalseOrTrueOnCampaign
	Created By   : 
	Created Date : 25th July 2017
	Project      : Daimler APAC
	Usages       : This method would update Create Task field on Campaign for newly added campaign members
				   Before update scenario would update the Create Task flag to False.
				   After update scenario would update the Create Task flag to True.
	
	**********************************************************************************/
	public static void setCreateTaskFieldFalseOrTrueOnCampaign (list<CampaignMember> campMemList)
	{
		set<Id> campaignIdSet = new set<Id>();
		list<Campaign> updateCampaignList = new list<Campaign>();
		list<Campaign> campaignList = new list<Campaign>();
		Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c='Pending');
		if(!campMemList.isEmpty() && campMemList != null)
		{
			for(CampaignMember camMem : campMemList)
			{
				if(camMem.Task_Generated__c == false)
				{
					campaignIdSet.add(camMem.CampaignId);
				}
			}			
		}
		if(!campaignIdSet.isEmpty() && campaignIdSet != null)
		{
			campaignList = [select Id, Create_Task__c from Campaign where Id in : campaignIdSet];	
			if(!campaignList.isEmpty() && campaignList != null) 
			{          
	            database.executeBatch(new UtilCampaignTaskGenerationByAccount(campaignList), 200);
	            accJob.Campaign_Set__c = string.valueOf(campaignIdSet);
	            if(accJob!=Null)
	            {
	           		 insert accJob;
				}
	        }
		}
	}
	
	
	 /*public static void updatecustomstatus (list<CampaignMember> campMemList)
    {
       if(!campMemList.isEmpty() && campMemList != null)
        {
            for(CampaignMember camMem : campMemList)
            {
                camMem.Status__c = camMem.Status;
            }           
        }
    }*/
}