/*
    Type:       Test Class
    Purpose:    Test On MassApproveToolKitController
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-24

*/
@isTest(seeAllData=false)
public class MassApproveRetailCampaignControllerTest {
    static testMethod void myUnitTest() {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

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
            Feedback_Status__c = 'Planned',
            Car_Model__c = 'A-CLASS;B-CLASS;C-CLASS',
            Approver__c = Userinfo.getUserId()
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
        con.getApplyStatusOptions();
        con.getFeedbackStatusOptions();
        
        con.query();
        
        system.debug(con.hasPrev);
        system.debug(con.hasNext);
        con.previous();
        con.next();
        con.first();
        con.last();
        system.debug(con.recordNumbering);
        
        //con.cpnsInfo[0].checked = true;
        
        con.approve();
        Test.stopTest();
    }
}