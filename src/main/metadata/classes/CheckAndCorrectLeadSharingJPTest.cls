@isTest
public class CheckAndCorrectLeadSharingJPTest {
  private static Account dealer;
   private static Account contact;
    private static Lead__c lead;
    private static Account contact2;
    private static Lead__c lead2;
    public static testMethod void testCheckAndCorrectLeadSharingJP()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
         Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
           User thisUser = [ select Id,email from User where Id = :UserInfo.getUserId() ];
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test_dealer', MBK_Data_Source__c ='Email',Dealer_Sales_Manager_Email__c = thisUser.email, Dealer_GC_Code__c = '9999GCCode', MD__c = 'JP');
        insert dealer;
        
        Group newDealerPublicGroup = new Group(Name = 'test_dealer', Type = 'Regular', DeveloperName = 'test_dealer');
        insert newDealerPublicGroup;
        contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567', Allow_Data_Sharing2__c = 'No', MD__c = 'JP'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        contact2 = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567', Allow_Data_Sharing2__c = 'Yes', MB_Customer_Info_Remove__c = false, MD__c = 'JP'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        //RecordType retailAccountLinkType = [select Id, developername from recordtype where sobjecttype = 'Account_Link__c' and developername = 'Retail_Person'];
        RecordType leadSalesType = [select Id from RecordType where SObjectType = 'Lead__c' and DeveloperName = 'Sales_Leads' limit 1];
        RecordType leadAftersalesType = [select Id from RecordType where SObjectType = 'Lead__c' and DeveloperName = 'Aftersales_Leads' limit 1];        
        
        Test.startTest();
        lead = new Lead__c(Allow_Data_Sharing__c = true, Contact__c = contact.Id, MD__c = 'JP', Assigned_Dealer__c = dealer.Id, CAC_Lead_Status__c = 'Allocated', RecordTypeId = leadSalesType.Id);
        insert lead;
		lead2 = new Lead__c(Allow_Data_Sharing__c = false, Contact__c = contact2.Id, MD__c = 'JP', Assigned_Dealer__c = dealer.Id, CAC_Lead_Status__c = 'Allocated', RecordTypeId = leadAftersalesType.Id);
        insert lead2;
        
        List<Lead__share> leadShareList = [select Id from Lead__Share where Rowcause IN('Assigned_Dealer__c', 'Manual')];
        Database.delete(leadShareList);
        
        List<Lead__c> allist = [select Id, Name, Lead_Assignment_Notification_Done__c, 
                                         CreatedBy.Name, Drop_off_Time__c, Portal_Request_ID__c, 
                                         Assigned_Dealer__r.Name, Assigned_Dealer__r.Dealer_GC_Code__c, 
                                         CreatedDate, Created_By_EP_Transaction__c from Lead__c 
                                         where CAC_Lead_Status__c = 'Allocated' and CreatedDate = LAST_N_DAYS:2 
                                         and Assigned_dealer__c != '' and RecordType.DeveloperName IN ('Sales_Leads', 'Aftersales_Leads') 
                                         and Id Not in (select ParentID from Lead__Share where Rowcause IN('Assigned_Dealer__c', 'Manual'))];
        system.assertEquals(2, allist.size());
        
        
            CheckAndCorrectLeadSharingJP batcher = new CheckAndCorrectLeadSharingJP();           
            Database.executeBatch(batcher, 200);
        
           
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
         Test.stopTest();

                	allist = [select Id, Name, Lead_Assignment_Notification_Done__c, 
                                         CreatedBy.Name, Drop_off_Time__c, Portal_Request_ID__c, 
                                         Assigned_Dealer__r.Name, Assigned_Dealer__r.Dealer_GC_Code__c, 
                                         CreatedDate, Created_By_EP_Transaction__c from Lead__c 
                                         where CAC_Lead_Status__c = 'Allocated' and CreatedDate = LAST_N_DAYS:2 
                                         and Assigned_dealer__c != '' and RecordType.DeveloperName IN ('Sales_Leads', 'Aftersales_Leads') 
                                         and Id Not in (select ParentID from Lead__Share where Rowcause IN('Assigned_Dealer__c', 'Manual'))];
        system.assertEquals(0, allist.size());

        
    }

}