@isTest
public class AUAssignVFPageToRecordTypeControllerTest
{
private static Account objAccount;
private static Account personAcc;
private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
private static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
 
 static testMethod void TestredirectToPage()
    {
    createAccount();
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AUAssignVFPageToRecordTypeController AUcontroller= new AUAssignVFPageToRecordTypeController(objSc);
      AUcontroller.redirectToPage();
      test.stopTest();
       system.assertNotEquals(null,objAccount.id);
        system.assertEquals(AUcontroller.recordId,objAccount.id);
    }
    
    static testMethod void TestredirectToPageElse()
    {
    createPersonAccount();
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',personAcc.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
      AUAssignVFPageToRecordTypeController AUcontroller= new AUAssignVFPageToRecordTypeController(objSc);
      AUcontroller.redirectToPage();
      test.stopTest();
      system.assertNotEquals(null,personAcc.id);
      system.assertEquals(AUcontroller.recordId,personAcc.id);
       
    }
    
    static void createAccount()
  {
    objAccount= new Account();
    objAccount.RecordtypeId=companyAccRecordTypeId;
    objAccount.Name='Test Person 1st';
    objAccount.Type='Personal';
    objAccount.Status__c='Active';
    objAccount.Province__c='Province1';
    objAccount.City__c='Test';
    objAccount.Email__c='test@mbau.com';
    objAccount.Mobile__c ='8884545243';
    insert objAccount;
  }
   
    
   static void createPersonAccount()
  {
  personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',
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
                                    
                                    RecordTypeId=strPerson);
       
       insert personAcc;
       }
  
}