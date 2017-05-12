/*
    Type: Util class used to create Custom setting records for custom setting(Trigger__C)
    This is used by test classes since the actual customs setting data is not accessible to them unless Showalldata = true.
    ---------------------------------------------------------------------------------------
    
    
    Created Date - 11/05/2017
*/

@isTest
public  class UtilCustomSettingTH {
    
  public static List<Trigger__c> updatecustomsetting=new List<Trigger__c>();
  
  
  /**
  *@Description : This methods adds all the custom setting records for custom setting(Trigger__C)and adds it to list which is returned by this method.
  The returned list is used by Test classes while preparing Test data for thailand
  *@Date : 15/12/2015
  *@param:None
  *@return:This mehtod Returns List of custom settings(Trigger__C).

  */ 
  public static  List<Trigger__c> customSettingDetails()
  {
      // ***************   TH Market   ***************
      
      Trigger__c AttachmentAfter=new Trigger__c(Name='TaskTriggerTH',Trigger_Name__c='TaskTrigger',Trigger_Handler__c='TaskTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(AttachmentAfter);
    
      Trigger__c AttachmentAfterKER=new Trigger__c(Name='TriggerAccountTH',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(AttachmentAfterKER);

      Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddressTH',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(TriggerAddress);
      
      Trigger__c CampaignMemberAfterTrigger=new Trigger__c(Name='TriggerCampaignTH',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(CampaignMemberAfterTrigger);
    
     Trigger__c CampaignMemberAfterTriggerKER=new Trigger__c(Name='TriggerCaseTH',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='CaseTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(CampaignMemberAfterTriggerKER);
      
      Trigger__c CaseTrigger=new Trigger__c(Name='TriggerDMRequestTH',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(CaseTrigger);
      
      Trigger__c ContactTrigger=new Trigger__c(Name='TriggerLeadTH',Trigger_Name__c='TriggerLead',Trigger_Handler__c='LeadTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
      updatecustomsetting.add(ContactTrigger);
      
        
      
   return updatecustomsetting;
   }
}