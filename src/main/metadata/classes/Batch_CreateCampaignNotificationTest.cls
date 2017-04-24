@isTest
public class Batch_CreateCampaignNotificationTest
{
    static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    static String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
   
    public static testMethod void testAfterInsert()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        Test.startTest();       
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c = 'Email',
            Child_Campaign_Status__c = 'Segmentation',
            Execution_Start_Date__c = Date.Today(),
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
         
            Batch_CreateCampaignNotification batcher = new Batch_CreateCampaignNotification();
            Database.executeBatch(batcher, 300);
         Test.stopTest();
         
    }
}