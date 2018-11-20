/* Purpose: Helper class for Retail Task trigger for IN
   Date: 7/9/18
   Created By: Honey
*/
public class RetailTaskHelperIN{
    String market=System.Label.IN;
    public void shareRetailTasks(List<Retail_Task__c> retailTasks){
        RetailTaskHelperBase.shareRetailTasksNDCode(retailTasks,market);
    }
}