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
        
        System.runAs (user1) {
            test.starttest(); 
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            Account acc2 = TestUtils.createCompanyAccount(user1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account_Link__c acclnk = new Account_Link__c(Name = 'aTest',ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId,Retail_Postal_OptOut__c=true,Retail_Email_OptOut__c=true,Retail_Phone_OptOut__c=true,Retail_SMS_OptIn__c=true,Retail_SMS_OptOut__c=true);
            insert acclnk; 
            Map<id,sobject> aclist= new Map<id,sobject>(); 
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
            test.stopTest();
    
    }
   }
}