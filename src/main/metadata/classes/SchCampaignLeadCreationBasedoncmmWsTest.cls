/***********************************************************************************
Created By          :    venky    
Created Date        :    2018-08-24
Company             :    NTT Data,Inc.
Usage               :    Test class for SchCampaignLeadCreationBasedoncmmWs
Business Conditions :SFDCJP-3453 
*   
JIRA NO             :        

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

@isTest
public class SchCampaignLeadCreationBasedoncmmWsTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        SchCampaignLeadCreationBasedoncmmWs sh1 = new SchCampaignLeadCreationBasedoncmmWs();
        String sch = '0 0 22 * * ?';
        system.schedule('SchCampaignLionBasedoncmmWs', sch, sh1);
        Test.stopTest();
    }
}