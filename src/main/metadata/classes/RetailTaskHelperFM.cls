public class RetailTaskHelperFM {
   
    Public User u= Utility_FM.getLoggedInUserInfo();
    String market=u.Market__c;
    
    public void shareRetailTasks(List<Retail_Task__c> retailTasks){
       // RetailTaskSharingWrapServiceBase wrapService = new RetailTaskSharingWrapServiceBase();
       //SharingService.shareRetailTasks(wrapService.wrapRetailTasksGeneric(retailTasks,market));
	    RetailTaskHelperBase.shareRetailTasksNDCode(retailTasks,market);
    }
}