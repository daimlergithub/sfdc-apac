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
    public JSON2ApexCustomerFromCDM custSearch{get;set;}
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.LoadProvince();
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
        INAcccontroller.show=true;
        INAcccontroller.one=true;
        INAcccontroller.showCDM=false;
        
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.LoadProvince();
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.LoadProvince();
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.country='India';
        INAcccontroller.province='test';
        INAcccontroller.objAccount.id=null; 
        INAcccontroller.district='test';
        INAcccontroller.subdistrict='test';
        INAcccontroller.zip='1234';
        INAcccontroller.Addressobj.Address_Line_1__c='asdf';
        INAcccontroller.Addressobj.Address_Line_2__c='';
        INAcccontroller.Addressobj.Address_Line_3__c='';
        INAcccontroller.Addressobj.Country__c='China';
        INAcccontroller.Addressobj.Foreign_Nationals__c =false;        
        INAcccontroller.ShowHideFields();
        INAcccontroller.LoadDistrict();
        INAcccontroller.LoadProvince();
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.LoadProvince();
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.LoadProvince();
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
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.LoadProvince();
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
        INAcccontroller.LoadProvince();
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
        INAcccontroller.objAccount.Country__c = 'India';
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
    private static void testSaveAccount10() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        PageReference pageRef = Page.AddressSearchValidationCDM;
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
        INAcccontroller.objAccount.Country__c = 'India';
        INAcccontroller.RecordType = 'Person Account';
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
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.checkForeignNational();
        
        test.stopTest();
    }
    @IsTest
    private static void testSaveAccount11() {
        createTestData();
        ApexPages.currentPage().getParameters().put('recordType','Person Account');
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
        PageReference pageRef = Page.AddressSearchValidationCDM;
        INAcccontroller.market = 'IN';
        INAcccontroller.objAccount = objAccount;
        INAcccontroller.objAccount.Individual_Home_Phone__c=null;
        INAcccontroller.objAccount.id=null;
        INAcccontroller.objAccount.Mobile__c='';         
        INAcccontroller.objAccount.Work_Phone__c=null; 
        INAcccontroller.objAccount.Home_Phone_2__c=null; 
        INAcccontroller.objAccount.Phone='+911234567890'; 
        INAcccontroller.objAccount.Email__c=null; 
        INAcccontroller.objAccount.Email2__c='test@test.com'; 
        INAcccontroller.objAccount.Country__c = 'India';
        INAcccontroller.RecordType = 'Person Account';
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
        INAcccontroller.Addressobj.Foreign_Nationals__c = true;
        INAcccontroller.Addressobj.Address_Type__c = 'Home';
        INAcccontroller.objAccount.GSTN_Number__c='12AAAAA1234A1A1';
        INAcccontroller.objAccount.Name = '';
        INAcccontroller.phoneFieldConcatIN();
        
        test.stopTest();
    }
    @IsTest
    private static void testJasonClass() {
        JSON2ApexCustomerFromCDM.parse('{ "name":"Prem", "age":25, "city":"New York" }');
    }
    
    @IsTest
    private static void testPagination() {
        createTestData();
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        system.runas(user1){
            List<account> acclist= new list<account>();
            for(integer i=0;i<12;i++){
                personAcc =new Account();
                personAcc.firstname= 'John';
                personAcc.lastname= 'Leamos';
                personAcc.mobile__c= '+666465';
                personAcc.ID_Number__c='12312';     
                personAcc.UCID__c='12345'+i;
                personAcc.market__c='IN';
                acclist.add(personAcc);
            }
            
            test.startTest();
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            INAcccontroller.market = 'IN';
            INAcccontroller.objPersonAccount = personAcc;
            INAcccontroller.recordType = 'Person Account';
            INAcccontroller.selectedRecordType = 'Person Account';
            INAcccontroller.objAccount = personAcc; 
            INAcccontroller.DedupAccountList.addall(acclist);
            INAcccontroller.LastIndex=acclist.size();
            INAcccontroller.last=false;     
            INAcccontroller.previous=false;     
            INAcccontroller.first=false;        
            INAcccontroller.next=false; 
            INAcccontroller.First();
            INAcccontroller.next();
            INAcccontroller.previous();
            INAcccontroller.last();
           
            test.stopTest();
        }
    }   
            
       /*
        static testmethod void testOnLineDeduplicationCDMIN(){
            //Person Account
            Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
             user user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                              TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            DMLManagerService.insertAsSystem(user1 );
            CDM_Integration_URLs__c cdm=new CDM_Integration_URLs__c();
             cdm.Country__c='IN';
             cdm.type__c='Person Account';
             cdm.Context__c='Person Account';
             cdm.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-IN-SearchPersonAccount?';
             cdm.Name='SearchPersonAccount';
             insert cdm;
             CDM_Integration_URLs__c cdm1=new CDM_Integration_URLs__c();
             cdm1.Country__c='IN';
             cdm1.type__c='Company';
             cdm1.Context__c='Company';
             cdm1.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-IN-SearchCompanyAccount?';
             cdm1.Name='SearchCompanyAccount';
             insert cdm1;
             CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
             cs.DEFAULT_CALLOUT_TIME__c='1000';
             cs.MAX_CALLOUT_TIME__c='5000';
             cs.Name='CalloutValues';
             insert cs;
             
               personAcc =new Account();
            personAcc.firstname= 'John';
            personAcc.lastname= 'Leamos';
            personAcc.mobile__c= '+911234567890';
            personAcc.ID_Number__c='12312';
            personAcc.UCID__c='12345';
            personAcc.market__c='IN';
              ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
        AddressSearchValidationControllerCDM INAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            INAcccontroller.market='IN';
            INAcccontroller.objPersonAccount = personAcc;
            INAcccontroller.recordType = 'Person Account';
            INAcccontroller.selectedRecordType = 'Person Account';
           INAcccontroller.objAccount = personAcc;
            
          
             
          
            Continuation cont2 = (Continuation)INAcccontroller.onLineDeduplicationIN();
            Map<String, HttpRequest> requests = cont2.getRequests();
            system.assert(requests.size() == 1);
            system.assert(requests.get(INAcccontroller.requestLabel) != null);
            HttpResponse response = new HttpResponse();
            response.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc.UCID__c+',"AdminClientNum":"'+personAcc.id+'"}]}');  
            Test.setContinuationResponse(INAcccontroller.requestLabel, response);
             Object result = Test.invokeContinuationMethod(INAcccontroller, cont2);
             System.assertEquals(null, result);
            
            personAcc1 = new Account();
            personAcc1.Name='New Organization';
            personAcc1.Company_Name__c='New Organization';
            personAcc1.Work_Phone__c='123456';
            personAcc1.Name='New Organization';
             ApexPages.StandardController objSc1 = new ApexPages.StandardController(personAcc1);
        AddressSearchValidationControllerCDM INAcccontroller1= new AddressSearchValidationControllerCDM(objSc1);
           INAcccontroller1.objPersonAccount = personAcc1;
            INAcccontroller1.recordType = 'Company';
            INAcccontroller1.selectedRecordType = 'Company';
            INAcccontroller1.objAccount = personAcc1;
            INAcccontroller1.hmphoneNumber='02345678';
           Continuation conti3 = (Continuation)INAcccontroller1.onLineDeduplicationIN();
            Map<String, HttpRequest> requests1 = conti3.getRequests();
            system.assert(requests1.size() == 1);
            system.assert(requests1.get(INAcccontroller1.requestLabel) != null);
            HttpResponse response1 = new HttpResponse();
            response1.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":'+personAcc1.CDM_UCID__c+',"AdminClientNum":"2018-05-87987"}]}');  
            Test.setContinuationResponse(INAcccontroller1.requestLabel, response1);
             Object result1 = Test.invokeContinuationMethod(INAcccontroller1, conti3);
             System.assertEquals(null, result1);
          
            }
            */
        
            
    
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
                rg.City__c='Test City';
                rg.Market__c ='TR';
            rm.add(rg);
            RegionMasterInfo__c rg1=new RegionMasterInfo__c();
            rg1.Province__c='chittoor';
            rg1.ZipCode__c='45756';
            rg1.Language__c='English';
            rg1.District__c='chittoor';
            rg1.Sub_DIstrict__c='chittoor';
                rg1.City__c='Test City';
                rg1.Market__c ='TR';
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
                personAcc.FirstName='Test123';
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
                rg.Market__c='IN';
            rm.add(rg);
            RegionMasterInfo__c rg1=new RegionMasterInfo__c();
            rg1.Province__c='chittoor';
            rg1.ZipCode__c='45756';
            rg1.Language__c='English';
                rg1.Market__c='IN';
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
            if(us.market__c=='TH'||us.market__c=='KR'||us.market__c=='IN'){
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
        //TR specific methods
        /*static void createTestDataTR1(){
            Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
            
            user1 = new User(Alias = 'standt', Email='user1@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
                             TimeZoneSidKey='America/Los_Angeles', UserName='user1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert user1;
            user_Obj = new User(Alias = 'standt', Email='user2@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
                                TimeZoneSidKey='America/Los_Angeles', UserName='user2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert user_Obj;
            system.runAs(user1){    
                List<RegionMasterInfo__c> rm= new List<RegionMasterInfo__c>();
                RegionMasterInfo__c rg=new RegionMasterInfo__c();
                rg.Province__c='Ayas';
                rg.ZipCode__c='24575';
                rg.Language__c='English';
                rg.District__c='Ayas';
                //rg.Sub_DIstrict__c='subdist';
                rm.add(rg);
                RegionMasterInfo__c rg1=new RegionMasterInfo__c();
                rg1.Province__c='Ayas';
                rg1.ZipCode__c='45756';
                rg1.Language__c='English';
                rg1.District__c='Ayas';
                //rg1.Sub_DIstrict__c='chittoor';
                rm.add(rg1);
                insert rm;
                objAccount= new Account();
                objAccount.RecordtypeId= companyAccRecordTypeId;
                objAccount.Name='Test Person 1st';
                objAccount.Status__c='Active';
                objAccount.Province__c='Ayas';
                objAccount.Market__c='TR';
                objAccount.City__c='Ankara';
                objAccount.Email__c='abcf@hji.com';
                //objAccount.ID_Type__c='National ID';
               // objAccount.ID_Number__c='1234567891234';
                //objAccount.Commercial_Reg_No__c='adfgrt';
                User us=[select market__c from user where id=:UserInfo.getUserId()];
                if(us.market__c=='TR'){
                    objAccount.ZipCode__c = '42875';
                    
                }
               
                
                objAccount.Email__c='test@mbj.com';  
                objAccount.Mobile__c='+905444444442';
                objAccount.Preferred_Language__c='English';      
                objAccount.Data_Source__c ='Past Data';
                objAccount.Province__c = 'Ayas';
                objAccount.Phone = '08022420181';
                objAccount.Vat_No__c='8360043469';
                //objAccount.Preferred_Language__c='English';
                objAccount.Province__c='ayas';
                
                
                
                insert objAccount;
                
                objAccount1 = new Account();
                objAccount1.RecordtypeId= companyAccRecordTypeId;
                objAccount1.Name='Test Person 1st';
                //objAccount1.ID_Type__c='National ID';
                //objAccount1.ID_Number__c='1234567891234';
                objAccount1.Market__c='TR';
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
                personAcc.Province__c='Ayas';
                personAcc.City__c='Ankara';
                personAcc.Market__c='TR';
                //personAcc.ID_Type__c='National ID';
                //personAcc.ID_Number__c='1234567891234';
                if(us.market__c=='TR'){
                    personAcc.ZipCode__c = '42877';
                    
                }
                
                personAcc.Email__c='test@mbj.com';
                personAcc.Mobile__c='+905234567890';
                personAcc.Preferred_Language__c='Engmmm';        
                personAcc.Data_Source__c ='Past data';
                personAcc.Phone = '08022420181';
                personAcc.Province__c = 'Ayas';
                //personAcc.Commercial_Reg_No__c='adfgrt';
                //personAcc.Vat_No__c='8360043469';
                //personAcc.Preferred_Language__c='telugu';
                insert personAcc;
                
                personAcc1 = new Account();
                personAcc1.RecordtypeId= strPerson;
                personAcc1.LastName='Test Person 2nd';
                personAcc1.Market__c='TR';
                //personAcc1.ID_Type__c='National ID';
                //personAcc1.ID_Number__c='1234567891234';
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
                //addressobj.Address_Line_3__c = 'line 3';
                //addressobj.Block__c = 'Block';
                addressobj.Customer__c = objAccount.id;
                addressobj.ZipCode__c = '14941';
                addressobj.Province__c ='Ayas';
                //addressobj.TitleOfHonor__c = 'To Person';
                addressobj.Market__c='TR';
                addressobj.Foreign_Nationals__c = false;
                addressobj.Country__c = 'China';
                insert addressobj;
            }
        }*/
        
        static void createTestDataTR(){
            Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
            
            user1 = new User(Alias = 'standt', Email='abc@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', 
                             ProfileId = p1.Id, Market__c='TR',LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',
                             UserName='abc@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert user1;
            user_Obj = new User(Alias = 'standt', Email='xyz@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Test',  
                                ProfileId = p1.Id, Market__c='TR',LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles',
                                UserName='xyz@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert user_Obj;
            system.runAs(user1){    
                List<RegionMasterInfo__c> rm= new List<RegionMasterInfo__c>();
                RegionMasterInfo__c rg=new RegionMasterInfo__c();
                rg.Province__c='ayas';
                rg.City__c='Ankara';
                rg.ZipCode__c='24575';
                rg.Language__c='English';
                rg.District__c='ayas';
                rg.Market__c='TR';
                //rg.Sub_DIstrict__c='subdist';
                rm.add(rg);
                RegionMasterInfo__c rg1=new RegionMasterInfo__c();
                rg1.Province__c='ayas';
                rg1.City__c='Ankara';
                rg1.ZipCode__c='45756';
                rg1.Language__c='English';
                rg1.District__c='ayas';
                rg1.Market__c='TR';
                //rg1.Sub_DIstrict__c='chittoor';
                rm.add(rg1);
                insert rm;
                objAccount= new Account();
                objAccount.RecordtypeId= companyAccRecordTypeId;
                objAccount.Name='Test Person 1st';
                objAccount.Status__c='Prospect';
                objAccount.Data_source__c='MBT Event';
                objAccount.Province__c='ayas';
                objAccount.City__c='Ankara';
                objAccount.Email__c='abcf@hji.com';
                objAccount.Market__c='TR';
                //objAccount.ID_Type__c='National ID';
                //objAccount.ID_Number__c='1234567891234';
                //objAccount.Commercial_Reg_No__c='adfgrt';
                User us=[select market__c from user where id=:UserInfo.getUserId()];
                if(us.market__c=='TR'){
                    objAccount.ZipCode__c = '42875';
                    
                }
                
                
                objAccount.Email__c='test@mbj.com';  
                objAccount.Mobile__c='+905234567890';
                //objAccount.Preferred_Language__c='English';      
                objAccount.Data_Source__c ='MBT Event';
                objAccount.Province__c = 'Ayas';
                objAccount.Phone = '08022420181';
                objAccount.Vat_No__c='8360043469';
                //objAccount.Preferred_Language__c='English';
                //objAccount.Province__c='apdff';
                
                
                
                insert objAccount;
                
                objAccount1 = new Account();
                objAccount1.RecordtypeId= companyAccRecordTypeId;
                objAccount1.Name='Test Person 1st';
                objAccount1.Market__c='TR';
                objAccount1.Vat_No__c='42970854504';
                //objAccount1.ID_Type__c='National ID';
                //objAccount1.ID_Number__c='1234567891234';
                try{
                    insert objAccount1;
                }
                catch(DMLException e){
                    system.debug('!!!'+ e);
                }
                
                personAcc= new Account();
                personAcc.RecordtypeId= strPerson;
                personAcc.LastName='Test123';
                personAcc.FirstName='Test123';
                personAcc.Status__c='Active';
                personAcc.data_source__c='MBT Event';
                personAcc.Province__c='ayas';
                personAcc.City__c='ankara';
                personAcc.Market__c='TR';
                //personAcc.ID_Type__c='National ID';
                //personAcc.ID_Number__c='1234567891234';
                if(us.market__c=='TR'){
                    personAcc.ZipCode__c = '42877';
                    
                }
                
                personAcc.Email__c='test@mbj.com';
                personAcc.Mobile__c='+905234567890';
                //personAcc.Preferred_Language__c='Engmmm';        
                personAcc.Data_Source__c ='MBT Event';
                personAcc.Phone = '08022420181';
                personAcc.Province__c = 'ayas';
                personAcc.Social_ID__c='11900313862';
                //personAcc.Commercial_Reg_No__c='adfgrt';
                personAcc.Vat_No__c='8360043469';
                //personAcc.Preferred_Language__c='telugu';
                insert personAcc;
                
                personAcc1 = new Account();
                personAcc1.RecordtypeId= strPerson;
                personAcc1.Market__c='TR';
                personAcc1.FirstName='TR Name';
                personAcc1.LastName='Test Person 2nd';
                //personAcc1.opt_in_email__c = true;
                //personAcc1.Social_ID__c=Decimal.valueof('31915677582');
                personAcc1.Status__c='Prospect';
                personAcc1.Data_Source__c='MBT Event';
                //personAcc1.ID_Type__c='National ID';
                //personAcc1.ID_Number__c='1234567891234';
                try{insert personAcc1;}
                catch(DMLException e){
                    
                    system.debug('!!! '+ e);
                    
                }
                
                addressobj =  new Address__C();
                addressobj.Customer__c = objAccount.Id;
                addressobj.Address_Type__c = 'Home';
                addressobj.Address_Line_1__c = 'line 1';
                addressobj.Address_Line_2__c = 'line 2';
                //addressobj.Block__c = 'Block';
                addressobj.Customer__c = objAccount.id;
                addressobj.ZipCode__c = '14941';
                addressobj.Province__c ='ayas';
                //addressobj.TitleOfHonor__c = 'To Person';
                addressobj.Market__c='TR';
                addressobj.Foreign_Nationals__c = true;
                addressobj.Country__c = 'Turkey';
                insert addressobj;
            }
        } 
        
        
        @IsTest
        private static void testSaveAccountTR1() {
            createTestDataTR();
            ApexPages.currentPage().getParameters().put('recordType','Person Account');
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc);
            AddressSearchValidationControllerCDM TRAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            TRAcccontroller.market = 'TR';
            TRAcccontroller.objAccount = personAcc;
            
            TRAcccontroller.objAccount.id=null;
            TRAcccontroller.objAccount.Mobile__c=null;         
            TRAcccontroller.objAccount.Work_Phone__c=null; 
            
            TRAcccontroller.objAccount.Phone='+911234567890'; 
            TRAcccontroller.objAccount.Email__c=null; 
            TRAcccontroller.objAccount.Opt_In_Email__c=true;
            TRAcccontroller.objAccount.Opt_In_SMS__c=true;
            
            TRAcccontroller.RecordType = 'Person Account';
            test.startTest();      
            TRAcccontroller.hmphoneNumber= '12345678'; 
            TRAcccontroller.wkphoneNumber= '12345678';
            
           
            TRAcccontroller.mbCountryCode='+91';
           
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.objAccount.Work_Phone__c='+911234567890'; 
          
            TRAcccontroller.objAccount.id=null; 

            TRAcccontroller.addresspicklist = 'Home';
            TRAcccontroller.country='Turkey';
            TRAcccontroller.province='Ayas';
            TRAcccontroller.city='Ankara';
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.district='Ayas';
            TRAcccontroller.Market='TR';

            TRAcccontroller.zip='12345';
            TRAcccontroller.Addressobj.Address_Line_1__c='asdf';
            TRAcccontroller.Addressobj.Address_Line_2__c='zxcv';
     
            TRAcccontroller.Addressobj.Foreign_Nationals__c = true;
            TRAcccontroller.Addressobj.Country__c = 'Turkey';
            TRAcccontroller.Addressobj.Address_Type__c = 'Home';
            TRAcccontroller.ShowHideFields();
            TRAcccontroller.LoadProvince();
            TRAcccontroller.LoadDistrict();
            TRAcccontroller.selectedRecordTypeValue();
            TRAcccontroller.checkForeignNational();
            TRAcccontroller.checkcountrycodeindia();
            TRAcccontroller.phoneFieldConcatTR();
            TRAcccontroller.SaveAccountDetailsTR();
            TRAcccontroller.saveAccountTR();
            TRAcccontroller.onLineDeduplicationTR();
            TRAcccontroller.generateCDMEndPointURL();
            TRAcccontroller.processResponse();
            TRAcccontroller.cancel();

            TRAcccontroller.show=true;
            TRAcccontroller.one=true;
            TRAcccontroller.showCDM=false;
            

            test.stopTest();
        }
      /*  @IsTest
        private static void testSaveAccountTR2() {
            createTestDataTR();
            ApexPages.currentPage().getParameters().put('recordType','Person Account');
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationControllerCDM TRAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            TRAcccontroller.market = 'TR';
            TRAcccontroller.objAccount = personAcc1;
       
            TRAcccontroller.objAccount.id=null;
            TRAcccontroller.objAccount.Mobile__c=null;         
            TRAcccontroller.objAccount.Work_Phone__c=null; 
            
            TRAcccontroller.objAccount.Phone='null'; 
            TRAcccontroller.objAccount.Email__c=null; 
           
            TRAcccontroller.objAccount.Generated_by__c= 'MBIL'; 
            TRAcccontroller.RecordType = 'Person Account';
            test.startTest();      
            TRAcccontroller.hmphoneNumber= ''; 
            TRAcccontroller.wkphoneNumber= '';
            TRAcccontroller.mbphoneNumber= '';
         
            TRAcccontroller.hmAreaCode='';
            TRAcccontroller.hmCountryCode='';
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.objAccount.FirstName = '';
            TRAcccontroller.objAccount.LastName = '';
            TRAcccontroller.addresspicklist = 'Home';
            TRAcccontroller.objAccount.Work_Phone__c=''; 
         
            TRAcccontroller.objAccount.Email__c='test@test.com';
            TRAcccontroller.objAccount.id=null; 
         
            TRAcccontroller.country='Turkey';
            TRAcccontroller.city='123';
            TRAcccontroller.province='test';
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.district='ayas';

            TRAcccontroller.zip='12345';
            TRAcccontroller.Addressobj.Address_Line_1__c='asdf';
            TRAcccontroller.Addressobj.Address_Line_2__c='';
           
            TRAcccontroller.Addressobj.Foreign_Nationals__c = true;
            TRAcccontroller.ShowHideFields();
            TRAcccontroller.LoadDistrict();
            TRAcccontroller.LoadProvince();
            TRAcccontroller.selectedRecordTypeValue();
            TRAcccontroller.checkForeignNational();
      
            TRAcccontroller.phoneFieldConcatTR();
            TRAcccontroller.onLineDeduplicationTR();
            TRAcccontroller.generateCDMEndPointURL();
            TRAcccontroller.processResponse();
            TRAcccontroller.SaveAccountDetailsTR();
            TRAcccontroller.saveAccountTR();
            TRAcccontroller.cancel();
            test.stopTest();
        }*/
        
        @IsTest
        private static void testSaveAccountTR3() {
            createTestDataTR();
            ApexPages.currentPage().getParameters().put('recordType','Company');
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressSearchValidationControllerCDM TRAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            TRAcccontroller.market = 'TR';
            TRAcccontroller.objAccount = objAccount;
            TRAcccontroller.objAccount.Individual_Home_Phone__c=null;
            TRAcccontroller.objAccount.id=null;
            TRAcccontroller.objAccount.Mobile__c=null;         
            TRAcccontroller.objAccount.Work_Phone__c=null; 
            TRAcccontroller.objAccount.Home_Phone_2__c=null; 
            TRAcccontroller.objAccount.Phone='null'; 
            TRAcccontroller.objAccount.Email__c=null; 
            TRAcccontroller.objAccount.Email2__c='test@test.com'; 
            TRAcccontroller.RecordType = 'Person Account';
            test.startTest();      
            TRAcccontroller.hmphoneNumber= '3458745698'; 
            TRAcccontroller.wkphoneNumber= '2347896541';
            TRAcccontroller.mbphoneNumber= '3457896541';
            TRAcccontroller.faxphoneNumber= '3454576';
            TRAcccontroller.wkAreaCode='01';
            TRAcccontroller.wkCountryCode='+71';
            TRAcccontroller.hmAreaCode='09';
            TRAcccontroller.hmCountryCode='+71';
            TRAcccontroller.mbAreaCode='00';
            TRAcccontroller.mbCountryCode='+71';
            TRAcccontroller.faxAreaCode='09';
            TRAcccontroller.faxCountryCode='';
            TRAcccontroller.objAccount.id=null; 
            //TRAcccontroller.addresspicklist = 'Home';
            TRAcccontroller.objAccount.Work_Phone__c=''; 
            TRAcccontroller.objAccount.Home_Phone_2__c=''; 
            TRAcccontroller.objAccount.Individual_Home_Phone__c='+911234'; 
            TRAcccontroller.objAccount.Fax='';
            TRAcccontroller.objAccount.Email__c='test@test.com';
            TRAcccontroller.objAccount.id=null;
            
            TRAcccontroller.addresspicklist = 'Home';
            TRAcccontroller.country='Mexico';
            TRAcccontroller.province='test';
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.district='test';
            TRAcccontroller.subdistrict='test';
            TRAcccontroller.zip='12346';
            TRAcccontroller.city='--Select--';
            TRAcccontroller.Addressobj.Address_Line_1__c='asdf';
            TRAcccontroller.Addressobj.Address_Line_2__c='';
            TRAcccontroller.Addressobj.Address_Line_3__c='';
            TRAcccontroller.Addressobj.Country__c='Turkey';
            TRAcccontroller.Addressobj.Foreign_Nationals__c = true;
            TRAcccontroller.Addressobj.Address_Type__c = 'Home';
            TRAcccontroller.ShowHideFields();
            TRAcccontroller.LoadDistrict();
            TRAcccontroller.LoadProvince();
            TRAcccontroller.selectedRecordTypeValue();
            TRAcccontroller.checkForeignNational();
            TRAcccontroller.checkcountrycodeIndia();
            TRAcccontroller.phoneFieldConcatTR();
            TRAcccontroller.onLineDeduplicationTR();
            TRAcccontroller.generateCDMEndPointURL();
            TRAcccontroller.processResponse();
            TRAcccontroller.SaveAccountDetailsTR();
            TRAcccontroller.saveAccountTR();
            test.stopTest();
        }
         @IsTest
        private static void testSaveAccountTR4() {
            createTestDataTR();
            ApexPages.currentPage().getParameters().put('recordType','Person Account');
            ApexPages.StandardController objSc = new ApexPages.StandardController(personAcc1);
            AddressSearchValidationControllerCDM TRAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            TRAcccontroller.market = 'TR';
            TRAcccontroller.objAccount = personAcc1;
            //TRAcccontroller.objAccount.Individual_Home_Phone__c=null;
            TRAcccontroller.objAccount.id=null;
            TRAcccontroller.objAccount.Mobile__c=null;         
            TRAcccontroller.objAccount.Work_Phone__c=null; 
            //TRAcccontroller.objAccount.Home_Phone_2__c=null; 
            TRAcccontroller.objAccount.Phone='null'; 
            TRAcccontroller.objAccount.Email__c=null; 
            //TRAcccontroller.objAccount.Email2__c='test@test.com';
	    TRAcccontroller.objAccount.Social_ID__c='11900313862'; 
            TRAcccontroller.RecordType = 'Person Account';
            test.startTest();      
            TRAcccontroller.hmphoneNumber= '345'; 
            TRAcccontroller.wkphoneNumber= '234';
            TRAcccontroller.mbphoneNumber= '345';
            //TRAcccontroller.faxphoneNumber= '345';
            //TRAcccontroller.wkAreaCode='01';
            TRAcccontroller.wkCountryCode='+71';
            //TRAcccontroller.hmAreaCode='09';
            TRAcccontroller.hmCountryCode='+71';
            //TRAcccontroller.mbAreaCode='00';
            TRAcccontroller.mbCountryCode='+71';
            //TRAcccontroller.faxAreaCode='09';
            //TRAcccontroller.faxCountryCode='+71';
            TRAcccontroller.objAccount.id=null; 
            //TRAcccontroller.addresspicklist = 'Home';
            TRAcccontroller.objAccount.Work_Phone__c='';
            TRAcccontroller.objAccount.Opt_In_Mobile__c=true;           
            TRAcccontroller.objAccount.Opt_In_Email__c=true;
            TRAcccontroller.objAccount.Email__c='test@test.com';
            TRAcccontroller.objAccount.id=null; 
      
            TRAcccontroller.country='Turkey';
            
            TRAcccontroller.objAccount.id=null; 
            TRAcccontroller.district='Ayas';
        
            TRAcccontroller.zip='12346';
            
            TRAcccontroller.Addressobj.Address_Line_1__c='asdf';
            TRAcccontroller.Addressobj.Address_Line_2__c='';
            TRAcccontroller.Addressobj.Address_type__c='Home';
            TRAcccontroller.Addressobj.Country__c='China';
            TRAcccontroller.Addressobj.Foreign_Nationals__c =false;        
            TRAcccontroller.ShowHideFields();
            TRAcccontroller.city='Ankara';
            TRAcccontroller.LoadProvince();
            TRAcccontroller.province='ayas';
            TRAcccontroller.LoadDistrict();
            TRAcccontroller.selectedRecordTypeValue();
            TRAcccontroller.checkForeignNational();
            TRAcccontroller.checkcountrycodeindia();
            TRAcccontroller.phoneFieldConcatIN();
            TRAcccontroller.validateSocialIdTR('SocId');
            TRAcccontroller.onLineDeduplicationTR();
            TRAcccontroller.generateCDMEndPointURL();
            TRAcccontroller.processResponse();
            TRAcccontroller.SaveAccountDetailsTR();
            TRAcccontroller.saveAccountTR();
            test.stopTest();
        }
        @IsTest
        private static void testSaveAccountTR5() {
            createTestDataTR();
            ApexPages.currentPage().getParameters().put('recordType','Company');
            ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
            AddressSearchValidationControllerCDM TRAcccontroller= new AddressSearchValidationControllerCDM(objSc);
            PageReference pageRef = Page.AddressSearchValidationCDM;
            TRAcccontroller.market = 'TR';
            TRAcccontroller.objAccount = objAccount;

            TRAcccontroller.objAccount.id=null;
            TRAcccontroller.objAccount.Mobile__c=null;         
            TRAcccontroller.objAccount.Work_Phone__c=null; 

            TRAcccontroller.objAccount.Phone='+911234567890'; 
            TRAcccontroller.objAccount.Email__c=null; 

            TRAcccontroller.RecordType = 'Company';
            test.startTest();      
            TRAcccontroller.hmphoneNumber= '0234562578'; 
            TRAcccontroller.wkphoneNumber= '0234585678';

            TRAcccontroller.wkCountryCode='+91';

            TRAcccontroller.hmCountryCode='+91';

            TRAcccontroller.mbCountryCode='+91';

            TRAcccontroller.objAccount.id=null; 
            
            TRAcccontroller.Addressobj.Foreign_Nationals__c = false;
            TRAcccontroller.Addressobj.Address_Type__c = 'Home';

            TRAcccontroller.objAccount.Vat_No__c='8360043469';
            TRAcccontroller.objAccount.Name = '';
            TRAcccontroller.ShowHideFields();
            TRAcccontroller.city='test1'; 
            TRAcccontroller.LoadDistrict();
            TRAcccontroller.LoadProvince();
            TRAcccontroller.selectedRecordTypeValue();
            TRAcccontroller.checkForeignNational();

            TRAcccontroller.phoneFieldConcatTR();
            TRAcccontroller.onLineDeduplicationTR();
            TRAcccontroller.generateCDMEndPointURL();
            TRAcccontroller.processResponse();
            TRAcccontroller.validateVATNoTR();
            TRAcccontroller.validateSocialIdTR('Soc');
            TRAcccontroller.optInFields();
            TRAcccontroller.SaveAccountDetailsTR();
            TRAcccontroller.saveAccountTR();   
            TRAcccontroller.cancel();     
            test.stopTest();
        }
       
    }