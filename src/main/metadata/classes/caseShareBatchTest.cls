
/*
    Type:Test class
    Purpose:Test Class for caseShareBatch
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 04-11-2017 
    2. Modified     
*/

@isTest
public class caseShareBatchTest {
public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      public static Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
      public static Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
      public static Id saleslead_RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
      public static Id caseInquiry_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
      
      public static void init()
     { 
        
      Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='MBK09Shq'); 
         insert dealer;
      Account  personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc',MD__C='KR',Data_Source__c='Dealer Outlet',MBK_Data_Source__c='Dealers',Mobile__c='000-0000-9642');
         insert personAcc;
       Account_Link__c  accLink= new Account_Link__c(Name='testacclink',RecordTypeId = retailPerson_RecordTypeId,fromRole__c=dealer.id,toRole__c=personAcc.id,MD__C='KR');
         insert accLink;
       Case cs = new Case(RecordTypeId = caseInquiry_RecordTypeId,Case_Dealer__c = dealer.Id,Status = 'CM Inputting',MD__c = 'KR');
       	insert cs;  
         
         
       Group gp = new Group();
		gp.Name = dealer.Dealer_ND_Code__c;
		insert gp;   
         
         
     }
     
     static testmethod void batchAugment()
   {
          init();
       
          Test.startTest();
       
       caseShareBatch bc= new caseShareBatch();
       database.executeBatch(bc);
       
          Test.stopTest();
   }
}