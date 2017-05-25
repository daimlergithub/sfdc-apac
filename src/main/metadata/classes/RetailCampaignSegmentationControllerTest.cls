/*
    Type:       test class
    Purpose:    RetailCampaignSegmentationController test class
    User Story: Release 1.2 Retail Campaign
    Used By:    RetailCampaignSegmentationController
    7-Jul-2014 Sinow    Created
*/
@isTest 
public Without Sharing class RetailCampaignSegmentationControllerTest 
{
//Private Static List<String> filterOptions ;
 Private Static List<SelectOption> hobbyOptions ;
 Private Static List<SelectOption> leadDesiredServiceOptions ;
 Private Static  List<SelectOption> leadAdditionalServiceOptions ;
 Private Static  List<SelectOption> leadClassOptions;
 Private Static  List<SelectOption> VehicleClassOptions;
 Private Static  List<SelectOption> SpecialMarkonAccount;
 Private Static  List<SelectOption> Customerphase;
 Private Static  List<SelectOption> RetailOptOutContactReason;
 Private Static  List<SelectOption> status;
 Private Static  List<SelectOption> RetailSalesSanction;
Private Static Retail_Campaign__c rc;
Private Static  List<SelectOption> getItems;
    public static String filtername = 'Name';
 
    public static testMethod void testRetailCampaignSegmentationController()
    {
     Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.Enable__c=true;
        cls.name='Community Enabled';
        insert cls;
       //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
       {    
           User u= UtilTestData.createPortalUser('Dealer User','Dealer Community User');
           Contact con = new Contact();
            con.Title = 'Title';
            //con.Id = u.ContactId;
            con.LastName = 'LastName';
            insert con;
            //Contact con = 
            //[select Id, SegmentationFilters__c from Contact where Id = :u.ContactId];
            con.SegmentationFilters__c = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"Filter Three", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"","bracket":false}]}}]';
            update con;
            
            system.runAs(u){
                String acc3rdPartyRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                String segmentationRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Segmentation Only').getRecordTypeId();
                
                Account customer = new Account(Dealer_DMS_SR_Code__c='',Status__c='xCustomer',City__c='Beijing',phone = '1344444', PersonOtherPhone='0231456987',PersonHomePhone='0231456989',PersonMobilePhone='0231456439',
                                             Retail_Fax__c='0237456989',Retail_Home_Phone__c='0281456989', Retail_Mobile__c='0231456949', Retail_Work_Phone__c='0231056989',Area_code__c = '010',Age_Range__c = '26-35',
                                            LastName = 'galaxy2', ZipCode__c='000000',Branch_name__c = '2014/06/05', File_Name__pc = 'C://User/folder',RecordTypeId=acc3rdPartyRTId);
                insert customer;
                 rc = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId ,Campaign_Execution_Channels__c ='DM' );
                insert rc;
                
                String filterString = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"Filter Three", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"11","logic":"","bracket":false}]}}]';
                
                PageReference retailCampaignSegmentation = Page.RetailCampaignSegmentation;
                retailCampaignSegmentation.getParameters().put('id',rc.id);
                Test.setCurrentPage(retailCampaignSegmentation);
                RetailCampaignSegmentationController extension = new RetailCampaignSegmentationController();
                
                 //filterOptions = extension.filterOptions;
                // hobbyOptions = extension.hobbyOptions;
                // leadDesiredServiceOptions = extension.leadDesiredServiceOptions;
               // leadAdditionalServiceOptions = extension.leadAdditionalServiceOptions;                
                //leadClassOptions=extension.leadClassOptions;
                RetailSalesSanction =extension.RetailSalesSanction;
                getItems =extension.getItems();
                //VehicleClassOptions=extension.VehicleClassOptions;
                SpecialMarkonAccount = extension.SpecialMarkonAccount;
                Customerphase = extension.Customerphase;
                RetailOptOutContactReason = extension.RetailOptOutContactReason;
                status = extension.status;
                //RetailCampaignSegmentationController.saveFilter(filterString);
                extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"26-35","logic":"","bracket":false}]}}';
               // extension.attendedCampaign = 'testCampaign';
                extension.searchAccount();
                extension.addToCampaign();
                //extension.getCountries();
                extension.first();
                 extension.last();
                 extension.previous();
                 extension.next();
                 extension.hasnext = True;
                 extension.hasPrevious= True;                
                //extension.leadSoql ='Select id,Retail_Campaign_Name__c from Lead__C ';
            try{
               // RetailCampaignSegmentationController.deleteFilter(filtername);
                }catch(Exception e){}
               // extension.getlimitAccounts();
        
            }
            
            RetailCampaignSegmentationController extension = new RetailCampaignSegmentationController();
             //filterOptions = extension.filterOptions;
            extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"26-35","logic":"","bracket":false}]}}';
            extension.searchAccount();
       }
       else
       {
            Test.starttest();
            PageReference retailCampaignSegmentation = Page.RetailCampaignSegmentation;
            retailCampaignSegmentation.getParameters().put('id',rc.id);
                Test.setCurrentPage(retailCampaignSegmentation);
            RetailCampaignSegmentationController extension = new RetailCampaignSegmentationController();
            extension.searchAccount();
            extension.addToCampaign();
           // extension.getlimitAccounts();
            Test.stoptest();
           
            
       }
    }
}