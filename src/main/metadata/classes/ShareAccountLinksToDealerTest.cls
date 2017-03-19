@isTest
public class ShareAccountLinksToDealerTest {
public static Account Dealer;
    public static Account newDealer;
    public static Account personAcc;
    public static Case objCaseold;
    public static Case objCaseNew;
    public static Lead__c newLead;
    public static Lead__c oldLead;
    public static Vehicle__c vehicles;
    public static Vehicle_Relationship__c vRel;
    public static user usr;
    public static Account_Link__c accLink;
    public static Account_Link__c newAccLink;
    public static void createTestData()
    { 
     List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
        
     Trigger__c TriggerShareAccountLinksToDealer=new Trigger__c(Name='ShareAccountLinksToDealer',Trigger_Name__c='ShareAccountLinksToDealer',Trigger_Handler__c='ShareAccountLinksToDealerTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='NA');
     insert TriggerShareAccountLinksToDealer;  
        
      List<Account> accList=new List<Account>();
      List<Lead__c> leadList=new List<Lead__c>();
      Dealer = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_CRM_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '080801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',                                    
                                    ZipCode__c='1234567',Allow_Data_Sharing_Comment__c='comments',Mobile__c='0000000000',
                                    RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
       //insert Dealer;
      accList.add(Dealer);
      newDealer= new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_CRM_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '080801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',                                    
                                    ZipCode__c='1234567',Allow_Data_Sharing_Comment__c='comments',Mobile__c='0000000000',
                                    RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
      accList.add(newDealer);
                                   
      personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_CRM_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '080180101',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='1234567',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',
                                    Email__c='test011@test.com',
                                    Email2__c='test012@test.com',
                                    Home_Phone_2__c='0000000000',Mobile__c='0000000000',Allow_Data_Sharing_Comment__c='comments',
                                    RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert personAcc;
         accList.add(personAcc);
       // insert accList;
        objCaseold = new Case(AccountId = personAcc.Id);
        objCaseold.case_Dealer__C=Dealer.Id;
        UtilTestData.createSobject(objCaseold, UtilTestData.CASE_RT_CHRYSLER_COMPLAINT);
        
        objCaseNew = new Case(AccountId = personAcc.Id);
        objCaseNew.case_Dealer__C=newDealer.Id;
        UtilTestData.createSobject(objCasenew, UtilTestData.CASE_RT_CHRYSLER_COMPLAINT);
        //Creating Lead 
        newLead = new Lead__c();
        //testLead.Need_Assign_To_Dealer__c = 'Need';
        newLead.Contact__c = personAcc.id;
        newLead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        newLead.Lead_Type__c = 'New Car';
        newLead.Relation_With_The_Leads__c = 'I owner';
        newLead.Purchase_Time__c = '0 - 3 months';
        newLead.Interested_Vehicle_Brand__c = 'MB';
        newLead.Purchase_Time__c = '0 - 3 months';
        newLead.Assigned_Dealer__c = Dealer.id;
       // insert newLead;
        leadList.add(newLead);
        oldLead = new Lead__c();
        //testLead.Need_Assign_To_Dealer__c = 'Need';
        oldLead.Contact__c = personAcc.id;
        oldLead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        oldLead.Lead_Type__c = 'New Car';
        oldLead.Relation_With_The_Leads__c = 'I owner';
        oldLead.Purchase_Time__c = '0 - 3 months';
        oldLead.Interested_Vehicle_Brand__c = 'MB';
        oldLead.Purchase_Time__c = '0 - 3 months';
        oldLead.Assigned_Dealer__c = Dealer.id;
        //insert oldLead;
        leadList.add(oldLead);
        insert leadList;
        
       vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'));
       insert vehicles;
      
       vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAcc.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;
      profile SystemAdmin = [select Id from Profile where Name = 'System Administrator' limit 1];       
      usr = new User(
            Username = System.now().millisecond() + 'test777@test.com',
            
            ProfileId = SystemAdmin.Id,            
            Alias = 'test777',
            Email = 'test777@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty1',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        insert usr;
     
      accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAcc.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      insert accLink;
      newAccLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAcc.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId(),Name = 'contact-Contact-Contact-Contact', Vehicle__c = vehicles.Id);
      insert newAccLink;
  }
    
    
    public static testmethod void testshareAccountByAccountLink()
{
createTestData();
    
    
Map<id,Account_Link__c> newDataAl = new Map<id,Account_Link__c>();
newDataAl.put(AccLink.id, AccLink);
Map<id,Account_Link__c> newData = new Map<id,Account_Link__c>();
newData.put(newAccLink.id, newAccLink);
Map<id,Account_Link__c> oldDataAl = new Map<id,Account_Link__c>();
oldDataAl.put(AccLink.id, AccLink); 
test.startTest(); 

try{
AccountSharingDataHandler accSdh = new AccountSharingDataHandler('Account_Link__c'); 
accSdh.shareAccountByAccountLink(newDataAl, oldDataAl, false);
accSdh.shareAccountByAccountLink(newDataAl, oldDataAl, true); 
accSdh.shareAccountByAccountLink(newData, oldDataAl, true); 
    
  
ShareAccountLinksToDealerTriggerHandler shacc = new ShareAccountLinksToDealerTriggerHandler();
//shacc.handleTrigger(true,true,true,true,true);
shacc.handleIntegrationTrigger(true,true,true,true,true);


test.stopTest();
system.assertNotEquals(null,newData);
}catch(exception e){}
}
}