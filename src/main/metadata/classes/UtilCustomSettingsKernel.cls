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
  
  public static  List<Trigger__c> customSettingDetails(){
       Trigger__c TriggerPackageItem=new Trigger__c(Name='TriggerPackageItem',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelationshipTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       updatecustomsetting.add(TriggerPackageItem);
              
       Trigger__c caseTrigger = new Trigger__c(Name='CaseTrigger',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='CaseTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       updatecustomsetting.add(caseTrigger);
       
       Trigger__c campaignOfferingTrigger = new Trigger__c(Name='TriggerCampaignOffering',Trigger_Name__c='TriggerCampaignOffering',Trigger_Handler__c='TriggerCampaignOfferingTriggerHandler ',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       updatecustomsetting.add(campaignOfferingTrigger);
       
       Trigger__c CampaignPackageTrigger = new Trigger__c(Name='TriggerCampaignPackage',Trigger_Name__c='TriggerCampaignPackage',Trigger_Handler__c='TriggerCampaignPackageTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       updatecustomsetting.add(CampaignPackageTrigger);
       
       Trigger__c triggerCampaign = new Trigger__c(Name='TriggerCampaign',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       updatecustomsetting.add(triggerCampaign);
       
       TriggerPackageItem = new Trigger__c(Name='TriggerRecall',Trigger_Name__c='TriggerRecall',Trigger_Handler__c='TriggerRecallTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
       updatecustomsetting.add(TriggerPackageItem );
       
       TriggerPackageItem = new Trigger__c(Name='TriggerRetailTask',Trigger_Name__c='TriggerRetailTask',Trigger_Handler__c='TriggerRetailTaskTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
       updatecustomsetting.add(TriggerPackageItem );

       return updatecustomsetting;
   }
   
}