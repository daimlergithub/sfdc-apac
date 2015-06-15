/*
    Type:       test class
    Purpose:    YearlyTAReportController test class
    User Story: Release 1.2 Report S&M R006

    Used By:    YearlyTAReportController
    ---------------------------------------------------------------
    History:

    9-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class YearlyTAReportControllerTest {

Private Static Retail_Campaign__c rc;
Private Static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();

    public static testMethod void testYearlyTAReportController(){
       preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Joint';
        YearlyTA.M_ATL_BTL__c ='Media Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_Brand__c,'MB + StarElite');
        System.assertEquals(YearlyTA.M_KPI_Type__c,'Marketing Budget');
    }
    public static testMethod void testYearlyTAJointEventPlan(){
      
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Joint';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_Brand__c,'MB + StarElite');
        System.assertEquals(YearlyTA.M_ATL_BTL__c,'Event Plan');
    }
    
    public static testMethod void testYearlyTAReportControllerelse(){
      
        preparedTestData();                  
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Media Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.Driven__c,'Dealer Driven');
    }
     public static testMethod void testYearlyTAReportControllerelseEventPlan(){
       
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_ATL_BTL__c ,'Event Plan');
    }
     public static testMethod void testYearlyKPITypeNewLead(){
       
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='New Lead';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_KPI_Type__c,'New Lead');
    }
     public static testMethod void testYearlyKPITypeNewOrder(){
        
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='MB + StarElite';
        YearlyTA.M_KPI_Type__c='New Order';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();        
        System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_KPI_Type__c,'New Order');
    }
    
    public static testMethod void testYearlyBrandsmart(){
        preparedTestData();    
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='smart';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Joint';
        YearlyTA.M_ATL_BTL__c ='Media Plan';
        YearlyTA.M_YearlyTA__c=rc.id;        
        Test.startTest();
        insert YearlyTA;                
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'smart');
    }
     public static testMethod void testYearlyBrandAMG(){
     
        preparedTestData();
        
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='AMG';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Joint';
        YearlyTA.M_ATL_BTL__c ='Media Plan';
        YearlyTA.M_YearlyTA__c=rc.id;        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'AMG');
    }
    
     public static testMethod void testYearlyTAAMGEventPlan(){
       
       
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='AMG';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;  
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'AMG');
    }
     public static testMethod void testYearlyTAsmartEventPlan(){
        
       preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='smart';
        YearlyTA.M_KPI_Type__c='Marketing Budget';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'smart');
    }
     public static testMethod void testYearlyTAsmartNewLead(){
      preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='smart';
        YearlyTA.M_KPI_Type__c='New Lead';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'smart');
    }
    public static testMethod void testYearlyTAsmartNewOrder(){
    preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='smart';
        YearlyTA.M_KPI_Type__c='New Order';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        
        Test.startTest();
        insert YearlyTA;                
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'smart');
    }
    public static testMethod void testYearlyTAAMGNewOrder(){
    
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='AMG';
        YearlyTA.M_KPI_Type__c='New Order';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.M_Brand__c,'AMG');
    }
    public static testMethod void testYearlyTAAMGNewLead(){
    
        preparedTestData();
        Retail_Campaign__c YearlyTA= new Retail_Campaign__c();
        YearlyTA.RecordTypeId = RTId;
        YearlyTA.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        YearlyTA.Y_MB_Joint_Marketing_Budget__c=3;
        YearlyTA.Y_MB_Marketing_Budget__c=4;
        YearlyTA.Y_MB_Marketing_Expense__c=5;
        YearlyTA.Y_SMART_Marketing_Budget__c=6;
        YearlyTA.Y_SMART_Marketing_Expense__c=7;
        YearlyTA.Y_AMG_Marketing_Budget__c=8;
        YearlyTA.Y_AMG_Marketing_Expense__c=9;
        YearlyTA.M_Brand__c='AMG';
        YearlyTA.M_KPI_Type__c='New Lead';
        YearlyTA.Driven__c ='Dealer Driven';
        YearlyTA.M_ATL_BTL__c ='Event Plan';
        YearlyTA.M_YearlyTA__c=rc.id;
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        YearlyTAReportController extension = new YearlyTAReportController();
        Test.stopTest();
       System.assertEquals(rc.M_ATL_BTL__c ,'Media Plan');
        System.assertEquals(YearlyTA.Driven__c ,'Dealer Driven');
    }
    public static void preparedTestData()
    {
     rc = new Retail_Campaign__c();
        rc.RecordTypeId = RTId;
        rc.Y_MB_Dealer_Driven_Marketing_Budget__c=2;
        rc.Y_MB_Joint_Marketing_Budget__c=3;
        rc.Y_MB_Marketing_Budget__c=4;
        rc.Y_MB_Marketing_Expense__c=5;
        rc.Y_SMART_Marketing_Budget__c=6;
        rc.Y_SMART_Marketing_Expense__c=7;
        rc.Y_AMG_Marketing_Budget__c=8;
        rc.Y_AMG_Marketing_Expense__c=9;
        rc.M_Brand__c='MB + StarElite';
        rc.M_KPI_Type__c='Marketing Budget';
        rc.Driven__c ='Joint';
        rc.M_ATL_BTL__c ='Media Plan';
        
        insert rc;
        
    }
   }