/*
    Type:       test class
    Purpose:    RetailCampaignSegmentationController test class
    User Story: Release 1.2 Retail Campaign

    Used By:    RetailCampaignSegmentationController
    ---------------------------------------------------------------
    History:

    7-Jul-2014 Sinow    Created
*/
@isTest(seeAllData=true)
public class RetailCampaignSegmentationControllerTest {
    public static testMethod void testRetailCampaignSegmentationController(){  
   
        //User u = [select Id, ContactId from User where isActive = true and ContactId !=:null  limit 1];
        //TODO : Added portalUser in UtilTestData class
        User us=UtilTestData.createPortalUser('IB QC','CAC IB CSR');            
        User u = [select Id, ContactId from User where isActive = true and ContactId =:us.contactId  limit 1];
        Contact con = [select Id, SegmentationFilters__c from Contact where Id = :u.ContactId];
        con.SegmentationFilters__c = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"Filter Three", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"","bracket":false}]}}]';
        update con;
        
        system.runAs(u){
            String acc3rdPartyRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
            String segmentationRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Segmentation Only').getRecordTypeId();
            
            Account customer = new Account(Dealer_DMS_SR_Code__c='',
                                        Status__c='xCustomer',
                                        City_CN__c='Beijing',
                                        Phone = '80801010',
                                        Area_code__c = '010',
                                        Age_Range__c = '26-35',
                                        LastName = 'galaxy2',
                                        ZipCode__c='000000',
                                        Branch_name_CHS__c = '2014/06/05',
                                        File_Name__pc = 'C://User/folder',
                                        RecordTypeId=acc3rdPartyRTId);
            insert customer;
            Retail_Campaign__c rc = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId);
            insert rc;
            
            String filterString = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"Filter Three", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"","bracket":false}]}}]';
            
            PageReference retailCampaignSegmentation = Page.RetailCampaignSegmentation;
            retailCampaignSegmentation.getParameters().put('id',rc.id);
            Test.setCurrentPage(retailCampaignSegmentation);
            RetailCampaignSegmentationController extension = new RetailCampaignSegmentationController();
            
            List<String> filterOptions = extension.filterOptions;
            List<SelectOption> hobbyOptions = extension.hobbyOptions;
            List<SelectOption> leadDesiredServiceOptions = extension.leadDesiredServiceOptions;
            List<SelectOption> leadAdditionalServiceOptions = extension.leadAdditionalServiceOptions;
            
            RetailCampaignSegmentationController.saveFilter(filterString);
            extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"26-35","logic":"","bracket":false}]}}';
            extension.attendedCampaign = 'testCampaign';
            extension.searchAccount();
            extension.addToCampaign();
            List<Account> accountList = extension.getlimitAccounts();
        }
        
        RetailCampaignSegmentationController extension = new RetailCampaignSegmentationController();
        List<String> filterOptions = extension.filterOptions;
        extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"26-35","logic":"","bracket":false}]}}';
        extension.searchAccount();
    }
}