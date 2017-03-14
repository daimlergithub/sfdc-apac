@istest
public class ParticipateDealerHandlerTestJP
{
 private static Account dealer;
  private static Account dealer2;
  private static Participating_Dealer__c lead;   
     public static Contact contact;
   public static User sysAdminUser1;
    public static testMethod void testAfterInsert()
    {
     List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;   
          Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress; 
          Trigger__c TriggerAddress1=new Trigger__c(Name='TriggerParticipatingDealer',Trigger_Name__c='TriggerParticipatingDealer',Trigger_Handler__c='TriggerParticipateDealerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        insert TriggerAddress1;    
         RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email');
        insert dealer; 
        dealer2 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer2', MBK_Data_Source__c ='Email');
        insert dealer2;
        contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = 'sysAdmin1@dialmer.com';
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = dealer2.Id;
        contact.Dealer_Presales__c = true;
        insert contact;
        // Fetch Profile Id
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'Japan Dealer Sales Manager' limit 1].ID;
// Create User       
        sysAdminUser1 = new User ( Alias = 'sysA1'
                                        , Email='sysAdmin1@dialmer.com'
                                        , EmailEncodingKey='UTF-8'
                                        , LastName='Adminstrator'
                                        , FirstName='System'
                                        , LanguageLocaleKey='en_US'
                                        , LocaleSidKey='en_US'
                                        , ProfileId = sysAdminProfileId
                                        , TimeZoneSidKey='America/Los_Angeles'
                                        , Market__c = 'JP'
                                        , UserName='sysAdmin1@mbj.daimler-apac.com.asiadev1'
                                        , User_Type__c = 'Dealer'
                                        , ContactId = contact.Id);
        insert sysAdminUser1;                 
     Map<Id, Participating_Dealer__c> oldMap = new Map<Id, Participating_Dealer__c> ();
     List<Participating_Dealer__c> newList = new List<Participating_Dealer__c> ();
      
        Test.startTest();    
        lead = new Participating_Dealer__c (Dealer__c =dealer.Id );
        insert Lead;      
        oldMap.put(Lead.id , Lead);    
        Lead.Dealer__c =dealer2.Id;
        update lead;              
        newList.add(lead);  
       //TriggerParticipateDealerHandlerJP pj = new TriggerParticipateDealerHandlerJP();
        //pj.handleTrigger(TRUE,TRUE,TRUE,TRUE,TRUE);
        //pj.handleIntegrationTrigger(TRUE,TRUE,TRUE,TRUE,TRUE);
        ParticipateDealerHandlerJP cnt = new ParticipateDealerHandlerJP();
        ParticipateDealerHandlerJP.afterInsertEvent(newList);
        ParticipateDealerHandlerJP.afterUpdateEvent(newList,oldMap);
        Test.stopTest();
    }      
}