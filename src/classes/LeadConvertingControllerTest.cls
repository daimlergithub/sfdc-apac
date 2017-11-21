/*
    Type:       test class
    Purpose:    LeadConvertingController test class
    User Story: Release 1.2
    Used By:    LeadConvertingController
    History:9-Jun-2014 Sinow    Created
*/
@isTest 
public with sharing class LeadConvertingControllerTest
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
  Private static String segmentation='Segmentation Only';
  Private static String ids='id';
  static{
    Profile p = [select id from profile where name='System Administrator' limit 1];
    currentUser = new User(alias = 'usrTest', email='usrTesting614@testingorg.com',
      emailencodingkey='UTF-8', lastname='Apex', languagelocalekey='en_US',
      localesidkey='en_US', profileid = p.Id, country='United States',
      timezonesidkey='America/Los_Angeles', username='usrTestingclasses6114@testing.org',isActive = true);
    insert currentUser;

  }

  private static void init() {
 
      Trigger__c newtrg = new Trigger__c(Name= 'TriggerAccount16',Trigger_Name__c = 'TriggerAccount',Trigger_Handler__c = 'TriggerAccountTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
      
       //List<Trigger__c> triggerRetailCampaignMembers = [select Id from Trigger__c where Trigger_Name__c = 'TriggerRetailCampaignMember'];
       //if (triggerRetailCampaignMembers == null || triggerRetailCampaignMembers.isEmpty()) {
           insert new Trigger__c(Name = 'TriggerRetailCampaignMember',Market__c='JP',Trigger_Name__c = 'TriggerRetailCampaignMember', Trigger_Handler__c = 'TriggerRetailCampaignMemberHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
       //}
       thirdParty = new Account(LastName = 'TestAmit216', RecordTypeId =thirdPartyRTID);
       insert thirdParty;
       dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
       insert dealer;
       rc = new Retail_Campaign__c(RecordTypeId =RTId,Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Campaign_Execution_Channels__c = 'DM');
       insert rc;      
       rtm = new Retail_Campaign_Member__c(Retail_Campaign__c = rc.Id, Contact__c = thirdParty.Id, Status__c = 'Show up');
       insert rtm;    
        
   }
   private static void set_Lead_ASRETAILCAMPAIGN() {
       //init();    
       leadConverting = Page.LeadConverting;
       leadConverting.getParameters().put(ids,rc.id);
       leadConverting.getParameters().put('rt',UtilConstant.AS_RETAIL_CAMPAIGN); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
   private static void LeadRT_Segmentation() {
       //init();           
       leadConverting = Page.LeadConverting;
       leadConverting.getParameters().put(ids,rc.id);
       leadConverting.getParameters().put('rt',segmentation); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
   private static void LeadRT_notSegmentation() {
       //init();           
       leadConverting = Page.LeadConverting;
       leadConverting.getParameters().put(ids,rc.id);
       leadConverting.getParameters().put('rt','Not Segmentation Only'); 
       Test.setCurrentPage(leadConverting);
       extension = new LeadConvertingController();  
   }
    
  public static testMethod void test_Converttolead_isConvertedtrue()
  {
      //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

    init();
    set_Lead_ASRETAILCAMPAIGN();
    Test.startTest();       
    System.runAs (currentUser) {        
      System.assertEquals(1, extension.retailCampaignMemberInfos.size());
      extension.retailCampaignMemberInfos[0].isConverted = true; 
      extension.converttolead();  
    }
    Test.stopTest();

    System.assertEquals(ApexPages.currentPage().getParameters().get('rt'),UtilConstant.AS_RETAIL_CAMPAIGN);
  }  
    
    public static testMethod void test_Converttolead_LeadType_Product()
       {
           //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){        
        extension.retailCampaignMemberInfos[0].isConverted =true;
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='Product';
        extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c='';
        extension.converttolead();  
        Test.stopTest(); 
        system.assertequals(ApexPages.currentPage().getParameters().get('rt'),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);      
        } 
      }  
      public static testMethod void test_Converttolead_Additional_Service_Null()
       {
           //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();       
        system.runAs(currentUser){
        extension = new LeadConvertingController();        
        extension.retailCampaignMemberInfos[0].isConverted =true;       
        extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c='Test'; 
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='ProductTest';
        extension.retailCampaignMemberInfos[0].lead.Lead_Additional_Service__c='';      
        extension.converttolead();
        Test.stopTest();
        system.assertequals(ApexPages.currentPage().getParameters().get('rt'),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!='product');
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c!=Null);
        }         
      }   
      public static testMethod void test_Converttolead_Collectioner_Notes_Null()
       {
          // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

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
        system.assertequals(ApexPages.currentPage().getParameters().get('rt'),UtilConstant.AS_RETAIL_CAMPAIGN);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Type__c!='product');
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Sub_Type__c!=Null);
        system.assert(extension.retailCampaignMemberInfos[0].lead.Lead_Additional_Service__c!=Null);
        }        
      } 
     public static testMethod void test_Converttolead_RTSegmentation()
       {
           //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

        init();
        LeadRT_Segmentation();
        Test.startTest();       
        system.runAs(currentUser){ 
        extension.retailCampaignMemberInfos[0].isConverted =true;    
        extension.converttolead(); 
        Test.stopTest(); 
        system.assertequals(ApexPages.currentPage().getParameters().get('rt'),segmentation);
        system.assertequals(extension.retailCampaignMemberInfos[0].lead.Assigned_Date_Time__c,date.today());
        system.assert(extension.retailCampaignMemberInfos[0].dealerNameId!=Null);  
        system.assertequals(extension.retailCampaignMemberInfos[0].lead.Contact__c,extension.retailCampaignMemberInfos[0].retailCampaignMember.Contact__c);  
        system.assertequals('New',extension.retailCampaignMemberInfos[0].lead.CAC_Lead_Status__c);  
        system.assertequals(date.today(),extension.retailCampaignMemberInfos[0].lead.Order_Placed_Date__c);  
        system.assertequals('Converted',extension.retailCampaignMemberInfos[0].retailCampaignMember.Status__c);
       }        
     } 
    public static testMethod void test_Converttolead_Lead_Desired_Service()
         {
            // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c='';   
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get('rt')!=segmentation);
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted); 
            system.assertequals('',extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c);           
         }        
      }      
    public static testMethod void test_Converttolead_Retail_Purchase_Time()
          {
             // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c='DesiredService';  
            extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c ='';  
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get('rt')!='Segmentation Only');
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted);
            system.assertequals('',extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c);
        }        
      } 
     public static testMethod void test_Converttolead_Lead_Type()
         {
             //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

            init();
            LeadRT_notSegmentation();
            Test.startTest();       
            system.runAs(currentUser){ 
            extension.retailCampaignMemberInfos[0].isConverted =true;   
            extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c='DesiredService';  
            extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c ='PurchaseTime'; 
            extension.retailCampaignMemberInfos[0].lead.Lead_Type__c ='';
            extension.converttolead(); 
            Test.stopTest(); 
            system.assert(ApexPages.currentPage().getParameters().get('rt')!='Segmentation Only');
            system.assertequals(true,extension.retailCampaignMemberInfos[0].isConverted);
            system.assertequals('',extension.retailCampaignMemberInfos[0].lead.Lead_Type__c);
         }        
      }
      public static testMethod void test_Cancel()
       {    
          // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
     // insert updatecustomsettings;

        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();           
        extension.cancel();
        Test.stopTest();  
        system.assertequals(ApexPages.currentPage().getParameters().get('id'),rc.id);    
        system.assert(extension.cancel()!=Null);  
      } 
      public static testMethod void test_VehicleLooking()
       {
          // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;

        init();
        set_Lead_ASRETAILCAMPAIGN();
        Test.startTest();           
        extension.vehicleLooking(); 
        Test.stopTest();   
        system.assertequals(ApexPages.currentPage().getParameters().get('id'),rc.id);  
        system.assertequals(extension.vehicleLooking(),Null);      
      }      
}