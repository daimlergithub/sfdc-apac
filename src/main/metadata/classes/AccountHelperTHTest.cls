/*
    Type:      class
    Purpose:   Test class for AccountHelperTH
    Create By: Mohammedtouseef Ahmed
    Created Date :2/4/2016
*/
@isTest
public with sharing class AccountHelperTHTest 
{
     static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        test.starttest();
        Account acc=new Account(
        Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202123626',
                               Work_Phone__c ='+66-12-123-799',
                               Status__c='NoCustomer',Email__c = 'testmail@test.com',Email2__c = 'teemail2@test.com',Email3__c = 'temail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0802101110',
                               Individual_Home_Phone__c='+66-12-323-789',
                              //Mobile__c = '+66-03-777-9999',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              LastName = 'galaxy1',
                              FirstName = 'First Name',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Shanghai',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '+66-03-777-9999',
                               //Email__c ='Dhanamjaya@gmail.com',
                               //Email2__c='Dhanamjaya@gmail.com',
                               //Email3__c='Dhanamjaya@gmail.com',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=false,
                               ownerid=user1.id,
                               PersonHasOptedOutOfEmail=false,
                               Opt_In_Email__c=true,
                               owner=user1,
                               PersonBirthdate=date.today(),
                               Foundation_Date__c=date.today()+1,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        
        list<Account> list2=new list<Account>();
        list2.add(acc);
        //acc.Individual_Home_Phone__c = '03202245626';
        //system.debug(list2[0]);
        acc.Home_Phone_2__c = '03202245026';
        acc.Work_Phone__c ='+66-56-123-799';
        acc.Phone = '0802101110';
        acc.Email__c = 'testmail@test.com';
        //acc.Mobile2__c = '03202245626';
        //acc.Individual_Home_Phone__c = '032022456261';
        //acc.Work_Phone__c = '03202245626';
        //acc.Mobile__c = '032022456261';
        //acc.Mobile2__c = '032022456261';

        //acc.Work_Phone__c = '07202245626';
        update acc;
        //list2.add(acc);
        map<id,Account> addmap1=new map<id,Account>();
        addmap1.put(acc.id,acc);
        //system.debug(addmap1);
        Account acc2=new Account(
        Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202123626',
                               Work_Phone__c ='+66-12-123-799',
                               Status__c='NoCustomer',Email__c = 'testmail@test.com',Email2__c = 'teemail2@test.com',Email3__c = 'temail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0802101110',
                               Individual_Home_Phone__c='+66-12-323-789',
                              //Mobile__c = '+66-03-777-9999',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              //LastName = 'galaxy1',
                              //FirstName = 'First Name',
                              //Salutation = 'Unknown',
                              Name='galxy',
                              
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Shanghai',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '+66-03-777-9999',
                               //Email__c ='Dhanamjaya@gmail.com',
                               //Email2__c='Dhanamjaya@gmail.com',
                               //Email3__c='Dhanamjaya@gmail.com',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=false,
                               ownerid=user1.id,
                               PersonHasOptedOutOfEmail=false,
                               Opt_In_Email__c=true,
                               owner=user1,
                               //PersonBirthdate=date.today(),
                               Foundation_Date__c=date.today()+1,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        insert acc2;
        
        list<Account> list3=new list<Account>();
        list3.add(acc2);
        
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = acc.id, ReCordTypeId = RetailPerson);
        insert acclnk;
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        //acc.Primary_Address_Reference__c=address.id;
        //update acc;
        list<address__c> list1=new list<address__c>();
        list1.add(address);
        
        
        AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
        AccountHelperTH.updateOnDoNotCall(List2);
        AccountHelperTH.updateOnPostalOptout(List2);
        AccountHelperTH.updateOnEmailOptout(List2);
        AccountHelperTH.updateAgeRange(List2);
        AccountHelperTH.activeContracts(List2);
        AccountHelperTH.updateAccountFieldsBeforeUpdate(list2,addmap1,true);
        AccountHelperTH.updatePrimaryAddressdisplay(List2,true);
        AccountHelperTH.CreateRetailCopy(list2,true,true);
        AccountHelperTH.CreateRetailCopy(list3,true,true);
        AccountHelperTH.calculateAgeRange(18);
        AccountHelperTH.calculateAgeRange(22);
        AccountHelperTH.calculateAgeRange(37);
        AccountHelperTH.calculateAgeRange(47);
        AccountHelperTH.calculateAgeRange(57);
        AccountHelperTH.calculateAgeRange(67);
        AccountHelperTH.updateRetailCopy(True,True,True,list2);
        AccountHelperTH.createUCID(list2,True);
        //AddressHelperTH.updateAddressOnAccount(list1);
        //AddressHelperTH.validateSameAddressType(list1,addmap,true,true);
        //AddressHelperTH.validateSameAddressType(list1,addmap,False,False);
        //AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        test.stopTest();
   

    }
  }
  
     
  
   static testMethod void testAccAssignment1() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        test.starttest();
        Account acc=new Account(
        Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202278926',
                               //Work_Phone__c = '02202245626',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Female',
                               Phone = '0801903330',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              LastName = 'Test',
                              FirstName = 'Data',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Beijing',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '918197597651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               ownerid=user1.id,
                               PersonDoNotCall=True,
                               PersonHasOptedOutOfEmail=True,
                               Opt_In_Email__c=true,
                               owner=user1,
                               PersonBirthdate=date.today(),
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        
        
        list<Account> list2=new list<Account>();
        list2.add(acc);
        //acc.Individual_Home_Phone__c = '03202245626';
        acc.Home_Phone_2__c = '02202278926';
        //acc.Work_Phone__c = '07202245626';
        update acc;
        list2.add(acc);
        map<id,Account> addmap1=new map<id,Account>();
        addmap1.put(acc.id,acc);
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = acc.id, ReCordTypeId = RetailPerson);
        insert acclnk;
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        
        list<address__c> list1=new list<address__c>();
        list1.add(address);
        //acc.Primary_Address_Reference__c=address.id;
        //update acc;
        
        AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
        AccountHelperTH.updateOnDoNotCall(List2);
        AccountHelperTH.updateOnPostalOptout(List2);
        AccountHelperTH.updateOnEmailOptout(List2);
        AccountHelperTH.updateAgeRange(List2);
        AccountHelperTH.activeContracts(List2);
        AccountHelperTH.updateAccountFieldsBeforeUpdate(List2,addmap1,true);
        AccountHelperTH.updatePrimaryAddressdisplay(List2,true);
        AccountHelperTH.CreateRetailCopy(List2,true,true);
        AccountHelperTH.calculateAgeRange(18);
        AccountHelperTH.calculateAgeRange(22);
        AccountHelperTH.calculateAgeRange(37);
        AccountHelperTH.calculateAgeRange(47);
        AccountHelperTH.calculateAgeRange(57);
        AccountHelperTH.calculateAgeRange(67);
        AccountHelperTH.createUCID(list2,True);
        AccountHelperTH.updateRetailCopy(True,True,True,list2);
        //AddressHelperTH.updateAddressOnAccount(list1);
        //AddressHelperTH.validateSameAddressType(list1,addmap,true,true);
        //AddressHelperTH.validateSameAddressType(list1,addmap,False,False);
        //AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        test.stopTest();
   

    }
  }
    static testMethod void testAccAssignment3() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        test.starttest();
        Account acc=new Account(
        Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202245626',
                               //Work_Phone__c = '02202245626',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              LastName = 'galaxy1',
                              FirstName = 'First Name',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Shanghai',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '918197597651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=True,
                               //ownerid=user1.id,
                               PersonHasOptedOutOfEmail=false,
                               Opt_In_Email__c=true,
                               owner=user1,
                               PersonBirthdate=date.today(),
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        
        
        list<Account> list2=new list<Account>();
        list2.add(acc);
        //acc.Individual_Home_Phone__c = '03202245626';
        acc.Home_Phone_2__c = '04202245626';
        //acc.Work_Phone__c = '05202245626';
        update acc;
        list2.add(acc);
        map<id,Account> addmap1=new map<id,Account>();
        addmap1.put(acc.id,acc);
        
        
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = acc.id, ReCordTypeId = RetailPerson);
        insert acclnk;
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
            
        insert address;
        address.Address_Type__c='Business';
        update address;
        acc.Primary_Address_Reference__c=address.id;
        update acc;
        list<address__c> list1=new list<address__c>();
        list1.add(address);
        
        
        AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
        AccountHelperTH.updateOnDoNotCall(List2);
        AccountHelperTH.updateOnPostalOptout(List2);
        AccountHelperTH.updateOnEmailOptout(List2);
        AccountHelperTH.updateAgeRange(List2);
        AccountHelperTH.activeContracts(List2);
        AccountHelperTH.updateAccountFieldsBeforeUpdate(List2,addmap1,true);
        AccountHelperTH.updatePrimaryAddressdisplay(List2,true);
        AccountHelperTH.CreateRetailCopy(List2,true,true);
        AccountHelperTH.calculateAgeRange(18);
        AccountHelperTH.calculateAgeRange(22);
        AccountHelperTH.calculateAgeRange(37);
        AccountHelperTH.calculateAgeRange(47);
        AccountHelperTH.calculateAgeRange(57);
        AccountHelperTH.calculateAgeRange(67);
        AccountHelperTH.createUCID(list2,True);
        AccountHelperTH.updateRetailCopy(True,True,True,list2);
        //AddressHelperTH.updateAddressOnAccount(list1);
        //AddressHelperTH.validateSameAddressType(list1,addmap,true,true);
        //AddressHelperTH.validateSameAddressType(list1,addmap,False,False);
        //AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        test.stopTest();
   

    }
  }
  
static testMethod void testAccAssignment1_1() {

    
     Profile p4 = [select id from profile where Name='System Administrator' limit 1];
     UserRole role= [Select Id,name From UserRole Where name ='AfterSalesManager'];
    User user1 = new User(LastName='User',UserRoleId = role.id,country='Australia',firstName='BCI',ProfileId=p4.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    Map<String, String> addtrmap1 = new Map<String, String>();
    addtrmap1.put('test','123333');
    UtilAddressTranslation.addtrmap = addtrmap1;
    
    Account acc1;
    contact con ;
    Account_Link__c acclnk;
    Address__c address;
     System.runAs (user1) {
     acc1=new Account(
     Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202278926',
                               //Work_Phone__c = '02202245626',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Female',
                               Phone = '0801903330',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                               Name = 'InfyDealaer',
                              //LastName = 'Test',
                              //FirstName = 'Data',
                              //Salutation = 'Mrs.',
                              // Postal_Opt_Out__c=True,     
                               Province__c = 'Beijing',
                               ZipCode__c= '32703',
                               Mobile__c = '918-197-597-1651',
                               Mobile2__c = '918-197-597-1651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               //PersonDoNotCall=false,
                               ownerid=user1.id,
                               //PersonHasOptedOutOfEmail=True,
                               //Opt_In_Email__c=true,
                               owner=user1,
                               PersonBirthdate=null,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                               
                               //RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
        insert acc1;
        con = new Contact(LastName ='testCon',AccountId = acc1.Id);
        insert con; 
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = acc1.id, ReCordTypeId = RetailPerson,Retail_Province__c = 'ABC null');
        insert acclnk;
        
         //address = new Address__c(Address_Type__c='Home',Province__c='Aichi',City__c='bangalore',
         address = new Address__c(Address_Type__c='Home',Province__c='test',City__c='bangalore',
         District__c='test2',Block__c='test3',Address_Line_1__c='testaddress1',Address_Line_2__c='testaddress2',
         Customer__c=acc1.id, TitleOfHonor__c ='To Person',preferred__c=True,Opt_In_Hardcopy__c=True,MD__c='TH');
         
        /*address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc1.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';*/
            
        insert address;
        
        } 
        
        Profile p2 = [select id from profile where Name='Thailand Dealer Delegate Admin'];
        User userB = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p2.id, country='Australia',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/New_York', username='UserB@noemail.com');
        Insert userB;
   
        System.runAs (userB) {
   
      
        
        //testDataSetup.IntialCustomSetting(user1.id,user2.id);
        
        test.starttest();
        /*Account acc=new Account(
        Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02202245626',
                               Home_Phone_2__c = '02202278926',
                               //Work_Phone__c = '02202245626',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Female',
                               Phone = '0801903330',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                              LastName = 'Test',
                              FirstName = 'Data',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Beijing',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '918197597651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=True,
                               ownerid=user1.id,
                               PersonHasOptedOutOfEmail=True,
                               Opt_In_Email__c=true,
                               owner=user1,
                               PersonBirthdate=date.today(),
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;*/
        
        
        list<Account> list2=new list<Account>();
        //list2.add(acc);
        list2.add(acc1);
        
        //acc.Individual_Home_Phone__c = '03202245626';
        acc1.Home_Phone_2__c = '02202278926';
        //acc.Work_Phone__c = '07202245626';
        //update acc1;
        //list2.add(acc1);
        map<id,Account> addmap1=new map<id,Account>();
        addmap1.put(acc1.id,acc1);
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        //Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = acc1.id, ReCordTypeId = RetailPerson);
        //insert acclnk;
        
       /* Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=acc1.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
            
        insert address;*/
        //address.Address_Type__c='Business';
        //update address;
        
        list<address__c> list1=new list<address__c>();
        list1.add(address);
        //acc.Primary_Address_Reference__c=address.id;
        //update acc;
        
        AccountHelperTH.updateAccountFieldsBeforeInsert(list2,True);
        AccountHelperTH.updateOnDoNotCall(List2);
        AccountHelperTH.updateOnPostalOptout(List2);
        AccountHelperTH.updateOnEmailOptout(List2);
        AccountHelperTH.updateAgeRange(List2);
        AccountHelperTH.activeContracts(List2);
        AccountHelperTH.updateAccountFieldsBeforeUpdate(List2,addmap1,true);
        AccountHelperTH.updatePrimaryAddressdisplay(List2,true);
        //AccountHelperTH.CreateRetailCopy(List2,true,true);
        AccountHelperTH.CreateRetailCopy(List2,true,false);
        AccountHelperTH.calculateAgeRange(18);
        AccountHelperTH.calculateAgeRange(22);
        AccountHelperTH.calculateAgeRange(37);
        AccountHelperTH.calculateAgeRange(47);
        AccountHelperTH.calculateAgeRange(57);
        AccountHelperTH.calculateAgeRange(67);
        AccountHelperTH.calculateAgeRange(29);
        AccountHelperTH.createUCID(list2,True);
        //AccountHelperTH.updateRetailCopy(True,True,True,list2);
        //AddressHelperTH.updateAddressOnAccount(list1);
        //AddressHelperTH.validateSameAddressType(list1,addmap,true,true);
        //AddressHelperTH.validateSameAddressType(list1,addmap,False,False);
        //AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        test.stopTest();
   }

    //}
  }
  

  
   }