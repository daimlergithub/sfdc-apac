/***********************************************************************************
Created By          :    Venky
Created Date        :    17.11.2017
Company             :    NTT Data,Inc.
Usage               :    This class is created for covering test code coverage for batch class revokesharingToRetailCopies
JIRA NO             :    SFDCJP-3115                                                

MODIFICATION DETAILS:

1. Modified By      :  
   Modifide Date    :    
************************************************************************************/

@isTest
public class revokesharingToRetailCopiesTest   {

 public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   public static Id personaccRecordTypeId1=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
   private static Account objMaster; 
   private static Account dealer;
   private static Address__c address;
   public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
   public static testMethod void test_Accountlink()
  {
     User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
       Revoke_RT_Sharing__c cs = new Revoke_RT_Sharing__c();
       cs.Name='RevokeRT';
        cs.Enter_Number_of_Days__c=6;
        //cs.Other fiels values
     insert cs;
         Integer integerValue1 = 6;
             Date today = Date.today().addDays(-integerValue1);
       objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = 'オオ',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');    
      insert objMaster;
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123');
        insert dealer;
        
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
        
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = AccountLink_RetailPersonRecordTypeId ,Retail_Duplicate_Flag__c=true, Name = 'contact2Contact', toRole__c=objMaster.id , fromRole__c = dealer.Id ,Retail_Address_Reference__c = address.Id,MD__c = 'JP');
       
         
       Test.StartTest();
       insert contact2Contact;
        Database.executeBatch(new revokesharingToRetailCopies(),200);
       Test.StopTest();
       }
  }
}