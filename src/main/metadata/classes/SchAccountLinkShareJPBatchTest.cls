/***********************************************************************************
Created By          :    venky    
Created Date        :    27/07/2018
Company             :    NTT Data,Inc. 
MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

@isTest
public class SchAccountLinkShareJPBatchTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        SchAccountLinkShareJPBatch sh1 = new SchAccountLinkShareJPBatch();
        String sch = '0 0 22 * * ?';
        system.schedule('SchAccountLinkShareJPBatch', sch, sh1);
        Test.stopTest();
    }
}