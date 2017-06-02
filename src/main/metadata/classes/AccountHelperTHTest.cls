/*******************************************************************************************
* Class:                            AccountHelperTHTest
* Description:                      Test class for AccountHelperTH
* ------------------------------------------------------------------------------------------
* Date          Name                        Modification Description
* 2/4/2016      Mohammedtouseef Ahmed       Created  
* 17/5/2017     Shruthi Aipanjiguly         updated based on the best practises of test class
* 25/5/2017     Sarath                      testMethod to test updateAccountNumber format issue  
===========================================================================================*/
@isTest
public with sharing class AccountHelperTHTest 
{
/*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createAdminUser();
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
                       
            
            AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperTH.updateOnDoNotCall(List2);
            AccountHelperTH.updateOnPostalOptout(list3);
            AccountHelperTH.updateOnEmailOptout(List2);
            AccountHelperTH.updateAgeRange(List2);
            
            Contract cont = TestUtils.createContract(Acc.ID);
            AccountHelperTH.activeContracts(List2);
            
            AccountHelperTH.updatePrimaryAddressdisplay(List3,true);
            
            system.assertequals(AccountHelperTH.calculateAgeRange(18),'17-25');
            system.assertequals(AccountHelperTH.calculateAgeRange(27),'26-35');
            system.assertequals(AccountHelperTH.calculateAgeRange(37),'36-45');
            system.assertequals(AccountHelperTH.calculateAgeRange(47),'46-55');
            system.assertequals(AccountHelperTH.calculateAgeRange(57),'56-65');
            system.assertequals(AccountHelperTH.calculateAgeRange(67),'65+');
            
            list<Account> updateAccountList=[select Opt_In_Home_Phone__c,Opt_In_Email__c from Account where id=:acc.Id]; 
            system.assertEquals(acc.Opt_In_Home_Phone__c, false);
            system.assertEquals(acc.Opt_In_Email__c, false);
            
          
            AccountHelperTH.CreateRetailCopy(list2,true,true);
            AccountHelperTH.CreateRetailCopy(list3,true,true);

            Account_Link__c PAcclink = TestUtils.createAccLink('Retail Person', Acc.Id);//person account   
            AccountHelperTH.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLink('Retail Person', acc2.Id);//company account
            AccountHelperTH.updateRetailCopy(True,True,True,list3);
            AccountHelperTH.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            system.assert(retailCopyList.size()>0);
           
            test.stopTest();
        }
    }
    
/* This method is used to test 
* CreateRetailCopy method with Partner Community Profile user.
* calculateAgeRange*/
    
    static testMethod void testAccAssignment1_1() {
        
        User user2 = TestUtils.createAfterSalesManager();
        Account acc1;Account acc2;
        contact con ;
        Address__c address;
        
        System.runAs (user2) {
            
            acc1 = TestUtils.createCompanyAccount(user2);
            acc2 = TestUtils.createPersonAccountAsUserAsOwner(user2);
            con = TestUtils.createContact('TestCon',acc1.id);
            address = TestUtils.createAddress(acc1.id);
            
        } 
        
        User userB = TestUtils.createDDAdminUSer(con.id);        
        System.runAs (userB) {
            test.starttest();
            list<Account> list2=new list<Account>();
            list2.add(acc1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            list3.add(acc1);
            
            AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
            AccountHelperTH.updateOnDoNotCall(List2);
            AccountHelperTH.updateOnPostalOptout(List2);
            AccountHelperTH.updateOnEmailOptout(List2);
            AccountHelperTH.updateAgeRange(List2);
            AccountHelperTH.activeContracts(List2);
            AccountHelperTH.updatePrimaryAddressdisplay(List2,true);
            try{
                AccountHelperTH.CreateRetailCopy(list3,true,false);
            }catch(exception ex){
                System.Assert(ex.getMessage().contains('null object'));
            }
            
            AccountHelperTH.createUCID(list2,True);
            AccountHelperTH.updateRetailCopy(True,True,True,list2);
            AccountHelperTH.entityNotifyUpdate('Account',acc1.id,'TH','Account');
            test.stopTest();
        }
    }
    
// Method to test updateAccountFieldsBeforeUpdate Method
    static testMethod void updateAccountFieldsBeforeUpdate_Test() {
        User user3 = TestUtils.createAdminUser();   
        System.runAs (user3) {
            test.starttest();            
            Account acc2 = TestUtils.createCompanyAccount(user3);
            
            map<id,Account> addmap1=new map<id,Account>();
            addmap1.put(acc2.id,acc2);
            system.assert(acc2.id!=null);
            
            acc2 = TestUtils.UpdateAccount(acc2.Id);            
            List<account> AccList = new List<account>();
            AccList.add(acc2);            
            AccountHelperTH.updateAccountFieldsBeforeUpdate(AccList,addmap1,true);            
            test.stopTest();
        }
    }
// Method to test phoneNumber format issue   
    static testMethod void checkWhetherPhoneNumberIsUpdatedOrNot(){    
        User user4 = TestUtils.IntegrationAPIUser();       
        System.runAs (user4) {
            test.starttest();
            Account acc = TestUtils.createPersonAccountAsUserAsOwner(user4);
            
            acc.Mobile__c='0987654532';
            acc.Work_Phone__c='098576434';
            acc.Individual_Home_Phone__c='078648434';
                        
            List<account> AccList = new List<account>();
            AccList.add(acc);            
            AccountHelperTH.updatePhoneFormat(AccList);    
            
            system.assertEquals('+66987654532', acc.Mobile__c);
            system.assertEquals('+6698576434',  acc.Work_Phone__c);
            system.assertEquals('+6678648434',  acc.Individual_Home_Phone__c);            
            acc.Mobile__c='987654523';
            acc.Work_Phone__c='998576443';
            acc.Individual_Home_Phone__c='978648434';            
            AccList.add(acc);
            AccountHelperTH.updatePhoneFormat(AccList);            
            system.assertEquals('+66987654523', acc.Mobile__c);
            system.assertEquals('+66998576443',  acc.Work_Phone__c);
            system.assertEquals('+66978648434',  acc.Individual_Home_Phone__c);
            test.stopTest();
        }  
    }
   /* method Should remove zero from phone number*/
    static testMethod void removeZeroFromNumber() {        
        User user5 = TestUtils.createAdminUser();
        System.runAs (user5) {            
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user5);
            Acc.Mobile__c='+660987654532';
            Acc.Work_Phone__c='+66098576434';
            Acc.Individual_Home_Phone__c='+66078648434';
            list<Account> removeZero=new list<Account>();
            removeZero.add(Acc);
            test.starttest();
                AccountHelperTH.eliminateZerofrmPhone(removeZero);
                system.assertEquals('+66987654532', Acc.Mobile__c);
                system.assertEquals('+6698576434',  Acc.Work_Phone__c);
                system.assertEquals('+6678648434',  Acc.Individual_Home_Phone__c);
            test.stopTest();
                
        }
    }
}