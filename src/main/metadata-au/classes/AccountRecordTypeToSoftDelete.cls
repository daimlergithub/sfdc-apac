/*
Type        : Scheduled Apex Class on Account
Purpose     : If a Lead is not modified for last 5 years and if the corresponding account activities also not modified for 5 years and the account PC_Status__c = 'Prospect' AND VAN_Status__c = 'Prospect' AND Insurance_Status__c = 'Prospect'
      then change the account record type to 'Company Soft Deleted'.
Issue nO    : SFDCAU-974
Created Date: 7th Oct, 2016
ReCreated Date : 5th Dec, 2016 By Sudheer Kandukuri

*/

global class AccountRecordTypeToSoftDelete implements Database.Batchable<sobject>,Schedulable {
    private static final String PersonAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.PERSON_ACCOUNT).getRecordTypeId();
    private static final String CompanyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.COMPANY_ACCOUNT).getRecordTypeId();
    private static final String PersonAccountSoftDeletedRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.PERSON_SOFT_DELETE_ACCOUNT).getRecordTypeId();
    private static final String CompanyAccountSoftDeletedRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.COMPANY_SOFT_DELETE_ACCOUNT).getRecordTypeId();
    string pcCvInsuValue = 'Prospect';
    public void execute(SchedulableContext sc)
    {
        AccountRecordTypeToSoftDelete scheAccBatch = new AccountRecordTypeToSoftDelete();
        ID batchJobId = Database.executeBatch(scheAccBatch, 2000);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        /*List<Sobject> querylist=[SELECT id, RecordtypeID, LastModifiedDate, (SELECT id, Name,LastModifiedDate  FROM Lead_Contact__r ORDER BY LastModifiedDate DESC LIMIT 1) , 
                             (SELECT id, Name,LastModifiedDate  FROM Leads__r  ORDER BY LastModifiedDate DESC LIMIT 1), 
                             (SELECT id, LastModifiedDate  FROM tasks ORDER BY LastModifiedDate DESC LIMIT 1), 
                             (SELECT id, LastModifiedDate  FROM Events ORDER BY LastModifiedDate DESC LIMIT 1) 
                             From Account WHERE (RecordtypeID =: PersonAccountRecordTypeId OR RecordtypeID =: CompanyAccountRecordTypeId) AND
                             (PC_Status__c =: UtilConstant.Prospect_Value AND VAN_Status__c =: UtilConstant.Prospect_Value)];*/

       /* string query ='SELECT id, RecordtypeID, LastModifiedDate, (SELECT id, Name,LastModifiedDate  FROM Lead_Contact__r ORDER BY LastModifiedDate DESC LIMIT 1) ,'+ 
                       '(SELECT id, Name,LastModifiedDate  FROM Leads__r  ORDER BY LastModifiedDate DESC LIMIT 1), '+
                       '(SELECT id, LastModifiedDate  FROM tasks ORDER BY LastModifiedDate DESC LIMIT 1), '+
                       '(SELECT id, LastModifiedDate  FROM Events ORDER BY LastModifiedDate DESC LIMIT 1) '+
                       'From Account WHERE (RecordtypeID =: PersonAccountRecordTypeId OR RecordtypeID =: CompanyAccountRecordTypeId) AND '+
                       '(PC_Status__c =:pcCvInsuValue AND VAN_Status__c =:pcCvInsuValue AND (Insurance_Status__c =:pcCvInsuValue OR Insurance_Status__c = null))'; */
        string query ='SELECT id, RecordtypeID, LastModifiedDate From Account WHERE (RecordtypeID =: PersonAccountRecordTypeId OR RecordtypeID =: CompanyAccountRecordTypeId) AND '+
                       '(PC_Status__c =:pcCvInsuValue AND VAN_Status__c =:pcCvInsuValue AND (Insurance_Status__c =:pcCvInsuValue OR Insurance_Status__c = null))';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC ,List<Account> acctList)
    {    
        List<account> modifiedacclist = new List<account>();
        List<Task> taskList = new List<Task>();
        List<Lead__c> leadList = new List<Lead__c>();
        List<Event> eventList = new List<Event>();
        Datetime lastFiveYears = System.Now();
        datetime lastmodifieddate_lead;
        datetime lastmodifieddate_task_event;
        set<id> accids = new set<id>();
        for (Account a : acctList)
        {
            accids.add(a.id);
        }
        if(!accids.isEmpty() && taskList != null)
        {
            taskList = [SELECT id, LastModifiedDate, WhatId  FROM task where WhatId =:accids ORDER BY LastModifiedDate DESC LIMIT 1];
            eventList = [SELECT id, LastModifiedDate, WhatId  FROM event where WhatId =:accids ORDER BY LastModifiedDate DESC LIMIT 1];
            leadList = [SELECT id, Name,LastModifiedDate from Lead__c where (Contact__c =:accids OR Company_Account__c =:accids) ORDER BY LastModifiedDate DESC LIMIT 1];
        }
            if (leadList!= null && !leadList.isEmpty())
            {
               lastmodifieddate_lead =  leadList[0].lastmodifieddate;
            }
            if (taskList != null && !taskList.isEmpty())
            {
                lastmodifieddate_task_event =  taskList[0].lastmodifieddate;
            }
            if (eventList != null && !eventList.isEmpty())
            {
                if (lastmodifieddate_task_event == null || lastmodifieddate_task_event < eventList[0].lastmodifieddate)
                {
                     lastmodifieddate_task_event =  eventList[0].lastmodifieddate;
                } 
              
            }
            for(Account acc : acctList)
            {
                if ((lastmodifieddate_lead != null && lastmodifieddate_lead < lastFiveYears) && (lastmodifieddate_task_event == null || lastmodifieddate_task_event < lastFiveYears ) ) 
            
                    {                
                        if (acc.RecordtypeID == PersonAccountRecordTypeId)
                        {
                            acc.RecordtypeID= PersonAccountSoftDeletedRecordTypeId;
                        }
                        if (acc.RecordtypeID == CompanyAccountRecordTypeId)
                        {
                            acc.RecordtypeID= CompanyAccountSoftDeletedRecordTypeId;
                        }
                        Account acct= new Account();
                        acct.id= acc.id;
                        acct.RecordtypeID= acc.RecordtypeID;
                        modifiedacclist.add(acct);
                        System.debug('Change Record Type to SoftDelete >>>>>>>>>>>' + acc.name + '<<<ID >>>>' + acc.id);
                    }
                    else 
                    {
                        if (acc.LastModifiedDate < lastFiveYears){
                            if (acc.RecordtypeID == PersonAccountRecordTypeId)
                            {
                                acc.RecordtypeID= PersonAccountSoftDeletedRecordTypeId;
                            }
                            if (acc.RecordtypeID == CompanyAccountRecordTypeId)
                            {
                                acc.RecordtypeID= CompanyAccountSoftDeletedRecordTypeId;
                            }
                            Account acct= new Account();
                            acct.id= acc.id;
                            acct.RecordtypeID= acc.RecordtypeID;
                            modifiedacclist.add(acct);
                        }
                    }
                }
    
        if(!modifiedacclist.isEmpty())
        {
            Update modifiedacclist;
        }

    }
    global void finish(Database.BatchableContext bc)
    {
    } 
}