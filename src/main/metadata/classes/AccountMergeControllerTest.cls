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
    public static User user;
    public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

    //creating records for Master and Slave Account
    public static void init()
    {      
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = 'MasterAcc',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');       
        objSlave= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = false,lastname = 'SlaveAcc',DUPNumber__c='110',
                              Last_Successful_Call_Office_Phone__c = System.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress2');
        System.runAs(new User(Id = UserInfo.getUserId())){
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
        }                         
    }   
    
    public static testMethod void testAccountMergeController() {
        init();
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
        Test.stopTest();  
        list<Rejected_Duplicate_Log__c> lstLogsCreated = [select id from Rejected_Duplicate_Log__c];
        system.assert(lstLogsCreated.size() > 0 );           
    } 
    
    public static testMethod void testAccountMergeControllerdealer() {
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
         Account objMasterdeal= new Account(RecordTypeId=dealerRecordtypeid,Name='Master',MBK_Data_Source__c='Email',Mobile__c='00000009842');
            
         Account objSlavedealer = new Account(RecordTypeId=dealerRecordtypeid,Name='Slave',MBK_Data_Source__c='Email',Mobile__c='00000009842');
         
        System.runAs(new User(Id = UserInfo.getUserId())){
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
        list<Account> lstAccToInsert = new list<Account>();
        lstAccToInsert.add(objMasterdeal);
        lstAccToInsert.add(objSlavedealer);
        insert lstAccToInsert;
        
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.SelectSlaveAccount; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objMasterdeal.id);
        ApexPages.currentPage().getParameters().put('selectedSlaveAccount',objSlavedealer.id);
        ApexPages.currentPage().getParameters().put('selectedMasterAccount',objMasterdeal.id);
       
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
        Test.stopTest();  
        list<Rejected_Duplicate_Log__c> lstLogsCreated = [select id from Rejected_Duplicate_Log__c];
        system.assert(lstLogsCreated.size() > 0 );           
    } 
}
public static testMethod void testAccountMergeControllerCompany() {
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
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      
            
         Account objSlavecom = new Account(Dealer_Default_Flag__c=false,
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
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
         
        System.runAs(new User(Id = UserInfo.getUserId())){
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
        list<Account> lstAccToInsert = new list<Account>();
        lstAccToInsert.add(objMastercom);
        lstAccToInsert.add(objSlavecom);
        insert lstAccToInsert;
        
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.SelectSlaveAccount; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objMastercom.id);
        ApexPages.currentPage().getParameters().put('selectedSlaveAccount',objSlavecom.id);
        ApexPages.currentPage().getParameters().put('selectedMasterAccount',objMastercom.id);
       
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
           
            objAccountController.selectAllParam = System.Label.master;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.master);
            objAccountController.selectAllParam = System.Label.slave;
            objAccountController.selectAll();
            system.assertEquals(objAccountController.selectAllParam,System.Label.slave);
            objAccountController.previous(); 
        Test.stopTest();  
             
    } 
}
}