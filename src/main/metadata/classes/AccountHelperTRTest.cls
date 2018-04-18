@isTest
public class AccountHelperTRTest {
/*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createTRAdminUser();
        Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            
        System.runAs (user1) {
            test.starttest();            
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            acc.Social_ID__c =Decimal.Valueof('56897456987');
            acc.Personal_Agreement__c = 'No';
            //Update Account            
            Acc = TestUtils.UpdateAccount(Acc.id);  
            Account acc2 = TestUtils.createCompanyAccount(user1);
            acc2.Primary_Address_Reference__c = TestUtils.createAddressTR(acc2.ID).ID;
            acc2.Vat_No__c='5896547896';
            update acc2;
            list<Account> list3=new list<Account>();
            list3.add(acc2);
                       
            
            AccountHelperTR.updateAccountFieldsBeforeInsert(list2,True);
            //AccountHelperTR.entityNotifyUpdate(acc);
            AccountHelperTR.validateSocialIdTR(acc);
            AccountHelperTR.validateVATNoTR(acc2);
            AccountHelperTR.updateOnDoNotCall(List2);
            AccountHelperTR.updateOnPostalOptout(list3);
            AccountHelperTR.updateOnEmailOptout(List2);
            AccountHelperTR.updateOnSMSoptout(List2);
            AccountHelperTR.updateOnPhoneoptout(List2);
            AccountHelperTR.updateAgeRange(List2);
            AccountHelperTR.UpdateKVKFields(List2);
            
            Contract cont = TestUtils.createContract(Acc.ID);
            Map<Id,Account> acct = new map<Id,Account>();
            acct.put(acc2.Id,acc2);           
            AccountHelperTR.updatePrimaryAddressdisplay(List3,true,acct);
            //updateAccountFieldsBeforeInsertInt
            AccountHelperTR.updateAccountFieldsBeforeInsertInt(list3,true);
            AccountHelperTR.createUpdateCDMUCID('abcd','TR',list3);
            //AccountHelperTR.entityNotifyUpdate('abcd','MY','MY','abcd');
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list3[0];
            m.put(a.id,a);
            AccountHelperTR.updateAccountFieldsBeforeIntUpdate(list3,m,true);
           /* system.assertequals(AccountHelperTR.calculateAgeRange(18),'17-25');
            system.assertequals(AccountHelperTR.calculateAgeRange(27),'26-35');
            system.assertequals(AccountHelperTR.calculateAgeRange(37),'36-45');
            system.assertequals(AccountHelperTR.calculateAgeRange(47),'46-55');
            system.assertequals(AccountHelperTR.calculateAgeRange(57),'56-65');
            system.assertequals(AccountHelperTR.calculateAgeRange(67),'65+'); */
            
            list<Account> updateAccountList=[select Opt_In_Home_Phone__c,Opt_In_Email__c from Account where id=:acc.Id]; 
            
            
          
            AccountHelperTR.CreateRetailCopy(list2,true,true);
            AccountHelperTR.CreateRetailCopy(list3,true,true);

            Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id);//person account   
            AccountHelperTR.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLink('Retail Person', acc2.Id);//company account
            AccountHelperTR.updateRetailCopy(True,True,True,list3);
            AccountHelperTR.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            
           
            test.stopTest();
        }
    }
    
/* This method is used to test 
* CreateRetailCopy method with Partner Community Profile user.
* calculateAgeRange*/
    
    static testMethod void testAccAssignment1_1() {
        
       User user2 = TestUtils.createAfterSalesManagerTR();
        Account acc1;Account acc2;
        contact con ;
        Address__c address;
        
        System.runAs (user2) {
            
            acc1 = TestUtils.createCompanyAccount(user2);
            acc2 = TestUtils.createPersonAccountAsUserAsOwner(user2);
            con = TestUtils.createContactTR('TestCon',acc1.id);
            address = TestUtils.createAddressTR(acc1.id);
            
        } 
        
        User userB = TestUtils.createDDAdminUSer(con.id);        
        System.runAs (userB) {
            test.starttest();
            list<Account> list2=new list<Account>();
            list2.add(acc1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            list3.add(acc1);
            
            AccountHelperTR.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperTR.updateOnDoNotCall(List2);
            AccountHelperTR.updateOnPostalOptout(List2);
            AccountHelperTR.updateOnEmailOptout(List2);
            AccountHelperTR.updateAgeRange(List2);
            //AccountHelperTR.activeContracts(List2);
            Map<Id,account> acct1 = new map<Id,account>();
            acct1.put(acc1.Id,acc1);
            AccountHelperTR.updatePrimaryAddressdisplay(List2,true,acct1);
            try{
                AccountHelperTR.CreateRetailCopy(list3,true,false);
            }catch(Exception e){}
           
            AccountHelperTR.createUCID(list2,True);
           
            AccountHelperTR.updateRetailCopy(True,True,True,list2);
           
            test.stopTest();
        }
    }
    
// Method to test updateAccountFieldsBeforeUpdate Method
    static testMethod void updateAccountFieldsBeforeUpdate_Test() {
        User user3 = TestUtils.createMYAdminUser();   
        System.runAs (user3) {
            test.starttest();            
            Account acc2 = TestUtils.createCompanyAccount(user3);
            
            map<id,Account> addmap1=new map<id,Account>();
            addmap1.put(acc2.id,acc2);
                  
                  
            acc2 = TestUtils.UpdateAccount(acc2.Id);            
            List<account> AccList = new List<account>();
            AccList.add(acc2);            
            AccountHelperTR.updateAccountFieldsBeforeUpdate(AccList,addmap1,true);            
            test.stopTest();
        }
    }
}