/*
    Type:Test class
    Purpose:Test Class for Account Merge
    User Story:US-DD-002
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 2-Dec-2015
    2. Modified on 4-Feb-2017    
*/
@isTest
public class AccountMergeControllerTest {  
    public static Account objMaster;
    public static Account objSlave;
    private static Address__c address;
    private static Address__c address1;
    public static User user;
    public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

    //creating records for Master and Slave Account
    public static void init()
    {   UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true); 
        system.runAs(user_Obj){       
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = '雄志',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');       
        objSlave= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = false,lastname = '雄志',DUPNumber__c='110',
                              Last_Successful_Call_Office_Phone__c = System.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress2');
                              
        
        
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
         
      }                    
    }   
    
    public static testMethod void testAccountMergeController() {
        init();
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
       User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='ja_JP', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );  
    system.runas(user1){  
        list<Account> lstAccToInsert = new list<Account>();
        
         
        lstAccToInsert.add(objMaster);
        lstAccToInsert.add(objSlave);
        insert lstAccToInsert;
        
        
        
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.SelectSlaveAccount; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objMaster.id);
        ApexPages.currentPage().getParameters().put('selectedSlaveAccount',objSlave.id);
        ApexPages.currentPage().getParameters().put('selectedMasterAccount',objMaster.id);
       
        //Instantiate and construct the controller class.     
        AccountMergeController objAccountController = new AccountMergeController(); 
        Test.startTest(); 
            for(AccountMergeController.Accountwrapper objAccWr : objAccountController.AccountwrapperList) {
                if(objAccWr.acc.Id == objSlave.Id){
                    objAccWr.selected = TRUE;
                }
            }
            objAccountController.processSelected();
            objAccountController.rejectDup();
            objAccountController.mergeAccount();
            objAccountController.selectAllParam = System.Label.master;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.master);
            objAccountController.selectAllParam = System.Label.slave;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.slave);
            objAccountController.previous(); 
            objAccountController.populateAddressWrappers();
           objAccountController.getParameter('abcd');
        List<String> strList=objAccountController.fieldAPIList1;
        Test.stopTest();  
        list<Rejected_Duplicate_Log__c> lstLogsCreated = [select id from Rejected_Duplicate_Log__c];
        system.assert(lstLogsCreated.size() > 0 );   
     }        
    } 
    
  
public static testMethod void testAccountMergeControllerCompany() {
       Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
       User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='ja_JP', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );  
    system.runas(user1){      
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        Account objMastercom = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', 
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                DUPNumber__c='101',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      
            
         Account objSlavecom = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', 
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'JP',
                                name = 'tes company name1',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                DUPNumber__c='101',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                                
        
         
       // System.runAs(new User(Id = UserInfo.getUserId())){
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
        list<Account> lstAccToInsert = new list<Account>();
        lstAccToInsert.add(objMastercom);
        lstAccToInsert.add(objSlavecom);
        insert lstAccToInsert;
        
        Address__c address2 = new Address__c(Address_Type__c='Home',Province__c='test1',City__c='bangalore', District__c='test2', Block__c='test3', Address_Line_1__c='testaddress1', 
                                Address_Line_2__c='testaddress2',Customer__c=lstAccToInsert[0].id, TitleOfHonor__c = 'To Person');
                                
        Address__c address3 = new Address__c(Address_Type__c='Home',Province__c='test1',City__c='bangalore', District__c='test2', Block__c='test3', Address_Line_1__c='testaddress1', 
                                Address_Line_2__c='testaddress2',Customer__c=lstAccToInsert[1].id, TitleOfHonor__c = 'To Person');
        
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.SelectSlaveAccount; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objMastercom.id);
        ApexPages.currentPage().getParameters().put('selectedSlaveAccount',objSlavecom.id);
        ApexPages.currentPage().getParameters().put('selectedMasterAccount',objMastercom.id);
        
         Rejected_Duplicate_Log__c duplicateLog = new Rejected_Duplicate_Log__c(
            Master_Account__c = objMastercom.Id,
            Duplicate_Account__c = objSlavecom.Id,  
            Status__c=System.Label.Rejected);
        
           
            insert duplicateLog;  
       
        //Instantiate and construct the controller class.     
        AccountMergeController objAccountController = new AccountMergeController(); 
        Test.startTest(); 
            for(AccountMergeController.Accountwrapper objAccWr : objAccountController.AccountwrapperList) {
                if(objAccWr.acc.Id == objSlavecom.Id){
                    objAccWr.selected = TRUE;
                }
            }
            objAccountController.selectedAddress = 'test';
            objAccountController.processSelected();
            objAccountController.rejectDup();
           // objAccountController.mergeAccount();
            objAccountController.displayAddress();
           
            objAccountController.selectAllParam = System.Label.master;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.master);
            objAccountController.selectAllParam = System.Label.slave;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.slave);
            objAccountController.previous(); 
            objAccountController.getaddtype();
            objAccountController.rejectDup();
            AccountMergeController.addrs=objSlavecom.Id;
            AccountMergeController.addrs1=objSlavecom.Id;
            //List<AccountMergeController.Accountwrapper> li = objAccountController.AddWrapList ;
           // Integer a=objAccountController.AddWrapList.size();
            //objAccountController.fieldAPIList1;
        Test.stopTest();  
             
    } 
}

}