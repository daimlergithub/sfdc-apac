 
/***********************************************************************************
Created By          :    venky    
Created Date        :    2018-08-16
Company             :    NTT Data,Inc.
Usage               :    Created scheduler class to schedule ,batch class  CampaignLeadCreationBasedoncmmRT.
Business Conditions :SFDCJP-3453 
*   
JIRA NO             :        

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class SchCampaignLeadCreationBasedoncmmRT implements Schedulable    {
    
    global void execute(SchedulableContext sc){
        CampaignLeadCreationBasedoncmmRT batch=new CampaignLeadCreationBasedoncmmRT();
        database.executeBatch(batch,1);
    }   
}