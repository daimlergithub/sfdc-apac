/*
    Type:       Test Class
    Purpose:    Test On MyProcess Class
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-24

*/
@isTest(seeAllData=false)
public class MyProcessTest {
    static testMethod void myEnUnitTest() {
        Id id = UserInfo.getUserId();
        User u = [Select Id, LanguageLocaleKey from user where id =:id][0];
        u.LanguageLocaleKey = 'en_US';
        update u;
        
        Account dealer = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
            Name = 'test dealer',
            Dealer_Active__c = true
        );
        insert dealer;
        
        Retail_Campaign__c rc = new Retail_Campaign__c(
            RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId(), 
            Name = 'test retail campaign',
            Dealer_Name__c = dealer.id,
            Location__c = 'test',
            Brand__c = 'MB',
            CBU_PbP__c = 'CBU',
            Event_Type__c = 'Road Show',
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned'
            );
        insert rc;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(rc.id);
        req1.setSubmitterId(Userinfo.getUserId()); 
        req1.setProcessDefinitionNameOrId('Retail_Campaign_Approval_Process');
        req1.setSkipEntryCriteria(false);
        Approval.ProcessResult result = Approval.process(req1);
        
        
        Test.startTest();
        System.assert(result.isSuccess());
        System.assert([Select Id, Apply_Status__c from Retail_Campaign__c where id = :rc.id][0].Apply_Status__c == 'Confirmed');
        
        PageReference pr = new PageReference('/apex/MassApproveRetailCampaign');
        Test.setCurrentPage(pr);
        
        MassApproveRetailCampaignController con = new MassApproveRetailCampaignController();
        con.cpn.Dealer_Name__c = dealer.id;
        con.getRecordTypes();
        
        con.query();
        //con.cpnsInfo[0].checked = true;
        
        con.approve();
        Test.stopTest();
    }
    
    static testMethod void approveMethodTest() {
        Account dealer = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
            Name = 'test dealer',
            Dealer_Active__c = true
        );
        insert dealer;
        
        Retail_Campaign__c rc = new Retail_Campaign__c(
            RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId(), 
            Name = 'test retail campaign',
            Dealer_Name__c = dealer.id,
            Location__c = 'test',
            Brand__c = 'MB',
            CBU_PbP__c = 'CBU',
            Event_Type__c = 'Road Show',
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned'
        );
        insert rc;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(rc.id);
        req1.setSubmitterId(Userinfo.getUserId()); 
        req1.setProcessDefinitionNameOrId('Retail_Campaign_Approval_Process');
        req1.setSkipEntryCriteria(false);
        Approval.ProcessResult result = Approval.process(req1);
        
        System.assert(result.isSuccess());
        System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status : '+result.getInstanceStatus());
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        System.assert(!newWorkItemIds.isEmpty());
        
        MyProcess p = new MyProcess(rc.id);
        System.assert(p.approve('test comment', newWorkItemIds.get(0)));
    }
    
    static testMethod void newContentTest() {
        List<ContentVersion> lc = new List<ContentVersion> {new ContentVersion(title = 'title', ContentUrl = 'www.baidu.com')};
        Database.SaveResult[] results = Database.insert(lc, true);
        System.assert(results[0].isSuccess(), true);
    }
}