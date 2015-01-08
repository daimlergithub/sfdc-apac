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
    public static testMethod void testMedia01(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Approved', Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Delay_Reason__c  = 'test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testMedia02(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Approved', Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Delay_Reason__c  = 'test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testEvent01(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Confirmed', Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Delay_Reason__c  = 'test', Actual_Order__c = 100, Feedback_Comments__c = 'Test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testEvent02(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Confirmed', Driven__c = 'Dealer Driven', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Delay_Reason__c  = 'test', Actual_Order__c = 100, Feedback_Comments__c = 'Test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
        public static testMethod void testMediaJoint01(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String cpnRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media BMBS Campaign').getRecordTypeId();
        Campaign cpn = new Campaign(RecordTypeId = cpnRT, Name='TestCpn');
        insert cpn;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Name = 'TestCpn', Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Approved', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Relevant_BMBS_Campaign__c = cpn.Id, Delay_Reason__c  = 'test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testMediaJoint02(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String cpnRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media BMBS Campaign').getRecordTypeId();
        Campaign cpn = new Campaign(RecordTypeId = cpnRT, Name='TestCpn');
        insert cpn;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Media Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Name = 'TestCpn', Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Approved', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Relevant_BMBS_Campaign__c = cpn.Id, Delay_Reason__c  = 'test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testEventJoint01(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String cpnRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event BMBS Campaign').getRecordTypeId();
        Campaign cpn = new Campaign(RecordTypeId = cpnRT, Name='TestCpn');
        insert cpn;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Name = 'TestCpn', Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Confirmed', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Relevant_BMBS_Campaign__c = cpn.Id, Delay_Reason__c  = 'test', 
            Actual_Order__c = 100, Feedback_Comments__c = 'Test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testEventJoint02(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String cpnRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event BMBS Campaign').getRecordTypeId();
        Campaign cpn = new Campaign(RecordTypeId = cpnRT, Name='TestCpn');
        insert cpn;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Name = 'TestCpn', Dealer_Name__c = dealer.Id, 
            Apply_Status__c = 'Approved', Feedback_Status__c = 'Confirmed', Driven__c = 'Joint', 
            Actual_Start_Date__c = System.today().addDays(-10), Actual_End_Date__c = System.today().addDays(-5), 
            Plan_Start_Date__c = System.today().addDays(-10), Plan_End_Date__c = System.today().addDays(-5), 
            Plan_Expense__c = 5000, Actual_Expense__c = 8000, Brand__c = 'MB', Relevant_BMBS_Campaign__c = cpn.Id, Delay_Reason__c  = 'test', 
            Actual_Order__c = 100, Feedback_Comments__c = 'Test');
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
    
    public static testMethod void testYearlyTarget01(){
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(RecordTypeId = dealerType,  Name = 'test dealer', Branch_name_CHS__c = 'test chs dealer');
        insert dealer;
        
        String RT = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RT, Y_Dealer_Name__c = dealer.Id, Y_MB_Marketing_Budget__c = 10000, Y_Year__c = String.valueOf(System.today().Year()));
        insert rc;
        
        PageReference yearlyTAAchievementTracingReport = Page.YearlyTAAchievementTracingReport ;
        yearlyTAAchievementTracingReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(yearlyTAAchievementTracingReport);
        YearlyTAAchieTracingController extension = new YearlyTAAchieTracingController();
    }
}