/**
* Utility for Trigger on Task 
* Author: Sushma
* Created Date : 2017-11-09
*/

public with sharing class TaskHelperBase{
  //private static String OBCAllTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task',Label.OB_Call);
  //private static String eDMTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task',Label.eDM);
   
  /*public static string closedString='closed'; 
  public static string validString='valid';
  public static string leadTabId = System.Label.LeadId;
  public static string dmRequestTabId = System.Label.DMRequestTabId;
  public static Map<String, String> srRecordTypeSubjects = new Map<String, String>{'1st Survey Result'=>'1st Survey Call', '2nd Survey Result'=>'2nd Survey Call', 'Welcome Call + 1st Survey Result'=>'Welcome Call + 1st Survey Call', 'Welcome Call Result'=>'Welcome Call'};*/
  
   /**
  *@Description : Fetches related Campaign members based on whoId and whatId and updates the campaignMember status
  based on task.Activity status and priority.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
        if(isInsert)
            UtilTask.updateCampaignMemberStatus(tasks);
        if(isUpdate)
        {
             List<Task> lstTaskUpdate = new List<Task>();
             for (Task newTask : tasks)
             {
                if (newTask.Activity_Status__c != taskOldMap.get(newTask.Id).Activity_Status__c)
                {
                    lstTaskUpdate.add(newTask);
                }
             }
             UtilTask.updateCampaignMemberStatus(lstTaskUpdate);
        }   
   }
 
 
}