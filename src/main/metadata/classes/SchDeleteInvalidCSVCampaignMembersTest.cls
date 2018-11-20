/***********************************************************************************
Created By          :    venky    
Created Date        :    2018-08-15
Company             :    NTT Data,Inc.
Usage               :    Created scheduler class to schedule batch class  DeleteInvalidCSVCampaignMembers.
Business Conditions :
*   
JIRA NO             :        

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/
@isTest
public class SchDeleteInvalidCSVCampaignMembersTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        SchDeleteInvalidCSVCampaignMembers sh1 = new SchDeleteInvalidCSVCampaignMembers();
        String sch = '0 0 22 * * ?';
        system.schedule('SchDeleteInvalidCSVCampaignMembers', sch, sh1);
        Test.stopTest();
    }
}
