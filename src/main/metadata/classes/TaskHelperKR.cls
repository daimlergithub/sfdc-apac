/*
1. To cature the customer's Mobile information as part of phone field on Task Object. 
2. Mobile 1 is preffered filed.
3. Need to update email field as well.
4. if the record type is "OB Call" - update Phone field.
5. if the recordtype is "eDM" - update email field.
6. Customer Consent is not present for phone email and address then need to prevent agents from sending or working on the campaign tasks.

**/


public class TaskHelperKR { 
    private static String OBCAllTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    private static String eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    private static string leadTabId = System.Label.LeadId;
    private static string dmRequestTabId = System.Label.DMRequestTabId;
    private static String ExecutionCampaignRecordTypeId = Schema.Sobjecttype.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
     
    
   /*
     @Description - capture phone and email fields.
     @Date : 16/8/2016
     @Param : List of Tasks.new , Indicators for Insert/Update.
     @return:This mehtod does not return any value.

    */
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
            if(led.Contact__r.Mobile__c == null ||  led.Contact__r.Email__c == null ){
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

     /*
     @Description - Customer consent is not present.
     @Date : 16/8/2016
     @Param : List of Tasks.new ,List of Accounts, Indicators for Insert/Update.
     @return:This mehtod does not return any value.

    */
    //private static String errMsg = 'You can not work on the campaign tasks as customer consent is not present.' ;
    private static String errMsg = System.Label.TaskTriggerErrorMsg;    
    public static void CustomerConsenment(List<Task> lstTask){
        
        Set<Id> accId = new Set<Id>();
        map<id,Account> Accounts = new map<id,Account>(); 
        List<Account> lstAccount = new List<Account>();
        Account account;
        for(Task tsk : lstTask){
            if(tsk.WhatId != null && String.valueOf( tsk.WhatId ).startsWith( '001' )){
                accId.add(tsk.WhatId);
            } 
        }
        if(!accId.isEmpty() && accId != null)
        {
            lstAccount = [Select Id,Opt_In_Work_Phone__c,Opt_In_Home_Phone__c,Opt_In_SMS__c,
                                    Opt_In_Email__c,PersonHasOptedOutOfEmail,PersonDoNotCall from Account where Id =:accId];
        }
        
        for(Account acc : lstAccount){
            Accounts.put(acc.Id, acc);
        }
                        
        for(Task t : lstTask){            
            if(t.WhatId != null && String.valueOf( t.WhatId ).startsWith('001')){
                account = Accounts.get(t.WhatId);               
                if(t.RecordTypeId == OBCAllTaskRecordTypeId){                
                    if(account != null && account.PersonDoNotCall == True){                     
                        t.addError(errMsg);
                    }
                 //account.Opt_In_Home_Phone__c != True &&  account.Opt_In_SMS__c != True   
                }else if(t.RecordTypeId == eDMTaskRecordTypeId){                
                        if(account != null && 
                            account.PersonHasOptedOutOfEmail == True){
                            t.addError(errMsg);
                            }  
                        
                       }
            }
        }

    }
        
  /*SFDCKR-1740 - Open up the access of the execution campaign when a task is assigned to a Dealer user who does not have access of execution campaign
   Added by Avishek Roy
   Added on : 04-04-2018
  */
  
 
 public static void updateExecutionCampaignSharing(List<Task> tasks,Map<Id, Task> taskOldMap,boolean isInsert,boolean isUpdate)
   {
               
        Set<Id> camIds = new Set<Id>();
        Set<Id> userIds = new Set<iD>();
        List<Task> CampTask = new List<Task>();
        List<CampaignShare> sharesToCreate = new List<CampaignShare>();
        List<Campaign> Camp = new List<Campaign>();
        List<User> Usr = new List<User>();
        List<CampaignShare> LstCampShare = new List<CampaignShare>();
        List<CampaignShare> LstCampShare1 = new List<CampaignShare>();
        List<CampaignShare> LstCampShare2 = new List<CampaignShare>();
        
        
        if(isUpdate)
         {
             
            for (Task newTask : tasks)
            {
             if(newTask.OwnerId != taskOldMap.get(newTask.Id).OwnerId && newTask.WhatId!=null && newTask.MD__C == 'KR')
               {
                   CampTask.add(newTask);
                   camIds.add(newTask.WhatId);
                   userIds.add(newTask.OwnerId);
               }
               
             }
             
             if(CampTask.Size()>0)
             { 
             Camp = [select Id, RecordTypeId from Campaign where Id IN :camIds];
             Usr = [select Id, MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c from User where Id =:userIds];
             
             if(Camp.Size()>0 && Camp[0].RecordTypeId==ExecutionCampaignRecordTypeId)
             {
             LstCampShare = [select Id from CampaignShare where CampaignId =:Camp[0].Id and UserOrGroupId =:Usr[0].Id];
                                 
             if(LstCampShare.isEmpty()) 
             {
                 if(Usr[0].MBK_Partner_Roles__c == 'Team Leader')
                 {
                   
                    CampaignShare CampShare = new CampaignShare();
                    CampShare.CampaignId = Camp[0].Id;
                    CampShare.UserOrGroupId =  Usr[0].Id;
                    CampShare.CampaignAccessLevel = 'Read';
                    sharesToCreate.add(CampShare);
                                      
                     if(Usr[0].MBK_Reporting_Partner_User__c!=null)
                     {
                        LstCampShare1 = [select Id from CampaignShare where CampaignId =:Camp[0].Id and UserOrGroupId =:Usr[0].MBK_Reporting_Partner_User__c];
                        
                        if(LstCampShare1.isEmpty())
                        {
                            CampaignShare CampShare1 = new CampaignShare();
                            CampShare1.CampaignId = Camp[0].Id;
                            CampShare1.UserOrGroupId =  Usr[0].MBK_Reporting_Partner_User__c;
                            CampShare1.CampaignAccessLevel = 'Read';
                            sharesToCreate.add(CampShare1);
                         }
                      
                     }
                   }
                   
                   if(Usr[0].MBK_Partner_Roles__c == 'Sales Consultant')
                 {
                   
                    CampaignShare CampShare = new CampaignShare();
                    CampShare.CampaignId = Camp[0].Id;
                    CampShare.UserOrGroupId =  Usr[0].Id;
                    CampShare.CampaignAccessLevel = 'Read';
                    sharesToCreate.add(CampShare);
                                    
                     if(Usr[0].MBK_Reporting_Partner_User__c!=null)
                     {
                        LstCampShare1 = [select Id from CampaignShare where CampaignId =:Camp[0].Id and UserOrGroupId =:Usr[0].MBK_Reporting_Partner_User__c];
                        
                        if(LstCampShare1.isEmpty())
                        {
                            CampaignShare CampShare1 = new CampaignShare();
                            CampShare1.CampaignId = Camp[0].Id;
                            CampShare1.UserOrGroupId =  Usr[0].MBK_Reporting_Partner_User__c;
                            CampShare1.CampaignAccessLevel = 'Read';
                            sharesToCreate.add(CampShare1);
                         }
                         
                       if(Usr[0].MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!=null)
                       {  
                        LstCampShare2 = [select Id from CampaignShare where CampaignId =:Camp[0].Id and UserOrGroupId =:Usr[0].MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c];
                        
                        if(LstCampShare2.isEmpty())
                        {
                            CampaignShare CampShare2 = new CampaignShare();
                            CampShare2.CampaignId = Camp[0].Id;
                            CampShare2.UserOrGroupId =  Usr[0].MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c;
                            CampShare2.CampaignAccessLevel = 'Read';
                            sharesToCreate.add(CampShare2);
                          }
                        }
                      
                     }
                   }
                   
                  if (!sharesToCreate.isEmpty())
                   {
                     insert sharesToCreate;
                   }
                    
             
                 } 
                }  
              }   
                
             }
} //End of method updateExecutionCampaignSharing 

      /**
     *
     *
     * @param Tasks
     */
    //MBK Message Send Manage 6/26/2018
    public static void MessageSendManage(List<Task> Tasks, Map<Id,Task> oldTaskMap, String action){

        List<String> taskIds = new List<String>();
        for(Task temp:Tasks){
            if(action == 'Update'){
                Task oldTask = oldTaskMap.get(temp.Id);
                if(temp.Status__c <> oldTask.Status__c){
                    taskIds.add(temp.Id);
                }
            }else taskIds.add(temp.Id);
        }
        MBKSendManageHelperKR.messageManageValidationCheck(taskIds, 'Task', action);
    }    
 
}