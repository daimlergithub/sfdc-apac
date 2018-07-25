/**
* Utility for Trigger on Task for TR(Turkey)
* Author: Hildaa
*/

public without sharing class TaskHelperTR {
  private static String OBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
  private static String iBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
  private static String eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
  public static string leadTabId = (String)Schema.getGlobalDescribe().get('Lead__C').getDescribe().getKeyPrefix();//System.Label.LeadId;
  public static string dmRequestTabId = (String)Schema.getGlobalDescribe().get('DM_Request__c').getDescribe().getKeyPrefix();//System.Label.DMRequestTabId;
   /**
  *@Description : Updates Accounts if they are blacklisted based on Activity status of Tasks.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.
  */     
   public static void TaskFailBlacklist(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {    
        TaskHelperBase.TaskFailBlacklist(tasks,taskOldMap,isInsert,isUpdate);
   }
   
   /**
  *@Description : Fetches related Campaign members based on whoId and whatId and updates the campaignMember status
  based on task.Activity status and priority.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
          TaskHelperBase.updateCampaignMemberStatus(tasks,taskOldMap,isInsert,isUpdate);
   }
   public static void updateAccountMobile(List<Task> lstTask){          
       TaskHelperBase.updateAccountMobile(lstTask);
    }
    public static void updateAssignees(List<Task> tasks){
        set<id> tskVRId = new set<id>();
        set<Id> dealerId = new set<Id>();
        map<id,Id> dealerUsrId = new map<id,id>();
        list<task> tasktoUpdate = new list<Task>();
        Map<ID,ID> mContactToUsr = new Map<ID,ID>();
        Map<ID,ID> VRToAct = new Map<ID,ID>();
        for(Task tk : tasks){
            tskVRId.add(tk.whatId);
        }
        for(Vehicle_Relationship__c vr :[select id,Last_Service_Dealer__c,Last_Service_Dealer__r.Dealer_Lead_Gate_Keeper__c from Vehicle_Relationship__c where id in :tskVRId ]) {
           dealerId.add(vr.Last_Service_Dealer__c);
           VRToAct.put(vr.Id,vr.Last_Service_Dealer__c);
        }
         for(User user : [Select id, contact.AccountID, ContactID from user where contact.AccountID in :dealerId and isActive = true]){
            mContactToUsr.put(user.contactID, user.id);
        }
        for(Contact ct : [select id,name,accountid from contact where accountid in :dealerId and Dealer_Lead_Gate_Keeper__c = true]){
            dealerUsrId.put(ct.accountid,mContactToUsr.get(ct.id));
        }
        for(Task tk : tasks){
            if(dealerUsrId != null && VRToAct.containskey(tk.whatid) && dealerUsrId.containskey(VRToAct.get(tk.whatid)) && dealerUsrId.get(VRToAct.get(tk.whatid)) != null) {
                tk.ownerid = dealerUsrId.get(VRToAct.get(tk.whatid));
                tasktoUpdate.add(tk);
            }
        }
      /*  if(tasktoUpdate.size()> 0)
            DMLManagerService.updateAsSystem(tasktoUpdate);*/
            
    }
}