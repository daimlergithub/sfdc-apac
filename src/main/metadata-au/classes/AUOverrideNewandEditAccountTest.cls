@isTest
public class AUOverrideNewandEditAccountTest
{
private static Account objAccount;
private static Account personAcc;
private static Contact testContact;
private static id accid; 
private static id personaccid;
private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
private static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
 
 static testMethod void TestsaveAccount()
    {
    createAccount();
    test.startTest();
    ApexPages.currentPage().getParameters().put('recordId',objAccount.id);
     ApexPages.currentPage().getParameters().put('Type','company');
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      AUOverrideNewandEditForAccountController AUcontroller= new AUOverrideNewandEditForAccountController(objSc);
      AUcontroller.saveAccount();
       AUcontroller.saveNew();
       AUcontroller.cancel();
     AUcontroller.getAccountDeatails(accid);
      test.stopTest();
       system.assertNotEquals(null,objAccount.id);
       
    }
    
    static testMethod void TestsaveNew() 
    {
    createPersonAccount();
    test.startTest();
    ApexPages.currentPage().getParameters().put('recordId',personAcc.id);
    ApexPages.currentPage().getParameters().put('Type','person');
      ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
      AUOverrideNewandEditForAccountController AUcontroller= new AUOverrideNewandEditForAccountController(objSc);
      AUcontroller.saveAccount();
      AUcontroller.saveNew();
       AUcontroller.cancel();
       
       AUcontroller.getPersonAccountDeatails(personaccid);
      test.stopTest();
      system.assertNotEquals(null,personAcc.id);
      
       
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
    objAccount.Business_Unit__c='Alliance';
    insert objAccount;
     accid=objAccount.id;
       testContact = new Contact ( AccountId = objAccount.id,
                                         Dealer_Complaint_Gate_Keeper__c = true,      
                                         Inactive__c=false,
                                         Business_Unit__c='Alliance',
                                         Sub_BusinessUnit__c='Finance',
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false,Salutation='DRM MBFS');
          insert testContact;
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
     personaccid=personAcc.id;
       }
}