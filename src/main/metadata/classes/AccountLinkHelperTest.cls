@isTest
private class AccountLinkHelperTest {
private static Account dealer;
private static Account dealer1;
public static Contact contactObj;
  private static Vehicle__c vehicle;    
  private static Account objMaster; 
   private static Account objMaster1; 
   private static Address__c address;
  public static Id AccountLink_ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
   public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   public static Id personaccRecordTypeId1=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
  Private static String accountLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId(); 
    Private static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(); 
    Private static String contact2ContactType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(); 
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
  public static testMethod void test_nameParsing()
  {
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;
         objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = 'MasterAcc',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');    
        try{
        insert objMaster;
        }catch(exception e){}
          objMaster1= new Account(RecordTypeId=personaccRecordTypeId1,Master_Record__c = true,lastname = 'MasterAcc',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');    
        try{
        insert objMaster1;
        }catch(exception e){}
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123');
        insert dealer;
        dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
       Trigger__c TriggerDMR=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=false,insert__c=false,delete__c=false,after__c=false,before__c=false,enabled__c=false,Market__c='JP');
        insert TriggerDMR;
        Trigger__c TriggerDMR1=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        insert TriggerDMR1;
  
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert vehicle;
        Group test1 = new Group();
        test1.Name = dealer.name;
        insert test1;

         address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Tokyo';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=objMaster.id;
        address.TitleOfHonor__c = 'To Person';             
        insert address;
         objMaster.Primary_Address_Reference__c=address.id;
        update objMaster;
         Test.startTest();  
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = AccountLink_RetailPersonRecordTypeId , Name = 'contact2Contact', Vehicle__c = vehicle.Id,toRole__c=objMaster.id , fromRole__c = dealer.Id ,Retail_Address_Reference__c = address.Id,MD__c = 'JP');

        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        List<SharingWrapper> testSharingWrapC2C = wrapService.wrapContact2Contact(new List<Account_Link__c>{contact2Contact});
     insert contact2Contact;
     update contact2Contact;     
     //delete contact2Contact;
      string crmcode ;
      string name =  'nameDMS-';

      String testStr = AccountLinkHelper.nameParsing('nameDMS-');
      
      name = name.substring(name.indexOf('DMS-'));
      crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
      system.assertEquals(crmCode, testStr);
      test.stopTest();
  }
    public static testMethod void test_nameParsing1()
  {
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      //insert updatecustomsettings;
            Trigger__c TriggerDMR=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=false,insert__c=false,delete__c=false,after__c=false,before__c=false,enabled__c=false,Market__c='JP');
        insert TriggerDMR;
         Trigger__c TriggerDMR1=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        insert TriggerDMR1;
     objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = 'MasterAcc',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');    
        try{
        insert objMaster;
        }catch(exception e){}
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;
        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
            
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert vehicle;
         Test.startTest();  
          Account_Link__c contact2Contact = new Account_Link__c(Status__c = 'My Shops',RecordTypeId = AccountLink_ContactSectorRecordTypeId , MD__c = 'JP',Name = 'contact2Contact', Vehicle__c = vehicle.Id,toRole__c=objMaster.id , fromRole__c = dealer.Id,Retail_Delete_Flag__c = False);
        
     insert contact2Contact;
     update contact2Contact;
     delete contact2Contact;
      test.stopTest();
   }  
}