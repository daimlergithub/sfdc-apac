/* Purpose: Helper class for Retail Task trigger for MY
   Date: 01/02/2018
   Created By: Sushma */

public class RetailTaskHelperMY{
    
    String market=System.Label.MarketMY;
    
    public void shareRetailTasks(List<Retail_Task__c> retailTasks){
        RetailTaskSharingWrapServiceBase wrapService = new RetailTaskSharingWrapServiceBase();
        SharingService.shareRetailTasks(wrapService.wrapRetailTasksGeneric(retailTasks,market));
    }
}