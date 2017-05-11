/*
    Type:       Test Class
    Purpose:    Test On MBJ_FS_Case_Intermediate_Controller Class
*/

@isTest
public class MBJ_FS_Case_Intermediate_ControllerTest{
    
    public static testMethod void testRetailTaskMBFInquiryController() {
        
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
        public static testMethod void testRetailTaskInquiryController() {
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
        testCase.AccountId = testAccount.id;
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
    public static testMethod void testRetailTaskMBComplaintController() {
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
        testCase.AccountId = testAccount.id;
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
/*---------------------------------------------------------------------------------*/
    public static testMethod void testAccountMBFInquiryController() {
        
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account Retail') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId1',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountRequestController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account Retail') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId1',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountClosingController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account Retail') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Contract Closing Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId1',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountQuotationController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account Retail') AND (SobjectType='Account')].Id;
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Quotation Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId1',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountComplaintController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account Retail') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Complaint Management Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
        insert testCase;
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));
        Apexpages.currentpage().getparameters().put('fromAccountId1',testAccount.id);
        ApexPages.currentPage().getParameters().put('RecordType',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);
        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
    
    public static testMethod void testAccountInquiryController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Inquiry'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.AccountId = testAccount.id;
        testCase.Case_Complainant__c = testAccount.id;
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
    
    public static testMethod void testAccountMBComplaintController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MB Complaint'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.AccountId = testAccount.id;
        testCase.Case_Complainant__c = testAccount.id;
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
/*---------------------------------------------------------------------------------*/
    public static testMethod void testCaseMBFInquiryController() {
        
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Inquiry Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
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
        
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
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
        
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;      
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Contract Closing Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
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
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Finance Quotation Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
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
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Complaint Management Case'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.Case_Complainant__c = testAccount.id;
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
    
    public static testMethod void testCaseInquiryController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Inquiry'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.AccountId = testAccount.id;
        testCase.Case_Complainant__c = testAccount.id;
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
    
    public static testMethod void testCaseMBComplaintController() {
        String rt = [SELECT id,Name FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;  
        Account testAccount = new Account(LastName='Test', UCID__c='UCIDtest3394510', recordTypeId=rt);
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MB Complaint'].Id;
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        testCase.AccountId = testAccount.id;
        testCase.Case_Complainant__c = testAccount.id;
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
/*--------------------------------------------------------------------------------------------------------------------*/    
       public static testMethod void testCaseMBFCustomerRequestCase() {
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'MBF Customer Request Case'].Id;        
        Case testCase = new Case();
        testCase.recordtypeid = strRecordTypeId;
        testCase.Subject = 'Test Subject';
        testCase.Status = 'New';
        Account acc=[select id,name from Account where id=:testAccount.id];
        testCase.Accountid =acc.id; 
       // testCase.Case_Complainant__c = acc.Id;
        insert testCase;
       
        PageReference pageRef = Page.MBJ_FS_Case_Intermediate_Page;
        Test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('Id', String.valueOf(testCase.Id));        
        pageRef.getParameters().put('fromAccountId', String.valueOf(acc.name));        
        ApexPages.currentPage().getParameters().put('fromAccountId',testAccount.id);      
        ApexPages.currentPage().getParameters().put('RecordTypeid',strRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);        
        MBJ_FS_Case_Intermediate_Controller intermediate = new MBJ_FS_Case_Intermediate_Controller(sc);        
        Test.Starttest(); 
        intermediate.Redirect();
        Test.Stoptest();
    }
}