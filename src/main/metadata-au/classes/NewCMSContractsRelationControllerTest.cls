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
    private static Account customer = testData.standardPersonAccount;
    
    public static testMethod void testNewCMSContractsRelationController_Case()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Case caseObj = createcase();
        insert caseObj;
        test.starttest();
        PageReference pr = Page.NewCMSContractsRelation;
        pr.getParameters().put('id', caseObj.Id);
        Test.setCurrentPage(pr);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        test.stoptest();
        system.assertequals(caseObj.Id,newCMS.CMSContractsRelationInfo.Case_No__c);
    }
    
    public static testMethod void testNewCMSContractsRelationController_Lead()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Lead__c objLead= CreateLead();        
        insert objLead;
        test.starttest();
        PageReference pr2 = Page.NewCMSContractsRelation;
        pr2.getParameters().put('id', objLead.Id);
        Test.setCurrentPage(pr2);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        test.stoptest();
        system.assertequals(objLead.Id,newCMS.CMSContractsRelationInfo.Lead__c);
    }
    
    public static testMethod void testNewCMSContractsRelationController_saveCMS()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Case caseObj = createcase();
        insert caseObj;
        test.starttest();
        PageReference pr = Page.NewCMSContractsRelation;
        pr.getParameters().put('id', caseObj.Id);
        Test.setCurrentPage(pr);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.saveCMS();
        test.stoptest();
        system.assertequals(caseObj.Id,ApexPages.currentPage().getParameters().get('id'));
    }
    
    public static testMethod void testNewCMSContractsRelationController_cancelCMS()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Case caseObj = createcase();
        insert caseObj;
        test.starttest();
        PageReference pr = Page.NewCMSContractsRelation;
        pr.getParameters().put('id', caseObj.Id);
        Test.setCurrentPage(pr);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.cancelCMS();
        test.stoptest();
        system.assertequals(caseObj.Id,ApexPages.currentPage().getParameters().get('id'));
    }
    
    public static testMethod void testNewCMSContractsRelationController_saveCMSforLead()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Lead__c objLead= CreateLead();        
        insert objLead;
        test.starttest();
        PageReference pr2 = Page.NewCMSContractsRelation;
        pr2.getParameters().put('id', objLead.Id);
        Test.setCurrentPage(pr2);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.saveCMSforLead();
        test.stoptest();
        system.assertequals(objLead.Id,ApexPages.currentPage().getParameters().get('id'));
    }
    
    public static testMethod void testNewCMSContractsRelationController_saveCMSforLeadAndNew()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Lead__c objLead= CreateLead();        
        insert objLead;
        test.starttest();
        PageReference pr2 = Page.NewCMSContractsRelation;
        pr2.getParameters().put('id', objLead.Id);
        Test.setCurrentPage(pr2);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.saveCMSforLeadAndNew();
        test.stoptest();
        system.assertequals(objLead.Id,ApexPages.currentPage().getParameters().get('id'));
    }
    
    public static testMethod void testNewCMSContractsRelationController_cancelforLead()
    {
        
        insert customer;
        
        Retail_Task__c objRT = createRetailTask();
        insert objRT;
        
        Lead__c objLead= CreateLead();        
        insert objLead;
        test.starttest();
        PageReference pr2 = Page.NewCMSContractsRelation;
        pr2.getParameters().put('id', objLead.Id);
        Test.setCurrentPage(pr2);
        NewCMSContractsRelationController newCMS = new NewCMSContractsRelationController();
        newCMS.cancelforLead();
        test.stoptest();
        system.assertequals(objLead.Id,ApexPages.currentPage().getParameters().get('id'));
    }
    
    
    static Retail_Task__c createRetailTask()
    {
    	Retail_Task__c contr = new Retail_Task__c();
        contr.ContractNumber__c = 'acme1234';
        contr.Account__c = customer.Id;
        return contr;
    }
    
    static case createcase()
    {
    	Case c = new Case();
        c.RecordTypeId = FOSId;
        c.Subject = 'acme';
        return c;
    }
    
    static Lead__c createLead()
    {
    	Lead__c finld = new Lead__c(RecordTypeId = leadFinanceRT
                                   , Contact__c = customer.Id
                                   , Lead_Source__c = 'Web Form'
                                   , Sub_Source__c = 'Contact Us'
                                   , Nature_of_Request__c = 'Brochure Request'
                                   , Business_Unit__c = 'Cars'
                                   , Sub_BusinessUnit__c = 'Sales'
                                   , CAC_Lead_Status__c = 'Quote Provided');
        return finld;
    }
}