/*
    Type:       test class
    Purpose:    RetailCampaignSegmentationController test class
    User Story: Release 1.2 Retail Campaign
    Used By:    RetailCampaignSegmentationController
    7-Jul-2014 Sinow    Created
*/
@isTest
public Without Sharing class RetailCampaignSegmentation_TH_Test 
{
//Private Static List<String> filterOptions ;
 Private Static List<SelectOption> hobbyOptions ;
 Private Static List<SelectOption> leadDesiredServiceOptions ;
 Private Static  List<SelectOption> leadAdditionalServiceOptions ;
 Private Static  List<SelectOption> leadClassOptions;
 Private Static  List<SelectOption> VehicleClassOptions;
 Private Static  List<SelectOption> SpecialMarkonAccount;
 Private Static  List<SelectOption> RetailTaskStatus;
 Private Static  List<SelectOption> RetailTaskType;
 Private Static  List<SelectOption> DealerLeadStatus;
 Private Static  List<SelectOption> InterestModel;
 Private Static  List<SelectOption> Occupation;
 Private Static  List<SelectOption> provincemodel;
 Private Static  List<SelectOption> RetailProductName;
 Private Static  List<SelectOption> RetailFinanceProductName;
 Private Static  List<SelectOption> Customerphase;
 Private Static  List<SelectOption> RetailOptOutContactReason;
 Private Static  List<SelectOption> status;
 Private Static  List<SelectOption> RetailSalesSanction;
Private Static Retail_Campaign__c rc;
Private Static  List<SelectOption> getItems;
 Private Static List<SelectOption> gender;
 Private Static List<SelectOption> personalAgreement;
 Private Static List<SelectOption> hobbies;
 Private Static List<SelectOption> idType;

        Private Static Account account;
        Private Static Lead__c lead;
        Private Static Vehicle__c vehicle;
        Private Static Vehicle_Relationship__c vehicleRel;
        Private Static Account_Link__c AlkRec;
        Private Static Retail_Task__c RatilTask;
        Private Static Address__c  address;
        Private Static campaign_member__C camMem;
        Private Static recall__C recall;
      

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
            con.SegmentationFilters__c = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"Filter Three", "content":{"Customer":[{"field":"Age_Range__c","operation":"Equals","criteria":"17-25","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"Unknown","logic":"AND","bracket":false},{"field":"Age_Range__c","operation":"Equals","criteria":"Unknown","logic":"","bracket":false}]}}]';
            update con;
            
            system.runAs(u){
                String acc3rdPartyRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                String segmentationRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Segmentation Only').getRecordTypeId();
                String segmentationRTId1 = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
                
                Account customer = new Account(Dealer_DMS_SR_Code__c='',Status__c='xCustomer',City__c='Beijing',phone = '1344444', PersonOtherPhone='0231456987',PersonHomePhone='0231456989',PersonMobilePhone='0231456439',
                                             Retail_Fax__c='0237456989',Retail_Home_Phone__c='0281456989', Retail_Mobile__c='0231456949', Retail_Work_Phone__c='0231056989',Area_code__c = '010',Occupation__c='Office Staff',
                                            LastName = 'galaxy2', ZipCode__c='000000',Branch_name__c = '2014/06/05', File_Name__pc = 'C://User/folder',RecordTypeId=acc3rdPartyRTId);
                insert customer;
              
                 Retail_Campaign__c rcobj1=new Retail_Campaign__c();
                 rcobj1.Name='Test Campaign1';
                 rcobj1.Status__c='Draft';
                 rcobj1.Execution_Start_Date__c=system.today()+1;
                 rcobj1.Segmentation_Date__c=system.today();
                 rcobj1.Segmentation_Base__c='Customer';
                 rcobj1.Execution_Type__c='eMail';
                 rcobj1.Campaign_Type__c='sales';
                 rcobj1.RecordTypeId=segmentationRTId1;
                 insert rcobj1;
                 rc = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId ,Campaign_Execution_Channels__c ='DM',Segmentation_Base__c='Customer',Parent_Campaign1__c=rcobj1.id);
                insert rc;
                
                String filterString = '[{"name":"Filter One", "content":{"Customer":[{"field":"PersonBirthdate","operation":"Equals","criteria":"11","logic":"AND","bracket":false},{"field":"Occupation__c","operation":"Equals","criteria":"Office Staff","logic":"","bracket":false},{"field":"PersonEmail","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Retail_Interested_Vehicle_Class__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Retail_Interested_Vehicle_Class__c","operation":"Not Equals","criteria":"33","logic":"","bracket":false}]}},{"name":"filter two", "content":{"Customer":[{"field":"FileName__c","operation":"Less Than","criteria":"11","logic":"AND","bracket":false},{"field":"Hobby__c","operation":"Not Equals","criteria":"22","logic":"","bracket":false}],"Interest":[{"field":"Lead_Source__c","operation":"Greater Than","criteria":"44","logic":"AND","bracket":false},{"field":"Lead_Type__c","operation":"Greater Than","criteria":"33","logic":"","bracket":false}],"Vehicle":[{"field":"Baumuster__c","operation":"Equals","criteria":"11","logic":"AND","bracket":true},{"field":"Baumuster__c","operation":"Not Equals","criteria":"22","logic":"AND","bracket":false},{"field":"Baumuster__c","operation":"Equals","criteria":"33","logic":"","bracket":false}]}}]';
                
                PageReference retailCampaignSegmentation = Page.RetailCampaignSegmentation_TH;
                retailCampaignSegmentation.getParameters().put('id',rc.id);
                Test.setCurrentPage(retailCampaignSegmentation);
                RetailCampaignSegmentationController_TH extension = new RetailCampaignSegmentationController_TH();
                
                 //filterOptions = extension.filterOptions;
                // hobbyOptions = extension.hobbyOptions;
                // leadDesiredServiceOptions = extension.leadDesiredServiceOptions;
               // leadAdditionalServiceOptions = extension.leadAdditionalServiceOptions;                
                //leadClassOptions=extension.leadClassOptions;
                //RetailSalesSanction =extension.RetailSalesSanction;
                getItems =extension.getItems();
                
                //VehicleClassOptions=extension.VehicleClassOptions;
                SpecialMarkonAccount = extension.SpecialMarkonAccount;
                //RetailTaskType=extension.RetailTaskType;
                //RetailTaskStatus=extension.RetailTaskStatus;
                DealerLeadStatus=extension.DealerLeadStatus;
                InterestModel=extension.InterestModel;
                Occupation=extension.Occupation;
                provincemodel=extension.provincemodel;
                //RetailProductName=extension.RetailProductName;
                //RetailFinanceProductName=extension.RetailFinanceProductName;
                Customerphase = extension.Customerphase;
                RetailOptOutContactReason = extension.RetailOptOutContactReason;
                status = extension.status;
                gender = extension.gender;
                personalAgreement = extension.personalAgreement;
                hobbies = extension.hobbies;
                idType = extension.idType;
                
                account = extension.account;
                lead = extension.lead;
                vehicle = extension.vehicle;
                vehicleRel = extension.vehicleRel;
                AlkRec = extension.AlkRec;
                //RatilTask = extension.RatilTask;
                address = extension.address;
                camMem = extension.camMem;
                recall = extension.recall;
                RetailCampaignSegmentationController_TH.wrapperAccount wrp = new RetailCampaignSegmentationController_TH.wrapperAccount();
                vehicleRel = wrp.veh;
                RatilTask = wrp.retail;
                recall = wrp.recall;
                AlkRec = wrp.accLink;
                
                extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Occupation__c","operation":"Equals","criteria":"Office Staff","logic":"","bracket":false}]}}';
              
                
                RetailCampaignSegmentationController_TH.wrapperAccount wrAcc=new RetailCampaignSegmentationController_TH.wrapperAccount();
                wrAcc.isSelected=true;
                wrAcc.acc=customer;
                
                RetailCampaignSegmentationController_TH.wrapperAccount wrVeh=new RetailCampaignSegmentationController_TH.wrapperAccount();
                wrVeh.isSelected=true;
                wrVeh.acc=customer;
                
                List<RetailCampaignSegmentationController_TH.wrapperAccount> wrapperListObj=new List<RetailCampaignSegmentationController_TH.wrapperAccount>();
                wrapperListObj.add(wrAcc);
                extension.wrapperList=wrapperListObj;
               
                extension.searchAccount();
                extension.addToCampaign();
                extension.getloadwrapAccountList();
                 
                 extension.selectedValue = 'Outlet';
                 extension.hasnext = True;
                 extension.hasPrevious= True;  
                 extension.first();
                 extension.last();
                 extension.next();
                 extension.previous();
                //extension.leadSoql ='Select id,Retail_Campaign_Name__c from Lead__C ';
               extension.jsonFilter = '{"name":"filterName", "content":{"VehicleRelation":[{"field":"Customer_Type__c","operation":"Equals","criteria":"Demo Car","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.getloadwrapAccountList();
               extension.jsonFilter = '{"name":"filterName", "content":{"Interest":[{"field":"Dealer_Lead_Status__c","operation":"Equals","criteria":"Order Placed","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.segmentationBase = 'Customer';
               extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Occupation__c","operation":"Equals","criteria":"Doctor","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.getloadwrapAccountList();
               extension.jsonFilter = '{"name":"filterName", "content":{"AccountLink":[{"field":"Retail_Sales_Sanction__c","operation":"Equals","criteria":"C","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.segmentationBase = 'Vehicle';
               extension.jsonFilter = '{"name":"filterName", "content":{"Vehicle":[{"field":"FirstRegistrationDate__c","operation":"Equals","criteria":"10/18/2017","logic":"","bracket":false}]}}';
               extension.searchAccount();
               //extension.getloadwrapAccountList();
               extension.jsonFilter = '{"name":"filterName", "content":{"Campaign":[{"field":"Status__c","operation":"Equals","criteria":"Ready","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.addToCampaign();
               //extension.getloadwrapAccountList();
               //extension.wrapperAccount wp = new extension.wrapperAccount();
               extension.jsonFilter = '{"name":"filterName", "content":{"Address":[{"field":"ZipCode__c","operation":"Equals","criteria":"106167","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.jsonFilter = '{"name":"filterName", "content":{"VehicleRetailcopy":[{"field":"NextInspectionDate__c","operation":"Equals","criteria":"10/20/2017","logic":"","bracket":false}]}}';
               extension.searchAccount();
               extension.jsonFilter = '{"name":"filterName", "content":{"VehicleRelation":[{"field":"New_Used__c","operation":"Equals","criteria":"New","logic":"","bracket":false}]}}';
               extension.searchAccount();
            try{
               // RetailCampaignSegmentationController.deleteFilter(filtername);
                }catch(Exception e){}
               // extension.getlimitAccounts();
        
            }
            
            RetailCampaignSegmentationController_TH extension = new RetailCampaignSegmentationController_TH();
            string query='select id,name from account limit 1';
            RetailCampaignSegmentationController_TH.saveCriteriaa('hello',query);
             //filterOptions = extension.filterOptions;
            extension.jsonFilter = '{"name":"filterName", "content":{"Customer":[{"field":"Occupation__c","operation":"Equals","criteria":"Office Staff","logic":"","bracket":false}]}}';
            
            extension.searchAccount();
            extension.getSelectedRecords();
       }
       else
       {
            Test.starttest();
            PageReference retailCampaignSegmentation = Page.RetailCampaignSegmentation_TH;
            retailCampaignSegmentation.getParameters().put('id',rc.id);
                Test.setCurrentPage(retailCampaignSegmentation);
            RetailCampaignSegmentationController_TH extension = new RetailCampaignSegmentationController_TH();
            extension.searchAccount();
            extension.addToCampaign();
           // extension.getlimitAccounts();
            Test.stoptest();
           
            
       }
    }
}