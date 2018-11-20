 
/***********************************************************************************
Created By          :    venky    
Created Date        :    2018-08-24
Company             :    NTT Data,Inc.
Usage               :    Test class for SchCampaignLeadCreationBasedoncmmRT
Business Conditions :SFDCJP-3453 
*   
JIRA NO             :        

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

@isTest
public class SchCampaignLeadCreationBasedoncmmRTTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        SchCampaignLeadCreationBasedoncmmRT sh1 = new SchCampaignLeadCreationBasedoncmmRT();
        String sch = '0 0 22 * * ?';
        system.schedule('SchCampaignLeadCreationBasedoncmmRT', sch, sh1);
        Test.stopTest();
    }
}