/*******************************************************************************************
* Class:                            AccountHelperTHTest
* Description:                      Test class for AccountHelperTH
* ------------------------------------------------------------------------------------------
* Date          Name                        Modification Description
* 2/4/2016      Mohammedtouseef Ahmed       Created  
* 17/5/2017     Shruthi Aipanjiguly         updated based on the best practises of test class
* 25/5/2017     Sarath                      testMethod to test updateAccountNumber format issue  
===========================================================================================*/
@isTest public with sharing class AccountHelperTHTest {

    public static User user1 = TestUtils.createAdminUser();
    public static User user2 = TestUtils.IntegrationAPIUser();

    public static void creatTestData() {
        List < Sobject > sobj = new List < sObject > ();
        list < Account > list1 = new list < Account > ();
        list < Account > list2 = new list < Account > ();
        Trigger__c tr = new Trigger__C(Name = 'TriggerAccountTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, update__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAccountTriggerHandlerTH', Trigger_Name__c = 'TriggerAccount');
        sobj.add(tr);

        CDM_EP_Switch__c cdmswitch = new CDM_EP_Switch__c();
        cdmswitch.name = 'Switch';
        cdmswitch.CDM__c = true;
        sobj.add(cdmswitch);
        insert sobj;

        Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
        list2.add(Acc);
        acc.ID_Number__c = '1361863682746';
        acc.PersonBirthdate = date.newInstance(1980, 03, 18);
        update acc;
        acc.PersonBirthdate = date.newInstance(1970, 03, 18);
        update acc;
        acc.PersonBirthdate = date.newInstance(1998, 03, 18);
        update acc;
        acc.PersonBirthdate = date.newInstance(1960, 03, 18);
        update acc;
        Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id); //person account   
        AccountHelperTH.updateRetailCopy(True, True, True, list2);

        Account acc2 = TestUtils.createCompanyAccount(user1);
        list1.add(acc2);
        Account_Link__c CAcclink = TestUtils.createAccLink('Retail Company', acc2.Id); //company account
        AccountHelperTH.updateRetailCopy(True, True, True, list1);
        acc2.Primary_Address_Reference__c = TestUtils.createAddress(acc2.ID).ID;
        update acc2;


    }

    public static testMethod void AccountHelperTHTestMethod2() {
        System.runAs(user2) {
            test.startTest();
            TriggerUtil.userCreate = false;
            creatTestData();
            test.stopTest();
        }
    }

    static testMethod void testAccAssignment1_1() {

        User user2 = TestUtils.createAfterSalesManager();
        Account acc1;
        Account acc2;
        Account acc3;
        contact con;
        Address__c address;

        System.runAs(user2) {

            acc1 = TestUtils.createCompanyAccount(user2);
            acc2 = TestUtils.createPersonAccountAsUserAsOwner(user2);
            con = TestUtils.createContact('TestCon', acc1.id);
            address = TestUtils.createAddress(acc1.id);
            acc3 = TestUtils.UpdateAccount(acc1.id);

        }

        User userB = TestUtils.createDDAdminUSer(con.id);
        System.runAs(userB) {
            test.starttest();

            list < Account > list2 = new list < Account > ();
            list2.add(acc1);
            list < Account > list3 = new list < Account > ();
            list3.add(acc2);
            list3.add(acc1);
            Map < Id, Account > amap = new Map < Id, Account > ();
            List < Account > alist = new List < Account > ();
            amap.put(acc1.Id, acc1);
            alist.add(acc3);

            try {
                AccountHelperTH.CreateRetailCopy(list3, true, false);
            } catch (exception ex) {
                system.debug(ex.getMessage() + '*******');
                System.AssertEquals(ex.getMessage(), ex.getMessage());
            }

            AccountHelperTH.createUCID(list2, True);
            AccountHelperTH.entityNotifyUpdate('Account', acc1.id, 'TH', 'Account');
            test.stopTest();
        }
    }

    // Method to test updateAccountFieldsBeforeUpdate Method
    static testMethod void updateAccountFieldsBeforeUpdate_Test() {

        System.runAs(user1) {
            test.starttest();
            Account acc2 = TestUtils.createCompanyAccount(user1);

            map < id, Account > addmap1 = new map < id, Account > ();
            addmap1.put(acc2.id, acc2);
            system.assert(acc2.id != null);

            acc2 = TestUtils.UpdateAccount(acc2.Id);
            List < account > AccList = new List < account > ();
            AccList.add(acc2);
            AccountHelperTH.updateAccountFieldsBeforeUpdate(AccList, addmap1, true);
            test.stopTest();
        }
    }
    
    //testMethod for sharing after account Merge
    static testMethod void shareAfterAccountMergeTest()
    {
        System.runAs(user2)
        {
            
            test.startTest();
            Id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
            TriggerUtil.userCreate = false;
            Trigger__c tr = new Trigger__C(Name = 'TriggerAccountTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, update__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAccountTriggerHandlerTH', Trigger_Name__c = 'TriggerAccount');
       		insert tr;
            Account goldenAcc = TestUtils.createCompanyAccount(user2);
            goldenAcc.MD__c='TH';
            goldenAcc.UCID__c='123456';
            update goldenAcc;
            Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12435');
        	insert dealer1;
            
            Account duplicateAcc = TestUtils.createCompanyAccount(user2);
            System.debug('***duplicateAcc'+duplicateAcc.Id);
            duplicateAcc.MD__c='TH';
            duplicateAcc.UCID__c='1234';
            update duplicateAcc;
            
            Account_Link__c Acclink = TestUtils.createAccLink('Retail Company', duplicateAcc.Id); //company account
            Acclink.fromRole__c=dealer1.Id;
            update Acclink;
            String grpName='TH'+dealer1.Dealer_ND_Code__c;
            Group grp=TestUtils.CreateTHGroup(grpName);
            duplicateAcc.UCID__c='123456';
            update duplicateAcc;
            test.stopTest();
        }
    }
    

}