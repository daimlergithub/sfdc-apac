@isTest
public With Sharing class UtilTaskTest
{
    public static List<Task> tasklst;
    public static List<Account> accList;
    public static List<CampaignMember> campmemlist = new List<CampaignMember>();
    
    public static testmethod void updateLeadForDataSharing_test()
    {
        createData();
        Test.startTest();
            UtilTask.updateCampaignMemberStatus(tasklst);
        Test.stopTest();
    }
    public static void createData(){
        accList = new List<Account>();
        Id recordTypeCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
        Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Account accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez');
        accList.add(accObj);
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605',Mobile__c ='09865234112');
        accList.add(accObj);
        insert accList;
        Contact contactObj = new Contact(AccountId= accList.get(0).Id,LastName= 'TestClass',Federation_ID__c = '258963147');
        insert contactObj;
        Campaign  campaignObj = new Campaign(Name='Test',RecordTypeId = recordTypeCampaignId,Repeat_From__c= system.now(),Repeat_End__c= system.now());
        insert campaignObj;
        Id recordTypeTaskId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Task taskObj = new Task(RecordTypeId = recordTypeTaskId,WhatId =campaignObj.Id,subject='Test Task',Activity_Status__c ='Need Verification',WhoId = contactObj.Id);
        tasklst = new List<Task>();
        tasklst.add(taskObj);
        insert tasklst;
        
       
        CampaignMember campaignMemObj = new CampaignMember(CampaignId = campaignObj.Id,ContactId=contactObj.Id,Status='Failed/No Response');
        insert campaignMemObj;
        campmemlist.add(campaignMemObj);
    }
}