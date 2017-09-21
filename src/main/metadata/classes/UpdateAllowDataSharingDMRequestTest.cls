@isTest
public class UpdateAllowDataSharingDMRequestTest {
  private static Account dealer;
  private static Lead__c lead;
   private static Account contact;
    private static DM_Request__c dmrequest;
    private static Account contact2;
    private static DM_Request__c dmrequest2;
    public static testMethod void testUpdateAllowDataSharing()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
         Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
           User thisUser = [ select Id,email from User where Id = :UserInfo.getUserId() ];
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_Sales_Manager_Email__c = thisUser.email);
        insert dealer;       
        contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567', Allow_Data_Sharing2__c = 'No', MD__c = 'JP'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        contact2 = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567', Allow_Data_Sharing2__c = 'Yes', MB_Customer_Info_Remove__c = false, MD__c = 'JP'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        //RecordType retailAccountLinkType = [select Id, developername from recordtype where sobjecttype = 'Account_Link__c' and developername = 'Retail_Person'];
        
        Test.startTest();
        dmrequest = new DM_Request__c(Allow_Data_Sharing__c = true, Customer_Name__c = contact.Id, MD__c = 'JP');
        insert dmrequest;
		dmrequest2 = new DM_Request__c(Allow_Data_Sharing__c = false, Customer_Name__c = contact2.Id, MD__c = 'JP');
        insert dmrequest2;
                
        List<DM_Request__c> allist = [SELECT Id, Allow_Data_Sharing__c, Customer_Name__r.Allow_Data_Sharing2__c, Customer_Name__r.MB_Customer_Info_Remove__c 
                                         FROM DM_Request__c where MD__c = 'JP' 
                                         and (((Customer_Name__r.Allow_Data_Sharing2__c = 'No' or Customer_Name__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Customer_Name__r.Allow_Data_Sharing2__c != 'No' and Customer_Name__r.MB_Customer_Info_Remove__c = false)and Allow_Data_Sharing__c = false))];
        system.assertEquals(2, allist.size());
        
        
            UpdateAllowDataSharingDMRequest batcher = new UpdateAllowDataSharingDMRequest();           
            Database.executeBatch(batcher, 200);
        
           
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
         Test.stopTest();

                	allist = [SELECT Id, Allow_Data_Sharing__c, Customer_Name__r.Allow_Data_Sharing2__c, Customer_Name__r.MB_Customer_Info_Remove__c 
                                         FROM DM_Request__c where MD__c = 'JP' 
                                         and (((Customer_Name__r.Allow_Data_Sharing2__c = 'No' or Customer_Name__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Customer_Name__r.Allow_Data_Sharing2__c != 'No' and Customer_Name__r.MB_Customer_Info_Remove__c = false)and Allow_Data_Sharing__c = false))];
        system.assertEquals(0, allist.size());

        
    }

}