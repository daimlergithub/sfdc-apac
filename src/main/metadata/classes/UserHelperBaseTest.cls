/**
* Test class for UserHelper Base class
* Author: Pratyasha Mishra 
* Created Date : 2018-02-16
*/

@isTest
public class UserHelperBaseTest {
    
    Private static Profile adminProfileObj;
    Private static User adminUserObj;
    public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
    
    public static void createtestdata(){
        
        Trigger__c TriggerUser=new Trigger__c(Name='UserTriggerMY',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
        insert TriggerUser;
        adminProfileObj = [select id from profile where Name='System Administrator' limit 1];
        adminUserObj = TestUtils.createMYAdminUser();
         
    }
    public static testmethod  void  ShareUsersToDealersAfterInsertAndUpdateTest(){
        test.startTest();
        createtestdata();
        Group grpObj=new Group(Name='12345');
        insert grpObj;
        
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
     	profile p2=[select id from profile where Name='Malaysia Dealer Delegate Admin'];

    	Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='MY', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
    	Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='MY',Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;

        Account dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='02202123626', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealerAccount;
        Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',AccountId=dealerAccount.Id);
        insert c1;
        
        System.runAs(adminUserObj)
        {
            Profile profileObj = [select id from profile where Name='Malaysia Dealer Delegate Admin' limit 1];
            User userObj = new User(ContactId=c1.Id,LastName='User',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusr11@daimler.com',Market__c = 'MY',isActive=true);
            insert userObj;  
            userObj.Market__c='MY';
          	update userObj;
        }
        test.stopTest();
    } 
    public static testMethod void AfterInsertANDUpdateMethodTest()
    {
        test.startTest();
        createtestdata();
        Group grpObj=new Group(Name='12345');
        insert grpObj;
        
        Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='MY', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
    	Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='MY',Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
       
        Account dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='02202123626', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealerAccount;
        Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',AccountId=dealerAccount.Id);
        insert c1;
        Contact c2=new Contact(FirstName = 'Test',Lastname = 'Contact2',AccountId=dealerAccount.Id);
        insert c2;
       
        System.runAs(adminUserObj)
        {
            Profile profileObj = [select id from profile where Name='Malaysia Dealer Delegate Admin' limit 1];
            
            User userObj = new User(ContactId=c1.Id,LastName='User',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert userObj;
        	userObj.Market__c='MY';
        	update userObj;
        
            AccountShare accShare=new AccountShare(UserOrGroupId=userObj.Id,AccountId=dealerAccount.Id,AccountAccessLevel='READ',OpportunityAccessLevel = 'READ');
            insert accShare;
            
            Car_Model__c modelObj=new Car_Model__c(Name='Polo');
            insert modelObj;
            
            Vehicle__c vehObj=new Vehicle__c(Colour__c='Blue',car_model__c=modelObj.Id);
            insert vehObj;
            
            Vehicle__Share vehShare = new Vehicle__Share();
            vehShare.AccessLevel = 'READ';
            vehShare.ParentID = vehObj.Id;
            vehShare.RowCause = Schema.Vehicle__Share.RowCause.Manual;
            vehShare.UserOrGroupId = userObj.Id;
            
            insert vehShare;
            
            Vehicle_Relationship__c vrObj=new Vehicle_Relationship__c(Card_No__c='13246',Owner_Dealer__c=dealerAccount.Id,Vehicle_ID__c=vehObj.Id); 
            insert vrObj;
            
            Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
            vrShare.AccessLevel = 'READ';
            vrShare.ParentID = vrObj.Id;
            vrShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
            vrShare.UserOrGroupId = userObj.Id;
            insert vrShare;
            
            Lead__c leadObj=new Lead__c(Batch_No__c='123465',Assigned_Dealer__c=dealerAccount.Id,MD__c='MY');
            insert leadObj;
            
            Lead__Share leadShare = new Lead__Share();
            leadShare.AccessLevel = 'Edit';
            leadShare.ParentID = leadObj.id;
            leadShare.RowCause = Schema.Lead__Share.RowCause.Manual;
            leadShare.UserOrGroupId = userObj.Id;
            insert leadShare;
            
            Retail_Campaign__c rcObj=new Retail_Campaign__c(Name='Test Campaign');
            insert rcObj;
            
            Retail_Campaign__Share rcShare = new Retail_Campaign__Share();
            rcShare.AccessLevel = 'Edit';
            rcShare.ParentID = rcObj.id;
            rcShare.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
            rcShare.UserOrGroupId = userObj.id;
            insert rcShare;
           
            Account acc =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='MY', Individual_Home_Phone__c='02202123626', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
          	insert acc;           
            
            Account_Link__c accLink=new Account_Link__c(Name='test Account link',MD__c='MY',fromRole__c=dealerAccount.Id,toRole__c=acc.Id);
            insert accLink;
            
            Account_Link__share accLinkShare = new Account_Link__share();
            accLinkShare.AccessLevel = 'EDIT';
            accLinkShare.parentid = accLink.id;
            accLinkShare.UserOrGroupId = userObj.Id;
            accLinkShare.RowCause = Schema.Account_link__Share.RowCause.Manual;
            insert accLinkShare;
            
            Car_Model__share cmShare = new Car_Model__share();
            cmShare.AccessLevel = 'READ';
            cmShare.parentid = modelObj.id;
            cmShare.UserOrGroupId = userObj.Id;
            cmShare.RowCause = Schema.Car_model__Share.RowCause.Manual;
            insert cmShare;
            
            Campaign campObj=new Campaign(Name='Test Campaign');
            insert campObj;
            
            CampaignShare campShare = new CampaignShare();
            campShare.CampaignAccessLevel = 'READ';
            campShare.CampaignID = campObj.id;
            campShare.UserOrGroupId = userObj.Id;
            campShare.RowCause = Schema.CampaignShare.RowCause.Manual;
            insert campShare;
            
            Campaign_member__c campMemObj=new Campaign_member__c(Bonus_Amount1__c='366666');
      		insert campMemObj;
            
            Campaign_member__share campMemShare = new Campaign_member__share();
            campMemShare.AccessLevel = 'EDIT';
            campMemShare.UserOrGroupId = userObj.Id;
            campMemShare.ParentId=campMemObj.Id;
            campMemShare.RowCause = Schema.campaign_member__Share.RowCause.Manual;
            insert campMemShare;
            
            case caseObj=new Case(Status='Closed',Case_Dealer__c=dealerAccount.Id,MD__c='MY');
            insert caseObj;
            
            caseShare cshare = new caseShare();
            cshare.CaseAccessLevel = 'EDIT';
            cshare.CaseId= caseObj.id;
            cshare.UserOrGroupId = userObj.Id;
            cshare.RowCause = Schema.caseShare.RowCause.Manual;
            insert cshare;
            
            SurveyTaker__c stObj=new SurveyTaker__c(MD__c='MY');
            insert stObj;
            
            SurveyTaker__share stshare = new SurveyTaker__share();
            stshare.AccessLevel = 'EDIT';
            stshare.parentid = stObj.id;
            stshare.UserOrGroupId = userObj.Id;
            stshare.RowCause = Schema.surveyTaker__Share.RowCause.Manual;
            insert stshare;
            
            Survey__c surveyObj=new Survey__c(Name='TestSurvey');
            insert surveyObj;
            
            Survey__share surveyShare= new Survey__share();
            surveyShare.AccessLevel = 'EDIT';
            surveyShare.parentid = surveyObj.id;
            surveyShare.UserOrGroupId = userObj.Id;
            surveyShare.RowCause = Schema.Survey__Share.RowCause.Manual;
            insert surveyShare;
            
            User userObj2 = new User(ContactId=c2.Id,LastName='User2',country='Australia',firstName='BCI',ProfileId=profileObj.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser02@testing.com',UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), Market__c = 'MY',isActive=true);
          	insert userObj2;        
        }
        test.stopTest();
    }
}