/**
* Test class for AccountLink Helper class for MY(Malayasia)
* Author: Pratyasha Mishra 
* Created Date : 2017-01-04
*/

@isTest
public class AccountlinkhelperMYTest {
    
    
    static testMethod void testAccAssignment() {
    
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLink',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='MY',Trigger_Handler__c='TriggerAccountlinkHandlerMY',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        
        User user1 = TestUtils.createMYAdminUser();
        String market='MY';
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
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk; 
            Map<id,sobject> aclist= new Map<id,sobject>(); 
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperMY my= new AccountlinkhelperMY();
            my.ValidateC2CAfterUpdateInsert(acclinklist,Label.MY,false,true,aclist);
            test.stopTest();
    
    }
   }
}