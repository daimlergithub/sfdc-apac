@isTest
public class TriggerCaseTriggerHandlerMYTest{    
    public List<Case> casesToUpdate = new List<Case>();
    public static Id caseInquiryRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public static Account testAccount1;
    public static Account testAccount2;                                                                      
    public static User marketUser;
    
    
    static void createCustomSetting(){
        //Enter the MY Specific settings here.
        system.debug('Create custom setting here...');
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
    }
    
    //Create the test data:
    static void init(){
        Trigger__c newtrg1 = new Trigger__c(Name= 'CaseTrigger',Trigger_Name__c = 'CaseTrigger',Trigger_Handler__c = 'CaseTriggerHandlerMY',Market__c ='MY',
                               enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert newtrg1;
        
       Id roleId=[Select Id,Name from UserRole where name='Daimler APAC'].id;
       Id profileId=[Select Id,Name from Profile where name='Base CRM'].id;
       
       
        
       user testUser = new User(
            Username = System.now().millisecond() + 'testDaimlerUser21212@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = profileId,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            UserRoleId=roleId,
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            
        );
        
        insert testUser;
       System.runAs(testUser){
           //Create Account
           testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'MY';
           update testAccount1;
           
           testAccount2 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount2.MD__c = 'MY';
           update testAccount2;
           
           
           //Create Case
           Case testCase1 = (Case)UtilTestData.createSobject(new Case(), UtilConstant.INQUIRY);
           testCase1.Case_Class__c = 'Complaint';
           testCase1.AccountId = testAccount1.Id;
           testCase1.MD__c = 'MY';
           update testCase1;
           
           Case testCase2 = (Case)UtilTestData.createSobject(new Case(), UtilConstant.INQUIRY);
           testCase2.Case_Class__c = 'Complaint';
           testCase2.AccountId = testAccount2.Id;
           testCase2.MD__c = 'MY';
           update testCase2;
           CaseTriggerHandlerMY TriggerCaseTriggerMY = new CaseTriggerHandlerMY();
           TriggerCaseTriggerMY.handleTrigger(true,true,true,true,true);
           
       }
       
    }
    
    static void createCaseToComputeDeadline(){
        List<String> priority = new List<String>{'A', 'B', 'C','D','E'};
        List<String> caseClass = new List<String>{UtilConstant.INQUIRY, UtilConstant.OTHERS, UtilConstant.COMPLAINT,UtilConstant.CLAIM,UtilConstant.REQUEST,UtilConstant.TOURING_SUPPORT,UtilConstant.FINANCE};
        List<Case> caseToInsert = new List<Case>();
        
        for(String case_class : caseClass){
            for (String p : priority){
                Case testCase1 = new Case(Case_Class__c = case_class, Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, Priority = p, MD__c = 'MY');
                caseToInsert.add(testCase1);
            }
        }              
        insert caseToInsert;      
    }
    
    
    public static testMethod void testComplaintAmountCaseInsert(){
        createCustomSetting();
        testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'MY';
           update testAccount1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Insert:' +acc);
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, MD__c = 'MY');
        insert testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Insert:' +acc);
        //system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseDelete(){
        createCustomSetting();
        
        testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'MY';
           update testAccount1;
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, MD__c = 'MY');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Delete :' +acc);
        
        delete testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Delete:' +acc);
        //system.assertEquals(1, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseUpdate(){
        createCustomSetting();
        
        testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'MY';
           update testAccount1;
           
            testAccount2 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount2.MD__c = 'MY';
           update testAccount2;
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'MY');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Update :' +acc);
        
        testCase1.AccountId = testAccount1.Id;
        update testCase1;
        
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Update:' +acc);
        //system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    
    public static testMethod void testComputeDeadline(){
        createCustomSetting();
        
        testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'MY';
           update testAccount1;
        
        createCaseToComputeDeadline();
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, Priority = 'A', MD__c = 'MY');
        insert testCase1;
               
        Case cs = [Select DeadLine__c from Case Where Id =: testCase1.Id];
        System.debug('Case Record...' +cs.DeadLine__c);
        Date todayDate = Date.today();
        
        //CaseDeadelineCalc__mdt caseDeadline = [Select CaseDeadelineCalc1__c FROM CaseDeadelineCalc__mdt WHERE QualifiedApiName ='Japan_Case_Deadlines'];
        //integer days = (Integer)caseDeadline.CaseDeadelineCalc1__c ;
        
        Date deadLineDate = todayDate.addDays(1);
        //system.assertEquals(todayDate,cs.DeadLine__c);
        
        List<Case> insertedCases = [Select DeadLine__c from Case Where DeadLine__c != null AND Id =: testCase1.Id];
        system.debug('Inserted Cases..' +insertedCases);
        for(Case c : insertedCases){
            system.assertEquals(c.DeadLine__c, deadLineDate);
        }
    } 
    public static testMethod void testupdateCase (){{

Account acc = New Account();
{
acc.Name = 'Sample Class';
insert acc;
}
Account ac = New Account();
{
ac.Name = 'Sample Class1';
insert ac;
}

Account a = New Account();
{
a.Name = 'Sample Class2';
insert a;
}

Case ca = New Case ();
{
ca.Subject = 'sample ';
ca.AccountId = acc.id;
ca.Status = 'Final Aprroval Done';
ca.Narrative_of_Type__c = 'Marketing Opt Out';

insert ca;
}


Case ca1 = New Case ();
{
ca1.Subject = 'sample 1';
ca1.AccountId = ac.id;
ca1.Status = 'Final Aprroval Done';
ca1.Narrative_of_Type__c = 'Magazine Opt Out';

insert ca1;
}

Case ca2 = New Case ();
{
ca2.Subject = 'sample 2';
ca2.AccountId = a.id;
ca2.Status = 'Final Aprroval Done';
ca2.Narrative_of_Type__c = 'Action';
insert ca2;
}

system.assertEquals('Magazine; Survey; MOT Car inspection; Gift; Campaign (Aftersales);Campaign (Finance);Campaign (New Car);Event (Aftersales);Event (New Car);Product Info (Aftersales);Product Info (Finance);Product Info (New Car);Fair','Magazine; Survey; MOT Car inspection; Gift; Campaign (Aftersales);Campaign (Finance);Campaign (New Car);Event (Aftersales);Event (New Car);Product Info (Aftersales);Product Info (Finance);Product Info (New Car);Fair' );

system.assertEquals('Magazine','Magazine');

//system.assertEquals(a.Opt_In_Contact_Reason__c,'Magazine; Survey; MOT Car inspection; Gift; Campaign (Aftersales);Campaign (Finance);Campaign (New Car);Event (Aftersales);Event (New Car);Product Info (Aftersales);Product Info (Finance);Product Info (New Car);Fair' );
}

}
       
}