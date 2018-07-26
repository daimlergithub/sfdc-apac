/***********************************************************************************
Created By          :    venky    
Created Date        :    25072018
Company             :    NTT Data,Inc.
Usage               :    Created scheduler class to schedule ,batch class  AccountLinkShareJPBatch.
Business Conditions :
*   
JIRA NO             :        

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class SchAccountLinkShareJPBatch implements Schedulable    {
    
    global void execute(SchedulableContext sc){
        AccountLinkShareJPBatch batch=new AccountLinkShareJPBatch();
        database.executeBatch(batch,1);
    }   
}