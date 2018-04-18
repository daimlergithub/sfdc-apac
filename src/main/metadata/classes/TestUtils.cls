/*******************************************************************************************
* Class:                TestUtils
* Description:          Utility class used by all test classes to create data for testing
* ------------------------------------------------------------------------------------------
* Date                  Name                        Modification Description
* 17-May-2017           Shruthi Aipanjiguly         Created
* 25-May-2017           Sarath                      Created IntegrationAPI user for phone formatIssue
* 18-Mar-2018       Sravanthi          Added createAdminUser and CreatePersonAccount generic methods
==========================================================================================*/

@istest
public class TestUtils {
public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
    
    /* Creation of users for different roles  - Begin */
    // Admin User Creation
     public static User createAdminUser(){   
      //UserRole role= [Select Id,name From UserRole Where DeveloperName ='MBTH'];            
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='UserTH',country='Australia',/*UserRoleId = role.id*/firstName='BCI',ProfileId=p.Id,Alias='ainTH123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusrTH@daimler.com'+String.valueof(DateTime.now().getTime()),Market__c = 'TH');
        insert u;
        return u;
    }
    public static User createMYAdminUser(){               
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusr@daimler.com'+String.valueof(DateTime.now().getTime()),Market__c = 'MY');
        insert u;
        return u;
    }
    //Generic method to create an admin user with passed market value - added by India market
    public static User createGenericAdminUser(String sCountry, String sTimeszonekey, String sMarket){               
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='User',country=sCountry,firstName='GenericBCI',ProfileId=p.Id,Alias='aind123',EmailEncodingKey='UTF-8',TimeZoneSidKey=sTimeszonekey,LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuserind01@testing.com',UserName='admusrind@daimler.com',Market__c = sMarket);
        insert u;
        return u;
    }
    public static User createTRAdminUser(){               
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='User',country='Turkey',firstName='BCI',ProfileId=p.Id,Alias='ain1TR',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusrTR@daimler.com',Market__c = 'TR');
        insert u;
        return u;
    }
 public static User createAfterSalesManagerTR(){       
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole role= [Select Id,name From UserRole Where DeveloperName ='MBTH_Manager'];
        User user1 = new User(LastName='User',UserRoleId = role.id,country='Australia', market__c = 'TR', firstName='BCI',ProfileId=p.Id,Alias='ain1TR',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='aftersalesmanager@testing.com',UserName='aftersalesTR@test.com');
        insert user1;
        return user1;
    }
    // After Sales Manager User Creation
    public static User createAfterSalesManager(){       
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole role= [Select Id,name From UserRole Where DeveloperName ='MBTH_Manager'];
        User user1 = new User(LastName='UserTH',UserRoleId = role.id,country='Australia',firstName='BCI',ProfileId=p.Id,Alias='ainTH123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='aftersalesmanager@testing.com',UserName='aftersales@test.com'+String.valueof(DateTime.now().getTime()));
        insert user1;
        return user1;
    }
    
    public static User createAfterSalesManagerMY(){       
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole role= [Select Id,name From UserRole Where DeveloperName ='MBTH_Manager'];
        User user1 = new User(LastName='User',UserRoleId = role.id,country='Australia', market__c = 'MY', firstName='BCI',ProfileId=p.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='aftersalesmanager@testing.com',UserName='aftersales@test.com'+String.valueof(DateTime.now().getTime()));
        insert user1;
        return user1;
    }
    
    // Country specific user - TH Dealer Delegate Admin Creation
    public static User createDDAdminUSer(id con){       
        Profile p2 = [select id from profile where Name='Thailand Dealer Delegate Admin'];
        User userB = new User(alias = 'test123', email='test123@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p2.id, country='Australia',IsActive =true,
                              ContactId = con,
                              timezonesidkey='America/New_York', username='UserBAHTH1@noemail.com'+String.valueof(DateTime.now().getTime()));
        Insert userB;
        return userB;
    }
    
    // Integration API user - Phone Formatting 
    public static User IntegrationAPIUser(){       
        Profile p3 = [select id from profile where Name='IntegrationAPI'];
        User userC = new User(alias = 'test123', email='test123@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p3.id, country='Thailand',IsActive =true,
                              timezonesidkey='America/New_York', username='UserBAHTH2@noemail.com'+String.valueof(DateTime.now().getTime()));
        Insert userC;
        return userC;
    }
    
    /* Creation of users for different roles - End */
    
    /* Creation of Generic methods by India - start */
    
    // Added to provide India specific custom permission to users.
    public static void providePermissionsIN(User u, PermissionSet ps, String custPermSet){ 
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = [select Id from CustomPermission where DeveloperName =: custPermSet][0].Id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
    }
    
    // Create generic bulk RegionMasterInfo__c records 
    public static List<RegionMasterInfo__c> createBulkRegionMaster(Integer n){
        List<RegionMasterInfo__c> rm = new List<RegionMasterInfo__c>();
        for(Integer i=0; i<n; i++){
            RegionMasterInfo__c rg = new RegionMasterInfo__c();
            rg.Province__c = 'Province'+i;
            rg.ZipCode__c = '123456';
            rg.Language__c = 'English';
            rg.District__c = 'Pimpri'+i;
            rg.Sub_DIstrict__c = 'Pimple Saudagar'+i;
            rm.add(rg);
        }
        return rm;
    } 
    
// Create Dealer Account(India)
    public static Account createDealerAccount(Id accRecordTypeId){
        Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = accRecordTypeId);
        insert dealerAcc;
        return dealerAcc;
    }
    
    // Create generic Opportunity record(India)
    public static Opportunity createGenericOpportunity(User u, Account acc, Id oppRecordTypeId, String market){
        /*
        DescribeFieldResult describeType = Opportunity.Lead_Type__c.getDescribe();
        List<PicklistEntry> typeValues = describeType.getPicklistValues();
        DescribeFieldResult describeSubType = Opportunity.Lead_Sub_Type__c.getDescribe();
        List<PicklistEntry> subTypeValues = describeSubType.getPicklistValues();
    */
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Market__c = market;
        opp.Name = 'Generic Opportunity';
        opp.RecordTypeId = oppRecordTypeId;
        opp.CloseDate = Date.newInstance(2018, 4, 17);
        if(UtilRecordType.getRecordTypeNameById('Opportunity', oppRecordTypeId) == 'Sales Lead'){
            opp.Lead_Type__c = 'Activities';
            opp.Lead_Sub_Type__c = 'Test Drive';
            opp.Lead_DataSource__c = 'Event';
        }
        else{
            opp.Lead_Type__c = 'Car Service';
            opp.Lead_Sub_Type__c = 'Others';
            opp.Lead_DataSource__c = 'Event';
        }
        //opp.Lead_Type__c = typeValues[0].getValue();
        //opp.Lead_Sub_Type__c = subTypeValues[0].getValue();
        insert opp;
        return opp;
    }
    
    // Create generic bulk Opportunity record(India)
    public static List<Opportunity> createGenericBulkOpportunity(User u, Account acc, Id oppRecordTypeId, String market, Integer count){
        List<Opportunity> oppList = new List<Opportunity>();
        String add = 'A';
        string dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN');
        insert dealerAcc;
        Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
        insert con;
        for(Integer i=0; i<count; i++){
            add += 'B';
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.StageName = 'New';
            opp.Market__c = market;
            opp.Name = 'Test' + add;
            opp.RecordTypeId = oppRecordTypeId;
            opp.Sales_Consultant__c = con.Id;
            opp.Assigned_Dealer__c = dealerAcc.Id;
            opp.Assigned_Service_Advisor__c = u.Id;
            opp.CloseDate = Date.newInstance(2018, 4, 17);
            if(UtilRecordType.getRecordTypeNameById('Opportunity', oppRecordTypeId) == 'Sales Lead'){
                opp.Lead_Type__c = 'Activities';
                opp.Lead_Sub_Type__c = 'Test Drive';
                opp.Lead_DataSource__c = 'Event';
            }
            else{
                opp.Lead_Type__c = 'Car Service';
                opp.Lead_Sub_Type__c = 'Others';
                opp.Lead_DataSource__c = 'Event';
            }
            oppList.add(opp);
        }
        insert oppList;
        return oppList;
    }
        
    // Create bulk Car Model Records(India)
    public static List<Car_Model__c> createBulkCarModel(Integer n){
        List<Car_Model__c> cModelList = new List<Car_Model__c>();
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'Mercedes-Benz' + i;
            cm.Brand__c = 'Mercedes-Benz';
            cm.Series__c = 'A' + 1;
            cm.Status__c = 'Own Sellable';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cModelList.add(cm);
        }
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'BMW GT Series' + i;
            cm.Brand__c = 'BMW';
            cm.Series__c = 'GT' + 1;
            cm.Status__c = 'Competitor';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cModelList.add(cm);
        }
        insert cModelList;
        return cModelList;
    }
    
    // Create bulk Lead Details Records(India)
    public static List<Lead_Details__c> createBulkLeadDetails(Opportunity opp, List<Car_Model__c> cmList){
        List<Lead_Details__c> ldList = new List<Lead_Details__c>();
        for(Car_Model__c cm : cmList){
            Lead_Details__c lDet = new Lead_Details__c();
            if(cm.Status__c == 'Own Sellable'){
                lDet.Car_Model__c = cm.Id;
                lDet.Related_Lead__c = opp.Id;
                lDet.Brand__c = cm.Brand__c;
                lDet.Color__c = cm.Colour__c;
                lDet.Trim__c = cm.Trim__c;
                lDet.Mileage__c = '40';
                lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                ldList.add(lDet);
            }
            else if(cm.Status__c == 'Competitor'){
                lDet.Car_Model_Competitor__c = cm.Id;
                lDet.Related_Lead__c = opp.Id;
                lDet.Brand__c = cm.Brand__c;
                lDet.Color__c = cm.Colour__c;
                lDet.Trim__c = cm.Trim__c;
                lDet.Mileage__c = '40';
                lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                ldList.add(lDet);
            } 
        }
        Lead_Details__c lDet1 = new Lead_Details__c();
        lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
        lDet1.Related_Lead__c = opp.Id;
        lDet1.Trim__c = 'Medium';
        lDet1.Year_of_Manufacture__c = '1234';
        lDet1.Mileage__c = '40';
        lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
        ldList.add(lDet1);
        insert ldList;
        return ldList;
    }
    
    // Create generic company account
    public static Account createGenericAccount(User u, String zipCode, Id accRecordTypeId, String mobile){
        Account genericAccount = new Account();
        genericAccount.RecordtypeId = accRecordTypeId;
        if(accRecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId()){
            genericAccount.Name = 'Test Generic Account';
        }
        else{
            genericAccount.FirstName = 'Test Generic fName';
            genericAccount.LastName = 'Test Generic lName';            
        }
        genericAccount.Status__c = 'Active';
        genericAccount.Province__c = 'Province1';
        genericAccount.City__c = 'Test';
        genericAccount.Email__c='test@test.com';
        genericAccount.ID_Type__c='National ID';
        genericAccount.ID_Number__c='1234567891234';
        genericAccount.Commercial_Reg_No__c='com12345';
        genericAccount.ZipCode__c = zipCode;
        genericAccount.Email__c ='test@test.com';  
        genericAccount.Mobile__c = mobile;
        genericAccount.Preferred_Language__c='English';      
        genericAccount.MBK_Data_Source__c ='Email';
        genericAccount.Province__c = 'Province1';
        genericAccount.Phone = '08022420181';
        genericAccount.Vat_No__c='kdjid';
        genericAccount.Preferred_Language__c='English';
        genericAccount.Province__c='apdff';
        insert genericAccount;
        return genericAccount;
    }
    
    // Create generic Address Record
    public static Address__C createGenericAddressRecord(Account acc, String zipCode, String market, String cntry){
        Address__C addressobj = new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Address_Line_3__c = 'line 3';
        addressobj.Block__c = 'Block';
        addressobj.Customer__c = acc.id;
        addressobj.ZipCode__c = zipCode;
        addressobj.Province__c ='Maharashtra';
        addressobj.TitleOfHonor__c = 'To Person';
        addressobj.Market__c = market;
        addressobj.Foreign_Nationals__c=true;
        addressobj.Country__c = cntry;
        insert addressobj;
        return addressobj;
    }
    // Create generic Address Record
    public static Address__C createGenericAddressRecord(Account acc, String zipCode, String market, String city, String state, String cntry){
        Address__C addressobj = new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Address_Line_3__c = 'line 3';
        addressobj.Block__c = 'Block';
        addressobj.District__c = city;
        addressobj.State__c = state;
        addressobj.Customer__c = acc.id;
        addressobj.ZipCode__c = zipCode;
        addressobj.Province__c ='Maharashtra';
        addressobj.TitleOfHonor__c = 'To Person';
        addressobj.Market__c = market;
        addressobj.Foreign_Nationals__c=false;
        addressobj.Country__c = cntry;
        addressobj.Preferred__c = true;
        insert addressobj;
        return addressobj;
    }
    /* Creation of Generic methods by India - End */
    
    /* Creation of test records in various objects  - Begin  */
    // Creation of a person account
    public static Account createPersonAccountAsUserAsOwner(user U){      
        Account a = new Account(FirstName = u.FirstName,LastName = u.LastName);
        a.Dealer_Default_Flag__c   = false;
        a.Dealer_DMS_SR_Code__c    = 'test code 2';
        a.Home_Phone_2__c          = '02202123626';
        a.Work_Phone__c            = '+6612123799';
        a.Status__c                = 'NoCustomer';
        a.Email__c                 = 'testmail@test.com';
        a.Email2__c                = 'teemail2@test.com';
        a.Email3__c                = 'temail3@test.com';
        a.City__c                  = 'Beijing';
        a.Gender__c                = 'Male';
        a.Phone                    = '0802101110';
        a.Individual_Home_Phone__c = '+6612323789';
        a.Area_code__c             = '0101';
        a.MD__c                    = u.market__c;  // Modified by Laqshay Arora
        a.Market__c                = u.market__c;  // Modified by Hildaa
        a.Postal_Opt_Out__c        = True;
        a.Province__c              = 'Shanghai';
        a.ZipCode__c               = '32703';
        a.Primary_Email__c         = 'Email1';
        a.Primary_Fax__c           = 'FAX2';
        a.Primary_Phone__c         = 'Other2';
        a.PersonDoNotCall          = True;
        a.ownerid                  = u.id;
        a.PersonHasOptedOutOfEmail = true;
        a.Opt_In_Email__c          = true;
        a.ID_Number__c             = '1234567891011';   // Added by Laqshay Arora
        a.ID_Type__c = 'National ID';
        a.PersonBirthdate          = date.newInstance(1991,03,18); // Modified By laqshay Arora
        a.Foundation_Date__c       = date.today();
        a.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert a;
        return a;
    }
//Generic method to create a person account for passed particular market
     public static Account createPersonAccountGeneric(user U, String sPhone, String sCountry, Integer iYear){      
        Account a = new Account(FirstName = u.FirstName,LastName = u.LastName);
        a.Work_Phone__c            = sPhone;
        a.Status__c                = 'Prospect';
        a.Email__c                 = 'testmail@test.com';
        a.Country__c               = sCountry;
        a.Gender__c                = 'Male';
        a.Phone                    = sPhone;
        a.Individual_Home_Phone__c = sPhone;
        a.MD__c                    = u.market__c;
        a.Market__c                = u.Market__c;
        a.ownerid                  = u.id;
        a.PersonBirthdate          = date.newInstance(iYear,03,18); // Modified By laqshay Arora
        a.Foundation_Date__c       = date.today();
        a.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert a;
        return a;
    }
    
// Creation of a company account (B2B)
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
        a.ID_Type__c = 'National ID';
        a.ID_Number__c='9999999993015';
        insert a;
        return a;
    }
    
    //update account
    public static Account UpdateAccount(Id AccID){
        Account Acc = new Account();
        Acc.ID = AccId;
        Acc.Home_Phone_2__c = '03202244644';
        Acc.Work_Phone__c ='+6656123000';
        Acc.Phone = '0802109999';
        Acc.Email__c = 'UpdatedEmail@test.com';
        update Acc;
        Return Acc;
    }
    
    // Creation of Contact
    public static Contact createContact(String name, Id acc){           
        Contact con = new Contact(LastName =name,AccountId = acc);
        insert con;
        return con;
    }
    
    // Creation of Contact
    public static Contact createContactTR(String name, Id acc){           
        Contact con = new Contact(LastName =name,AccountId = acc,Market__c='TR');
        insert con;
        return con;
    }
    
    // Creation of Contract
    public static Contract createContract(Id acc){                      
        Contract contr=new Contract(AccountId=acc,StartDate=date.today(),ContractTerm=4,Status='Draft');
        insert contr;
        return contr;
    }
    
    // Creation of Account Link
    public static Account_Link__c createAccLink(String rectype, Id AccId){          
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(rectype).getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = AccId, ReCordTypeId = RetailPerson);
        insert acclnk;
        return acclnk;
    }
    
    // Creation of Address
    public static Address__c createAddress(Id AccId){                   
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '32703';
        address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
        insert address;
        return address;
    }
    
     // Creation of Address
    public static Address__c createAddressTR(Id AccId){                   
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '32703';
        address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.Market__c='TR';
        address.MD__c='TR';
        insert address;
        return address;
    }
    
    
    public static Address__c createAddressMY(Id AccId){                   
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Fukuoka';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '32703';
        address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='MY';
        insert address;
        return address;
    }
    
    
    /* Creation of test records in various objects  - End */
    /* Creation of Dealer accounts*/
    public static Group CreateTHGroup(String Nameofgroup){
        Group gp= new Group();
        gp.Name = Nameofgroup;
        insert gp;
        return gp;
    }
    public static List<Sobject> createDealerAccountandUserTH(){
     Profile p1 = [select id from profile where Name='System Administrator' limit 1];
     profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];

    /*User user1 = new User(LastName='User1',country='Australia',firstName='aBCI',ProfileId=p1.Id,Alias='aint123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admus1r@daimler.com',Market__c = 'TH');
        insert user1;*/
    Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
    /*User user2 = new User(LastName='GEORGE',contactid=dealerContact.id,firstName='BCIo',country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;*/
    /*User user2 = new User(LastName='Usera',country='Australia',contactid=dealerContact.id,firstName='BCIt',ProfileId=p2.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser041@testing.com',UserName='admus5r@daimler.com',Market__c = 'TH');
        insert user2;*/
    Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
        
        return new List<Sobject>{dealer,dealer1};
        }
}