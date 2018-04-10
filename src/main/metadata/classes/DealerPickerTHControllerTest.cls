@isTest
public class DealerPickerTHControllerTest {
    public static User user1 = TestUtils.createAdminUser();
    public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Account accobj;
    public static Retail_Campaign__c  rcobj1;
    public static Campaign_Member__c cmr;
    public static Group grp;
    
    public static void createTestdata(){
        accobj =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='010-9885-7857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert accobj;
        Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
        scb.Name = 'sample';
        insert scb ;
        Campaign parentCamp=new Campaign(Name='test par',EndDate=System.Today()+10,StartDate=System.Today(),Segmentation_Date__c=system.today(),RecordtypeID=parentCampaign_RecordTypeID,Status='Responded');
        insert parentCamp;
        rcobj1=new Retail_Campaign__c(Relevant_Central_Campaign__c = parentCamp.id,IsAutoSegmentationExecuted__c = false,Segmentation_Criteria__c = scb.id,Auto_Segmentation__c = true,RecordTypeId=camIdExec,Execution_Type__c='eMail',Segmentation_Date__c=system.today(),Execution_Start_Date__c=system.today()+1,Name='Test Campaign1',Child_Campaign_Status__c='Segmentation',Status__c='Draft',Close_Date__c=system.today()+1);
        insert rcobj1;
        grp = new Group(Name='TH12345');
        insert grp;
    }
    
    public static testmethod void testCancel(){
        System.runAs(user1){
            test.startTest();
            createTestdata();
            ApexPages.currentPage().getParameters().put('CampaignId',rcobj1.Id);
            ApexPages.StandardController objSc = new ApexPages.StandardController(rcobj1);
            DealerPickerTHController dpTHc=new DealerPickerTHController();
            dpThc.shareRetailcampaignRecords();
            DealerPickerTHController.ThailandDealersList tdl= new DealerPickerTHController.ThailandDealersList(accobj);
            tdl.isselected=true;
            dpTHc.dealersListThailand.add(tdl);    
            dpThc.SharetoDealers();
            
            dpThc.cancel();
            dpThc.showPopup();
            dpThc.cancelURLS();
            
            Test.stopTest();
        }
    }
    
}