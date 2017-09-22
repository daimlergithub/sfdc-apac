@isTest
public class UpdateAllowDataSharingAccountLinkTest {
  private static Account dealer;
  private static Lead__c lead;
   private static Account contact;
    private static Account_Link__c accountlink;
    private static Account contact2;
    private static Account_Link__c accountlink2;
    private static Account contact3;
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
        contact3 = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567', Allow_Data_Sharing2__c = 'Yes', MB_Customer_Info_Remove__c = false, MD__c = 'JP'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        RecordType retailAccountLinkType = [select Id, developername from recordtype where sobjecttype = 'Account_Link__c' and developername = 'Retail_Person'];
        
        Test.startTest();
        accountlink = new Account_Link__c(Retail_Allow_Data_Sharing__c = 'Yes', fromRole__c = contact.Id, RecordTypeId = retailAccountLinkType.Id, MD__c = 'JP');
        insert accountlink;
		accountlink2 = new Account_Link__c(Retail_Allow_Data_Sharing__c = 'No', fromRole__c = contact2.Id, toRole__c = contact3.Id, RecordTypeId = retailAccountLinkType.Id, MD__c = 'JP');
        insert accountlink2;
                
        List<Account_Link__c> allist = [SELECT Id, Retail_Allow_Data_Sharing__c, fromRole__r.Allow_Data_Sharing2__c, 
                                         toRole__r.Allow_Data_Sharing2__c, fromRole__r.MB_Customer_Info_Remove__c, 
                                         toRole__r.MB_Customer_Info_Remove__c 
                                         FROM Account_Link__c where MD__c = 'JP' 
                                         and (((fromRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         toRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         fromRole__r.MB_Customer_Info_Remove__c = true or 
                                         toRole__r.MB_Customer_Info_Remove__c = true) and Retail_Allow_Data_Sharing__c != 'No') 
                                         or ((fromRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         toRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         fromRole__r.MB_Customer_Info_Remove__c != true and 
                                         toRole__r.MB_Customer_Info_Remove__c != true) and Retail_Allow_Data_Sharing__c = 'No'))];
        system.assertEquals(2, allist.size());
        
        
            UpdateAllowDataSharingAccountLink batcher = new UpdateAllowDataSharingAccountLink();           
            Database.executeBatch(batcher, 200);
        
           
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, batcher); 
         Test.stopTest();

                	allist = [SELECT Id, Retail_Allow_Data_Sharing__c, fromRole__r.Allow_Data_Sharing2__c, 
                                         toRole__r.Allow_Data_Sharing2__c, fromRole__r.MB_Customer_Info_Remove__c, 
                                         toRole__r.MB_Customer_Info_Remove__c 
                                         FROM Account_Link__c where MD__c = 'JP' 
                                         and (((fromRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         toRole__r.Allow_Data_Sharing2__c = 'No' or 
                                         fromRole__r.MB_Customer_Info_Remove__c = true or 
                                         toRole__r.MB_Customer_Info_Remove__c = true) and Retail_Allow_Data_Sharing__c != 'No') 
                                         or ((fromRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         toRole__r.Allow_Data_Sharing2__c != 'No' and 
                                         fromRole__r.MB_Customer_Info_Remove__c != true and 
                                         toRole__r.MB_Customer_Info_Remove__c != true) and Retail_Allow_Data_Sharing__c = 'No'))];
        system.assertEquals(0, allist.size());

        
    }
}