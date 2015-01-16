/*
    Type:       test class
    Purpose:    EventToolKitQuotaReportController test class
    User Story: Release 1.2 Report S&M R007

    Used By:    EventToolKitQuotaReportController
    ---------------------------------------------------------------
    History:

    10-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class EventToolKitQuotaReportControllerTest {
    public static testMethod void testEventToolKitQuotaReportController(){
        
        String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332111';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = DealerRecordtypeid;
        dealer.Dealer_LMS__c = 'No';
        dealer.Allow_Data_Sharing__c = 'Yes';
        dealer.Province__c = 'jiangsu';
        dealer.City_CN__c = 'nanjing';
        dealer.Preferred_Language__c = 'English';
        dealer.Dealer_LMS__c = 'No';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
        insert dealer;
        
        Account dealer2 = new Account();
        dealer2.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer2.Phone = '12332111';
        dealer2.Dealer_GC_Code__c = 'gc code';
        dealer2.Dealer_GS_Code__c = 'gs code';
        dealer2.Name = 'test dealer';
        dealer2.RecordTypeId = DealerRecordtypeid;
        dealer2.Dealer_LMS__c = 'No';
        dealer2.Allow_Data_Sharing__c = 'Yes';
        dealer2.Province__c = 'jiangsu';
        dealer2.City_CN__c = 'nanjing';
        dealer2.Preferred_Language__c = 'English';
        dealer2.Dealer_LMS__c = 'No';
        dealer2.Gender__c = '0=Male';
        dealer2.ZipCode__c = '200235';
        dealer2.Type = '0=Company';
        dealer2.Status__c = '0=contac1';
        dealer2.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer2.Dealer_Region__c = 'WEST';
        insert dealer2;
        
        Account dealer3 = new Account();
        dealer3.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer3.Phone = '12332111';
        dealer3.Dealer_GC_Code__c = 'gc code';
        dealer3.Dealer_GS_Code__c = 'gs code';
        dealer3.Name = 'test dealer';
        dealer3.RecordTypeId = DealerRecordtypeid;
        dealer3.Dealer_LMS__c = 'No';
        dealer3.Allow_Data_Sharing__c = 'Yes';
        dealer3.Province__c = 'jiangsu';
        dealer3.City_CN__c = 'nanjing';
        dealer3.Preferred_Language__c = 'English';
        dealer3.Dealer_LMS__c = 'No';
        dealer3.Gender__c = '0=Male';
        dealer3.ZipCode__c = '200235';
        dealer3.Type = '0=Company';
        dealer3.Status__c = '0=contac1';
        dealer3.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer3.Dealer_Region__c = 'NORTH';
        insert dealer3;
        
        Account dealer4 = new Account();
        dealer4.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer4.Phone = '12332111';
        dealer4.Dealer_GC_Code__c = 'gc code';
        dealer4.Dealer_GS_Code__c = 'gs code';
        dealer4.Name = 'test dealer';
        dealer4.RecordTypeId = DealerRecordtypeid;
        dealer4.Dealer_LMS__c = 'No';
        dealer4.Allow_Data_Sharing__c = 'Yes';
        dealer4.Province__c = 'jiangsu';
        dealer4.City_CN__c = 'nanjing';
        dealer4.Preferred_Language__c = 'English';
        dealer4.Dealer_LMS__c = 'No';
        dealer4.Gender__c = '0=Male';
        dealer4.ZipCode__c = '200235';
        dealer4.Type = '0=Company';
        dealer4.Status__c = '0=contac1';
        dealer4.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer4.Dealer_Region__c = 'SOUTH';
        insert dealer4;
        
        Date Q1StartDate = Date.newInstance(Date.Today().year(), 1, 1);
        Date Q2StartDate = Date.newInstance(Date.Today().year(), 4, 1);
        Date Q3StartDate = Date.newInstance(Date.Today().year(), 7, 1);
        Date Q4StartDate = Date.newInstance(Date.Today().year(), 10, 1);
        Id tkTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
        
        List<Tool_Kit__c> ToolKits = new List<Tool_Kit__c>();
        Tool_Kit__c toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer.Id, Dealer_Region__c = dealer.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q1StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer.Id, Dealer_Region__c = dealer.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q2StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer.Id, Dealer_Region__c = dealer.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q3StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer.Id, Dealer_Region__c = dealer.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q4StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer2.Id, Dealer_Region__c = dealer2.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q1StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo =  new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer2.Id, Dealer_Region__c = dealer2.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q2StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer2.Id, Dealer_Region__c = dealer2.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q3StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer2.Id, Dealer_Region__c = dealer2.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q4StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer3.Id, Dealer_Region__c = dealer3.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q1StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer3.Id, Dealer_Region__c = dealer3.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q2StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer3.Id, Dealer_Region__c = dealer3.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q3StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer3.Id, Dealer_Region__c = dealer3.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q4StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer4.Id, Dealer_Region__c = dealer4.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q1StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer4.Id, Dealer_Region__c = dealer4.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q2StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer4.Id, Dealer_Region__c = dealer4.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q3StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        toolkitInfo = new Tool_Kit__c(recordTypeId = tkTypeId, Dealer_Name__c = dealer4.Id, Dealer_Region__c = dealer4.Dealer_Region__c, Brand__c = 'MB', Apply_Status__c = 'Approved', Submit_Date__c = Q4StartDate, Ad_Size_Height__c = 1, Ad_Size_Width__c = 1, Bleed_Size_Height__c = 1, Bleed_Size_Width__c = 1);
        ToolKits.add(toolkitInfo);
        insert ToolKits;
        
        EventToolKitQuotaReportController extension = new EventToolKitQuotaReportController();
    }
}