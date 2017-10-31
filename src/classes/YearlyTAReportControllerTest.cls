/*
    Type:       test class
    Purpose:    YearlyTAReportController test class
    User Story: Release 1.2 Report S&M R006
    Used By:    YearlyTAReportController
    9-Jun-2014 Sinow    Created
*/
@isTest
public with sharing class YearlyTAReportControllerTest {

Private Static Retail_Campaign__c rc;
Private Static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
Private Static String mbsatrelite='mb + starelite';
Private Static String marketingbudget='marketing budget';
Private Static String joint='joint';
Private Static String mediaplan='media plan';
Private Static String id='id';
Private Static String eventplan='event plan';
Private Static String dealerdriven='dealer driven';
Private Static String newlead='new lead';
Private Static String neworder='new order';
Private Static String smart='smart';
Private Static String amg='amg';
Private Static YearlyTAReportController extension;

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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =joint;
        YearlyTA.M_ATL_BTL__c =mediaplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_Brand__c,'mbsatrelite');
        System.assertEquals(YearlyTA.M_KPI_Type__c,marketingbudget);
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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =joint;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(YearlyTA.M_ATL_BTL__c,eventplan);
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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =mediaplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.Driven__c,dealerdriven);
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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
		YearlyTA.Campaign_Execution_Channels__c='DM';
         
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_ATL_BTL__c ,eventplan);
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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=newlead;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
         
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_KPI_Type__c,newlead);
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
        YearlyTA.M_Brand__c=mbsatrelite;
        YearlyTA.M_KPI_Type__c=neworder;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
         
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();        
        System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_KPI_Type__c,neworder);
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
        YearlyTA.M_Brand__c=smart;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =joint;
        YearlyTA.M_ATL_BTL__c =mediaplan;
        YearlyTA.M_YearlyTA__c=rc.id;
         YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;                
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,smart);
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
        YearlyTA.M_Brand__c=amg;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =joint;
        YearlyTA.M_ATL_BTL__c =mediaplan;
        YearlyTA.M_YearlyTA__c=rc.id;
         YearlyTA.Campaign_Execution_Channels__c='DM';
         
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,amg);
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
        YearlyTA.M_Brand__c=amg;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
         YearlyTA.Campaign_Execution_Channels__c='DM';
         
        Test.startTest();
        insert YearlyTA;    
         PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,amg);
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
        YearlyTA.M_Brand__c=smart;
        YearlyTA.M_KPI_Type__c=marketingbudget;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
         YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
          System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,smart);
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
        YearlyTA.M_Brand__c=smart;
        YearlyTA.M_KPI_Type__c=newlead;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,smart);
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
        YearlyTA.M_Brand__c=smart;
        YearlyTA.M_KPI_Type__c=neworder;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM'; 
        
        Test.startTest();
        insert YearlyTA;                
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,smart);
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
        YearlyTA.M_Brand__c=amg;
        YearlyTA.M_KPI_Type__c=neworder;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
         System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.M_Brand__c,amg);
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
        YearlyTA.M_Brand__c=amg;
        YearlyTA.M_KPI_Type__c=newlead;
        YearlyTA.Driven__c =dealerdriven;
        YearlyTA.M_ATL_BTL__c =eventplan;
        YearlyTA.M_YearlyTA__c=rc.id;
        YearlyTA.Campaign_Execution_Channels__c='DM';
        
        Test.startTest();
        insert YearlyTA;        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put(id,rc.id);
        Test.setCurrentPage(YearlyTAReport);        
        extension = new YearlyTAReportController();
        Test.stopTest();
        System.assertEquals(rc.M_ATL_BTL__c ,mediaplan);
        System.assertEquals(YearlyTA.Driven__c ,dealerdriven);
        system.assertNotEquals(null,extension);
    }
   
    

    public static void preparedTestData()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
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
        rc.M_Brand__c='mbsatrelite';
        rc.M_KPI_Type__c=marketingbudget;
        rc.Driven__c =joint;
        rc.M_ATL_BTL__c =mediaplan;
        rc.Campaign_Execution_Channels__c='DM';
        
        insert rc;
        
    }
   }