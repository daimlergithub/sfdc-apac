@istest
public class ParticipateDealerHandlerTestJP
{
 private static Account dealer;
  private static Account dealer2;
  public Static Account DealerAccount;
  private static Participating_Dealer__c lead;   
     public static Contact contact;
     Public static List<Dealer_List_Member__c> dlList = new List<Dealer_List_Member__c>();
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
     
     public static testMethod void test_DealerListMember()
    {
      
    Trigger__c TriggerDLM=new Trigger__c(Name='DealerListMember',Trigger_Name__c='triggerDealerListMember',Trigger_Handler__c='TriggerDealerListMemberTriggerHandlerJP',update__c=False,insert__c=True,delete__c=False,after__c=True,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerDLM;
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
      DealerAccount= new Account();
        DealerAccount.RecordtypeId=dealerType.id;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
         DealerAccount.Dealer_GC_Code__c='12345';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        insert DealerAccount;
        lead = new Participating_Dealer__c (Dealer__c =DealerAccount.Id );
        insert Lead;
       Group grp=new Group();
        grp.name=DealerAccount.Name;
        insert grp;
        
        Dealer_List_Member__c dl = new Dealer_List_Member__c();
         dl.Participating_Dealer__c=lead.id;
         test.starttest();
         insert dl;
         dlList.add(dl);
         
         DealerListMemberHelperJP dj = new DealerListMemberHelperJP();
         DealerListMemberHelperJP.afterInsertEvent(dlList);
         test.stoptest();
    }    
}