/**
** Class: PhoneNumberFormatCheckINTest
** Description: Test Class for PhoneNumberFormatCheckINTest
** Created By: Prem Kumar
** Date: 2018/03/21
**/
@IsTest
public class PhoneNumberFormatCheckINTest {
	public static Account objAccount;
    public static Account objAccount1;
    public static Account personAcc;
    public static Account personAcc1;
    public static Address__C addressobj ;
    public static user usr;
    public static User user1;
    public static User user_Obj; 
    
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    @IsTest
    private static void testFormat1() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='asdf';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For Correct Phone format validation
    @IsTest
    private static void testFormat2() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.market = 'IN';     
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode=null;
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode= null;
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode=null;
        INAcccontroller.faxAreaCode='asdf';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // for null contry code validation check
    @IsTest
    private static void testFormat3() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.market = 'IN';
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode= '';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode= '';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode = '';
        INAcccontroller.faxAreaCode='asdf';
        INAcccontroller.faxCountryCode='';
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For null area code validation check
    @IsTest
    private static void testFormat4() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For Correct Fax Validation
    @IsTest
    private static void testFormat6() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.RecordType = 'Company';
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='asdf';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For null Fax Validation check
    @IsTest
    private static void testFormat7() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.RecordType = 'Company';
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='';
        INAcccontroller.faxCountryCode='';
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // for only Null fax area validation check
    @IsTest
    private static void testFormat8() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.RecordType = 'Company';
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= 'asdf';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For fax digit validation
    @IsTest
    private static void testFormat9() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        test.startTest();
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.RecordType = 'Company';
        INAcccontroller.market = 'IN';   
        INAcccontroller.hmphoneNumber= 'asdf'; 
        INAcccontroller.wkphoneNumber= 'asdf';
        INAcccontroller.mbphoneNumber= 'asdf';
        INAcccontroller.faxphoneNumber= '1234567';
        INAcccontroller.wkAreaCode='asdf';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='asdf';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='123';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    // For Contact Table format validation
    @IsTest
    private static void testFormat10() {
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.hmphoneNumber= 'asdf'; 
        ctc.wkphoneNumber= 'asdf';
        ctc.mbphoneNumber= 'asdf';
        ctc.faxphoneNumber= '1234567';
        ctc.wkAreaCode='asdf';
        ctc.wkCountryCode='+91';
        ctc.hmAreaCode='asdf';
        ctc.hmCountryCode='+91';
        ctc.mbAreaCode='';
        ctc.mbCountryCode='+91';
        ctc.faxAreaCode='123';
        ctc.faxCountryCode='+91';
        ctc.PhoneNumberFormatIN();
        ctc.UpdateAccountIN();
        test.stoptest();
    }
    
    static void createTestData(){
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user1;
        system.runAs(user1){    
            List<RegionMasterInfo__c> rm= new List<RegionMasterInfo__c>();
            RegionMasterInfo__c rg=new RegionMasterInfo__c();
            rg.Province__c='Province1';
            rg.ZipCode__c='24575';
            rg.Language__c='English';
            rg.District__c='bans';
            rg.Sub_DIstrict__c='subdist';
            rm.add(rg);
            RegionMasterInfo__c rg1=new RegionMasterInfo__c();
            rg1.Province__c='chittoor';
            rg1.ZipCode__c='45756';
            rg1.Language__c='English';
            rg1.District__c='chittoor';
            rg1.Sub_DIstrict__c='chittoor';
            rm.add(rg1);
            insert rm;
            objAccount= new Account();
            objAccount.RecordtypeId= companyAccRecordTypeId;
            objAccount.Name='Test Person 1st';
            objAccount.Status__c='Active';
            objAccount.Province__c='Province1';
            objAccount.City__c='Test';
            objAccount.Email__c='abcf@hji.com';
            objAccount.ID_Type__c='National ID';
            objAccount.ID_Number__c='1234567891234';
            objAccount.Commercial_Reg_No__c='adfgrt';
            User us=[select market__c from user where id=:UserInfo.getUserId()];
            if(us.market__c=='TH'||us.market__c=='KR'){
                objAccount.ZipCode__c = '42875';
                
            }
            else{
                objAccount.ZipCode__c = '123456';
            }
            
            objAccount.Email__c='test@mbj.com';  
            objAccount.Mobile__c='+911234567890';
            objAccount.Preferred_Language__c='English';      
            objAccount.MBK_Data_Source__c ='Email';
            objAccount.Province__c = 'Province1';
            objAccount.Phone = '08022420181';
            objAccount.Vat_No__c='kdjid';
            objAccount.Preferred_Language__c='English';
            objAccount.Province__c='apdff';
            
            
            
            insert objAccount;
            
            objAccount1 = new Account();
            objAccount1.RecordtypeId= companyAccRecordTypeId;
            objAccount1.Name='Test Person 1st';
            objAccount1.ID_Type__c='National ID';
            objAccount1.ID_Number__c='1234567891234';
            try{
                insert objAccount1;
            }
            catch(DMLException e){
                system.debug('!!!'+ e);
            }
            
            personAcc= new Account();
            personAcc.RecordtypeId= strPerson;
            personAcc.LastName='Test123';
            personAcc.Status__c='Active';
            personAcc.Province__c='Province1';
            personAcc.City__c='Test';
            personAcc.ID_Type__c='National ID';
            personAcc.ID_Number__c='1234567891234';
            if(us.market__c=='TH'||us.market__c=='KR'){
                personAcc.ZipCode__c = '42877';
                
            }
            else {
                personAcc.ZipCode__c = '123456';
            }
            personAcc.Email__c='test@mbj.com';
            personAcc.Mobile__c='+911234567890';
            personAcc.Preferred_Language__c='Engmmm';        
            personAcc.MBK_Data_Source__c ='Email';
            personAcc.Phone = '08022420181';
            personAcc.Province__c = 'Province1';
            personAcc.Commercial_Reg_No__c='adfgrt';
            personAcc.Vat_No__c='kdjid';
            personAcc.Preferred_Language__c='telugu';
            insert personAcc;
            
            personAcc1 = new Account();
            personAcc1.RecordtypeId= strPerson;
            personAcc1.LastName='Test Person 2nd';
            personAcc1.ID_Type__c='National ID';
            personAcc1.ID_Number__c='1234567891234';
            try{insert personAcc1;}
            catch(DMLException e){
                
                system.debug('!!! '+ e);
                
            }
            
            addressobj =  new Address__C();
            addressobj.Customer__c = objAccount.Id;
            addressobj.Address_Type__c = 'Home';
            addressobj.Address_Line_1__c = 'line 1';
            addressobj.Address_Line_2__c = 'line 2';
            addressobj.Block__c = 'Block';
            addressobj.Customer__c = objAccount.id;
            addressobj.ZipCode__c = '14941';
            addressobj.Province__c ='Maharashtra';
            addressobj.TitleOfHonor__c = 'To Person';
            addressobj.Market__c='IN';
            addressobj.Foreign_Nationals__c = true;
            addressobj.Country__c = 'India';
            insert addressobj;
        }
    }
}