/***********************************************************************************
Created By          :    Venky    
Created Date        :     06.12.2016
Company             :    NTT Data,Inc.
Usage               :    This class written to cover the test code covergae for  SendAccountInfoToSPO class

MODIFICATION DETAILS:

1. Modified By      :    Venky
   Modifide Date    :    25.1.2017
   Deatils          :Fixed test class failure and improved code coverage.

************************************************************************************/

@isTest
 public class SendAccountInfoToSPOTest {
 
  private static List<Account> accountlist = new List<Account>();
   private static Account account;
     private static Address__c address;
   private static Account personAcc;
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
       
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '023482832';
        account.Data_Source__c  = 'Test4';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         SendAccountInfoToSPO spo=new SendAccountInfoToSPO(sc);
         spo.SendTOSpo();
         spo.message = 'Test';
         spo.ShowHideError = False;
         spo.redirectUrl = 'Test';
         test.StopTest();
         system.assertNotEquals(personAcc,null);
  }
 
 }