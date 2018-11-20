/**
* Type:Test class
* Test class for AccountLink Helper class for IN
* Created By:Sravanthi Gudibandi
*/

@isTest
public class AccountlinkhelperINTest {
    
    static testMethod void testAccAssignment() {
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLinkIN',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='IN',Trigger_Handler__c='TriggerAccountlinkTriggerHandlerIN',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        User user1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        String market='IN';
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        Id accDealer_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
        Id C2C_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
        Id RetPersonRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
        Id RetCompanyRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');
        System.runAs (user1) {
            test.starttest(); 
            Account Acc = TestUtils.createPersonAccountGeneric(user1, '+911234567890', 'IN', 2005);
            Address__c adOne = TestUtils.createAddressIN(acc.Id);
            list<Account> list2 = new list<Account>();
            list2.add(Acc);
            Account acc2 = TestUtils.createPersonAccountGeneric(user1, '+911234567891', 'IN', 2005);
            Address__c adTwo = TestUtils.createAddressIN(acc2.Id);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account dealerAcc1 = new Account(Name='dAccOne', recordTypeId=accDealer_RecordTypeId, Market__c='IN', Dealer_ND_Code__c='nd1', Dealer_GS_Code__c='gc1',Dealer_Active__c=true);
            insert dealerAcc1;
            Account dealerAcc2 = new Account(Name='dAccTwo', recordTypeId=accDealer_RecordTypeId, Market__c='IN', Dealer_ND_Code__c='nd2', Dealer_GS_Code__c='gc1',Dealer_Active__c=true);
            insert dealerAcc2;
            Account_Link__c acclnk = new Account_Link__c(Name = 'TestOne', Market__c='IN', Role__c = 'Owner', Role2__c = 'Staff', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk; 
            Account_Link__c acclnk1 = new Account_Link__c(Name = 'TestTwo', Market__c='IN', ToRole__c = Acc.Id, fromRole__c = dealerAcc1.id, ReCordTypeId = RetPersonRecordTypeId);
            insert acclnk1;
            Account_Link__c acclnk3 = new Account_Link__c(Name = 'TestFour', Market__c='IN', ToRole__c = Acc.Id, fromRole__c = dealerAcc2.id, ReCordTypeId = RetPersonRecordTypeId);
            insert acclnk3;
            Map<id,sobject> aclist= new Map<id,sobject>(); 
            Map<id,Account_Link__c> acMapList = new Map<id,Account_Link__c>();//08242018 namitha added for test coverage of kernal methods invoked.
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            acMapList.put(acclnk.id,acclnk);//08242018 namitha added for test coverage of kernal methods invoked.
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperIN alh = new AccountlinkHelperIN();
            alh.ValidateC2CAfterUpdateInsert(acclinklist,Label.IN,true,true,aclist);
            alh.afterInsertEventShareRetailCopy(acclinklist);//Start 07132018 : Namitha added to invoke share retailcopy and Account as part of ph2.
            alh.afterInsertEventShareAccount(acclinklist);//Start 07132018 : Namitha added to invoke share retailcopy and Account as part of ph2.
            AccountLinkHelperBase.validateC2C(acclinklist,Label.IN,true,true,aclist);
            //Start : 08242018 namitha added for test coverage of kernal methods invoked.
            alh.addressupdateRT(acclinklist,acMapList);
            alh.RemoveAccessofUsers(acclinklist);
            Group pubGrp = new Group(Name='INPublicGroup');
            insert pubGrp;
            AccountShare accShare  = new AccountShare();
            accShare.accountId  = acc.Id;
            accShare.UserOrGroupId = pubGrp.Id;
            accShare.RowCause = Schema.AccountShare.RowCause.Manual;
            Database.SaveResult sr = Database.insert(accShare,false);
            AccountShare accShare1  = new AccountShare();
            accShare1.accountId  = acc2.Id;
            accShare1.UserOrGroupId = pubGrp.Id;
            accShare1.RowCause = Schema.AccountShare.RowCause.Manual;
            Database.SaveResult sr1 = Database.insert(accShare1,false);
            List<Account_Link__c> acclinkRetaillist = new List<Account_Link__c>();
            acclinkRetaillist.add(acclnk1);
            acclinkRetaillist.add(acclnk3);
            alh.ShareC2CRecord(acclinkRetaillist);
            alh.RevokeApexSharingAfterUpdate(acclinklist,acMapList,acclinklist);
            //Ends : 08242018
            test.stopTest();
            
        }
    }
}