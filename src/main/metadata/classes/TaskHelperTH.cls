/**
* Utility for Trigger on Task for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-02
*/

public without sharing class TaskHelperTH {
  private static String OBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
  private static String iBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
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
        Set<ID> accId = new Set<ID>();
        Set<ID> conId = new Set<ID>();
        Set<ID> leadId = new Set<ID>();
        Set<ID> campId = new Set<ID>();
        set<id> contactId = new set<id>();
        Set<ID> dmRequestId = new Set<ID>();
        List<Account> lstAccount = new List<Account>();
         List<contact> lstcon = new List<contact>();
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
        Map<Id , id> custname = new Map<Id , id>();
        Map<Id , String> mapCampaign = new Map<Id , String>();
        Map<Id , String> mapEMailCampaign = new Map<Id , String>();
        
        for(Task tsk : lstTask){ 
            if( tsk.whoid != null && String.valueOf( tsk.whoid ).startsWith( '001' )){
                accId.add(tsk.whoid);       
            }
            else if( tsk.whoid != null && String.valueOf( tsk.whoId ).startsWith( '003' )){
                conId.add(tsk.whoId);       
            }
            else if(tsk.WhatId != null){
                if(String.valueOf( tsk.WhatId ).startsWith(leadTabId)){
                   
                  leadId.add(tsk.WhatId);        
                }else if(String.valueOf( tsk.WhatId ).startsWith( dmRequestTabId )){
                  dmRequestId.add(tsk.WhatId);  
                }
                        
            }
        
        }
        if(accId != Null && !accId.isEmpty()){
            lstAccount = [Select Id,Mobile__c,Email__c, Primary_Phone__c,individual_Home_Phone__c,PersonContactId,Work_Phone__c from Account where Id =:accId or id=:conId];
        } 
    if(conId != Null && !conId.isEmpty()){
            lstcon = [Select Id, Account.Email__c, Account.Primary_Phone__c,Account.individual_Home_Phone__c,Account.Work_Phone__c from contact where Id =:conId];
        }       
        
        if(leadId != Null && !leadId.isEmpty()){
            lstLead = [Select Id,Contact__r.Mobile__c,Contact__c,Contact__r.Email__c, Contact__r.Primary_Phone__c,Contact__r.individual_Home_Phone__c,Contact__r.PersonContactId,Contact__r.Work_Phone__c,Company_Account__r.Mobile__c,Company_Account__r.Email__c from Lead__c where Id =:leadId];
            
        }
        
        if(dmRequestId != Null && !dmRequestId.isEmpty()){
           lstDMRequest = [Select Id,Customer_Name__c,Customer_Name__r.Mobile__c,Customer_Name__r.Primary_Phone__c,Customer_Name__r.individual_Home_Phone__c,Customer_Name__r.Work_Phone__c,Customer_Name__r.Email__c,Customer_Name__r.PersonContactId  from DM_Request__c where Id =:dmRequestId]; 
            
        }
        
        
        for(contact con : lstcon){
            if(con.account.Primary_Phone__c!=null){
                if(con.account.Primary_Phone__c=='Mobile'){
                mapTask.put(con.id, con.account.Mobile__c);
                }
                else if(con.account.Primary_Phone__c=='Home phone'){
                mapTask.put(con.id, con.account.individual_Home_Phone__c);
                }
                else if(con.account.Primary_Phone__c=='Work Phone'){
                    mapTask.put(con.id, con.account.Work_Phone__c);
                }
            }         
            mapEMailTask.put(con.id, con.account.Email__c);
            //custname.put(acc.id,acc.PersonContactId);
           
        }
        for(Account acc : lstAccount){
            if(acc.Primary_Phone__c!=null){
                if(acc.Primary_Phone__c=='Mobile'){
                mapTask.put(acc.id, acc.Mobile__c);
                }
                else if(acc.Primary_Phone__c=='Home phone'){
                mapTask.put(acc.id, acc.individual_Home_Phone__c);
                }
                else if(acc.Primary_Phone__c=='Work Phone'){
                    mapTask.put(acc.id, acc.Work_Phone__c);
                }
            }         
            mapEMailTask.put(acc.id, acc.Email__c);
            //custname.put(acc.id,acc.PersonContactId);
           
        }
        
        for(Lead__c led : lstLead){

            if(led.contact__c!=null && led.Contact__r.Primary_Phone__c!=null){
                    if(led.Contact__r.Primary_Phone__c=='Mobile'){
                        mapLead.put(led.id, led.Contact__r.Mobile__c);
                    }
                    else if(led.Contact__r.Primary_Phone__c=='Home phone'){
                        mapLead.put(led.id,led.Contact__r.individual_Home_Phone__c);
                    }
                    else if(led.Contact__r.Primary_Phone__c=='Work Phone'){
                            mapLead.put(led.id, led.Contact__r.Work_Phone__c);
                    }
                }
                mapEMailLead.put(led.id, led.Contact__r.Email__c);
                custname.put(led.id,led.Contact__r.PersonContactId);
    
        }
        
        for(DM_Request__c dmr : lstDMRequest){   
             if(dmr.Customer_Name__c!=null && dmr.Customer_Name__r.Primary_Phone__c!=null){
                    if(dmr.Customer_Name__r.Primary_Phone__c=='Mobile'){
                        mapDMRequestPhone.put(dmr.id, dmr.Customer_Name__r.Mobile__c);
                    }
                    else if(dmr.Customer_Name__r.Primary_Phone__c=='Home phone'){
                        mapDMRequestPhone.put(dmr.id,dmr.Customer_Name__r.individual_Home_Phone__c);
                    }
                    else if(dmr.Customer_Name__r.Primary_Phone__c=='Work Phone'){
                            mapDMRequestPhone.put(dmr.id, dmr.Customer_Name__r.Work_Phone__c);
                    }
                }         
            mapDMRequestEmail.put(dmr.id, dmr.Customer_Name__r.Email__c);
            custname.put(dmr.id,dmr.Customer_Name__r.PersonContactId);
        }
                
        for(Task t : lstTask){
            if(t.RecordTypeId == OBCAllTaskRecordTypeId||t.RecordTypeid==iBCAllTaskRecordTypeId){
                system.debug(t.WhoId+'abcdef');
                if(t.WhoId != Null && String.valueOf( t.whoid ).startsWith( '003' )){
                    t.Phone__c = mapTask.get(t.Whoid);  
                    //t.whoid= custname.get(t.whatid);
                }
                else if(t.whoid != Null && String.valueOf( t.whoid ).startsWith( '001' )){
                     t.Phone__c = mapTask.get(t.WhatId); 
                     //t.whoid= custname.get(t.whatid);
                }
                else if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( leadTabId )){
                    t.Phone__c = mapLead.get(t.WhatId);  
                     t.whoid= custname.get(t.whatid);
                }
                else if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith(dmRequestTabId)){                    
                    
                        t.Phone__c = mapDMRequestPhone.get(t.WhatId);
                         t.whoid= custname.get(t.whatid);
                }
            }else if(t.RecordTypeId == eDMTaskRecordTypeId){
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