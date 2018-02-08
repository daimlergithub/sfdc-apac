@isTest
public class EmailnotificationLeadsTest
{
  private static Account dealer;
  private static Lead__c lead;
   private static Account contact;
    public static testMethod void testAfterInsert()
    {
   
        //User thisUser = [ select Id,email from User where Id = :UserInfo.getUserId() ];
        UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];   
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',UserRoleId = portalRole1.Id,
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        //DMLManagerService.insertAsSystem(user_Obj);
        system.runAs(user_Obj)
        {
         User user2 = UtilTestData.createPortalUser('Dealer User','Japan Dealer Sales Manager');   
         
         contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567',OwnerId = user2.Id), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                   
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
         Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_Sales_Manager_Email__c = user2.email,SalesLead_Notification_Timing__c = '3 times a day');
        insert dealer;       
        
       // RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
        
          RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Sales_Leads'];               
          lead = new Lead__c(Assigned_Dealer__c = dealer.Id, MD__c = 'JP' ,Contact__c = contact.Id, RecordTypeId = retailLeadType.Id,Lead_Type__c = 'Used Car',CAC_Lead_Status__c = 'Allocated',Lead_Assignment_Notification_Done__c = false,Lead_DataSource__c='Dealers');
        insert lead;
        //Assigned_Dealer__r.Dealer_GC_Code__c   
       
        List<Lead__c> leadList= new List<Lead__c>();
        leadList.add(lead);
           Test.startTest();
            system.assertEquals(True, leadList.size()>0);
            EmailnotificationLeads batcher = new EmailnotificationLeads();           
            Database.executeBatch(batcher, 300);
            //batcher.execute(null,leadList);
            //batcher.Finish(null);
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
            system.assertEquals(false,lead.Lead_Assignment_Notification_Done__c) ;     
         Test.stopTest();
        

             
        }
    }
}