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
            if(led.Contact__r.Mobile__c == null || 	led.Contact__r.Email__c == null ){
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
            lstAccount = [Select Id,FS_Opt_In_Home_Phone__c,FS_Opt_In_Home_Phone2__c,FS_Opt_In_Work_Phone__c,
                                    FS_Opt_In_Work_Phone2__c,FS_Opt_In_Email__c,
                                    FS_Opt_In_Email2__c,FS_Opt_In_Email3__c from Account where Id =:accId];
        }
        
        for(Account acc : lstAccount){
            Accounts.put(acc.Id, acc);
        }
                        
        for(Task t : lstTask){            
            if(t.WhatId != null && String.valueOf( t.WhatId ).startsWith('001')){
                account = Accounts.get(t.WhatId);            	
                if(t.RecordTypeId == OBCAllTaskRecordTypeId){                
                    if(account != null &&                     
                        account.Opt_In_Work_Phone__c != True &&
                        account.Opt_In_Home_Phone__c != True &&
                      	account.Opt_In_SMS__c != True){                     
                        t.addError(errMsg);
                    }
                    
                }else if(t.RecordTypeId == eDMTaskRecordTypeId){                
                        if(account != null && 
                            account.Opt_In_Email__c != True){
                           	t.addError(errMsg);
                            }  
                        
                       }
            }
    	}

	}
}