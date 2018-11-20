@istest
public class sObjectMappingUtilityTest {
public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
public static string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
     public static Account objAccount;
     public static Account personAcc;
   public static Address__C addressobj ;
    public static user usr;
    public static User user1;
    public static User user_Obj; 

    
       static testmethod void sObjectMappingUtilityTest1(){
           createTestData();
           //creating custom setting 
           Operation_Mapping__c om = New Operation_Mapping__c();
           om.Operation_Parameters__c = 'Account;Account_Link__c;RetailCopy';
               om.Name = 'RetailCopy';
               insert om; 
           
           Account_Link__c newAlk = new Account_Link__c();
                   newAlk.toRole__c = objAccount.id;
                    newAlk.Retail_Address_Reference__c = addressobj.id;
                   // newAlk.fromRole__c = account.Main_Dealer__c;
                    newAlk.RecordTypeId = alkPerson_RecordTypeId;
                    newAlk.Market__c = objAccount.market__c;           
           
			sObjectMappingUtility varMapUtil = new sObjectMappingUtility('AU', 'Create_RetailCopy_CompanyAccount');
        	varMapUtil.mapFieldValues(objAccount, newAlk);
       }
    
     static void createTestData(){
      Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='ja_JP', ProfileId = p1.Id, Market__c='AU',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
       user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
    system.runAs(user1){    

	
        objAccount= new Account();
        objAccount.RecordtypeId= companyAccRecordTypeId;
        objAccount.Name='TestAccount';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='abcf@hji.com';
        objAccount.ZipCode__c = '4287';
     objAccount.Md__c ='AU';
        insert objAccount;
        
         
        personAcc= new Account();
        personAcc.RecordtypeId= strPerson;
        personAcc.LastName='TestLN';
        personAcc.Status__c='Active';
        personAcc.Province__c='Province1';
        personAcc.City__c='Test';
        personAcc.ZipCode__c = '4287';
        personAcc.Email__c='test@mbj.com';
        personAcc.Preferred_Language__c='Engmmm';        
        personAcc.MBK_Data_Source__c ='Email';
        personAcc.Phone = '+61200345678';
        personAcc.Province__c = 'Province1';
        personAcc.Preferred_Language__c='telugu';
        insert personAcc;
        
         
        system.debug('+++++++++++++++++'+addressobj);
        addressobj =new Address__C();
        addressobj =  new Address__C();
        addressobj.Address_Type__c = 'Home';
        addressobj.Address_Line_1__c = 'line 1';
        addressobj.Address_Line_2__c = 'line 2';
        addressobj.Block__c = 'Block';
        addressobj.Customer__c = objAccount.id;
        addressobj.ZipCode__c = '1441';
        addressobj.Province__c ='Fukushima';
        addressobj.TitleOfHonor__c = 'To Person';
        addressobj.Market__c='AU';
        addressobj.State_City__c='VIC';
        insert addressobj;
       
    }
        
    }
    
}