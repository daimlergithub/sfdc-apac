/*
    Type:       SMSBatchService 
    Purpose:    design for "Active all" "Suspend All" button SMS Batch in compagin Page
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. lishuang Created on 2013-12-01
    2. lishuang Updated  on 2014-03-12
*/
global class SMSBatchSecdule implements Database.Batchable<sObject>, Database.Stateful {
    
    private Id compaginId;
    Campaign  campaign;
    SMS_Batch__c SMSBatch;
    private String query;
    Template__c smsTemplates;
    Map<Id, Campaign_Lead__c> clMap;
    integer batchSize = 99999999;
    integer taskCount;
    Map<String, Task> upSMSTaskList = new Map<String, Task>();

    private String SMS_RECORD_TYPE =  Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private String MMS_RECORD_TYPE =  Schema.SObjectType.task.getRecordTypeInfosByName().get('MMS').getRecordTypeId();

    global SMSBatchSecdule(Id CampaignId, SMS_Batch__c SMSBatch) {
        this.SMSBatch = SMSBatch;
        this.compaginId = CampaignId;
        campaign = [SELECT name, SMS_Task_Verified__c, Create_Unique_Code__c, Execution_Type__c FROM Campaign WHERE Id = :CampaignId];
        smsTemplates = [select id, Message_Detail__c, Type__c, Template_ID__c from Template__c where id = :smsBatch.Campaign__r.Template__c and Template__c.Active__c = true];
        clMap = new Map<Id, Campaign_Lead__c>([Select Id From Campaign_Lead__c Where Campaign__c = : compaginId]);
        if (SMSBatch.Batch_Size__c <> null){
            batchSize = integer.valueOf(SMSBatch.Batch_Size__c);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	String recordType;
    	if(campaign.Execution_Type__c == 'SMS'){
    		recordType = SMS_RECORD_TYPE;
    	}else if (campaign.Execution_Type__c == 'MMS'){
    		recordType = MMS_RECORD_TYPE;
    	}
        return Database.getQueryLocator([SELECT Id, Status, Activity_Status__c, UniqueCode__c, SMS_Content__c FROM Task WHERE Activity_Status__c = 'Need Verification' AND  RecordTypeId = :recordType and (WhatId = :compaginId OR WhatId in :clMap.keySet()) limit :batchSize]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        list<Task> taskSMS;
        // update task
        taskSMS = (list<Task>)scope;
        try {
	        if(taskSMS.size() > 0){
	            for(Task tk : taskSMS){
	                tk.Status = 'Closed';
	                tk.Activity_Status__c = 'Sent';
	                String UniqueCd = '';
	                if(campaign.Create_Unique_Code__c){
	                  UniqueCd = getUniqueCd();
	                  tk.UniqueCode__c = UniqueCd;
	                }
				    if(campaign.Execution_Type__c == 'SMS'){
			    		tk.SMS_Content__c = tk.SMS_Content__c + UniqueCd;
			    	}
	                tk.SMSBatchNumber__c = SMSBatch.Name;
	                tk.Campaign_Name__c = campaign.Name;
	                tk.SMSTemplateID__c = smsTemplates.id;
	                if (campaign.Execution_Type__c == 'MMS'){
			    		tk.eDM_Template__c = smsTemplates.Template_ID__c;
			    	}
	                if(smsTemplates.Type__c == 'Upstream & Downstream'){
	                    tk.SMS_Response_Required__c = true;
	                }
	            }
	            Database.SaveResult[] srs = Database.update(taskSMS, false);
	            processUpdateMisTasks(srs, taskSMS);
	        }
        } 
        catch(exception ex) {
            System.debug('update task failed : ' + ex.getTypeName());             
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    	// insert task
    	List<SMSTestRecipient__c> SMSTestRecipients = [Select TestRecipientName__r.Id, TestRecipientName__r.FirstName, TestRecipientName__r.LastName, TestRecipientName__r.Salutation, TestRecipientName__r.SMSOptOut__c, TestRecipientName__c, Mobile__c From SMSTestRecipient__c  where TestRecipientGroup__c = :smsBatch.TestRecipientGroup__c and TestRecipientGroup__r.IsActive__c = true and IsActive__c = true];
        List<Task> smsTasks = new List<Task>();
        User intUser = [SELECT Id FROM User WHERE Profile.Name = 'IntegrationAPI' AND isActive = true  LIMIT 1];
        Map<String, Task> SMSTaskMap= new Map<String, Task>();
        try {
	        for(SMSTestRecipient__c SMSTestRecipient : SMSTestRecipients){
	            
	            if(SMSTestRecipient.TestRecipientName__r.SMSOptOut__c ||  SMSTestRecipient.Mobile__c == null || SMSTestRecipient.Mobile__c == ''){
	                continue;
	            }
	            Task smsTask = new Task();
	            smsTask.WhatId = compaginId;
	            smsTask.WhoId = SMSTestRecipient.TestRecipientName__r.Id;
	            smsTask.Phone__c = SMSTestRecipient.Mobile__c;
	            smsTask.Status = 'Closed';
	            smsTask.Activity_Status__c = 'Sent';
	            smsTask.SMSTemplateID__c = smsTemplates.id;
			    if(campaign.Execution_Type__c == 'SMS'){
			    	smsTask.Subject = 'SMS';
		    		smsTask.RecordTypeId = SMS_RECORD_TYPE;
		    	}
		    	else if (campaign.Execution_Type__c == 'MMS'){
		    		smsTask.Subject = 'MMS';
		    		smsTask.RecordTypeId = MMS_RECORD_TYPE;
		    		smsTask.eDM_Template__c = smsTemplates.Template_ID__c;
		    	}
	            
	            String UniqueCd = '';
	            if(campaign.Create_Unique_Code__c){
	              UniqueCd = getUniqueCd();
	              smsTask.UniqueCode__c = UniqueCd;
	            }
	            smsTask.SMS_Content__c = smsTemplates.Message_Detail__c + UniqueCd;
	            smsTask.Campaign_Name__c = campaign.Name;
	            smsTask.SMSBatchNumber__c = SMSBatch.Name;
	            smsTask.ActivityDate = System.today();
	            smsTask.OwnerId = intUser.Id;
	            
	            SMSTaskMap.put(smsTask.Phone__c,smsTask);
	        }
	        smsTasks.addAll(SMSTaskMap.Values());
	        Database.SaveResult[] srs =  Database.insert(smsTasks, false);
	        processInsertMisTasks(srs, smsTasks);
	        // update smsbatch status to Finished
	        SMSBatch.Batch_Status__c = 'Finished';
	        update SMSBatch;
        } 
        catch(exception ex) {
            System.debug('create task failed : ' + ex.getTypeName());             
        }
    }
    
        /* Private Properties */
    private static final List<String> arrayLst = 
                    new List<String>{'0','1', '2', '3', '4', '5', '6', '7', '8', '9', 
                                     'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 
                                     'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 
                                     'U', 'V', 'W', 'X', 'Y', 'Z'};
    private static final Long divider36 = Long.valueOf('36');
    private static String result = '';
    
    /* Make a no duplicate code*/
    private static String getUniqueCd() {
        String uniqueTime36 = changeToHhex36(datetime.now().getTime());
        // Get the 6 digital from right side of uniqueTime36
        String uniqueBeforePart = uniqueTime36.substring(uniqueTime36.length()-6);
        
        String uniqueAfterPart = '';
        // Get a random Double that is greater than or equal to 0.0 and less than 1.0.
        Double randomDouble = Math.random();
        Integer randomInt = Math.round(randomDouble * 100);
        if (randomInt == 0) {
            uniqueAfterPart = '00';
        } else if (randomInt < 10) {
            uniqueAfterPart = '0' + String.valueOf(randomInt);
        } else if (randomInt == 100) {
            uniqueAfterPart = '10';
        } else {
            uniqueAfterPart = String.valueOf(randomInt);
        }
        
        return uniqueBeforePart + uniqueAfterPart;
    }
    
    /* 36 Hexadecimal decimal conversion*/
    private static String changeToHhex36(Long pLong) {
        
        Long remainder = Math.mod(pLong, divider36);
        
        result = arrayLst[remainder.intValue()] + result;
        Long a = pLong / divider36;

        if (a >= divider36)
        {
            changeToHhex36(a);
        }
        else if( a > 0)
        {
            result = arrayLst[a.intValue()] + result;
        }
        
        return result;
    }

    public void processUpdateMisTasks(Database.SaveResult[] srs, List<Task> taskList) {
        // Define misunderstood task list
        List<Task> missedTasks = new List<Task>();

        for (Integer i = 0; i < srs.size(); i++) {
            Database.SaveResult sr = srs[i];
            if (!sr.isSuccess()) {
                Task ta = taskList[i];
                missedTasks.add(ta);
                }
            }

        Database.update(missedTasks, false);
    }
    public void processInsertMisTasks(Database.SaveResult[] srs, List<Task> taskList) {
        // Define misunderstood task list
        List<Task> missedTasks = new List<Task>();

        for (Integer i = 0; i < srs.size(); i++) {
            Database.SaveResult sr = srs[i];
            if (!sr.isSuccess()) {
                Task ta = taskList[i];
                missedTasks.add(ta);
                }
            }

        Database.insert(missedTasks, false);
    }
}