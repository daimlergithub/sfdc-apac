/*
    Type: Util class used to create Custom setting records for custom setting(Trigger__C)
    This is used by test classes since the actual customs setting data is not accessible to them unless Showalldata = true.
    ---------------------------------------------------------------------------------------
    
    
    Created Date - 15/12/2015
*/
public  class UtilCustomSettingsJP {
    
  public static List<Trigger__c> updatecustomsetting=new List<Trigger__c>();
  
  
  /**
  *@Description : This methods adds all the custom setting records for custom setting(Trigger__C)and adds it to list which is returned by this method.
  The returned list is used by Test classes while preparing Test data.
  *@Date : 15/12/2015
  *@param:None
  *@return:This mehtod Returns List of custom settings(Trigger__C).

  */ 
  public static  List<Trigger__c> customSettingDetails()
  {
      // ***************   JP Market   ***************
      
      Trigger__c AttachmentAfter=new Trigger__c(Name='AttachmentAfter',Trigger_Name__c='AttachmentAfter',Trigger_Handler__c='AttachmentAfterTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(AttachmentAfter);
	  
	  Trigger__c AttachmentAfterKER=new Trigger__c(Name='AttachmentAfterKER',Trigger_Name__c='AttachmentAfter',Trigger_Handler__c='AttachmentAfterTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='NA');
      updatecustomsetting.add(AttachmentAfterKER);

      Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerAddress);
      
      Trigger__c CampaignMemberAfterTrigger=new Trigger__c(Name='CampaignMemberAfterTrigger',Trigger_Name__c='CampaignMemberAfterTrigger',Trigger_Handler__c='CampaignMemberAfterTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(CampaignMemberAfterTrigger);
	  
	  Trigger__c CampaignMemberAfterTriggerKER=new Trigger__c(Name='CampaignMemberAfterTriggerKER',Trigger_Name__c='CampaignMemberAfterTrigger',Trigger_Handler__c='CampaignMemberAfterTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='NA');
      updatecustomsetting.add(CampaignMemberAfterTriggerKER);
      
      Trigger__c CaseTrigger=new Trigger__c(Name='CaseTrigger',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='CaseTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(CaseTrigger);
      
      Trigger__c ContactTrigger=new Trigger__c(Name='ContactTrigger',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(ContactTrigger);
      
      Trigger__c RecallAfterInsertUpdate=new Trigger__c(Name='RecallAfterInsertUpdate',Trigger_Name__c='RecallAfterInsertUpdate',Trigger_Handler__c='RecallAfterInsertUpdateTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(RecallAfterInsertUpdate);
      
      Trigger__c RetailCampaignTrigger=new Trigger__c(Name='RetailCampaignTrigger',Trigger_Name__c='RetailCampaignTrigger',Trigger_Handler__c='RetailCampaignTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(RetailCampaignTrigger);
      
      Trigger__c TriggerAccountLink=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerAccountLink);
      
      Trigger__c SSITrigger=new Trigger__c(Name='SSITrigger',Trigger_Name__c='SSITrigger',Trigger_Handler__c='SSITriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(SSITrigger);
      
      Trigger__c TaskTrigger=new Trigger__c(Name='TaskTrigger',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TaskTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TaskTrigger);
      
      Trigger__c ToolKitTrigger=new Trigger__c(Name='ToolKitTrigger',Trigger_Name__c='ToolKitTrigger',Trigger_Handler__c='ToolKitTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(ToolKitTrigger);
      
      Trigger__c TriggerAccount=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerAccount);
      
      Trigger__c TriggerBatchJob=new Trigger__c(Name='TriggerBatchJob',Trigger_Name__c='TriggerBatchJob',Trigger_Handler__c='TriggerBatchJobTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerBatchJob);
      
      Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaign',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaign);
	  
	  Trigger__c TriggerCampaignCityKER=new Trigger__c(Name='TriggerCampaignCityKER',Trigger_Name__c='TriggerCampaignCity',Trigger_Handler__c='TriggerCampaignCityTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='NA');
      updatecustomsetting.add(TriggerCampaignCityKER);
      
      Trigger__c TriggerCampaignCity=new Trigger__c(Name='TriggerCampaignCity',Trigger_Name__c='TriggerCampaignCity',Trigger_Handler__c='TriggerCampaignCityTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaignCity);
      
      Trigger__c TriggerCampaignLead=new Trigger__c(Name='TriggerCampaignLead',Trigger_Name__c='TriggerCampaignLead',Trigger_Handler__c='TriggerCampaignLeadTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaignLead);
      
      Trigger__c TriggerCampaignMembers=new Trigger__c(Name='TriggerCampaignMembers',Trigger_Name__c='TriggerCampaignMembers',Trigger_Handler__c='TriggerCampaignMembersTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaignMembers);
      
      Trigger__c TriggerCampaignOffering=new Trigger__c(Name='TriggerCampaignOffering',Trigger_Name__c='TriggerCampaignOffering',Trigger_Handler__c='TriggerCampaignOfferingTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaignOffering);
      
      Trigger__c TriggerCampaignPackage=new Trigger__c(Name='TriggerCampaignPackage',Trigger_Name__c='TriggerCampaignPackage',Trigger_Handler__c='TriggerCampaignPackageTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerCampaignPackage);
      
      Trigger__c TriggerDealerLocator=new Trigger__c(Name='TriggerDealerLocator',Trigger_Name__c='TriggerDealerLocator',Trigger_Handler__c='TriggerDealerLocatorHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerDealerLocator);
      
      Trigger__c TriggerDMRequest=new Trigger__c(Name='TriggerDMRequest',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerDMRequest);
      
      Trigger__c TriggerLead=new Trigger__c(Name='TriggerLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerLead);
    
      Trigger__c TriggerVehicleRelationship=new Trigger__c(Name='TriggerVehicleRelationship',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
      updatecustomsetting.add(TriggerVehicleRelationship);    
      
      // ***************   KR Market   ***************
      
      Trigger__c CaseTriggerKR=new Trigger__c(Name='CaseTriggerKR',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='TriggerCaseTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(CaseTriggerKR);   

      Trigger__c RetailTaskTriggerKR=new Trigger__c(Name='RetailTaskTriggerKR',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='RetailTaskTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(RetailTaskTriggerKR);
      
      Trigger__c TaskTriggerKr=new Trigger__c(Name='TaskTriggerKr',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TaskTriggerHandlerKr',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TaskTriggerKr);
      
      Trigger__c TriggerAccountKR=new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerAccountKR);
      
      Trigger__c TriggerAddressKR=new Trigger__c(Name='TriggerAddressKR',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerAddressKR);
      
      Trigger__c TriggerCampaignKR=new Trigger__c(Name='TriggerCampaignKR',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignKR);
      
      Trigger__c TriggerDMRequestKR=new Trigger__c(Name='TriggerDMRequestKR',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerDMRequestKR);
      
      Trigger__c TriggerLeadKR=new Trigger__c(Name='TriggerLeadKR',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerLeadKR);
      
      Trigger__c TriggerVehicleRelationshipKR=new Trigger__c(Name='TriggerVehicleRelationshipKR',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerVehicleRelationshipKR);
   
      
   return updatecustomsetting;
   }
}