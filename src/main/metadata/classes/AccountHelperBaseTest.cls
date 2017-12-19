@isTest
public class AccountHelperBaseTest {
/*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createMYAdminUser();
        String market='MY';
        Integer ageInt=25;
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        //Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Person);
        //Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Company);
        Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            
        System.runAs (user1) {
            test.starttest();            
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            
            //Update Account            
            Acc = TestUtils.UpdateAccount(Acc.id);  
            Account acc2 = TestUtils.createCompanyAccount(user1);
            acc2.Primary_Address_Reference__c = TestUtils.createAddress(acc2.ID).ID;
            update acc2;
            list<Account> list3=new list<Account>();
            list3.add(acc2);
                       
            
            AccountHelperBase.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperBase.updateOnDoNotCall(List2);
            AccountHelperBase.updateOnPostalOptout(list3);
            AccountHelperBase.updateOnEmailOptout(List2);
            AccountHelperBase.updateAgeRange(List2);
            AccountHelperBase.ValidateNationalid(List2);
            AccountHelperBase.ValidateNationalid(List3);
            AccountHelperBase.calculateAgeRange(ageInt);
            Contract cont = TestUtils.createContract(Acc.ID);
            AccountHelperBase.activeContracts(List2);
            
            AccountHelperBase.updatePrimaryAddressdisplay(List3,true);
            AccountHelperBase.updateMarketingFields(list2);
            AccountHelperBase.updateAccountFieldsBeforeInsertInt(list2,True);
            AccountHelperBase.updatemarket(list2);
            AccountHelperBase.createUpdateCDMUCID('abcd', 'MY',list2 );
            AccountHelperBase.entityNotifyUpdate('abcd','MY','MY','abcd');
           AccountHelperBase.validate('12345678', 1234, 'abcd', 9, 4);
            
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list2[0];
            m.put(a.id,a);
            AccountHelperBase.UpdateConsentHistory(m,list2);
            //AccountHelperBase.updateAccountFieldsBeforeIntUpdate();
            AccountHelperBase.updateAccountFieldsBeforeUpdate(list2, m, true);
            AccountHelperBase.updateAccountFieldsBeforeIntUpdate(list2,m,true);
            //AccountHelperBase.updateAccountFieldsBeforeInsert(listNewAccounts, isInsert)
            
           /* system.assertequals(AccountHelperBase.calculateAgeRange(18),'17-25');
            system.assertequals(AccountHelperBase.calculateAgeRange(27),'26-35');
            system.assertequals(AccountHelperBase.calculateAgeRange(37),'36-45');
            system.assertequals(AccountHelperBase.calculateAgeRange(47),'46-55');
            system.assertequals(AccountHelperBase.calculateAgeRange(57),'56-65');
            system.assertequals(AccountHelperBase.calculateAgeRange(67),'65+'); */
            
            list<Account> updateAccountList=[select Opt_In_Home_Phone__c,Opt_In_Email__c from Account where id=:acc.Id]; 
            system.assertEquals(acc.Opt_In_Home_Phone__c, false);
            system.assertEquals(acc.Opt_In_Email__c, false);
            
          
            AccountHelperBase.CreateRetailCopy(list2,true,true);
            AccountHelperBase.CreateRetailCopy(list3,true,true);

            Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id);//person account   
            AccountHelperBase.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLink('Retail Person', acc2.Id);//company account
            AccountHelperBase.updateRetailCopy(True,True,True,list3);
            AccountHelperBase.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            system.assert(retailCopyList.size()>0);
           
            test.stopTest();
        }
    }
    
}