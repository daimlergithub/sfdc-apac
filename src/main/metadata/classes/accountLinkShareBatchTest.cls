/*
    Type:Test class
    Purpose:Test Class for accountLinkShareBatch
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 13-07-2017
    2. Modified     
*/
@isTest
public class accountLinkShareBatchTest { 

      public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      public static Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
      public static Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    
     public static void init()
     { 
         try{
         
      Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='MBK09Shq',MD__C='KR'); 
         insert dealer;
          KR_Switch__c krswitch=new KR_Switch__c(Name='AccountLinkhelperSwitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountLinkhelperSwitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountLinkhelperSwitch').Enable_Flag__c;
        }
        Account  personAcc;
        if (!KRSwitchEnabledFlag ) {
       personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc',MD__C='KR',Data_Source__c='Dealer Outlet',MBK_Data_Source__c='Dealers',Mobile__c='000-0000-9642');
      }
      else{
       personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc',MD__C='KR',Data_Source__c='Dealer Outlet',MBK_Data_Source__c='Dealers',Mobile__c='+82-18-0000-9642');
      }
         insert personAcc;
       Account_Link__c  accLink= new Account_Link__c(Name='testacclink',RecordTypeId = retailPerson_RecordTypeId,fromRole__c=dealer.id,toRole__c=personAcc.id,MD__C='KR');
         insert accLink;
       }
        catch(Exception e)
        {
        }   
     }
    
    
    static testmethod void batchAugment()
   {
          init();
       
          Test.startTest();
       
       accountLinkShareBatch bc= new accountLinkShareBatch();
       database.executeBatch(bc);
       
          Test.stopTest();
   }
   
   static testmethod void batchAugmentOne()
   {
          init();
       
          Test.startTest();
       
       accountLinkKoreaShareBatch  bc= new accountLinkKoreaShareBatch();
       database.executeBatch(bc);
       
          Test.stopTest();
   }

}