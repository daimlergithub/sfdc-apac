@isTest
public class CaseHelperJPTest{    
    public List<Case> casesToUpdate = new List<Case>();
    public static Id caseInquiryRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public static Account testAccount1;
    public static Account testAccount2;                                                                      
    public static User marketUser;
    
    
    static void createCustomSetting(){
        //Enter the JP Specific settings here.
        system.debug('Create custom setting here...');
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
    }
    
    //Create the test data:
    static void init(){
    
       User testUser = TestUserCreate.createuserrecord('JP');
       System.runAs(testUser){
           //Create Account
           testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'JP';
           update testAccount1;
           
           testAccount2 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount2.MD__c = 'JP';
           update testAccount2;
           
           system.debug('Account 1' +testAccount1);
           system.debug('Account 2' +testAccount2);
           
           //Create Case
           Case testCase1 = (Case)UtilTestData.createSobject(new Case(), UtilConstant.INQUIRY);
           testCase1.Case_Class__c = 'Complaint';
           testCase1.AccountId = testAccount1.Id;
           testCase1.MD__c = 'JP';
           update testCase1;
           
           Case testCase2 = (Case)UtilTestData.createSobject(new Case(), UtilConstant.INQUIRY);
           testCase2.Case_Class__c = 'Complaint';
           testCase2.AccountId = testAccount2.Id;
           testCase2.MD__c = 'JP';
           update testCase2;
           TriggerCaseTriggerHandlerJP TriggerCaseTriggerJP = new TriggerCaseTriggerHandlerJP();
           TriggerCaseTriggerJP.handleTrigger(false, false, false, false, false);
           TriggerCaseTriggerJP.handleIntegrationTrigger(false, false, false, false, false);
           system.debug('Case 1' +testCase1);
           system.debug('Case 2' +testCase2);
       }
       
    }
    
    static void createCaseToComputeDeadline(){
        List<String> priority = new List<String>{'A', 'B', 'C','D','E'};
        List<String> caseClass = new List<String>{UtilConstant.INQUIRY, UtilConstant.OTHERS, UtilConstant.COMPLAINT,UtilConstant.CLAIM,UtilConstant.REQUEST,UtilConstant.TOURING_SUPPORT,UtilConstant.FINANCE};
        List<Case> caseToInsert = new List<Case>();
        
        for(String case_class : caseClass){
            for (String p : priority){
                Case testCase1 = new Case(Case_Class__c = case_class, Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, Priority = p, MD__c = 'JP');
                caseToInsert.add(testCase1);
            }
        }              
        insert caseToInsert;      
    }
    
    
    public static testMethod void testComplaintAmountCaseInsert(){
        createCustomSetting();
        init();
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Insert:' +acc);
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, MD__c = 'JP');
        insert testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Insert:' +acc);
        system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseDelete(){
        createCustomSetting();
        init();
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, MD__c = 'JP');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Delete :' +acc);
        
        delete testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Delete:' +acc);
        system.assertEquals(1, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseUpdate(){
        createCustomSetting();
        init();
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'JP');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Update :' +acc);
        
        testCase1.AccountId = testAccount1.Id;
        update testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Update:' +acc);
        system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    
    public static testMethod void testComputeDeadline(){
        createCustomSetting();
        init();
        createCaseToComputeDeadline();
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, Priority = 'A', MD__c = 'JP');
        insert testCase1;
               
        Case cs = [Select DeadLine__c from Case Where Id =: testCase1.Id];
        System.debug('Case Record...' +cs.DeadLine__c);
        Date todayDate = Date.today();
        
        CaseDeadelineCalc__mdt caseDeadline = [Select CaseDeadelineCalc1__c FROM CaseDeadelineCalc__mdt WHERE QualifiedApiName ='Japan_Case_Deadlines'];
        integer days = (Integer)caseDeadline.CaseDeadelineCalc1__c ;
        
        Date deadLineDate = todayDate.addDays(days);
        //system.assertEquals(todayDate,cs.DeadLine__c);
        
        List<Case> insertedCases = [Select DeadLine__c from Case Where DeadLine__c != null AND Id =: testCase1.Id];
        system.debug('Inserted Cases..' +insertedCases);
        for(Case c : insertedCases){
            system.assertEquals(c.DeadLine__c, deadLineDate);
        }
    }    
}