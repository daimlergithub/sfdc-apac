/*
    Type:       test class
    Purpose:    NewCMSContractsRelationController test class
    User Story: quick wins FOS Complaint

    Used By:    NewCMSContractsRelationController 
    ---------------------------------------------------------------
    History:

    2015-02-27 Sinow Created
*/
@isTest
public class NewCMSContractsRelationControllerTest {

    private static Id FOSId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FOS Complaint').getRecordTypeId();
    private static TestDataUtil testData = TestDataUtil.getInstance();
    private static Id leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();   
    
    public static testMethod void testNewCMSContractsRelationController() {
        
        Account customer = testData.standardPersonAccount;
        insert customer;
        
        Retail_Task__c contr = new Retail_Task__c();
        contr.ContractNumber__c = 'acme1234';
        contr.Account__c = customer.Id;
        insert contr;
        
        Case c = new Case();
        c.RecordTypeId = FOSId;
        c.Subject = 'acme';
        insert c;
        
        PageReference pr = Page.NewCMSContractsRelation;
        pr.getParameters().put('id', c.Id);
        Test.setCurrentPage(pr);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.CMSContractsRelationInfo.Name = 'acme1234';
        newCMS.saveCMS();
        newCMS.cancelCMS();
        
        Lead__c finld = new Lead__c(RecordTypeId = leadFinanceRT
                                   , Contact__c = customer.Id
                                   , Lead_Source__c = 'Web Form'
                                   , Sub_Source__c = 'Contact Us'
                                   , Nature_of_Request__c = 'Brochure Request'
                                   , Business_Unit__c = 'Cars'
                                   , Sub_BusinessUnit__c = 'Sales'
                                   , CAC_Lead_Status__c = 'Quote Provided');
        insert finld;
        
        PageReference pr2 = Page.NewCMSContractsRelation;
        pr2.getParameters().put('id', finld.Id);
        Test.setCurrentPage(pr2);
        newCMS = new NewCMSContractsRelationController();
        newCMS.CMSContractsRelationInfo.Name = 'acme1234';
        newCMS.saveCMSforLead();
        newCMS.saveCMSforLeadAndNew();
        newCMS.cancelforLead();
    }
}