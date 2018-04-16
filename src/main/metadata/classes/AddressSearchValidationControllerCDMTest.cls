/**
** Class: AddressSearchValidationControllerCDMTest
** Description: Test Class for AddressSearchValidationControllerCDMTest
** Created By: Prem Kumar
** Date: 2018/03/14
**/
@IsTest
public class AddressSearchValidationControllerCDMTest {
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
    private static void testSaveAccount1() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.objAccount.Generated_by__c= 'Dealer';
        INAcccontroller.RecordType = 'Person Account';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '12345678'; 
        INAcccontroller.wkphoneNumber= '12345678';
        INAcccontroller.mbphoneNumber= '1234567890';
        INAcccontroller.faxphoneNumber= '12345678';
        INAcccontroller.wkAreaCode='12';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='12';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='12';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.objAccount.id=null; 
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.objAccount.Work_Phone__c='+911234567890'; 
        INAcccontroller.objAccount.Home_Phone_2__c='+911234567890'; 
        INAcccontroller.objAccount.Individual_Home_Phone__c='+911234567890'; 
        INAcccontroller.objAccount.Fax='+911234567890';
        INAcccontroller.objAccount.Email__c='test@test.com';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.PAN__c='ABCDE1234F';
        INAcccontroller.objAccount.Aadhaar__c='123456789012';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.country='India';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='123456';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='zxcv';
        INAcccontroller.Addressobj.Address_Line_3__c='qwer';
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.Addressobj.Country__c = 'India';
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.cancel();
        INAcccontroller.getIsClassic();
        /*
        INAcccontroller.next();
        INAcccontroller.previous();
        INAcccontroller.last();
        INAcccontroller.First();
        */
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveAccount2() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='null'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com';
         INAcccontroller.objAccount.Generated_by__c= 'MBIL'; 
        INAcccontroller.RecordType = 'Person Account';
        test.startTest();      
        INAcccontroller.hmphoneNumber= ''; 
        INAcccontroller.wkphoneNumber= '';
        INAcccontroller.mbphoneNumber= '';
        INAcccontroller.faxphoneNumber= '';
        INAcccontroller.wkAreaCode='';
        INAcccontroller.wkCountryCode='';
        INAcccontroller.hmAreaCode='';
        INAcccontroller.hmCountryCode='';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='';
        INAcccontroller.faxAreaCode='';
        INAcccontroller.faxCountryCode='';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.FirstName = '';
        INAcccontroller.objAccount.LastName = '';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.objAccount.Work_Phone__c=''; 
        INAcccontroller.objAccount.Home_Phone_2__c=''; 
        INAcccontroller.objAccount.Individual_Home_Phone__c='+911234567890'; 
        INAcccontroller.objAccount.Fax='';
        INAcccontroller.objAccount.Email__c='test@test.com';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.PAN__c='ABCDEABCDE';
        INAcccontroller.objAccount.Aadhaar__c='123456AG9012';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.country='India';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='123456';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='';
        INAcccontroller.Addressobj.Address_Line_3__c='';
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        INAcccontroller.cancel();
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveAccount3() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='null'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.RecordType = 'Person Account';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '345'; 
        INAcccontroller.wkphoneNumber= '234';
        INAcccontroller.mbphoneNumber= '345';
        INAcccontroller.faxphoneNumber= '3454576';
        INAcccontroller.wkAreaCode='01';
        INAcccontroller.wkCountryCode='+71';
        INAcccontroller.hmAreaCode='09';
        INAcccontroller.hmCountryCode='+71';
        INAcccontroller.mbAreaCode='00';
        INAcccontroller.mbCountryCode='+71';
        INAcccontroller.faxAreaCode='09';
        INAcccontroller.faxCountryCode='';
        INAcccontroller.objAccount.id=null; 
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.objAccount.Work_Phone__c=''; 
        INAcccontroller.objAccount.Home_Phone_2__c=''; 
        INAcccontroller.objAccount.Individual_Home_Phone__c='+911234'; 
        INAcccontroller.objAccount.Fax='';
        INAcccontroller.objAccount.Email__c='test@test.com';
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.PAN__c='ABCDE1234F';
        INAcccontroller.objAccount.Aadhaar__c='123456AG9012';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.country='India';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='1234';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='';
        INAcccontroller.Addressobj.Address_Line_3__c='';
        INAcccontroller.Addressobj.Country__c='India';
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveAccount4() {
        createTestData1();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='null'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.RecordType = 'Person Account';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '345'; 
        INAcccontroller.wkphoneNumber= '234';
        INAcccontroller.mbphoneNumber= '345';
        INAcccontroller.faxphoneNumber= '345';
        INAcccontroller.wkAreaCode='01';
        INAcccontroller.wkCountryCode='+71';
        INAcccontroller.hmAreaCode='09';
        INAcccontroller.hmCountryCode='+71';
        INAcccontroller.mbAreaCode='00';
        INAcccontroller.mbCountryCode='+71';
        INAcccontroller.faxAreaCode='09';
        INAcccontroller.faxCountryCode='+71';
        INAcccontroller.objAccount.id=null; 
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.objAccount.Work_Phone__c=''; 
        INAcccontroller.objAccount.Home_Phone_2__c=''; 
        INAcccontroller.objAccount.Individual_Home_Phone__c='+911234'; 
        INAcccontroller.objAccount.Fax='';
        INAcccontroller.objAccount.Email__c='test@test.com';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.PAN__c='ABCDE1234F';
        INAcccontroller.objAccount.Aadhaar__c='123456789012';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.country='China';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='1234';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='';
        INAcccontroller.Addressobj.Address_Line_3__c='';
        INAcccontroller.Addressobj.Country__c='China';
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;        
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
    
    
    @IsTest
    private static void testSaveAccount5() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.RecordType = 'Company';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '02345678'; 
        INAcccontroller.wkphoneNumber= '02345678';
        INAcccontroller.mbphoneNumber= '02345678';
        INAcccontroller.wkAreaCode='02';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='02';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='01';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();   
        INAcccontroller.cancel();     
        test.stopTest();
    }
    
    
    @IsTest
    private static void testSaveAccount6() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.RecordType = 'Company';
        INAcccontroller.objAccount.Name = '';
        test.startTest();      
        INAcccontroller.hmphoneNumber= ''; 
        INAcccontroller.wkphoneNumber= '';
        INAcccontroller.mbphoneNumber= '';
        INAcccontroller.wkAreaCode='';
        INAcccontroller.wkCountryCode='';
        INAcccontroller.hmAreaCode='';
        INAcccontroller.hmCountryCode='';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='';
        INAcccontroller.faxAreaCode='';
        INAcccontroller.faxCountryCode='';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();  
        test.stopTest();
    }
    
  
    @IsTest
    private static void testSaveAccount7() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.RecordType = 'Company';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '023'; 
        INAcccontroller.wkphoneNumber= '0678';
        INAcccontroller.mbphoneNumber= '02678';
        INAcccontroller.wkAreaCode='02';
        INAcccontroller.wkCountryCode='+71';
        INAcccontroller.hmAreaCode='02';
        INAcccontroller.hmCountryCode='+71';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+71';
        INAcccontroller.faxAreaCode='01';
        INAcccontroller.faxCountryCode='+71';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAAA1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();   
        test.stopTest();
    }
    
    
    @IsTest
    private static void testSaveAccount8() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Company');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.objAccount.Country__c = 'China';
        INAcccontroller.RecordType = 'Company';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '02345678'; 
        INAcccontroller.wkphoneNumber= '02345678';
        INAcccontroller.mbphoneNumber= '02345678';
        INAcccontroller.wkAreaCode='02';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='02';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='01';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.Addressobj.Country__c = 'china';
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        test.stopTest();
    }
       
  @IsTest
    private static void testSaveAccount9() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Test');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.objAccount.Country__c = 'China';
        INAcccontroller.RecordType = 'Company';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '02345678'; 
        INAcccontroller.wkphoneNumber= '02345678';
        INAcccontroller.mbphoneNumber= '02345678';
        INAcccontroller.wkAreaCode='02';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='02';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='01';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.Addressobj.Foreign_Nationals__c = false;
        INAcccontroller.Addressobj.Country__c = 'china';
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.onLineDeduplicationIN();
    }
    
    @IsTest
    private static void testJasonClass() {
        JSON2ApexCustomerFromCDM.parse('{ "name":"Prem", "age":25, "city":"New York" }');
    }
    
    @IsTest
    private static void testPagination() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c=null;         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.objAccount.Generated_by__c= 'Dealer';
        INAcccontroller.RecordType = 'Person Account';
        test.startTest();      
        INAcccontroller.hmphoneNumber= '12345678'; 
        INAcccontroller.wkphoneNumber= '12345678';
        INAcccontroller.mbphoneNumber= '1234567890';
        INAcccontroller.faxphoneNumber= '12345678';
        INAcccontroller.wkAreaCode='12';
        INAcccontroller.wkCountryCode='+91';
        INAcccontroller.hmAreaCode='12';
        INAcccontroller.hmCountryCode='+91';
        INAcccontroller.mbAreaCode='';
        INAcccontroller.mbCountryCode='+91';
        INAcccontroller.faxAreaCode='12';
        INAcccontroller.faxCountryCode='+91';
        INAcccontroller.objAccount.id=null; 
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.objAccount.Work_Phone__c='+911234567890'; 
        INAcccontroller.objAccount.Home_Phone_2__c='+911234567890'; 
        INAcccontroller.objAccount.Individual_Home_Phone__c='+911234567890'; 
        INAcccontroller.objAccount.Fax='+911234567890';
        INAcccontroller.objAccount.Email__c='test@test.com';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.objAccount.PAN__c='ABCDE1234F';
        INAcccontroller.objAccount.Aadhaar__c='123456789012';
        //INAcccontroller.addresspicklist = 'Home';
        INAcccontroller.country='India';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='123456';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='zxcv';
        INAcccontroller.Addressobj.Address_Line_3__c='qwer';
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.Addressobj.Country__c = 'India';
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.selectedRecordTypeValue();
        INAcccontroller.checkForeignNational();
        INAcccontroller.checkcountrycodeindia();
        INAcccontroller.phoneFieldConcatIN();
        INAcccontroller.SaveAccountDetailsIN();
        INAcccontroller.saveAccountIN();
        INAcccontroller.onLineDeduplicationIN();
        INAcccontroller.generateCDMEndPointURL();
        INAcccontroller.processResponse();
        INAcccontroller.cancel();
        INAcccontroller.getIsClassic();
        INAcccontroller.DedupAccountList.add(personAcc);
        INAcccontroller.displayAccList.clear();  
        INAcccontroller.startIndex=0;  
        INAcccontroller.lastindex=100;
        INAcccontroller.last=false;     
        INAcccontroller.previous=false;     
        INAcccontroller.first=false;        
        INAcccontroller.next=false; 
        //INAcccontroller.next();
        INAcccontroller.previous();
        INAcccontroller.last();
        //INAcccontroller.First();
        
        test.stopTest();
    }
    
    
    static void createTestData(){
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user1;
        user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user_Obj;
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
    
    static void createTestData1(){
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user1;
        user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user_Obj;
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
            objAccount.Mobile__c='4444-4444';
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
            try{
                insert personAcc1;
            }
            catch(DMLException e){
                system.debug('!!! '+ e);
            }
            addressobj =  new Address__C();
            addressobj.Customer__c = objAccount.Id;
            addressobj.Address_Type__c = 'Home';
            addressobj.Address_Line_1__c = 'line 1';
            addressobj.Address_Line_2__c = 'line 2';
            addressobj.Address_Line_3__c = 'line 3';
            addressobj.Block__c = 'Block';
            addressobj.Customer__c = objAccount.id;
            addressobj.ZipCode__c = '14941';
            addressobj.Province__c ='Maharashtra';
            addressobj.TitleOfHonor__c = 'To Person';
            addressobj.Market__c='IN';
            addressobj.Foreign_Nationals__c = false;
            addressobj.Country__c = 'China';
            insert addressobj;
        }
    }
    
    
}