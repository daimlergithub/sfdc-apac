@isTest
public class ScheduleRetailCampCompletionTest
{
public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id childCampaign_RecordTypeID= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
      private static Account contact;
    public static testMethod void testAfterInsert()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
         contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        Test.startTest();       
        Retail_Campaign__c top = new Retail_Campaign__c(            
            Name = 'top',             
            Close_Date__c=date.Today(),
            RecordTypeId = parentCampaign_RecordTypeID 
        );
        
        insert top;
        Retail_Campaign__c top1 = new Retail_Campaign__c(            
            Name = 'top1',    Parent_Campaign1__c=top.Id,         
            Child_Campaign_Status__c='Execution',
            RecordTypeId = childCampaign_RecordTypeID
        );
        
        insert top1;
        Retail_Campaign_Member__c top2 = new Retail_Campaign_Member__c(        
            Retail_Campaign__c= top1.Id,Contact__c= contact.Id
        );
        
        insert top2;
         
            ScheduleRetailCampCompletion batcher = new ScheduleRetailCampCompletion();
     
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
         Test.stopTest();
         
    }
}