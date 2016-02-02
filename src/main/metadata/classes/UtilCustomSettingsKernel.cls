/*
    Type: Util class used to create Custom setting records for custom setting(Trigger__C)
    This is used by test classes since the actual customs setting data is not accessible to them unless Showalldata = true.
    ---------------------------------------------------------------------------------------
    
    
    Created Date - 15/12/2015
*/
public  class UtilCustomSettingsKernel {
    
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
    
      Trigger__c AttachmentAfter=new Trigger__c(Name='AttachmentAfter',Trigger_Name__c='AttachmentAfter',Trigger_Handler__c='AttachmentAfterTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(AttachmentAfter);
      
      Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerAddress);
      
      Trigger__c CampaignMemberAfterTrigger=new Trigger__c(Name='CampaignMemberAfterTrigger',Trigger_Name__c='CampaignMemberAfterTrigger',Trigger_Handler__c='CampaignMemberAfterTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(CampaignMemberAfterTrigger);
      
      Trigger__c CaseTrigger=new Trigger__c(Name='CaseTrigger',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='CaseTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(CaseTrigger);
      
      Trigger__c ContactTrigger=new Trigger__c(Name='ContactTrigger',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(ContactTrigger);
      
      Trigger__c RecallAfterInsertUpdate=new Trigger__c(Name='RecallAfterInsertUpdate',Trigger_Name__c='RecallAfterInsertUpdate',Trigger_Handler__c='RecallAfterInsertUpdateTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(RecallAfterInsertUpdate);
      
      Trigger__c RetailCampaignTrigger=new Trigger__c(Name='RetailCampaignTrigger',Trigger_Name__c='RetailCampaignTrigger',Trigger_Handler__c='RetailCampaignTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(RetailCampaignTrigger);
      
      Trigger__c TriggerAccountLink=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerAccountLink);      
      
      Trigger__c SSITrigger=new Trigger__c(Name='SSITrigger',Trigger_Name__c='SSITrigger',Trigger_Handler__c='SSITriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(SSITrigger);
      
      Trigger__c TaskTrigger=new Trigger__c(Name='TaskTrigger',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TaskTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TaskTrigger);
      
      Trigger__c ToolKitTrigger=new Trigger__c(Name='ToolKitTrigger',Trigger_Name__c='ToolKitTrigger',Trigger_Handler__c='ToolKitTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(ToolKitTrigger);
      
      Trigger__c TriggerAccount=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerAccount);
      
      Trigger__c TriggerBatchJob=new Trigger__c(Name='TriggerBatchJob',Trigger_Name__c='TriggerBatchJob',Trigger_Handler__c='TriggerBatchJobTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerBatchJob);
      
      Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaign',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaign);
      
      Trigger__c TriggerCampaignCity=new Trigger__c(Name='TriggerCampaignCity',Trigger_Name__c='TriggerCampaignCity',Trigger_Handler__c='TriggerCampaignCityTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignCity);
      
      Trigger__c TriggerCampaignLead=new Trigger__c(Name='TriggerCampaignLead',Trigger_Name__c='TriggerCampaignLead',Trigger_Handler__c='TriggerCampaignLeadTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignLead);
      
      Trigger__c TriggerCampaignMembers=new Trigger__c(Name='TriggerCampaignMembers',Trigger_Name__c='TriggerCampaignMembers',Trigger_Handler__c='TriggerCampaignMembersTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignMembers);
      
      Trigger__c TriggerCampaignOffering=new Trigger__c(Name='TriggerCampaignOffering',Trigger_Name__c='TriggerCampaignOffering',Trigger_Handler__c='TriggerCampaignOfferingTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignOffering);
      
      Trigger__c TriggerCampaignPackage=new Trigger__c(Name='TriggerCampaignPackage',Trigger_Name__c='TriggerCampaignPackage',Trigger_Handler__c='TriggerCampaignPackageTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerCampaignPackage);
      
      Trigger__c TriggerDealerLocator=new Trigger__c(Name='TriggerDealerLocator',Trigger_Name__c='TriggerDealerLocator',Trigger_Handler__c='TriggerDealerLocatorHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerDealerLocator);
      
      Trigger__c TriggerDMRequest=new Trigger__c(Name='TriggerDMRequest',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerDMRequest);
      
      Trigger__c TriggerLead=new Trigger__c(Name='TriggerLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
      updatecustomsetting.add(TriggerLead);
		
	  Trigger__c TriggerVehicleRelationship=new Trigger__c(Name='TriggerVehicleRelationship',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
   	  updatecustomsetting.add(TriggerVehicleRelationship);	      
   
      
   return updatecustomsetting;
   }
}