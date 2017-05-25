/**
* Utility for Trigger on Task for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-02
*/


public class TaskHelperTH {
    // Get Task record type ids
    private static String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
    private static String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    private static String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    private static String SMS_TASK_RECORDTYPEID = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    
    // Get QC__c record type ids
    private static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
    private static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
      private static String OBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
     private static String eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    //
    private static String OBTaskRecordTypeId1 = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    private static String WelcomeCallRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
    private static String MMSTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
    private static String GeneralTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
    private static String mbdaTaskRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('MBDA Survey').getRecordTypeId();
  public static string closedString='closed'; 
  public static string validString='valid';
   private static string leadTabId = System.Label.LeadId;
     private static string dmRequestTabId = System.Label.DMRequestTabId;
    
    private static Map<String, String> srRecordTypeSubjects = new Map<String, String>{'1st Survey Result'=>'1st Survey Call', '2nd Survey Result'=>'2nd Survey Call', 'Welcome Call + 1st Survey Result'=>'Welcome Call + 1st Survey Call', 'Welcome Call Result'=>'Welcome Call'};
  /**
  *@Description : Updates Accounts if they are blacklisted based on Activity status of Tasks.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */     
   public static void TaskFailBlacklist(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
     
     
        set<Id> setTaskIds = new set<Id>();
        for(Task tk : tasks)
        {
            if(isInsert && tk.Activity_Status__c == 'Fail-Blacklist')
            {
                system.debug('insert1');
                setTaskIds.add(tk.Id);
                
            }
            if(isUpdate && tk.Activity_Status__c == 'Fail-Blacklist' && taskOldMap.get(tk.Id).Activity_Status__c != 'Fail-Blacklist')
            {
                system.debug('update1');
                setTaskIds.add(tk.Id);
            }
        }
        if(setTaskIds!=null && !setTaskIds.Isempty())
        {
            List<Task> lstTask = [SELECT Id, WhoId FROM Task WHERE Id in :setTaskIds];
            Set<Id> conIds = new Set<Id>();
            if(lstTask!=null && !lstTask.Isempty())
            {
                for(Task tks : lstTask)
                {
                    if (tks.WhoId != null)
                    {
                        conIds.add(tks.WhoId);
                    }                
                }
                if (conIds.size() > 0)
                {
                    List<Account> accs = [SELECT Id, Is_Blacklist__c FROM Account WHERE PersonContactId=:conIds And Is_Blacklist__c != true];
                    if(accs!=null && !accs.IsEmpty())
                    {
                        for(Account acc : accs)
                        {
                            acc.Is_Blacklist__c = true;
                        }
                        if (accs!=null && !accs.IsEmpty())
                        {
                            update accs;
                        } 
                    }
                }
            }
        }      
   }
   
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
   public static void updateAccountMobile(List<Task> lstTask){          
        Set<ID> accId = new Set<ID>();
        Set<ID> leadId = new Set<ID>();
        Set<ID> campId = new Set<ID>();
        set<id> contactId = new set<id>();
        Set<ID> dmRequestId = new Set<ID>();
        
        List<Account> lstAccount = new List<Account>();
        List<Lead__c> lstLead = new List<Lead__c>();
        List<DM_Request__c> lstDMRequest = new List<DM_Request__c>();
        List<Account> lstCampaignAccount = new List<Account>();
        List<campaignmember> lstCampContact = new List<campaignmember>();
        List<Campaign> campaignList = new List<Campaign>();
        
        // Maps 
        Map<Id , String> mapTask = new Map<Id , String>();
        Map<Id , String> mapEMailTask = new Map<Id , String>();
        Map<Id, Id> contactMap = new Map<Id, Id>();
        Map<Id , String> mapLead = new Map<Id , String>();
        Map<Id , String> mapEMailLead = new Map<Id , String>();
        
        Map<Id , String> mapDMRequestPhone = new Map<Id , String>();
        Map<Id , String> mapDMRequestEmail = new Map<Id , String>();
        
        Map<Id , String> mapCampaign = new Map<Id , String>();
        Map<Id , String> mapEMailCampaign = new Map<Id , String>();
        
        for(Task tsk : lstTask){            
                if( tsk.whatId != null && String.valueOf( tsk.whatId ).startsWith( '001' )){
                    accId.add(tsk.whatId);       
                }
                if(tsk.WhatId != null && tsk.WhoId == Null){
                    if(String.valueOf( tsk.WhatId ).startsWith(leadTabId)){
                      leadId.add(tsk.WhatId);        
                    }else if(String.valueOf( tsk.WhatId ).startsWith( dmRequestTabId )){
                      dmRequestId.add(tsk.WhatId);    
                    }
                            
                }
            
        }
        if(accId != Null && !accId.isEmpty()){
            lstAccount = [Select Id,Mobile__c,Email__c from Account where Id =:accId];
        }        
        
        if(leadId != Null && !leadId.isEmpty()){
            lstLead = [Select Id,Contact__r.Mobile__c,Contact__r.Email__c,Company_Account__r.Mobile__c,Company_Account__r.Email__c from Lead__c where Id =:leadId];
        }
        
        if(dmRequestId != Null && dmRequestId.isEmpty()){
           lstDMRequest = [Select Id,Customer_Name__r.Mobile__c,Customer_Name__r.Email__c from DM_Request__c where Id =:dmRequestId]; 
        }
        
        
        for(Account acc : lstAccount){
          mapTask.put(acc.id, acc.Mobile__c);  
            mapEMailTask.put(acc.id, acc.Email__c);
        }
        
        for(Lead__c led : lstLead){
            if(led.Contact__r.Mobile__c == null ||   led.Contact__r.Email__c == null ){
                    mapLead.put(led.id, led.Company_Account__r.Mobile__c);
                    mapEMailLead.put(led.id, led.Company_Account__r.Email__c);
                }else{
                    mapLead.put(led.id, led.Contact__r.Mobile__c);
                    mapEMailLead.put(led.id, led.Contact__r.Email__c);
                }
        }
        
        for(DM_Request__c dmr : lstDMRequest){            
            mapDMRequestPhone.put(dmr.id, dmr.Customer_Name__r.Mobile__c);
            mapDMRequestEmail.put(dmr.id, dmr.Customer_Name__r.Email__c);
        }
                
        
        
        
        for(Task t : lstTask){
            if(t.RecordTypeId == OBCAllTaskRecordTypeId){
                if(t.WhoId != Null && String.valueOf( t.whoid ).startsWith( '003' )){
                    t.Phone__c = mapTask.get(t.WhoId);   
                }
                if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( '001' )){
                     t.Phone__c = mapTask.get(t.WhatId); 
                }
                if(t.WhatId != Null){                    
                    if(String.valueOf( t.WhatId ).startsWith(leadTabId)){
                      t.Phone__c = mapLead.get(t.WhatId);    
                    }else if(String.valueOf( t.WhatId ).startsWith(dmRequestTabId)){
                        t.Phone__c = mapDMRequestPhone.get(t.WhatId);    
                    }                     
                }
          }else
            if(t.RecordTypeId == eDMTaskRecordTypeId){
                if(t.WhoId != Null && String.valueOf( t.whoid ).startsWith( '003' )){
                    t.Email_Address__c = mapEMailTask.get(t.WhoId);                    
                } 
                if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( '001' )){
                    t.Email_Address__c = mapEMailTask.get(t.WhatId);
                }
                if(t.WhatId != Null){
                    if(String.valueOf( t.WhatId ).startsWith(leadTabId)){
                      t.Email_Address__c = mapEMailLead.get(t.WhatId); 
                  }else if(String.valueOf( t.WhatId ).startsWith(dmRequestTabId)){
                        t.Email_Address__c = mapDMRequestEmail.get(t.WhatId);    
                    } 
            }
          }
      }
    
  }

   
}