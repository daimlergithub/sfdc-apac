/*
    Type:       Test Class
    Purpose:    Test On MyProcess Class 
    History: 
    1. Cyril Created on 2014-10-24

*/
@isTest 
public with sharing class MyProcessTest {
Private Static String Planned='Planned';
Private Static Account dealer;
Private Static Retail_Campaign__c rc;
Private Static User usr;
Private Static List<Trigger__c> updatecustomsettings=new List<Trigger__c>();


   static testMethod void testData() {
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         usr = new User(Alias = 'nUser777', Email='newuser777@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser777@testorg.com',ManagerId=UserInfo.getuserId()); 
       system.runAs(usr){
        dealer = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
            Name = 'test dealer',
            Dealer_Active__c = true
        );
        insert dealer;
        rc = new Retail_Campaign__c(
            RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId(), 
            Name = 'test retail campaign',
            Dealer_Name__c = dealer.id,
            Location__c = 'test',
            Brand__c = 'MB',
            CBU_PbP__c = 'CBU',
            Campaign_Execution_Channels__c = 'eEmail',
            Event_Type__c = 'Road Show',
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = Planned,
            Feedback_Status__c = Planned,
            Approver__c=usr.id           
            );
        insert rc;
        //TO DO : Please remove Approver__c=u.id after adding handler methods to RetailCampaignTriggerHandlerJP        
     }
    }
    static testMethod void testCustomSetting(){
         updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings; 
    }  

    static testMethod void myEnUnitTest() {
         testData();
         testCustomSetting();
          Approval.ProcessSubmitRequest reqest = new Approval.ProcessSubmitRequest();
          reqest.setComments('Submitting request for approval.');
          reqest.setObjectId(rc.id);
          reqest.setSubmitterId(Userinfo.getUserId()); 
          reqest.setProcessDefinitionNameOrId('Retail_Campaign_Approval_Process');
          reqest.setSkipEntryCriteria(false);      
      //    reqest.setNextApproverIds(new ID[] {usr.Id});
          Approval.ProcessResult result  = Approval.process(reqest); 
         Test.startTest();
            PageReference pr = new PageReference('/apex/MassApproveRetailCampaign');
            Test.setCurrentPage(pr);        
            MassApproveRetailCampaignController con = new MassApproveRetailCampaignController();
            con.cpn.Dealer_Name__c = dealer.id;
            con.getRecordTypes();        
            con.query();
            //con.cpnsInfo[0].checked = true;        
            con.approve();
         Test.stopTest();
       //  System.assert(result.isSuccess());
         System.assert([Select Id, Apply_Status__c from Retail_Campaign__c where id = :rc.id][0].Apply_Status__c == 'Confirmed');
     } 
       
    static testMethod void approveMethodTest() {
        testData();
        testCustomSetting();
        Approval.ProcessSubmitRequest reqest = new Approval.ProcessSubmitRequest();
        reqest.setComments('Submitting request for approval.');
        reqest.setObjectId(rc.id);
        reqest.setSubmitterId(Userinfo.getUserId()); 
        reqest.setProcessDefinitionNameOrId('Retail_Campaign_Approval_Process');
        reqest.setSkipEntryCriteria(false);      
        reqest.setNextApproverIds(new ID[] {usr.Id});
       Approval.ProcessResult result  = Approval.process(reqest);
        Test.startTest();
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        MyProcess p = new MyProcess(rc.id);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status : '+result.getInstanceStatus());
        System.assert(p.approve('test comment', newWorkItemIds.get(0)));
        System.assert(!newWorkItemIds.isEmpty());
    }
    
    static testMethod void newContentTest() {
       testData();  
       testCustomSetting();
       Approval.ProcessSubmitRequest reqest = new Approval.ProcessSubmitRequest();
       reqest.setComments('Submitting request for approval.');
       reqest.setObjectId(rc.id);
       reqest.setSubmitterId(Userinfo.getUserId()); 
       reqest.setProcessDefinitionNameOrId('Retail_Campaign_Approval_Process');
       reqest.setSkipEntryCriteria(false);      
       reqest.setNextApproverIds(new ID[] {usr.Id});
       Approval.ProcessResult result  = Approval.process(reqest); 
       Test.startTest();
        List<ContentVersion> lc = new List<ContentVersion> {new ContentVersion(title = 'title', ContentUrl = 'www.baidu.com')};
        Database.SaveResult[] results = Database.insert(lc, true);
      Test.stopTest();
      System.assert(results[0].isSuccess(), true);
    }
}