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
      String testStr1 = AccountLinkHelperKR.nameParsing('nameDMS-');
      name = name.substring(name.indexOf('DMS-'));
      crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
      system.assertEquals(crmCode, testStr);
      system.assertEquals(crmCode, testStr1);
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
   
    public static testMethod void beforeupdateEventAddressTest(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,Retail_UCID__c,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Gender__c='Male';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.beforeInsertUpdateEvent(listcampaigns1,oldMap);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
   
   public static testMethod void beforeupdateEventAddressTest1(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,Retail_UCID__c,RecordTypeId,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Full_Name__c='sai saranya';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
        public static testMethod void beforeupdateEventAddressTest12(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,Retail_UCID__c,RecordTypeId,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Full_Name_Title__c='Ms';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          //AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
    public static testMethod void beforeupdateEventAddressTest13(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,Retail_UCID__c,RecordTypeId,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_FirstName__c='Sai';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
         public static testMethod void beforeupdateEventAddressTest14(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',Retail_Company_Name__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,RecordTypeId,fromRole__c,Retail_UCID__c,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Company_Name__c='Sai';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                 al1.Retail_Preferred_Language__c='Japan';
           update al1;
           update listcampaigns1;
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
   
    public static testMethod void beforeupdateEventAddressTest15(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,RecordTypeId,fromRole__c,Retail_UCID__c,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Position__c='Sai';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           insert vecle;
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
   
   public static testMethod void beforeupdateEventAddressTest16(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,RecordTypeId,fromRole__c,Retail_UCID__c,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Preferred_Language__c='Japan';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       
        public static testMethod void beforeupdateEventAddressTest17(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',status__c='Last Selling',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,RecordTypeId,fromRole__c,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           al1.fromRole__c=accobj3.id;
           al1.Retail_Preferred_Language__c='Japan';
           al1.Status__c='My Shop';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
   public static testMethod void beforeupdateEventAddressTest18(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',status__c='Last Selling',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           al1.fromRole__c=accObj3.id;
           al1.Status__c='My Shop';
           al1.Retail_Preferred_Language__c='Japan';
           update al1;
           update listcampaigns1;
           
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       
         public static testMethod void beforeupdateEventAddressTest19(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Account accObj4 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj4;
            
             
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',status__c='Last Selling',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           al1.toRole__c=accObj4.id;
           al1.Status__c='My Shop';
           al1.Retail_Preferred_Language__c='Japan';
           update al1;
           update listcampaigns1;
           
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
           al1.Status__c='My Shops';
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       public static testMethod void beforeupdateEventAddressTest20(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Account accObj4 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj4;
            
             
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
          
           al1.Status__c='My Shop';
           al1.Retail_Special_Care__c='TestJa';
           update al1;
           update listcampaigns1;
           
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
      
    public static testMethod void beforeupdateEventAddressTest21(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,Retail_Related_Company__c=al2.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           AccountLinkHelper.updateRetailCopyfromC2C(true,true,true,listcampaigns1);
           AccountLinkHelperKR.updateRetailCopyfromC2C(true,true,true,listcampaigns1);
           AccountLinkHelperKR.updateRetailPositionfromC2C(true,true,true,listcampaigns1);
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
          
           al1.Status__c='My Shop';
           al1.Retail_Special_Care__c='TestJa';
           update al1;
           update listcampaigns1;
          
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
        public static testMethod void updateAccountlinksonPrimaryAddressTest(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,Retail_Related_Company__c=al2.id,Retail_Allow_Data_Sharing__c='No', Retail_Address_Reference__c=address1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
          al1.Retail_Allow_Data_Sharing__c='Yes';
           al1.Status__c='My Shop';
           al1.Retail_Special_Care__c='TestJa';
           update al1;
           update listcampaigns1;
          AccountLinkHelper.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
     public static testMethod void afterInsertDeleteEventTest(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
           
             Survey__c sur= new Survey__c();
             sur.name = 'testsurvey';
            insert sur;
          SurveyTaker__c st = new SurveyTaker__c();
           // st.account__c = accobj1.id;
            st.survey__c = sur.id;
           insert st;
           
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,Retail_Fax__c='0123456',Retail_Related_Company__c=al2.id,Retail_Allow_Data_Sharing__c='No', Retail_Address_Reference__c=address1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,Retail_Fax__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           al1.Retail_Fax__c='0123476';
           update al1;
           update listcampaigns1;
           AccountLinkHelper.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelper.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          
           AccountLinkHelperKR.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       
        public static testMethod void afterDeleteEventTest(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
            
            
            Survey__c sur= new Survey__c();
            sur.name = 'testsurvey';
            insert sur;
            list<SurveyTaker__c> listsurvey=new list<SurveyTaker__c>();
          SurveyTaker__c st = new SurveyTaker__c();
            st.account__c = accobj1.id;
            st.survey__c = sur.id;
           listsurvey.add(st);
            insert listsurvey;
            
            group g=new group();
            g.name='Dealer';
            insert g;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
           
            
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Fax__c='0123456',Retail_Related_Company__c=al2.id,Retail_Allow_Data_Sharing__c='No', Retail_Address_Reference__c=address1.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,Retail_Fax__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           al1.Retail_Fax__c='0123476';
           update al1;
           update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterDeleteEvent(listcampaigns1);
           AccountLinkHelper.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelper.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterDeleteEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           
           
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
            AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
        public static testMethod void updateRetailCopyTest(){
           
           
            Account accObj1= new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Foundation_Date__c=system.today(),
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            
            insert accObj1;
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer',Phone ='09874760605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
           
             Survey__c sur= new Survey__c();
             sur.name = 'testsurvey';
            insert sur;
          SurveyTaker__c st = new SurveyTaker__c();
           // st.account__c = accobj1.id;
            st.survey__c = sur.id;
           insert st;
           
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',Retail_ZipCode__c='1003466',toRole__c=accobj1.id,Retail_Fax__c='0123456',Retail_Related_Company__c=al2.id,Retail_Allow_Data_Sharing__c='No', Retail_Address_Reference__c=address1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,Retail_Fax__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           al1.Retail_ZipCode__c='1003465';
           update al1;
           update listcampaigns1;
           //AccountLinkHelperKR.updateRetailCopy(true,true,true,listcampaigns1);
          AccountLinkHelper.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelper.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          
          AccountLinkHelperKR.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           
            AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       public static testMethod void afterUpdateEventTest1(){
           
           
            Account accObj1= new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Foundation_Date__c=system.today(),
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            
            insert accObj1;
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done');
            insert accobj2;
            
             Id recordTypeAccDealerAccountObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj3 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId1,Name='Dealer1',Phone ='09874766605');
            insert accobj3;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
           
             Survey__c sur= new Survey__c();
             sur.name = 'testsurvey';
            insert sur;
          SurveyTaker__c st = new SurveyTaker__c();
           // st.account__c = accobj1.id;
            st.survey__c = sur.id;
           insert st;
           
             Account_Link__c al2= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            insert al2;
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',Retail_Delete_Flag__c=false,MD__c='JP',Retail_City__c='Hyd',toRole__c=accobj1.id,Retail_Fax__c='0123456',Retail_Related_Company__c=al2.id,Retail_Allow_Data_Sharing__c='No', Retail_Address_Reference__c=address1.id,fromRole__c=accobj2.id,Retail_Special_Care__c='Test',Retail_Preferred_Language__c='English',status__c='My Shops',Retail_Position__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           system.debug('listcampaigns1--'+listcampaigns1);
           
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,fromRole__c,Retail_Fax__c,RecordTypeId,Retail_UCID__c,Retail_LastName__c,Status__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.fromRole__c=accobj3.id;
           al1.Retail_City__c='Vjy';
           update al1;
           update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
          
           AccountLinkHelper.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelper.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          
          AccountLinkHelper.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelper.afterInsertEvent(listcampaigns1);
          
          
          AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
          
           AccountLinkHelperKR.afterInsertDeleteEvent(listcampaigns1);
          AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(listcampaigns1,oldMap,false,true);
          
          AccountLinkHelperKR.ExportNotification(listcampaigns1,oldMap);
          
          AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
          al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
              update al1;
          update listcampaigns1;
           AccountLinkHelper.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           
           AccountLinkHelperKR.afterUpdateEvent(listcampaigns1,oldMap);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
           
          
           Vehicle__c vecle = new Vehicle__c (Brand__c='Mercedes-Benz',Related_contact__c=accobj1.id);
           al1.Vehicle__c=vecle.id;
            al1.RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
          update al1;
          update listcampaigns1;
           AccountLinkHelper.afterInsertEvent(listcampaigns1);
           AccountLinkHelperKR.afterInsertEvent(listcampaigns1);
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                
         
               system.assertNotEquals('ggg',listcampaigns1[0].Name);
           
       }
       
}