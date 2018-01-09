/**
* Utility for Trigger on Task for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-02
*/

public with sharing class TaskHelperTH {
  private static String OBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
  private static String eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
   
  public static string closedString='closed'; 
  public static string validString='valid';
  public static string leadTabId = System.Label.LeadId;
  public static string dmRequestTabId = System.Label.DMRequestTabId;
  public static Map<String, String> srRecordTypeSubjects = new Map<String, String>{'1st Survey Result'=>'1st Survey Call', '2nd Survey Result'=>'2nd Survey Call', 'Welcome Call + 1st Survey Result'=>'Welcome Call + 1st Survey Call', 'Welcome Call Result'=>'Welcome Call'};
  /**
  *@Description : Updates Accounts if they are blacklisted based on Activity status of Tasks.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.
  */     
   public static void TaskFailBlacklist(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   { 
        set<Id> setTaskIds = new set<Id>();
        for(Task tk : tasks){
         if(tk.Activity_Status__c == 'Fail-Blacklist' &&  ( isInsert || (isUpdate && taskOldMap.get(tk.Id).Activity_Status__c != 'Fail-Blacklist')))
         {
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
   
   /**
  *@Description : Fetches related Campaign members based on whoId and whatId and updates the campaignMember status
  based on task.Activity status and priority.
  *@param:List of Tasks.new , Task Old Map , Indicators for Insert/Update.
  *@return:This mehtod does not return any value.

  */
   public static void updateCampaignMemberStatus(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
        if(isInsert)
            UtilTaskTH.updateCampaignMemberStatus(tasks);
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
             UtilTaskTH.updateCampaignMemberStatus(lstTaskUpdate);
        }   
   }
   public static void updateAccountMobile(List<Task> lstTask){          
        Set<ID> conId = new Set<ID>();
        Set<ID> leadId = new Set<ID>();
        Set<ID> campId = new Set<ID>();
        set<id> contactId = new set<id>();
        Set<ID> dmRequestId = new Set<ID>();
        system.debug('IN');
        List<Contact> lstAccount = new List<Contact>();
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
            System.debug('++++++++++++++++++++++++++++'+tsk.AccountId );
                if( tsk.WhoId  != null && String.valueOf( tsk.WhoId  ).startsWith( '003' )){
                    System.debug('+++++++++++++++++++++Initializing Accid'+ tsk.WhoId );
                    conId.add(tsk.WhoId );       
                }
                if(tsk.WhatId != null && tsk.WhoId == Null){
                    if(String.valueOf( tsk.WhatId ).startsWith(leadTabId)){
                      leadId.add(tsk.WhatId);        
                    }else if(String.valueOf( tsk.WhatId ).startsWith( dmRequestTabId )){
                      dmRequestId.add(tsk.WhatId);    
                    }
                            
                }  
        }
        if(conId != Null && !conId.isEmpty()){
            lstAccount = [Select Id,Account.Mobile__c,Account.Email__c from Contact where Id =:conId];
        }        
        
        if(leadId != Null && !leadId.isEmpty()){
            lstLead = [Select Id,Contact__r.Mobile__c,Contact__r.Email__c,Company_Account__r.Mobile__c,Company_Account__r.Email__c from Lead__c where Id =:leadId];
        }
        
        if(dmRequestId != Null && dmRequestId.isEmpty()){
           lstDMRequest = [Select Id,Customer_Name__r.Mobile__c,Customer_Name__r.Email__c from DM_Request__c where Id =:dmRequestId]; 
        }
        
        
        for(Contact con : lstAccount){
            System.debug('+++++++++++++++++++++++++++Mobile'+con.Account.Mobile__c);
          mapTask.put(con.id, con.Account.Mobile__c);  
            mapEMailTask.put(con.id, con.Account.Email__c);
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
               if(t.whoId  != Null && String.valueOf( t.whoId  ).startsWith( '003' )){
                   t.Phone__c = mapTask.get(t.whoId);  
                   System.debug('++++++++++++++++++++++++++'+mapTask.get(t.whoId));
                }
              /*  if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( '001' )){
                     t.Phone__c = mapTask.get(t.WhatId); 
                   
                }*/
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