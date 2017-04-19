/*
    Type:       Test Class
    Purpose:    Test On MBJ_FS_Case_Inquiry_Controller Class
*/
@isTest
public class MBJ_FS_Case_Inquiry_ControllerTest{
    
    public static testMethod void testWithRetailTask() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        PageReference pageRef = Page.MBJ_FS_Case_Inquiry_Page;
        Test.setCurrentPage(pageRef);
        
        Case testCase = new Case();
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        testCase.Case_Complainant__c = testContract.Account__r.id;
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        insert testCase;
        
        MBJ_FS_Case_Inquiry_Controller Inquiry = new MBJ_FS_Case_Inquiry_Controller(sc);
        
        Test.Starttest(); 
        Inquiry.populateContractNumber();
        Inquiry.ReceiverSameAsRequestor();
        Inquiry.nullifyReqCompPersonPhone();
        Test.Stoptest();
    }
    
    public static testMethod void testWithoutContractNumber() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        PageReference pageRef = Page.MBJ_FS_Case_Inquiry_Page;
        Test.setCurrentPage(pageRef);
        
        Case testCase = new Case();
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        testCase.Case_Complainant__c = testContract.Account__r.id;
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        insert testCase;
        
        MBJ_FS_Case_Inquiry_Controller Inquiry = new MBJ_FS_Case_Inquiry_Controller(sc);
        
        Test.Starttest(); 
        Inquiry.populateContractNumber();
        Test.Stoptest();
    }
    
    public static testMethod void testContractClosing() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        PageReference pageRef = Page.MBJ_FS_Case_ContractClosing_Page;
        Test.setCurrentPage(pageRef);
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        testCase.Case_Complainant__c = testContract.Account__r.id;
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        insert testCase;
        
        MBJ_FS_Case_Inquiry_Controller Inquiry = new MBJ_FS_Case_Inquiry_Controller(sc);
        
        Test.Starttest(); 
        Inquiry.populateContractNumber();
        Inquiry.ReceiverSameAsRequestor();
        Inquiry.PayerSameAsRequestor();
        Inquiry.CallReceiverAndPayer();
        Inquiry.nullifyContractClosingPageSection();
        Test.Stoptest();
    }
    
    public static testMethod void testRequest() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        PageReference pageRef = Page.MBJ_FS_Case_Request_Page;
        Test.setCurrentPage(pageRef);
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        testCase.Case_Complainant__c = testContract.Account__r.id;
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        insert testCase;
        
        MBJ_FS_Case_Inquiry_Controller Inquiry = new MBJ_FS_Case_Inquiry_Controller(sc);
        
        Test.Starttest();
        Inquiry.nullifyRequestPageSection();
        Test.Stoptest();
    }
    
    public static testMethod void testQuotation() {
        
        String accRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Dealer'].Id;
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510',recordtypeid=accRecordTypeId);
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890',Related_Dealer__c=testaccount.id);
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        PageReference pageRef = Page.MBJ_FS_Case_Quotation_Page;
        Test.setCurrentPage(pageRef);
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        testCase.Case_Complainant__c = testContract.Account__r.id;
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        testCase.Requestor__c = 'Initial Dealer';
        testCase.Requester_Initial_Dealer__c = testContract.Related_Dealer__r.id;
        testCase.Receiver_Same_as_Requestor__c = true;
        testCase.Payer_Same_as_Requestor__c = true;
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        insert testCase;
        
        MBJ_FS_Case_Inquiry_Controller Inquiry = new MBJ_FS_Case_Inquiry_Controller(sc);
        
        Test.Starttest();
        Inquiry.ReceiverSameAsRequestor();
        Inquiry.PayerSameAsRequestor();
        Inquiry.nullifyCaseQuotationPageSection();
        Test.Stoptest();
    }
}