/*
    Type:       Test Class
    Purpose:    Test On MBJ_FS_Case_Intermediate_Controller Class
*/

@isTest
public class MBJ_FS_Case_Intermediate_ControllerTest{
    
    public static testMethod void testRetailTaskInquiryController() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testRetailTaskRequestController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testRetailTaskClosingController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Contract Closing Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testRetailTaskQuotationController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Quotation Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testRetailTaskComplaintController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Complaint Management Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testNonFSRetailController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Inquiry'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        Apexpages.currentpage().getparameters().put('retailTaskID',testContract.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountInquiryController() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountRequestController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountClosingController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Contract Closing Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountQuotationController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Quotation Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountComplaintController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Complaint Management Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testNonFSAccountController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Inquiry'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        Apexpages.currentpage().getparameters().put('fromAccountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testCaseInquiryController() {
        
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testCaseRequestController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testCaseClosingController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Contract Closing Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testCaseQuotationController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Quotation Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testCaseComplaintController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Complaint Management Case'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testNonFSCaseController() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Inquiry'].Id;
        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Retail_Task__c = testContract.id;
        testCase.Contract_Number__c = testContract.ContractNumber__c;
        testCase.Case_Complainant__c = testContract.Account__r.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
}