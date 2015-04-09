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
    public static testMethod void testYearlyTAReportController(){
        String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId);
        insert rc;
        
        PageReference YearlyTAReport = Page.Yearly_TA_Report;
        YearlyTAReport.getParameters().put('id',rc.id);

        Test.setCurrentPage(YearlyTAReport);
        
        YearlyTAReportController extension = new YearlyTAReportController();
    }
}