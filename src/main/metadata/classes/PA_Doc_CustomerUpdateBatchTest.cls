/*
    Type:Test class
    Purpose:Test Class for PA_Doc_CustomerUpdateBatch
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 22-08-2018 by Ashish vashisht
    2. Modified     
*/
@isTest 
public class PA_Doc_CustomerUpdateBatchTest
{
    public static User user2=TestUtils.IntegrationAPIUser();
    public static User user1 = TestUtils.createTRAdminUser();
    public static List<Account>acclst= new List<Account>();
    public static List<Account_link__c>acclnklst= new List<Account_link__c>();
    public static Id dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static Id Person_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Retail Person');
    public static testmethod void testMethod1() 
    {
        
        system.runas(user2)
        {

            Account acct1= new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           //Individual_Home_Phone__c = '02-202-2456',
                           Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212378978',Personal_Agreement__c ='Yes',Updated_Consent_Date__c = date.valueOf('2007-05-05'),
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '03',
                           MD__c = 'TR',
                           Market__c = 'TR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name1',
                           Salutation = 'Unknown',
                           Postal_Opt_Out__c=false,     
                           Province__c = 'Shanghai',
                           ZipCode__c= '32703',
                           //Mobile__c = '918197597651',
                           //Mobile2__c = '918197597651',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           PersonDoNotCall=false,
                           // ownerid=user1.id,
                           PersonHasOptedOutOfEmail=false,
                           Opt_In_Email__c=false,
                           Data_Source__c='Employee Referral',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
                           
            
                           
            Account acct3= new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           //Individual_Home_Phone__c = '02-202-2456',
                           Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212378978',Personal_Agreement__c ='Yes',Updated_Consent_Date__c = date.valueOf('2007-05-05'),
                           Status__c='NoCustomer',Email__c = 'testemail23@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '03',
                           MD__c = 'TR',
                           Market__c = 'TR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name1',
                           Salutation = 'Unknown',
                           Postal_Opt_Out__c=True,     
                           Province__c = 'Shanghai',
                           ZipCode__c= '32703',
                           //Mobile__c = '918197597651',
                           //Mobile2__c = '918197597651',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           PersonDoNotCall=True,
                           // ownerid=user1.id,
                           PersonHasOptedOutOfEmail=True,
                           Opt_In_Email__c=true,
                           Data_Source__c='Employee Referral',
                           //owner=user1,
                           //PersonBirthdate=date.today(),
                           
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
        
            acclst.add(acct1);
            acclst.add(acct3);
            
            insert acclst;
            
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            insert dealer1;
            
            Account_Link__c acclnk1 = new Account_Link__c(Name = 'aTest',ToRole__c = acct1.Id, fromRole__c = dealer1.id, ReCordTypeId = Person_RecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=true,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=true,Retail_SMS_OptOut__c=true);
            acclnklst.add(acclnk1);
            
            
            
            Account_Link__c acclnk3 = new Account_Link__c(Name = 'aTest',ToRole__c = acct3.Id, fromRole__c = dealer1.id, ReCordTypeId = Person_RecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=true,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=true,Retail_SMS_OptOut__c=true);
            acclnklst.add(acclnk3);
            
            insert acclnklst;
            
            test.starttest(); 
                PA_Doc_CustomerUpdateBatch b = new PA_Doc_CustomerUpdateBatch();
                Database.executebatch(b);
            test.stoptest(); 
        }
    }
    
     public static testmethod void testMethod2() 
    {
        User user2=TestUtils.IntegrationAPIUser();
        system.runas(user2)
        {
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            insert dealer1;
            Account acct2= new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           //Individual_Home_Phone__c = '02-202-2456',
                           Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212378978',Personal_Agreement__c ='Yes',Updated_Consent_Date__c = date.valueOf('2006-05-05'),
                           Status__c='NoCustomer',Email__c = 'testemai2344l@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '03',
                           MD__c = 'TR',
                           Market__c = 'TR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name1',
                           Salutation = 'Unknown',
                           Postal_Opt_Out__c=false,     
                           Province__c = 'Shanghai',
                           ZipCode__c= '32703',
                           //Mobile__c = '918197597651',
                           //Mobile2__c = '918197597651',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           PersonDoNotCall=True,
                           // ownerid=user1.id,
                           PersonHasOptedOutOfEmail=True,
                           Opt_In_Email__c=false,
                           Opt_In_SMS__c=false,
                           Postal_Opt_In__c=false,
                           Opt_In_Mobile__c=false,
                           Data_Source__c='Employee Referral',
                           //owner=user1,
                           //PersonBirthdate=date.today(),
                           
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
        
        insert acct2;
        
        Account_Link__c acclnk2 = new Account_Link__c(Name = 'aTest',ToRole__c = acct2.Id, fromRole__c = dealer1.id, ReCordTypeId = Person_RecordTypeId,Retail_Postal_OptOut__c=false,Retail_Email_OptOut__c=false,Retail_Phone_OptOut__c=false,Retail_SMS_OptIn__c=false,Retail_SMS_OptOut__c=false);
        
        insert acclnk2;

            test.starttest(); 
                    PA_Doc_CustomerUpdateBatch b = new PA_Doc_CustomerUpdateBatch();
                    Database.executebatch(b);
            test.stoptest(); 
        }
    }
    
}