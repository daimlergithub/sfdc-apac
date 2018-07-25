/**
* Helper class for Trigger handler on Task 
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/


public class TriggerTaskHelperIN{

       public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate){    
            TaskHelperBase.updateCampaignMemberStatus(tasks,taskOldMap,isinsert,isupdate);
       }

}