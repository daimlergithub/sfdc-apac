@isTest
public class AccountlinkHelperTRTest {
 static testMethod void testAccAssignment() {
    
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLink',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TR',Trigger_Handler__c='TriggerAccountlinkHandlerTR',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        
        User user1 = TestUtils.createTRAdminUser();
        String market='TR';
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        Id C2C_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
       Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        System.runAs (user1) {
            test.starttest(); 
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            Account acc2 = TestUtils.createCompanyAccount(user1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            insert dealer1;
            Account dealer2 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer2',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='12356');
            insert dealer2;
            group g=new group(name='TR1235');
            insert g;
            Account_Link__c acclnk = new Account_Link__c(Name = 'aTest',ToRole__c = Acc.Id, fromRole__c = dealer1.id, ReCordTypeId = AccountLink_RetailPersonRecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=true,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=true,Retail_SMS_OptOut__c=true);
            insert acclnk; 
            Account_Link__c acclnk1 = new Account_Link__c(Name = 'aTest1',ToRole__c = Acc.Id, fromRole__c = dealer2.id, ReCordTypeId = AccountLink_RetailPersonRecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=false,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=false,Retail_SMS_OptOut__c=true);
            insert acclnk1; 
            Map<id,Account_Link__c> aclist= new Map<id,Account_Link__c>(); 
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperTR tr= new AccountlinkhelperTR();
            tr.ValidateC2CAfterUpdateInsert(acclinklist,Label.TR,false,true,aclist);
             AccountlinkhelperTR.updateOnPostalOptout(acclinklist);
            AccountlinkhelperTR.updateOnEmailOptout(acclinklist);
            AccountlinkhelperTR.updateOnPhoneSMSoptout(acclinklist);
            acclnk.Retail_Phone_OptIn__c = false;
            acclnk.Retail_SMS_OptIn__c = false;
            update acclnk;
             AccountlinkhelperTR.updateOnPhoneSMSoptout(acclinklist);
            acclinklist.add(acclnk1);
            aclist.put(acclnk1.id,acclnk1);
            
             tr.updateRetailDOCforDealers(acclinklist,aclist);
            test.stopTest();
    
    }
   }
   static testMethod void testAccAssignmentFormAssmblyUser() {
    
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLink',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TR',Trigger_Handler__c='TriggerAccountlinkHandlerTR',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        
        User user1 = TestUtils.createTRAdminUser();
        user1.alias = Label.FormAssembly;
        update user1;
        String market='TR';
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        Id C2C_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
       Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        System.runAs (user1) {
            test.starttest(); 
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            Account acc2 = TestUtils.createCompanyAccount(user1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            insert dealer1;
            Account dealer2 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer2',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='12356');
            insert dealer2;
            group g=new group(name='TR1235');
            insert g;
            Account_Link__c acclnk = new Account_Link__c(Name = 'aTest',ToRole__c = Acc.Id, fromRole__c = dealer1.id, ReCordTypeId = AccountLink_RetailPersonRecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=true,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=true,Retail_SMS_OptOut__c=true);
            insert acclnk; 
            Account_Link__c acclnk1 = new Account_Link__c(Name = 'aTest1',ToRole__c = acc2.Id, fromRole__c = dealer2.id, ReCordTypeId = AccountLink_RetailPersonRecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=false,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=false,Retail_SMS_OptOut__c=true);
            insert acclnk1; 
            Map<id,Account_Link__c> aclist= new Map<id,Account_Link__c>(); 
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperTR tr= new AccountlinkhelperTR();
            tr.ValidateC2CAfterUpdateInsert(acclinklist,Label.TR,false,true,aclist);
             AccountlinkhelperTR.updateOnPostalOptout(acclinklist);
            AccountlinkhelperTR.updateOnEmailOptout(acclinklist);
            AccountlinkhelperTR.updateOnPhoneSMSoptout(acclinklist);
            acclnk.Retail_Phone_OptIn__c = false;
            acclnk.Retail_SMS_OptIn__c = false;
            update acclnk;
             AccountlinkhelperTR.updateOnPhoneSMSoptout(acclinklist);
            acclinklist.add(acclnk1);
            aclist.put(acclnk1.id,acclnk1);
            
             tr.updateRetailDOCforDealers(acclinklist,aclist);
            test.stopTest();
    
    }
   }
}