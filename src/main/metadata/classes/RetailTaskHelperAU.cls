/* Purpose: Helper class for Retail Task trigger for ANZ Market
   Date: Oct/10/2018
*/
public class RetailTaskHelperAU {
    String market=System.Label.AU;
    public void shareRetailTasks(List<Retail_Task__c> retailTasks){
        RetailTaskHelperBase.shareRetailTasksNDCodeEdit(retailTasks,market);
    }
}