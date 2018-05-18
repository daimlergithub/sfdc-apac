/*
Type:     Test  class
Create By: Sravanthi Gudibandi
Purpose: To test account helper India
add test comment
*/
@isTest
public class AccountHelperINTest {
/*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            
        System.runAs (user1) {
            test.starttest();            
            Account Acc = TestUtils.createPersonAccountGeneric(user1, '+911234567890', 'IN', 2005);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            
            //Update Account            
            Acc = TestUtils.UpdateAccount(Acc.id);  
            Account acc2 = TestUtils.createCompanyAccount(user1);
            acc2.Primary_Address_Reference__c = TestUtils.createAddress(acc2.ID).ID;
            update acc2;
            list<Account> list3=new list<Account>();
            list3.add(acc2);
                       
            AccountHelperIN.updateAccountCountry(List2,True);
            AccountHelperIN.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperIN.updateOnDoNotCall(List2);
            AccountHelperIN.updateOnPostalOptout(list3);
            AccountHelperIN.updateOnEmailOptout(List2);
            AccountHelperIN.updateAgeRange(List2);
            
            Map<Id, Account> m1=new Map<id, Account>();
            Account a1=list3[0];
            m1.put(a1.id,a1);
            
            AccountHelperIN.updatePrimaryAddressdisplay(List3,true,m1);
            //updateAccountFieldsBeforeInsertInt
            AccountHelperIN.updateAccountFieldsBeforeInsertInt(list3,true);
            AccountHelperIN.createUpdateCDMUCID('abcd','IN',list3);
            //AccountHelperIN.entityNotifyUpdate('abcd','IN','IN','abcd');
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list3[0];
            m.put(a.id,a);
            AccountHelperIN.updateAccountFieldsBeforeIntUpdate(list3,m,true);
            
            list<Account> updateAccountList=[select Opt_In_Home_Phone__c,Opt_In_Email__c from Account where id=:acc.Id]; 
    
            AccountHelperIN.CreateRetailCopy(list2,true,true);
            AccountHelperIN.CreateRetailCopy(list3,true,true);

            Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id);//person account   
            AccountHelperIN.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLink('Retail Person', acc2.Id);//company account
            AccountHelperIN.updateRetailCopy(True,True,True,list3);
            //AccountHelperIN.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
           
            Account oAcc = List2[0];
             System.assertEquals(oAcc.Country__c, 'India');
            
            test.stopTest();
        }
    }
    
// Method to test updateAccountFieldsBeforeUpdate Method
    static testMethod void updateAccountFieldsBeforeUpdate_Test() {
        User user3 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');  
        System.runAs (user3) {
            test.starttest();            
            Account acc2 = TestUtils.createCompanyAccount(user3);
            
            map<id,Account> addmap1=new map<id,Account>();
            addmap1.put(acc2.id,acc2);
                  
                  
            acc2 = TestUtils.UpdateAccount(acc2.Id);            
            List<account> AccList = new List<account>();
            AccList.add(acc2);            
            AccountHelperIN.updateAccountFieldsBeforeUpdate(AccList,addmap1,true);
			System.assertEquals('IN', user3.Market__c);
            test.stopTest();
        }
    }
}