@isTest
public class EmailnotificationLeadsnotupdatedTest
{
  private static Account dealer;
  private static Lead__c lead;
   private static Account contact;
    public static testMethod void testAfterInsert()
    {
        UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj)
        {        
          User user2 = UtilTestData.createPortalUser('Dealer User','Japan Dealer Sales Manager');     
          contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567',MD__c = 'JP',OwnerId = user2.Id), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
         Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
        //   User thisUser = [ select Id,email from User where Id = :UserInfo.getUserId() ];
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',MD__c = 'JP',Lead_No_Update_Notification_Disable__c=false, RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_Sales_Manager_Email__c = user2.email);
        insert dealer;       
       
        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Aftersales_Leads'];
        
            
          lead = new Lead__c(Assigned_Dealer__c = dealer.Id,Service_Advisor__c=user2.id ,  MD__c = 'JP',Contact__c = contact.Id, RecordTypeId = retailLeadType.Id,Appointment_DateTime__c = Date.Today(),CAC_Lead_Status__c = 'New',Lead_Assignment_Notification_Done__c = False,Dealer_Lead_Status__c='Order Placed');
        insert lead;
       //system.debug('HHHHH'+lead);     
       List<Lead__c> leadList= new List<Lead__c>();
       leadList.add(lead); 
       Test.startTest();  
            system.assertNotEquals(null,retailLeadType);
            EmailnotificationLeadsnotupdated batcher = new EmailnotificationLeadsnotupdated();           
            Database.executeBatch(batcher, 300);
            batcher.execute(null,leadList);
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
            system.assertEquals('New',lead.CAC_Lead_Status__c ); 
         Test.stopTest();
        }   
    }
}