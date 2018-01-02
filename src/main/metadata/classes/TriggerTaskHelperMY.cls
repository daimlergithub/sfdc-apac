/**
* Helper class for Trigger handler on Task 
* Author: Sushma
* Created Date : 2017-11-21
*/

public class TriggerTaskHelperMY{

       public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate){    
            TaskHelperBase.updateCampaignMemberStatus(tasks,taskOldMap,isinsert,isupdate);
       }

}