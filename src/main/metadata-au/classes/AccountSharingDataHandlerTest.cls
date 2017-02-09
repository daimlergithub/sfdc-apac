@istest
public with sharing class AccountSharingDataHandlerTest 

{
  public static Account personAcc;
  public static Account Dealer;   
  public static Lead__c testLead;
  public static Vehicle_Relationship__c vRel;
  public static Vehicle__c vehicles;
  public static user usr;
  private static Case objCase;
  private static Account_Link__c AccLink;
  public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
  public static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
  public static Profile SystemAdmin = [select Id from Profile where Name = 'System Administrator' limit 1];  
    
    
    public static testmethod void test_createShareObject()
    {
        createTestData();
        
        Map<id,Account> newData = new Map<id,Account>();
        newData.put(Dealer.id, Dealer);
        Map<id,Account> oldData = new Map<id,Account>();
        oldData.put(Dealer.id, Dealer);
        Map<id,Account_Link__c> newDataAl = new Map<id,Account_Link__c>();
        newDataAl.put(AccLink.id, AccLink);
        Map<id,Account_Link__c> oldDataAl = new Map<id,Account_Link__c>();
        oldDataAl.put(AccLink.id, AccLink);
        test.startTest();
        AccountSharingDataHandler accSdh = new AccountSharingDataHandler('processFlg');
        Sobject Shareobj =  accSdh.createShareObject(personAcc.id, usr.id);
        accSdh.shareDealerByCrmCode(newData, oldData, false);
        accSdh.shareAccountByAccountLink(newDataAl, oldDataAl, false);
        accSdh.deleteOldShare(oldData,'Dealer');
        test.stopTest();
        system.assertNotEquals(null, Shareobj);
    }
    
    
    public static testmethod void test_shareAccountByCRMCode()
    {
        createTestData();
        
        Map<id,Case> newDataC = new Map<id,Case>();
        newDataC.put(objCase.id, objCase);
        Map<id,Case> oldDataC = new Map<id,Case>();
        oldDataC.put(objCase.id, objCase);
        
        Map<id,Lead__c> newData = new Map<id,Lead__c>();
        newData.put(testLead.id, testLead);
        Map<id,Lead__c> oldData = new Map<id,Lead__c>();
        oldData.put(testLead.id, testLead);
        Map<id,Vehicle_Relationship__c> newDataVr = new Map<id,Vehicle_Relationship__c>();
        newDataVr.put(vRel.id, vRel);
        Map<id,Vehicle_Relationship__c> oldDataVr = new Map<id,Vehicle_Relationship__c>();
        oldDataVr.put(vRel.id, vRel);
        test.startTest();
        AccountSharingDataHandler accSdh = new AccountSharingDataHandler('processFlg');
        Sobject Shareobj =  accSdh.createShareObject(personAcc.id, usr.id);
        accSdh.shareAccountByCRMCode(newData, oldData, false);
        accSdh.shareAccountByRetailVR(newDataVr, oldDataVr, true);
        accSdh.shareAccountByComplaint(newDataC, oldDataC, true);
       
        test.stopTest();
        system.assertNotEquals(null, Shareobj);
    }
    static void createTestData()
  {
      
       Dealer = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_CRM_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '180801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',
                                    
                                    ZipCode__c='000000',
                                    RecordTypeId=DealerRecordtypeid);
       
       insert Dealer;

      personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_CRM_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '801801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='0000001',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',
                                     Email__c='test011@test.com',
                                    Email2__c='test012@test.com',
                                    Home_Phone_2__c='5879458745',
                                    RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc;


        objCase = new Case(AccountId = personAcc.Id);
        UtilTestData.createSobject(objCase, UtilTestData.CASE_RT_CHRYSLER_COMPLAINT);



      
      testLead = new Lead__c();
        //testLead.Need_Assign_To_Dealer__c = 'Need';
        testLead.Contact__c = personAcc.id;
        testLead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Service Lead').getRecordTypeId();
        testLead.Lead_Type__c = 'New Car';
        testLead.Relation_With_The_Leads__c = 'I owner';
        testLead.Purchase_Time__c = '0 - 3 months';
        testLead.Interested_Vehicle_Brand__c = 'MB';
        testLead.Purchase_Time__c = '0 - 3 months';
        testLead.Assigned_Dealer__c = Dealer.id;
        insert testLead;
      vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
       insert vehicles;
       
        vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = VRRecordTypeId);
        vRel.Contact__c = personAcc.id;
       vRel.Vehicle_ID__c = vehicles.id;
        insert vRel;
      
      
      usr = new User(
            Username = System.now().millisecond() + 'systemadmin@test.com',
            
            ProfileId = SystemAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty1',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        insert usr;
      
      AccLink = new Account_Link__c();
      AccLink.fromRole__c = personAcc.Id;
      AccLink.toRole__c =  Dealer.Id;
      
      
      
  }




}