@isTest
public class EmailnotificationLeadsnotassignedTest
{
  private static Account dealer;
  private static Lead__c lead;
   private static Account contact;
    public static testMethod void testAfterInsert()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
         Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
           User thisUser = [ select Id,email from User where Id = :UserInfo.getUserId() ];
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_Sales_Manager_Email__c = thisUser.email);
        insert dealer;       
        contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
        
        Test.startTest();       
          lead = new Lead__c(Assigned_Dealer__c = dealer.Id, Contact__c = contact.Id, RecordTypeId = retailLeadType.Id,Lead_Type__c = 'Used Car',CAC_Lead_Status__c = 'Allocated',Lead_Assignment_Notification_Done__c = False);
        insert lead;
       
            EmailnotificationLeadsnotassigned batcher = new EmailnotificationLeadsnotassigned ();           
            Database.executeBatch(batcher, 300);
           
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
         Test.stopTest();
         
    }
}