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
	//public static void setCreateTaskFieldFalseOrTrueOnCampaign (list<CampaignMember> campMemList)
	public static void setCreateTaskFieldFalseOrTrueOnCampaign (Id campnId)
	{
		set<Id> campaignIdSet = new set<Id>();
		list<Campaign> updateCampaignList = new list<Campaign>();
		list<Campaign> campaignList = new list<Campaign>();
		Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c='Pending');
		/*if(!campMemList.isEmpty() && campMemList != null)
		{
			for(CampaignMember camMem : campMemList)
			{
				if(camMem.Task_Generated__c == false)
				{
					campaignIdSet.add(camMem.CampaignId);
				}
			}			
		}*/
		//if(!campaignIdSet.isEmpty() && campaignIdSet != null)
		//{
			//campaignList = [select Id, Create_Task__c from Campaign where Id in : campaignIdSet];	
			campaignList = [select Id, Create_Task__c from Campaign where Id =: campnId];	
			if(!campaignList.isEmpty() && campaignList != null) 
			{          
	            database.executeBatch(new UtilCampaignTaskGenerationByAccount(campaignList), 200);
	            accJob.Campaign_Set__c = string.valueOf(campaignIdSet);
	            if(accJob!=Null)
	            {
	           		 insert accJob;
				}
	        }
		//}
	}
	
	
	 public static void updatecustomstatus (list<CampaignMember> campMemList,Map<Id,CampaignMember>oldCMmap)
    {
     list<CampaignMember> updateCampaignMemList = new list<CampaignMember>();
       
            for(CampaignMember camMem : campMemList)
            {
               system.debug('camMem.Status__c---'+camMem.Status__c);
               system.debug('trigger.isUpdate'+trigger.isUpdate);
                if(camMem.Status__c!=null && camMem.MD__c=='KR')
                {  
                system.debug('camMem.Status__c---'+camMem.Status__c);
                if(oldCMmap!=null)
                {
                if((camMem.Status__c == '응답함' || camMem.Status__c == 'Responded') && oldCMmap.get(camMem.id).Status__c != camMem.Status__c && oldCMmap.get(camMem.id).Status__c!=null)
                {
                 
                      camMem.Status = 'Responded';
                 
                }
                }
                if((camMem.Status == 'Sent' || camMem.Status == 'Responded') && ((camMem.Status__c == 'Sent' || camMem.Status__c == '발송함') || (camMem.Status__c == 'Responded' || camMem.Status__c == '응답함')))
                {
                  system.debug('I am here');
                  camMem.Status__c = camMem.Status;
                  system.debug(camMem.Status+'Status'+camMem.Status__c);
                }
                if(trigger.isUpdate && oldCMmap.get(camMem.id).Status != camMem.Status && ((camMem.Status__c == 'Failed/No Response' || camMem.Status__c == '실패/응답 없음') || (camMem.Status__c == 'Decline' || camMem.Status__c == '거절')))
                {
                  system.debug('I am here in update');
                  camMem.Status__c = camMem.Status;
                  system.debug(camMem.Status+'Status'+camMem.Status__c);
                }
                }
            }  
           
           
    }
}