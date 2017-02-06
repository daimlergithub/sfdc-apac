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
public class AccountMergeControllerKRTest {  
    public static Account objMaster;
    public static Account objSlave;
    public static User user;
    public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    //creating records for Master and Slave Account
    public static void init()
    {      
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = 'MasterAcc',Phone = '1234575',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,MBK_Data_Source__c='Email',Mobile__c = '000-0000-9642',DMS_Address__c = 'dmsaddress1');       
        objSlave= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = false,lastname = 'SlaveAcc',Phone = '1234572',DUPNumber__c='110',
                              Last_Successful_Call_Office_Phone__c = System.today(),MBK_Data_Source__c='Email',Mobile__c = '000-0000-9642',DMS_Address__c = 'dmsaddress2');
        System.runAs(new User(Id = UserInfo.getUserId())){
            user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
        }                         
    }   
    
    public static testMethod void testAccountMergeControllerKR() {
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
        AccountMergeControllerKR objAccountController = new AccountMergeControllerKR(); 
        Test.startTest(); 
            for(AccountMergeControllerKR.Accountwrapper objAccWr : objAccountController.AccountwrapperList) {
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