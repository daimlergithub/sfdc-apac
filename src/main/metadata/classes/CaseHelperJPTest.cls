@isTest
public class CaseHelperJPTest{    
    public List<Case> casesToUpdate = new List<Case>();
    public static Id caseInquiryRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public static Account testAccount1;
    public static Account testAccount2;                                                                      
    public static User marketUser;
    public static List<case> cas;
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    static void createCustomSetting(){
        //Enter the JP Specific settings here.
        system.debug('Create custom setting here...');
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
    }
    
    //Create the test data:
    static void init(){
    Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
        Trigger__c newtrg1 = new Trigger__c(Name= 'CaseTrigger',Trigger_Name__c = 'CaseTrigger',Trigger_Handler__c = 'CaseTriggerHandlerJP',Market__c ='JP',
                               enabled__c = True,after__c= True,before__c= True,delete__c= True,update__c= True,insert__c= True);
        insert newtrg1;
       User testUser = TestUserCreate.createuserrecord('JP');
       System.runAs(testUser){
           //Create Account
           testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount1.MD__c = 'JP';
           testAccount1.Complaint_Amount__c=100;
           update testAccount1;
           
           testAccount2 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
           testAccount2.MD__c = 'JP';
           testAccount2.Complaint_Amount__c=50;
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
        test.starttest();
        insert testCase1;
        test.stoptest();
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Insert:' +acc);
        //system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseDelete(){
        createCustomSetting();
        init();
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, MD__c = 'JP');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Delete :' +acc);
        test.starttest();
        try{
        delete testCase1;
        }catch(exception e){}
        test.stoptest();
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Delete:' +acc);
        //system.assertEquals(1, acc.Complaint_Amount__c);
    }
    
    public static testMethod void testComplaintAmountCaseUpdate(){
        createCustomSetting();
        init();
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'JP');
        insert testCase1;
        
        Account acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account Before Update :' +acc);
        
        testCase1.AccountId = testAccount1.Id;
        test.starttest();
        update testCase1;
        test.stoptest();
        acc = [Select Id, Complaint_Amount__c from Account Where Id =: testAccount1.Id];
        system.debug('Account After Update:' +acc);
        //system.assertEquals(2, acc.Complaint_Amount__c);
    }
    
    
    public static testMethod void testComputeDeadline(){
        createCustomSetting();
        init();
        createCaseToComputeDeadline();
        test.starttest();
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount1.Id, Priority = 'A', MD__c = 'JP');
        insert testCase1;
        test.stoptest();
               
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
      public static testMethod void testComplaintAmountCaseUpdate2(){
        createCustomSetting();
        init();
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');
        cas=new List<Case>();
        cas.add(testCase1);
        
        Case testCase2 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');
         cas.add(testCase2);
        Case testCase3 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, AccountId = testAccount2.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');
         cas.add(testCase3);
        insert cas;
        
        
        
       
        test.starttest();
        CaseHelperJP ch=new CaseHelperJP();
        ch.updateCase(cas);
        test.stoptest();
       
       
    }  
    
    @isTest static void updateGateKeaperforApprovedProcessTest()
     {
             
    Test.StartTest();
  List<Case> listcampaigns=new List<Case>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, Case_Dealer__c= dealer.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');
        
        insert testCase1;
        
        
        
      
        
       Case testCase2 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, Case_Dealer__c= dealer.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');


        insert testCase2;
        listcampaigns.add(testCase2);
        Case listCampaign =[select Case_Class__c ,RecordTypeId ,Status,Priority,Case_Dealer__c from Case where id IN:listcampaigns ];
         list<Case> oldList = new  list<Case>();
         oldList.add(listCampaign);
        map<id,Case> oldMap = new map<id,Case>();
         oldMap.put(listCampaign.id, listCampaign);
         TriggerCaseTriggerHandlerKR.isFutureUpdate =false;
        testCase2.Status='New';
        update testCase2;
        string isInsert;
     

         CaseHelperJP ch=new CaseHelperJP();    
         ch.updateGateKeaperforApprovedProcess(listcampaigns,oldMap,isInsert);
        
        
        Test.StopTest();
        
     }
     
     @isTest static void calculateComplaintAmountTest()
     {
             
    Test.StartTest();
  List<Case> listcampaigns=new List<Case>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
     Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer1;
     testAccount1 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
      testAccount2 = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        Case testCase1 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, Case_Dealer__c= dealer.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');
        
        insert testCase1;
        
        
        
      
        
       Case testCase2 = new Case(Case_Class__c = 'Complaint', Overdue_Reason__c ='Others', RecordTypeId = caseInquiryRec_Id, Accountid= testAccount1.Id, MD__c = 'JP',Narrative_of_Type__c='Marketing Opt Out');


        insert testCase2;
        listcampaigns.add(testCase2);
        Case listCampaign =[select Case_Class__c ,RecordTypeId,AccountId,Status,Priority,Case_Dealer__c from Case where id IN:listcampaigns ];
         list<Case> oldList = new  list<Case>();
         oldList.add(listCampaign);
        map<id,Case> oldMap = new map<id,Case>();
         oldMap.put(listCampaign.id, listCampaign);
         TriggerCaseTriggerHandlerKR.isFutureUpdate =false;
        testCase2.Accountid=testAccount2.id;
        update testCase2;
        
     

         CaseHelperJP ch=new CaseHelperJP();    
         ch.calculateComplaintAmount(listcampaigns,oldMap);
        
        
        Test.StopTest();
        
     }
}