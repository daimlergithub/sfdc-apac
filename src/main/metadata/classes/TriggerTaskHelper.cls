/**
* Helper class for Trigger handler on Task 
* Author: Sushma
* Created Date : 2017-11-21
*/

public class TriggerTaskHelper{

       public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate){    
            TaskHelperBase.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
       }

}