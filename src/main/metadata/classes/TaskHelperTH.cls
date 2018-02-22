/**
* Utility for Trigger on Task for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-02
*/

public without sharing class TaskHelperTH {
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
    //As per new requirement requested by TH market Fail-blacklist is not applicable for TH market so commenting
   public static void TaskFailBlacklist(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {    /*set<Id> setTaskIds = new set<Id>();
        Set<Id> conIds = new Set<Id>();
    list<account> accs=new list<account>();
        for(Task tk : tasks){
             if(tk.Activity_Status__c == 'Fail-Blacklist' &&  ( isInsert || (isUpdate &&!Test.isRunningTest()&& taskOldMap.get(tk.Id).Activity_Status__c != 'Fail-Blacklist')))
                setTaskIds.add(tk.Id);
        }            
        for(Task tks : [SELECT Id, WhoId FROM Task WHERE Id in :setTaskIds and WhoId != null] )
            conIds.add(tks.WhoId);                
        for(Account acc : [SELECT Id, Is_Blacklist__c FROM Account WHERE PersonContactId=:conIds And Is_Blacklist__c != true]){
            acc.Is_Blacklist__c = true;
            accs.add(acc);
        }
        if(accs.size()>0)   
            try{
            update accs;
            }
    catch(Exception e){
        
    }*/
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
                    lstTaskUpdate.add(newTask);
             }
            if(lstTaskUpdate.size()>0)
                 UtilTaskTH.updateCampaignMemberStatus(lstTaskUpdate);
        }   
   }
   public static void updateAccountMobile(List<Task> lstTask){          
        Set<ID> accId = new Set<ID>();
        Set<ID> conId = new Set<ID>();
        Set<ID> leadId = new Set<ID>();
        set<id> contactId = new set<id>();
        Set<ID> dmRequestId = new Set<ID>();
        List<Account> lstAccount = new List<Account>();
        List<contact> lstcon = new List<contact>();
        List<Lead__c> lstLead = new List<Lead__c>();
        List<DM_Request__c> lstDMRequest = new List<DM_Request__c>();
        // Maps
        Map<Id , String> mapTask = new Map<Id , String>();
        Map<Id , String> mapEMailTask = new Map<Id , String>();
        Map<Id , String> mapLead = new Map<Id , String>();
        Map<Id , String> mapEMailLead = new Map<Id , String>();
        Map<Id , String> mapDMRequestPhone = new Map<Id , String>();
        Map<Id , String> mapDMRequestEmail = new Map<Id , String>();
        Map<Id , id> custname = new Map<Id , id>();
        
        for(Task tsk : lstTask){ 
            if( tsk.whoid != null && String.valueOf( tsk.whoid ).startsWith( '001' ))
                accId.add(tsk.whoid);       
            else if( tsk.whoid != null && String.valueOf( tsk.whoId ).startsWith( '003' ))
                conId.add(tsk.whoId);       
            else if(tsk.WhatId != null){
                if(String.valueOf( tsk.WhatId ).startsWith(leadTabId))
                  leadId.add(tsk.WhatId);        
                else if(String.valueOf( tsk.WhatId ).startsWith( dmRequestTabId ))
                  dmRequestId.add(tsk.WhatId);           
            }
        
        }
        if(accId.size()>0)
            lstAccount = [Select Id,Mobile__c,Email__c, Primary_Phone__c,individual_Home_Phone__c,PersonContactId,Work_Phone__c from Account where Id =:accId or id=:conId];
        if(conId.size()>0)
            lstcon = [Select Id, Account.Email__c,Account.Mobile__c,Account.Primary_Phone__c,Account.individual_Home_Phone__c,Account.Work_Phone__c from contact where Id =:conId];
        if(leadId.size()>0)
            lstLead = [Select Id,Contact__r.Mobile__c,Contact__c,Contact__r.Email__c, Contact__r.Primary_Phone__c,Contact__r.individual_Home_Phone__c,Contact__r.PersonContactId,Contact__r.Work_Phone__c,Company_Account__r.Mobile__c,Company_Account__r.Email__c from Lead__c where Id =:leadId];
        if(dmRequestId.size()>0)
           lstDMRequest = [Select Id,Customer_Name__c,Customer_Name__r.Mobile__c,Customer_Name__r.Primary_Phone__c,Customer_Name__r.individual_Home_Phone__c,Customer_Name__r.Work_Phone__c,Customer_Name__r.Email__c,Customer_Name__r.PersonContactId  from DM_Request__c where Id =:dmRequestId]; 
        for(contact con : lstcon){
            if(con.account.Primary_Phone__c!=null){
            String contactphone=con.account.Primary_Phone__c=='Mobile'?con.account.Mobile__c:con.account.Primary_Phone__c=='Home phone'?con.account.individual_Home_Phone__c:con.account.Primary_Phone__c=='Work Phone'?con.account.Work_Phone__c:'nophone';
            if(contactphone!='nophone')
                mapTask.put(con.id,contactphone);
            }       
        }
        for(Account acc : lstAccount){
            if(acc.Primary_Phone__c!=null){
            String contactphone=acc.Primary_Phone__c=='Mobile'?acc.Mobile__c:acc.Primary_Phone__c=='Home phone'?acc.individual_Home_Phone__c:acc.Primary_Phone__c=='Work Phone'?acc.Work_Phone__c:'nophone';
            if(contactphone!='nophone')
                mapTask.put(acc.id,contactphone);
            } 
            mapEMailTask.put(acc.id, acc.Email__c);
            }         
        
        for(Lead__c led : lstLead){

            if(led.contact__c!=null && led.Contact__r.Primary_Phone__c!=null){
                String contactphone=led.Contact__r.Primary_Phone__c=='Mobile'?led.Contact__r.Mobile__c:led.Contact__r.Primary_Phone__c=='Home phone'?led.Contact__r.individual_Home_Phone__c:led.Contact__r.Primary_Phone__c=='Work Phone'?led.Contact__r.Work_Phone__c:'nophone';
                if(contactphone!='nophone')
                mapLead.put(led.id,contactphone);
                }
                mapEMailLead.put(led.id, led.Contact__r.Email__c);
                custname.put(led.id,led.Contact__r.PersonContactId);
    
        }
        
        for(DM_Request__c dmr : lstDMRequest){   
             if(dmr.Customer_Name__c!=null && dmr.Customer_Name__r.Primary_Phone__c!=null){
                    String contactphone=dmr.Customer_Name__r.Primary_Phone__c=='Mobile'?dmr.Customer_Name__r.Mobile__c:dmr.Customer_Name__r.Primary_Phone__c=='Home phone'?dmr.Customer_Name__r.individual_Home_Phone__c:dmr.Customer_Name__r.Primary_Phone__c=='Work Phone'?dmr.Customer_Name__r.Work_Phone__c:'nophone';
                    if(contactphone!='nophone')
                        mapDMRequestPhone.put(dmr.id,contactphone);
                }         
            mapDMRequestEmail.put(dmr.id, dmr.Customer_Name__r.Email__c);
            custname.put(dmr.id,dmr.Customer_Name__r.PersonContactId);
        }
                
        for(Task t : lstTask){
            if(t.RecordTypeId == OBCAllTaskRecordTypeId||t.RecordTypeid==iBCAllTaskRecordTypeId){
                if(t.WhoId != Null && String.valueOf( t.whoid ).startsWith( '003' ))
                    t.Phone__c = mapTask.get(t.Whoid);  
                else if(t.whoid != Null && String.valueOf( t.whoid ).startsWith( '001' ))
                     t.Phone__c = mapTask.get(t.WhatId); 
                else if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( leadTabId )){
                    t.Phone__c = mapLead.get(t.WhatId);  
                    t.whoid= custname.get(t.whatid);
                }
                else if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith(dmRequestTabId)){                    
                        t.Phone__c = mapDMRequestPhone.get(t.WhatId);
                        t.whoid= custname.get(t.whatid);
                }
            }else if(t.RecordTypeId == eDMTaskRecordTypeId){
                if(t.WhoId != Null && String.valueOf( t.whoid ).startsWith( '003' ))
                    t.Email_Address__c = mapEMailTask.get(t.WhoId);                    
                if(t.WhatId != Null && String.valueOf( t.WhatId ).startsWith( '001' ))
                    t.Email_Address__c = mapEMailTask.get(t.WhatId);
                if(t.WhatId != Null){
                    if(String.valueOf( t.WhatId ).startsWith(leadTabId))
                      t.Email_Address__c = mapEMailLead.get(t.WhatId); 
                    else if(String.valueOf( t.WhatId ).startsWith(dmRequestTabId))
                        t.Email_Address__c = mapDMRequestEmail.get(t.WhatId);       
            }
          }
      }
  }
}