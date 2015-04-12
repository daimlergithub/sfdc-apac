/*
    Type:       Test Class
    Purpose:    Test On MassApproveToolKitController
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-24

*/
@isTest(seeAllData=false)
public class MassApproveToolKitControllerTest {
    static testMethod void myUnitTest() {
        Account dealer = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
            Name = 'test dealer',
            Dealer_Active__c = true
        );
        insert dealer;
        
        Tool_Kit__c toolKit = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned',
            Brand__c = 'MB',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(toolKit.id);
        req1.setSubmitterId(Userinfo.getUserId()); 
        req1.setProcessDefinitionNameOrId('Tool_Kit_Approval_Process');
        req1.setSkipEntryCriteria(false);
        Approval.ProcessResult result = Approval.process(req1);
        
        
        Test.startTest();
        System.assert(result.isSuccess());
        System.assert([Select Id, Apply_Status__c from Tool_Kit__c where id = :toolKit.id][0].Apply_Status__c == 'Confirmed');
        
        PageReference pr = new PageReference('/apex/MassApproveToolKit');
        Test.setCurrentPage(pr);
        
        MassApproveToolKitController con = new MassApproveToolKitController();
        con.toolKit.Dealer_Name__c = dealer.id;
        con.getRecordTypes();
        con.getApplyStatusOptions();
        con.getFeedbackStatusOptions();
        con.getRegions();
        con.getSubRegions();
        
        con.query();
        system.debug(con.hasPrev);
        system.debug(con.hasNext);
        con.previous();
        con.next();
        con.first();
        con.last();
        system.debug(con.recordNumbering);
        
        //con.toolKitsInfo[0].isToApprove = true;
        
        con.approve();
        Test.stopTest();
    }
}