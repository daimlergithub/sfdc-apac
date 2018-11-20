/***********************************************************************************
Created By          :    venky    
Created Date        :    27/07/2018
Company             :    NTT Data,Inc. 

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

@istest
public class SchUpdateCampaignLeadBatchTest 
{
    public static testMethod void testschedule() {
        Test.StartTest();
        SchUpdateCampaignLeadBatch sh1 = new SchUpdateCampaignLeadBatch();
        String sch = '0 0 23 * * ?';
        system.schedule('SchUpdateCampaignLeadBatch', sch, sh1);
        Test.stopTest();
    }  
}