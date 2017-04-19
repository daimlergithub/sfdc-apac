@isTest
public class shareAccountRecordTest {
    public static Account Dealer;   
    public static Account personAcc;
    public static Case objCaseold;   
    public static testmethod void testshareAccountByAccountLink()
    { 
        
     Trigger__c TriggerShareAccountLinksToDealer=new Trigger__c(Name='ShareAccountLinksToDealer',Trigger_Name__c='ShareAccountLinksToDealer',Trigger_Handler__c='ShareAccountLinksToDealerTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
     insert TriggerShareAccountLinksToDealer;  
      List<Account> accList=new List<Account>();
      List<Lead__c> leadList=new List<Lead__c>();
      test.startTest();
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
      //  insert personAcc;
         accList.add(personAcc);
        insert accList;
        Group test1 = new Group();
        test1.Name = 'test dealer1';
        insert test1;
        objCaseold = new Case(AccountId = personAcc.Id);
        objCaseold.case_Dealer__C=Dealer.Id;
        UtilTestData.createSobject(objCaseold, UtilTestData.CASE_RT_CHRYSLER_COMPLAINT);
       List<Id> caseIds = new List<Id> ();
       caseIds.add(objCaseold.Id);       
    shareAccountRecord accSdh = new shareAccountRecord();
    shareAccountRecord.shareAccountRecordNow(caseIds);

    test.stopTest();
   } 
}