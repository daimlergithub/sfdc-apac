/*
    Type:       test class
    Purpose:    LeadConvertingController test class
    User Story: Release 1.2

    Used By:    LeadConvertingController
    ---------------------------------------------------------------
    History:

    9-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class LeadConvertingControllerTest
{
  static Account thirdParty;
  static Account dealer;
  static Retail_Campaign__c rc;
  static User currentUser;
  static Retail_Campaign_Member__c rtm;
  static PageReference leadConverting;
  static LeadConvertingController extension;
  static String thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
  static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();  
  static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
  static String ASRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
  static Retail_Campaign__c campaign;
  static String retailCampaignId; 
  static String recordType='rt';
  static string id_Value='id';
  static string Segmentation_Only='Segmentation Only';
  static string blank_Value='';

  static{
    Profile p = [select id from profile where name='System Administrator' limit 1];
    currentUser = new User(alias = 'usrTest', email='usrTesting@testingorg.com',
      emailencodingkey='UTF-8', lastname='Apex', languagelocalekey='en_US',
      localesidkey='en_US', profileid = p.Id, country='United States',
      timezonesidkey='America/Los_Angeles', username='usrTestingclasses@testing.org',isActive = true);
    insert currentUser;

  }

  private static void init() {
       thirdParty = new Account(LastName = 'Test Amit', RecordTypeId =thirdPartyRTID, Phone ='12345678921',PersonOtherPhone='0231456987',PersonHomePhone='0231456989',PersonMobilePhone='0231456439',Retail_Fax__c='0237456989',Retail_Home_Phone__c='0281456989',Retail_Mobile__c='0231456949',Retail_Work_Phone__c='0231056989');
       insert thirdParty;
       dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
       insert dealer;
       rc = new Retail_Campaign__c(RecordTypeId =RTId,Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved');
       insert rc;      
       rtm = new Retail_Campaign_Member__c(Retail_Campaign__c = rc.Id, Contact__c = thirdParty.Id, Status__c = 'Show up');
       insert rtm; 
       retailCampaignId = ApexPages.currentPage().getParameters().put(id_Value,rc.Id);        
   }
   private static void set_page(){
       init();    
       leadConverting = Page.LeadConverting;
       leadConverting.getParameters().put(id_Value,rc.id);
   }
   private static void set_Lead_ASRETAILCAMPAIGN() {
       set_page();
       leadConverting.getParameters().put(recordType,UtilConstant.AS_RETAIL_CAMPAIGN); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
   private static void LeadRT_Segmentation() {
       set_page();
       leadConverting.getParameters().put(recordType,Segmentation_Only); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
   private static void LeadRT_notSegmentation() {
       set_page();
       leadConverting.getParameters().put(recordType,'Not Segmentation Only'); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
   public static testMethod void test_Converttolead_isConvertedtrue()
     {
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){        
        extension.retailCampaignMemberInfos[0].isConverted =true; 
        extension.converttolead();  
        Test.stopTest();
        system.assertequals(ApexPages.currentPage().getParameters().get(recordType),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assertequals(Null,extension.retailCampaignMemberInfos[0].lead.Lead_Type__c);
        }         
      } 
    public static testMethod void test_Converttolead_LeadType_Product()
       {
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){        
        extension.retailCampaignMemberInfos[0].isConverted =true;
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='Product';
        extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c=blank_Value;
        extension.converttolead();  
        Test.stopTest(); 
        system.assertequals(ApexPages.currentPage().getParameters().get(recordType),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);      
        } 
      }  
      public static testMethod void test_Converttolead_Additional_Service_Null()
       {
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){
        extension = new LeadConvertingController();        
        extension.retailCampaignMemberInfos[0].isConverted =true;       
        extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c='Test'; 
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='ProductTest';
        extension.retailCampaignMemberInfos[0].lead.Lead_Additional_Service__c=blank_Value;      
        extension.converttolead();
        Test.stopTest();
        system.assertequals(ApexPages.currentPage().getParameters().get(recordType),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!='product');
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c!=Null);
        }         
      }   
      public static testMethod void test_Converttolead_Collectioner_Notes_Null()
       {
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){
        extension.retailCampaignMemberInfos[0].isConverted =true;
        extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c='Test'; 
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='ProductTest';
        extension.retailCampaignMemberInfos[0].lead.Lead_Additional_Service__c='AdditionalService';
        extension.retailCampaignMemberInfos[0].lead.Collectioner_Notes__c = Null;
        extension.converttolead(); 
        Test.stopTest(); 
        system.assertequals(ApexPages.currentPage().getParameters().get(recordType),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!='product');
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Additional_Service__c!=Null);
        }        
      } 
     public static testMethod void test_Converttolead_RTSegmentation()
       {       
        init();
        LeadRT_Segmentation();
        Test.startTest();            
        system.runAs(currentUser){ 
        extension.retailCampaignMemberInfos[0].isConverted =true;    
        extension.converttolead(); 
        campaign = [select Actual_Lead__c from Retail_Campaign__c where Id = :retailCampaignId];
        Test.stopTest(); 
        system.assertequals(ApexPages.currentPage().getParameters().get(recordType),Segmentation_Only);
        system.assertequals(extension.retailCampaignMemberInfos[0].lead.Assigned_Date_Time__c,date.today());
        system.assert(extension.retailCampaignMemberInfos[0].dealerNameId!=Null);  
        system.assertequals(extension.retailCampaignMemberInfos[0].lead.Contact__c,extension.retailCampaignMemberInfos[0].retailCampaignMember.Contact__c);  
        system.assertequals('New',extension.retailCampaignMemberInfos[0].lead.CAC_Lead_Status__c);  
        system.assertequals(date.today(),extension.retailCampaignMemberInfos[0].lead.Order_Placed_Date__c);  
        system.assertequals('Converted',extension.retailCampaignMemberInfos[0].retailCampaignMember.Status__c);       
        system.assertequals(campaign.Actual_Lead__c,[select count() from Lead__c where Retail_Campaign_Name__c = :retailCampaignId]);
       }        
     } 
    public static testMethod void test_Converttolead_Lead_Desired_Service()
         {
            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c=blank_Value;   
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get(recordType)!=Segmentation_Only);
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted); 
            system.assertequals(blank_Value,extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c);           
         }        
      }      
    public static testMethod void test_Converttolead_Retail_Purchase_Time()
          {
            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c='DesiredService';  
            extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c =blank_Value;  
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get(recordType)!=Segmentation_Only);
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted);
            system.assertequals(blank_Value,extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c);
        }        
      } 
     public static testMethod void test_Converttolead_Lead_Type()
         {
            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c='DesiredService';  
            extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c ='PurchaseTime'; 
            extension.retailCampaignMemberInfos[0].lead.Lead_Type__c =blank_Value;
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get(recordType)!=Segmentation_Only);
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted);
            system.assertequals(blank_Value,extension.retailCampaignMemberInfos[0].lead.Lead_Type__c);
         }        
      }
      public static testMethod void test_Cancel()
       {       
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();           
        extension.cancel();
        Test.stopTest();  
        system.assertequals(ApexPages.currentPage().getParameters().get(id_Value),rc.id);    
        system.assert(extension.cancel()!=Null);  
      } 
      public static testMethod void test_VehicleLooking()
       {
        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();           
        extension.vehicleLooking(); 
        Test.stopTest();   
        system.assertequals(ApexPages.currentPage().getParameters().get(id_Value),rc.id);  
        system.assertequals(extension.vehicleLooking(),Null);      
      }      
}