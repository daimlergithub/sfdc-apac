@isTest
public class AccountLinkControllerTest{
 
   private static List<Account> accountlist = new List<Account>();
   private static Account account;
   private static Account personAcc;
   private static Account companyAcc;
  public static testMethod void createTestData()
  {
  
      personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAcc;  
       
      companyAcc = new Account(Name='Test Company'
                        ,Email__c='test@compacc.com'
                        ,MD__c='JP'
                        ,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       insert companyAcc;
      
       /* account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '09440044090';
        account.Data_Source__c  = 'Test4';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account); */       
         
         Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
         Id Retailcompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(); 
        Account_Link__c acclnkcomp = new Account_Link__c(Name = 'Test Name',  toRole__c=personAcc.id, RecordTypeId = RetailPerson);
        insert acclnkcomp ;
        Account_Link__c acclnkcomp1 = new Account_Link__c(Name = 'Test Name1',  toRole__c=companyAcc.id, RecordTypeId = Retailcompany);
        insert acclnkcomp1;
        
         test.StartTest();
         ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         AccountLinkController spo=new AccountLinkController(sc);
         
         ApexPages.currentPage().getParameters().put('Id',companyAcc.id);
         ApexPages.StandardController sc1 = new ApexPages.StandardController(companyAcc);
         AccountLinkController spo1=new AccountLinkController(sc1);
         //spo1.ab();
         spo1.DeleteRetailCopy();
         test.StopTest();
   }
}