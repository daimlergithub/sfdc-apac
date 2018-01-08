/**
* Test class for AccountLink Helper Base class for MY(Malayasia)
* Author: Pratyasha Mishra 
* Created Date : 2017-01-04
*/

@isTest
public class AccountLinkHelperBaseTest {

    static testMethod void testAccAssignment() {
        
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
            Account Acc3 = TestUtils.createPersonAccountAsUserAsOwner(user1);
           
            
            
            Account acc2 = TestUtils.createCompanyAccount(user1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account_Link__c acclnk3 = new Account_Link__c(Name = 'Test', ToRole__c = Acc3.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk3;
            
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk;          
            
            Account_Link__c acclnk1 = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk1;
            list<account_link__c> aclink= new List<account_link__c>();
            aclink.add(acclnk1);
            aclink.add(acclnk);
            Map<id,sobject> accountlinkMap= new Map<id,sobject>();
            accountlinkMap.put(acclnk1.id,acclnk1);
            accountlinkMap.put(acclnk.id,acclnk);
            AccountLinkHelperBase.validateC2C(aclink,'MY',false,true,accountlinkMap);
            AccountLinkHelperBase.validateC2C(aclink,'MY',true,false,accountlinkMap); 
            test.stopTest();
        }
    }
}