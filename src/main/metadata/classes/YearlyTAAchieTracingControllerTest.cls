/*
    Type:       test class
    Purpose:    YearlyTAAchieTracingController test class
    User Story: Release 1.2 Report S&M R006

    Used By:    YearlyTAAchieTracingController 
    ---------------------------------------------------------------
    History:

    9-Jun-2014 Sinow    Created
*/
@isTest
public class YearlyTAAchieTracingControllerTest {

Private static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
Private static String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
Private static String SmEvent = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
Private static String cpnRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media Central Campaign').getRecordTypeId();
Private static String cpnRTEvent = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
Private static String RTSales= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
Private static Account dealer;
Private static Retail_Campaign__c rc;
Private static Retail_Campaign__c rcEvent;
Private static Campaign cpn;
Private static Campaign cpRTEvent;
Private static Retail_Campaign__c rcJoint;
Private static Retail_Campaign__c rcJointEventRT;
Private static Retail_Campaign__c rcSales;
Private static Retail_Campaign__c rcEventJoint;
Private static String id='id';
Private static String Approved='Approved';
Private static String MB='MB';
Private static String testcpn='testcpn';
Private static String tests='test';
Private static String currentYear= String.valueOf(Date.today().year());

    public static testMethod void testMedia01(){
    
        preparedTestData();
        Test.startTest();
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
        Test.stopTest();
        System.assert(rc.Dealer_Name__c!=null);
        system.assertNotEquals(null,rc.Actual_Expense__c);
        system.assertEquals(extension.currentYear,currentYear);
    }
    
      public static testMethod void testEvent01(){          
        preparedTestData();
        Test.startTest();
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put(id,rcEvent.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController Yt= new YearlyTAAchieTracingController();
        Test.stopTest();
        System.assert(rcEvent.Dealer_Name__c!=null);
         system.assertNotEquals(null,rc.Plan_Expense__c);
         system.assertEquals(Yt.currentYear,currentYear);
    }
        
     public static testMethod void testMediaJoint01(){
        preparedTestData();
        Test.startTest(); 
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put(id,rcJoint.id);
        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
        Test.stopTest();
        System.assert(rcJoint.Dealer_Name__c!=null);
        system.assertEquals(extension.currentYear,currentYear);
    }
        
    public static testMethod void testEventJoint01(){
        preparedTestData();
        Test.startTest();
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put(id,rcJointEventRT.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
        Test.stopTest();
        System.assert(rcJointEventRT.Dealer_Name__c!=null);
         system.assertEquals(extension.currentYear,currentYear);

    }
    
    
    public static testMethod void testEventJoint02(){
         preparedTestData();
        Test.startTest();       
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put(id,rcEventJoint.id);
        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
        Test.stopTest();
        System.assert(rcEventJoint.Dealer_Name__c!=null);
         system.assertEquals(extension.currentYear,currentYear);
    }
     public static void preparedTestData()
    {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name__c = 'test chs dealer');
        insert dealer;
        
            rc = new Retail_Campaign__c(RecordTypeId = RT, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = Approved, Feedback_Status__c = Approved, Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = MB, Delay_Reason__c  = tests);
            insert rc;
        
            rcEvent = new Retail_Campaign__c(RecordTypeId = SmEvent, Dealer_Name__c = dealer.Id, 
            Apply_Status__c =Approved, Feedback_Status__c = 'Confirmed', Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = MB, Delay_Reason__c  = tests, Actual_Order__c = 100, Feedback_Comments__c = tests);
            insert rcEvent;
        
            cpn = new Campaign(RecordTypeId = cpnRT, Name=TestCpn);
            insert cpn;
            
            cpRTEvent=new Campaign(RecordTypeId = cpnRTEvent, Name=TestCpn);
            insert cpRTEvent;
        
            rcJoint= new Retail_Campaign__c(RecordTypeId = RT, Name = TestCpn, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = Approved, Feedback_Status__c = Approved, Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = MB,Delay_Reason__c  = tests,Relevant_Central_Campaign__c=cpn.id);
            insert rcJoint;
            
            rcJointEventRT = new Retail_Campaign__c(RecordTypeId = RT, Name = TestCpn, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = Approved, Feedback_Status__c = 'Confirmed', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB',Delay_Reason__c  = tests, 
            Actual_Order__c = 100, Feedback_Comments__c = tests,Relevant_Central_Campaign__c=cpRTEvent.id);
            insert rcJointEventRT;           
                    
            rcSales = new Retail_Campaign__c(RecordTypeId = RTSales, Y_Dealer_Name__c = dealer.Id, Y_MB_Marketing_Budget__c = 10000, Y_Year__c = String.valueOf(System.today().Year()));
            insert rcSales;    
                                
            rcEventJoint= new Retail_Campaign__c(RecordTypeId = SmEvent, Name = TestCpn, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = Approved, Feedback_Status__c = 'Confirmed', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = MB,Delay_Reason__c  =tests, 
            Actual_Order__c = 100, Feedback_Comments__c = tests,Relevant_Central_Campaign__c=cpRTEvent.id);
            insert rcEventJoint;             
    }
}