@isTest 
public with sharing class TriggerCampaignCityTest {
    public static Account dealer;
    Private static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static List<Campaign_City__c> cpCityList = new List<Campaign_City__c>();
    
 @isTest static void testCampaignHelper(){
     	 List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
		 insert updatecustomsettings;
 		String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
        String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
     
 		Test.startTest();
        
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
        
        Campaign cac = new Campaign(
            Name = 'cac', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = cacCampRecordTypeId,
            ParentId = top.Id
        );
        insert cac;
        Campaign_City__c campcity=new Campaign_City__c();
        campcity.Campaign__c=cac.id;
        campcity.Start_Date__c=system.today();
        campcity.End_Date__c=system.today()+1;
        insert campcity;
        delete campcity;
     	TriggerCampaignCityTriggerHandlerJP CampaignCityHandlerJP = new TriggerCampaignCityTriggerHandlerJP();
     	CampaignCityHandlerJP.handleTrigger(false, false, false, false, false);
     	CampaignCityHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
        Test.stopTest();
      
       system.assertEquals([select Campaign__c,Start_Date__c,End_Date__c from Campaign_City__c where id=:campcity.id].IsEmpty(),true);
 }
}