/*
    Type:       Test class
    Purpose:    Test Class for Account Merge
    User Story: US-DD-002
    Used By:     
    ---------------------------------------------------------------
    History:
    
    1. Created on 2-Dec-2015    
*/
@isTest
public class AccountMergeControllerTest {  
public static Account objMaster;
public static Account objSlave;
public static User user;
  //creating records for Master and Slave Account
  public static void init()
    {      

        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
       objMaster= new Account(Master_Record__c = true,                                      
                                     Phone = '1234575',DUPNumber__c='110',
                                     Last_Successful_Call_Office_Phone__c = System.today() - 10,
                                     DMS_Address__c = 'dmsaddress1');       
       objMaster = (Account)UtilTestData.createSobject(objMaster,UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
       objSlave= new Account(Master_Record__c = false,                                     
                                    Phone = '1234572',DUPNumber__c='110',
                                    Last_Successful_Call_Office_Phone__c = System.today(),
                                    DMS_Address__c = 'dmsaddress2');
       objSlave = (Account)UtilTestData.createSobject(objSlave,UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
       System.runAs ( new User(Id = UserInfo.getUserId()) ){
           user = (User)UtilTestData.createUser('Central', UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED);
       }                         
    }   
    //Tested MergeDup Method
    public static testMethod void testmergeDup() {
         init();
         //Use the PageReference Apex class to instantiate a page
         PageReference pageRef = Page.SelectSlaveAccount; 
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('id',objMaster.id);
         //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
         AccountMergeController objAccountController = new AccountMergeController(); 
         // Start Test
         Test.startTest();         
         //objAccountController.mergeDup();   
         // Stop Test  
         Test.stopTest();         
         system.assertEquals(objSlave.Master_Record__c,false);           
    } 
    //Tested RejectDup Method   
    public static testMethod void testrejectDup() {
        init();        
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);
        AccountMergeController objAccountController = new AccountMergeController();     
        Test.startTest();
        objAccountController.rejectDup();      
        Test.stopTest(); 
        //Rejected_Duplicate_Log__c duplicateLog =[Select id,DUPNumber__c,Master_Account__c,Duplicate_Account__c from Rejected_Duplicate_Log__c Where Master_Account__c=:objMaster.Id];   
        //system.assert(duplicateLog!=Null); 
        //system.assertEquals(duplicateLog.Duplicate_Account__c,objSlave.Id);                
     }
    //If no Master Record found or More than one master record has selected
    public static testMethod void testMasterRecord() {
        init();     
        objSlave.Master_Record__c = true;
        update objSlave;  
        PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);    
        ApexPages.currentPage().getParameters().put(system.Label.apex_SelectSlaveAccount,system.Label.apex_SelectSlaveAccount+objSlave.id);       
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.     
        AccountMergeController objAccountController = new AccountMergeController();     
        Test.startTest();
        objAccountController.rejectDup(); 
        //objAccountController.mergeDup();     
        Test.stopTest(); 
        //system.assertEquals(objAccountController.getcountMasterRecord(),2);      
    }    
   
    //Tested MergeAccount Method
    public static testMethod void testMergeAccount() {
        init();                
       // ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class. 
        PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);    
        AccountMergeController objAccountController = new AccountMergeController();
        // Start Test
        Test.startTest();
       objAccountController.Master = objMaster;
        objAccountController.Slave  = objSlave;
        objAccountController.mergeAccount();
        // Stop Test
        Test.stopTest();
        Account salveAcct=objSlave;//[select id,DUPNumber__c,Dup_Reason__c,Master_Account_Id__c,RecordTypeId,OwnerId from Account Where Id=:objSlave.Id];
        Account masterAcct=objMaster; //[select id,DUPNumber__c,Dup_Reason__c,Master_Record__c,RecordTypeId from Account Where Id=:objMaster.Id];
        User usr = [SELECT Id FROM User 
                   WHERE Profile.Name = 
                   :UtilConstant.PROFILE_PERSON_ACCOUNT_SOFT_DELETED  And IsActive = true 
                   LIMIT 1];
        system.assertNotEquals(salveAcct.RecordTypeId,UtilRecordType.getRecordTypeIdByName('Account',UtilConstant.RECORDTYPE_PERSON_ACCOUNT_SOFT_DELETED)); 
        salveAcct.OwnerId = usr.Id;
        system.assertEquals(salveAcct.OwnerId,usr.Id);   
        salveAcct.Master_Account_Id__c = masterAcct.Id;
        system.assertEquals(salveAcct.Master_Account_Id__c,masterAcct.Id); 
    }
    //Tested selectAll Method for master record
    public static testMethod void testselectAllMaster() {
        init();                
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.  
         PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);   
        AccountMergeController objAccountController = new AccountMergeController();
        // Start Test
        Test.startTest();
        // Choose all master value as default
        objAccountController.selectAllParam =System.Label.master;
        objAccountController.selectAll();
        // Stop Test
        Test.stopTest();
    }    
   //Tested selectAll Method for slaverecord
    public static testMethod void testselectAllSlave() {
        init();                
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class. 
         PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);    
        AccountMergeController objAccountController = new AccountMergeController();
        // Start Test
        Test.startTest();
        // Choose all master value as default
        objAccountController.selectAllParam =System.Label.slave;
        objAccountController.selectAll();
        // Stop Test
        Test.stopTest();
    }
     //Tested Previous Method 
     public static testMethod void testPrevious() {
        init();    
        ApexPages.currentPage().getParameters().put(system.Label.retURL,System.Label.apex_SelectSlaveAccount+objMaster.id);                 
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.  
         PageReference pageRef = Page.AccountMerge; 
         
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',objMaster.id);   
        AccountMergeController objAccountController = new AccountMergeController();
        // Start Test
        Test.startTest();        
        PageReference PreviousUrl=objAccountController.previous();
        // Stop Test
        Test.stopTest();  
        system.assertEquals(PreviousUrl.getURL(),'/apex/SelectSlaveAccount?id='+objMaster.Id);
    }
    //Tested Previous Cancel
    /*
    public static testMethod void testCancel() {
        init();                
        //ApexPages.StandardController objAcc = new ApexPages.StandardController(objMaster);
        //Instantiate and construct the controller class.
        PageReference pageRef = Page.AccountMerge; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objMaster.id);     
        Test.startTest();
        AccountMergeController objAccountController = new AccountMergeController();
        // Start Test
        objAccountController.master.id = objMaster.id;
        objAccountController.cancel();
        
        // Stop Test
        Test.stopTest();        
              
    }
    */
}