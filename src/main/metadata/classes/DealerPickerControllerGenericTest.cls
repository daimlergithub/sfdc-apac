@isTest
public class DealerPickerControllerGenericTest{
    public static User user1 = TestUtils.createAdminUser();
    public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Account accobj;
    public static Retail_Campaign__c  rcobj1;
    public static Campaign_Member__c cmr;
    public static Group grp;
    public static void createTestdata(){
        accobj =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='MY',Individual_Home_Phone__c='6086057857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert accobj;
        Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
        scb.Name = 'sample';
        insert scb ;
        Campaign parentCamp=new Campaign(Name='test par',EndDate=System.Today()+10,StartDate=System.Today(),Segmentation_Date__c=system.today(),RecordtypeID=parentCampaign_RecordTypeID,Status='Responded');
        insert parentCamp;
        rcobj1=new Retail_Campaign__c(Relevant_Central_Campaign__c = parentCamp.id,IsAutoSegmentationExecuted__c = false,Segmentation_Criteria__c = scb.id,Auto_Segmentation__c = true,RecordTypeId=camIdExec,Execution_Type__c='eMail',Segmentation_Date__c=system.today(),Execution_Start_Date__c=system.today()+1,Name='Test Campaign1',Child_Campaign_Status__c='Segmentation',Status__c='Draft',Close_Date__c=system.today()+1);
        insert rcobj1;
        grp = new Group(Name='MY12345');
        insert grp;
        EmailTemplate e = new EmailTemplate (isActive = true,body='test',FolderId = UserInfo.getUserId(),developerName = 'MBMY_Retail_Campaign_Planning_And_Design_Notification_to_Dealers', TemplateType= 'Text', Name = 'MBMY_Retail_Campaign_Planning_And_Design_Notification_to_Dealers'); // plus any other fields that you want to set
        insert e;
    }
    public static testmethod void testCancel(){
         try{
        user1.market__c='MY';
        update user1;
        System.runAs(user1){
            test.startTest();
            createTestdata();
            ApexPages.currentPage().getParameters().put('CampaignId',rcobj1.Id);
            ApexPages.StandardController objSc = new ApexPages.StandardController(rcobj1);
            DealerPickerControllerGeneric dpTHc=new DealerPickerControllerGeneric();
            dpThc.cancel();
            dpThc.showPopup();
            dpThc.cancelURLS();
            Test.stopTest();
        }
        }Catch( exception e){}
    }
    
   /* public static testmethod void testshareRetailcampaignRecords(){
    try{    user1.market__c='MY';
            update user1;
        System.runAs(user1){
            test.startTest();
            createTestdata();
            ApexPages.currentPage().getParameters().put('CampaignId',rcobj1.Id);
            ApexPages.StandardController objSc = new ApexPages.StandardController(rcobj1);
            DealerPickerTHController dpTHc=new DealerPickerTHController();
            dpThc.shareRetailcampaignRecords();
            Test.stopTest();
            }
        }Catch( exception e){}
    }*/
    
    public static testmethod void testSharetoDealers(){
     try{   user1.market__c='MY';
    update user1;
        System.runAs(user1){
            test.startTest();
            createTestdata();
            system.debug([select id,name from group where name='MY12345']);
            ApexPages.currentPage().getParameters().put('CampaignId',rcobj1.Id);
            DealerPickerControllerGeneric dpTHc=new DealerPickerControllerGeneric ();
            DealerPickerControllerGeneric.DealersList tdl= new DealerPickerControllerGeneric.DealersList(accobj);
            tdl.isselected=true;
            dpTHc.dList.add(tdl);        
            dpThc.SharetoDealers();
            
            Test.stopTest();
        }
        }Catch( exception e){}
    }
}