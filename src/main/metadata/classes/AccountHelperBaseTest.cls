@istest
public class AccountHelperBaseTest {
    /*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange 

adding comment for auto merge testing 
comment added*/
    static testMethod void testAccAssignment() {
        
        User user1 = TestUtils.createGenericAdminUser('Australia', 'America/New_York', 'MY');
        String market='MY';
        Integer ageInt=25;
        Integer ageInt1=34;
        Integer ageInt2=39;
        Integer ageInt3=48;
        Integer ageInt4=60;
        Integer ageInt5=67;
        Integer ageInt6=-12;
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        //Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Person);
        //Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Company);
        Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        
        System.runAs (user1) {
            test.starttest();            
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            Acc.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(Acc.ID).ID;
            //Acc.Mobile__c='4545452';
            //Acc.Mobile2__c='9898989';
            update Acc;
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            
            //Update Account            
            Acc = TestUtils.UpdateAccount(Acc.id);  
            Account acc2 = AccountHelperBaseTest.createCompanyAccount(user1);
            acc2.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(acc2.ID).ID;
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
            
            AccountHelperBase.calculateAgeRange(ageInt1);
            AccountHelperBase.calculateAgeRange(ageInt2);
            AccountHelperBase.calculateAgeRange(ageInt3);
            AccountHelperBase.calculateAgeRange(ageInt4);
            AccountHelperBase.calculateAgeRange(ageInt5);
            AccountHelperBase.calculateAgeRange(ageInt6);
            Map<Id, Account> m1=new Map<id, Account>();
            Account a1=list3[0];
            m1.put(a1.id,a1);
            
            
            AccountHelperBase.updatePrimaryAddressdisplay(List3,true,m1);
            AccountHelperBase.updateMarketingFields(list2);
            AccountHelperBase.updateAccountFieldsBeforeInsertInt(list2,True);
            AccountHelperBase.updatemarket(list2);
            AccountHelperBase.createUpdateCDMUCID('abcd', 'MY',list2 );
            AccountHelperBase.entityNotifyUpdate('abcd','MY','MY','abcd');
            AccountHelperBase.validate('+66123456789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+6612345s789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+6600000123456789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+661234abcd', 3, 'Home Phone', 8, 11);
            AccountHelperBase.validate('+661234', 3, 'Home Phone', 8, 11);
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list2[0];
            m.put(a.id,a);
            
            Account acc3 = TestUtils.createPersonAccountAsUserAsOwner(user1);
            acc3.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(acc3.ID).ID;
            update acc3;
            Map<Id, Account> m2=new Map<id, Account>();
            Account a3=acc3;
            m2.put(a3.id,a3);
            acc3 = TestUtils.UpdateAccount(acc3.Id);
            acc3.Mobile2__c = '+66541725922';
            acc3.Mobile__c = '+66848392422';
            update acc3;
            list<Account> list4=new list<Account>();
            list4.add(acc3);
            
            Account acc4 = TestUtils.UpdateAccount(list2[0].Id);
            acc4.Mobile2__c = '+66837249812';
            acc4.Mobile__c = '+66837249546';
            update acc4;
            list<Account> list5=new list<Account>();
            list5.add(acc4);
            
            list<Account> list6=new list<Account>();
            list6.add(Acc);
            acc2.ID_Number__c = '';
            update(acc2);
            list6.add(acc2);
            acc3.ID_Number__c = '12as4';
            update(acc3);
            list6.add(acc3);
            AccountHelperBase.ValidateNationalid(list6);
            AccountHelperBase.UpdateConsentHistory(m,list2);
            //AccountHelperBase.updateAccountFieldsBeforeIntUpdate();
            AccountHelperBase.updateAccountFieldsBeforeUpdate(list4, m2, true);
            AccountHelperBase.updateAccountFieldsBeforeIntUpdate(list5,m,true);
            
            AccountHelperBase.DealerCommAccountlinkcreatecdm(List3,m1,'MY');
            AccountHelperBase.updatePrimaryAddressDetailsOnALK(list2,m);
            
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
   
    static testMethod void testAccAssignment1() {
        /*String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
insert dealer1;
Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
insert dealerContact;
User user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
insert user2;*/
        
        String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        profile p22=[select id from profile where Name='System Administrator'];
        userrole ur =[select id from userrole where Name ='Daimler APAC'];
        
        User user1 = new User(LastName='GEORGE',Market__c='TH',userroleid=ur.id,country='Australia',ProfileId=p22.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
        insert user1;
        //User user1 = TestUtils.createMYAdminUser();
        User user2;
        System.runAs (user1) {
                    //creating custom setting 
           Operation_Mapping__c om = New Operation_Mapping__c();
           om.Operation_Parameters__c = 'Account;Account_Link__c;RetailCopy';
               om.Name = 'RetailCopy';
               insert om; 
           Operation_Mapping__c om1 = New Operation_Mapping__c();
           om1.Operation_Parameters__c = 'Address__c;Account_Link__c;AddressRetailCopy';
               om1.Name = 'AddressRetailCopy';
               insert om1; 
      Operation_Mapping__c om2 = New Operation_Mapping__c();
           om2.Operation_Parameters__c = 'Account_Link__c;Address__c;AddressRetailCopy';
               om2.Name = 'AddressWholesaleCopy';
               insert om2; 
       Operation_Mapping__c om3 = New Operation_Mapping__c();
           om3.Operation_Parameters__c = 'Account_Link__c;Account;RetailCopy';
               om3.Name = 'WholesaleCopy';
               insert om3; 
            
            Account account = new Account();
            account.Name = 'account name';
            account.Phone = '012310086';
            account.Area_Code__c = '010';
            account.Fax = '012310086';
            account.BillingCity = 'San Francisco';
            account.BillingCountry = 'USA';
            account.BillingPostalCode = '94105';
            account.Dealer_nd_code__c='1234';
            account.BillingState = 'CA';
            account.Dealer_Presales_Email__c='test@test.com';
            account.Dealer_CRM_Manager_Email__c ='test@test.com';
            account.Dealer_Marketing_Manager_Email__c='test@test.com';
            account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5256';
            account.Dealer_Complaint_Manager__c='true';
            account.Dealer_Rollout_Status__c='Done';
            account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            account.Foundation_Date__c = date.today()-1;
            //account.MD__c='AU';
            insert account;
            
            
            
            List<Account> acList = new List<Account>();
            acList.add(account);
            AccountHelperBase.CreateRetailCopy(acList,true,true);
            
            Contact contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = 'test@test.com';
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = account.Id;
            
            Contact contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = 'test@test.com';
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
            contact1.AccountId = account.Id;
            
            List<Contact> contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;
            
            Id p = [SELECT Id FROM Profile WHERE usertype='PowerPartner' limit 1].id;
            User portaluser = new User(alias = 'test123', email='test123@noemail.com',
                                       emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                       localesidkey='en_US', profileid = p, country='India',IsActive =true,
                                       ContactId = contacts[0].Id,
                                       timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
            profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
            Account dealer1 =  new Account(Dealer_Rollout_Status__c='Done',Corporate_Category__c='Rental',Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company'), Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
            insert dealer1;
            Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
            insert dealerContact;
            user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev0d1');
            insert user2;
            Group g=new group(name='12345');insert g;
        }
        system.runAs(user2){
            test.startTest();
      /*      Account accD = TestUtils.createPersonAccountAsUserAsOwner(user2);
accD.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(accD.ID).ID;
update accD; */
            list<Account> listDeal=new list<Account>();
            listDeal.add(new Account( LastName = 'account name',Phone = '012310086',Area_Code__c = '010',
                                     Fax = '012310086',
                                     //Retail_Foundation_Month__c=system.today(),
                                     BillingCity = 'San Francisco',
                                     BillingCountry = 'USA',
                                     BillingPostalCode = '94105',
                                     BillingState = 'CA',MD__c='NZ',
                                     Dealer_Presales_Email__c='test@test.com',
                                     Dealer_CRM_Manager_Email__c ='test@test.com',
                                     Dealer_Marketing_Manager_Email__c='test@test.com',
                                     BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5255',
                                     Dealer_Complaint_Manager__c='true',
                                     Personal_Agreement__c='tree',Foundation_Date__c = date.today()-1,
                                     RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account')));
            listDeal.add(new Account( Name = 'account name',Phone = '012310086',Area_Code__c = '010',
                                     Fax = '012310086',
                                     BillingCity = 'San Francisco',
                                     BillingCountry = 'USA',
                                     BillingPostalCode = '94105',
                                     BillingState = 'CA',
                                     Dealer_Presales_Email__c='test@test.com',
                                     Dealer_CRM_Manager_Email__c ='test@test.com',
                                     Dealer_Marketing_Manager_Email__c='test@test.com',
                                     BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5254',
                                     Dealer_Complaint_Manager__c='true',Foundation_Date__c = date.today()-1,MD__c='NZ',
                                     RecordTypeId =RecordTypeAccessService.getRecordTypeId('Account','Company')));
            insert listDeal;
            Map<Id,Account> oldAccountMap=new Map<id,Account>();
            oldAccountMap.put(listDeal[0].id,listDeal[0]);
            Map<Id,Account> newMap=new Map<id,Account>();
            newMap.put(listDeal[0].id,listDeal[0]);
            List<Account> lea=[select id from account where id IN:listdeal];
          
            
            AccountHelperBase.CreateRetailCopy(listDeal,true,true);
            AccountHelperBase.UpdateConsentHistory(newMap,oldAccountMap.values());
            AccountHelperBase.updateRetailCopy(True,True,True,listDeal);
            test.stopTest();
        }
        
    }
    //Added for TR market
    static testMethod void testAccAssignmentTR() {
        
        User user1 = TestUtils.createTRAdminUser();
        system.debug('USER1-->'+user1);
        String market='TR';
        Integer ageInt=25;
        Integer ageInt1=34;
        Integer ageInt2=39;
        Integer ageInt3=48;
        Integer ageInt4=60;
        Integer ageInt5=67;
        Integer ageInt6=-12;
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        //Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Person);
        //Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c',Label.Retail_Company);
        Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        
        System.runAs (user1) {
            test.starttest();            
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            Acc.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(Acc.ID).ID;
            acc.Mobile__c='4545452';
            acc.Mobile2__c='9898989';
            update Acc;
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            Map<Id, Account> m2=new Map<id, Account>();
            m2.put(acc.id,acc);
            //Update Account            
            Acc = TestUtils.UpdateAccount(Acc.id);  
            Account acc2 = AccountHelperBaseTest.createCompanyAccount(user1);
            acc2.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(acc2.ID).ID;
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
            
            AccountHelperBase.calculateAgeRange(ageInt1);
            AccountHelperBase.calculateAgeRange(ageInt2);
            AccountHelperBase.calculateAgeRange(ageInt3);
            AccountHelperBase.calculateAgeRange(ageInt4);
            AccountHelperBase.calculateAgeRange(ageInt5);
            AccountHelperBase.calculateAgeRange(ageInt6);
            Map<Id, Account> m1=new Map<id, Account>();
            Account a1=list3[0];
            m1.put(a1.id,a1);
            
            
            AccountHelperBase.updatePrimaryAddressdisplay(List3,true,m1);
            AccountHelperBase.updateMarketingFields(list2);
            AccountHelperBase.updateAccountFieldsBeforeInsertInt(list2,True);
            AccountHelperBase.updatemarket(list2);
            AccountHelperBase.createUpdateCDMUCID('abcd', 'TR',list2 );
            AccountHelperBase.entityNotifyUpdate('abcd','TR','TR','abcd');
            AccountHelperBase.validate('+66123456789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+6612345s789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+6600000123456789', 3, 'Mobile', 9, 12);
            AccountHelperBase.validate('+661234abcd', 3, 'Home Phone', 8, 11);
            AccountHelperBase.validate('+661234', 3, 'Home Phone', 8, 11);
            Map<Id, Account> m=new Map<id, Account>();
            Account a=list2[0];
            m.put(a.id,a);
            
            Account acc3 = TestUtils.createPersonAccountAsUserAsOwner(user1);
            acc3.Primary_Address_Reference__c = AccountHelperBaseTest.createAddress(acc3.ID).ID;
            update acc3;
            Map<Id, Account> m3=new Map<id, Account>();
            Account a3=acc3;
            m3.put(a3.id,a3);
            acc3 = TestUtils.UpdateAccount(acc3.Id);
            acc3.Mobile2__c = '+66541725922';
            acc3.Mobile__c = '+66848392422';
            update acc3;
            list<Account> list4=new list<Account>();
            list4.add(acc3);
            
            Account acc4 = TestUtils.UpdateAccount(list2[0].Id);
            acc4.Mobile2__c = '+66837249812';
            acc4.Mobile__c = '+66837249546';
            update acc4;
            list<Account> list5=new list<Account>();
            list5.add(acc4);
            
            list<Account> list6=new list<Account>();
            list6.add(Acc);
            acc2.ID_Number__c = '';
            update(acc2);
            list6.add(acc2);
            acc3.ID_Number__c = '12as4';
            update(acc3);
            list6.add(acc3);
            AccountHelperBase.ValidateNationalid(list6);
            AccountHelperBase.UpdateConsentHistory(m,list2);
            //AccountHelperBase.updateAccountFieldsBeforeIntUpdate();
            AccountHelperBase.updateAccountFieldsBeforeUpdate(list4, m3, true);
            AccountHelperBase.updateAccountFieldsBeforeIntUpdate(list5,m,true);
            
            AccountHelperBase.DealerCommAccountlinkcreatecdm(List3,m1,'MY');
            AccountHelperBase.updatePrimaryAddressDetailsOnALK(list2,m);
            AccountHelperBase.CreateRetailCopy(list3,true,true);
            AccountHelperBase.updateRetailCopy(true,true,true,list3);
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
            
            Account_Link__c PAcclink = TestUtils.createAccLinkTR('Retail Person', Acc.Id);//person account   
            AccountHelperBase.updateRetailCopy(True,True,True,list2);
            Account_Link__c CAcclink = TestUtils.createAccLinkTR('Retail Person', acc2.Id);//company account
            AccountHelperBase.updateRetailCopy(True,True,True,list3);
            AccountHelperBase.createUCID(list2,True);
            
            List<Account_Link__c>  retailCopyList = [select id from Account_Link__c where toRole__c =:acc.Id AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            system.assert(retailCopyList.size()>0);
            test.stopTest();
        }
    }
    // Creation of Address
    public static Address__c createAddress(Id AccId){                   
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '327031';
        address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';   
        address.Country__c='India';
        system.debug('address-->'+address);
        insert address;
        return address;
    }
    //creation of company account
    public static Account createCompanyAccount(User U){             
        Account a = new Account(Name = u.LastName);
        a.Dealer_Default_Flag__c=false;
        a.Dealer_DMS_SR_Code__c='test code 2';
        a.Home_Phone_2__c = '02202123626';
        a.Work_Phone__c ='+6612123799';
        a.Mobile__c ='+66121237993';
        a.Mobile2__c ='+66121238003';
        a.Status__c='NoCustomer';
        a.Email__c = 'testmail@test.com';
        a.Email2__c = 'teemail2@test.com';
        a.Email3__c = 'temail3@test.com';
        a.City__c='Beijing';
        a.Gender__c = 'Male';
        a.Corporate_Category__c='Rental';
        a.Phone = '0802101110';
        a.Individual_Home_Phone__c='+6612323789';
        a.Area_code__c = '0101';
        a.MD__c = u.Market__c; // Modified by Laqshay Arora
        a.Postal_Opt_Out__c=True;  
        a.Province__c = 'Shanghai';
        a.ZipCode__c= '32703';
        a.Primary_Email__c = 'Email1';
        a.Primary_Fax__c = 'FAX2';
        a.Primary_Phone__c ='Other2';
        a.PersonDoNotCall=false;
        a.ownerid=u.id;
        a.PersonHasOptedOutOfEmail=false;
        a.Opt_In_Email__c=true;
        a.Foundation_Date__c=date.today()-1;
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        //a.ID_Type__c = 'National ID';
        a.ID_Type__c = '';
        //a.ID_Number__c='9999999993015';
        a.ID_Number__c='';
        insert a;
        return a;
    }
    
    static testMethod void testAccAssignmentTR1() {
        String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        profile p22=[select id from profile where Name='System Administrator'];
        userrole ur =[select id from userrole where Name ='Daimler APAC'];
        
        User user1 = new User(LastName='GEORGE',Market__c='TR',userroleid=ur.id,country='Australia',ProfileId=p22.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
        insert user1;
        //User user1 = TestUtils.createMYAdminUser();
        User user2;
        System.runAs (user1) {
            Account account = new Account();
            account.Name = 'account name';
            account.Phone = '012310086';
            account.Area_Code__c = '010';
            account.Fax = '012310086';
            account.BillingCity = 'San Francisco';
            account.BillingCountry = 'USA';
            account.BillingPostalCode = '94105';
            account.Dealer_nd_code__c='1234';          
            account.BillingState = 'CA';
            account.Market__c = 'TR';
            account.MD__c='NZ';
            account.Dealer_Presales_Email__c='test@test.com';
            account.Dealer_CRM_Manager_Email__c ='test@test.com';
            account.Dealer_Marketing_Manager_Email__c='test@test.com';
            account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5253';
            account.Dealer_Complaint_Manager__c='true';
            account.Dealer_Rollout_Status__c='Done';
            account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            account.Foundation_Date__c = date.today()-1;
            
            insert account;
            
            
            Contact contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = 'test@test.com';
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = account.Id;
            contact.Market__c = 'TR';
            
            Contact contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = 'test@test.com';
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
            contact1.AccountId = account.Id;
            contact1.Market__c = 'TR';
            
            List<Contact> contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;
            
            Id p = [SELECT Id FROM Profile WHERE usertype='PowerPartner' limit 1].id;
            User portaluser = new User(alias = 'test123', email='test123@noemail.com',
                                       emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                       localesidkey='en_US', profileid = p, country='India',IsActive =true,
                                       ContactId = contacts[0].Id,
                                       timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
            profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
            Account dealer1 =  new Account(Dealer_Rollout_Status__c='Done',Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TR', Individual_Home_Phone__c='+905698745632', RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company'), Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235',Corporate_Category__c='Rental');
            insert dealer1;
            Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TR', Market__c='TR',Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
            insert dealerContact;
            user2 = new User(LastName='GEORGE',contactid=dealerContact.id,Market__c='TR',country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev0d1');
            insert user2;
            Group g=new group(name='12345');insert g;
        }
        system.runAs(user2){
            test.startTest();
            /*Account accD = TestUtils.createPersonAccountAsUserAsOwner(user2);
accD.Primary_Address_Reference__c = TestUtils.createAddress(accD.ID).ID;
update accD;*/
            list<Account> listDeal=new list<Account>();
            listDeal.add(new Account( LastName = 'account name',FirstName='test name',Phone = '012310086',Area_Code__c = '010',
                                     Fax = '012310086',
                                     //Retail_Foundation_Month__c=system.today(),
                                     BillingCity = 'San Francisco',
                                     BillingCountry = 'USA',
                                     BillingPostalCode = '94105',
                                     BillingState = 'CA',
                                     Dealer_Presales_Email__c='test@test.com',
                                     Dealer_CRM_Manager_Email__c ='test@test.com',
                                     Dealer_Marketing_Manager_Email__c='test@test.com',
                                     BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5252',
                                     Dealer_Complaint_Manager__c='true',
                                     Personal_Agreement__c='tree',Foundation_Date__c = date.today()-1,
                                     RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account')));
            listDeal.add(new Account( Name = 'account name',Phone = '012310086',Area_Code__c = '010',
                                     Fax = '012310086',
                                     BillingCity = 'San Francisco',
                                     BillingCountry = 'USA',
                                     BillingPostalCode = '94105',
                                     BillingState = 'CA',
                                     Dealer_Presales_Email__c='test@test.com',
                                     Dealer_CRM_Manager_Email__c ='test@test.com',
                                     Dealer_Marketing_Manager_Email__c='test@test.com',
                                     BillingStreet = 'SnapBi 55 New Montgomery Street Suite 5251',
                                     Dealer_Complaint_Manager__c='true',Market__c='TR',Foundation_Date__c = date.today()-1,
                                     RecordTypeId =RecordTypeAccessService.getRecordTypeId('Account','Company')));
            insert listDeal;
            Map<Id,Account> oldAccountMap=new Map<id,Account>();
            oldAccountMap.put(listDeal[0].id,listDeal[0]);
            Map<Id,Account> newMap=new Map<id,Account>();
            newMap.put(listDeal[0].id,listDeal[0]);
            List<Account> lea=[select id from account where id IN:listdeal];
            AccountHelperBase.CreateRetailCopy(listDeal,true,true);
            AccountHelperBase.UpdateConsentHistory(newMap,oldAccountMap.values());
            AccountHelperBase.updateRetailCopy(True,True,True,listDeal);
            test.stopTest();
        }
        
    }
    
}