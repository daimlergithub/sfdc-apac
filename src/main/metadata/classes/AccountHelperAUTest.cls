@isTest
public class AccountHelperAUTest {
/*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createMYAdminUser();
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
                       
            
            AccountHelperAU.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperAU.updateOnDoNotCall(List2);
            AccountHelperAU.updateOnPostalOptout(list3);
            AccountHelperAU.updateOnEmailOptout(List2);
            AccountHelperAU.updateAgeRange(List2);
            AccountHelperAU.ValidateNationalid(List2);
            AccountHelperAU.ValidateNationalid(List3);
            Contract cont = TestUtils.createContract(Acc.ID);
            AccountHelperAU.activeContracts(List2) ;
            
            Map<Id, Account> m1=new Map<id, Account>();
            Account a1=list3[0];
            m1.put(a1.id,a1);
            
            AccountHelperAU.updatePrimaryAddressdisplay(List3,true,m1);
            //updateAccountFieldsBeforeInsertInt
            AccountHelperAU.updateAccountFieldsBeforeInsertInt(list3,true);
            AccountHelperAU.createUpdateCDMUCID('abcd','AU',list3);
            //AccountHelperAU.entityNotifyUpdate('abcd','AU','AU','abcd');
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list3[0];
            m.put(a.id,a);
            AccountHelperAU.updateAccountFieldsBeforeIntUpdate(list3,m,true);
           /* system.assertequals(AccountHelperAU.calculateAgeRange(18),'17-25');
            system.assertequals(AccountHelperAU.calculateAgeRange(27),'26-35');
            system.assertequals(AccountHelperAU.calculateAgeRange(37),'36-45');
            system.assertequals(AccountHelperAU.calculateAgeRange(47),'46-55');
            system.assertequals(AccountHelperAU.calculateAgeRange(57),'56-65');
            system.assertequals(AccountHelperAU.calculateAgeRange(67),'65+'); */
            
            list<Account> updateAccountList=[select Opt_In_Home_Phone__c,Opt_In_Email__c from Account where id=:acc.Id]; 
            
            
          
            AccountHelperAU.CreateRetailCopy(list2,true,true);
            AccountHelperAU.CreateRetailCopy(list3,true,true);

            Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id);//person account   
            AccountHelperAU.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLink('Retail Person', acc2.Id);//company account
            AccountHelperAU.updateRetailCopy(True,True,True,list3);
            AccountHelperAU.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            
           
            test.stopTest();
        }
    }
    
/* This method is used to test 
* CreateRetailCopy method with Partner Community Profile user.
* calculateAgeRange*/
    
    static testMethod void testAccAssignment1_1() {
        
       User user2 = TestUtils.createAfterSalesManagerMY();
        Account acc1;Account acc2;
        contact con ;
        Address__c address;
        
        System.runAs (user2) {
            
            acc1 = TestUtils.createCompanyAccount(user2);
            acc2 = TestUtils.createPersonAccountAsUserAsOwner(user2);
            con = TestUtils.createContact('TestCon',acc1.id);
            address = TestUtils.createAddressMY(acc1.id);
            
        } 
        
        User userB = TestUtils.createDDAdminUSer(con.id);        
        System.runAs (userB) {
            test.starttest();
            list<Account> list2=new list<Account>();
            list2.add(acc1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            list3.add(acc1);
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list3[0];
            m.put(a.id,a);
            AccountHelperAU.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperAU.updateOnDoNotCall(List2);
            AccountHelperAU.updateOnPostalOptout(List2);
            AccountHelperAU.updateOnEmailOptout(List2);
            AccountHelperAU.updateAgeRange(List2);
            AccountHelperAU.activeContracts(List2);
            AccountHelperAU.updatePrimaryAddressdisplay(List2,true,m);
            try{
                AccountHelperAU.CreateRetailCopy(list3,true,false);
            }catch(Exception e){}
           
            AccountHelperAU.createUCID(list2,True);
           
            AccountHelperAU.updateRetailCopy(True,True,True,list2);
           
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
            AccountHelperAU.updateAccountFieldsBeforeUpdate(AccList,addmap1,true);            
            test.stopTest();
        }
    }
}