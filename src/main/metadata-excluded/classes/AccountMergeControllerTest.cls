/*
    Type:       Test class
    Purpose:    Test Class for Account Merge
    User Story: US-DD-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-3-06
*/
@isTest
public class AccountMergeControllerTest {
    // Senario 1
    // Click Merge button on Master detail page
    public static testMethod void testAccountMerge_Master() {
        Account master = new Account(Master_Record__c = true, 
                                     DUP_Nummer__c = '110',
                                     Phone = '1234575',
                                     Last_Successful_Call_Office_Phone__c = System.today() - 10,
                                     DMS_Address__c = 'dmsaddress1');
                                     
        Account slave = new Account(Master_Record__c = false, 
                                    DUP_Nummer__c = '110',
                                    Phone = '1234572',
                                    Last_Successful_Call_Office_Phone__c = System.today(),
                                    DMS_Address__c = 'dmsaddress2');
        
        master = (Account)UtilTestData.createSobject(master, 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        slave = (Account)UtilTestData.createSobject(slave, 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        // Start Test
        Test.startTest();
        
        PageReference selectSlavePR = new PageReference('/apex/SelectSlaveAccount?' + master.Id);
        Test.setCurrentPage(selectSlavePR);
        AccountMergeController selectSlave = new AccountMergeController(
           new ApexPages.StandardController(master));
        
        // Master has only one Suspect Account: slave, it
        // means there are two elements in slaves list
        System.assert(selectSlave.slaves.size() == 2);
        
        // Redirect page to Account Merge Page
        PageReference mergePR = new PageReference('/apex/AccountMerge?Id=' + 
           master.Id + '&slaveId=' + 
           slave.Id + '&retURL=/apex/SelectSlaveAccount?Id=' + 
           master.Id);
        Test.setCurrentPage(mergePR);
        
        AccountMergeController accountMerge = new AccountMergeController(
            new ApexPages.StandardController(master));
        
        // Choose all master value as default
        accountMerge.selectAllParam = 'master';
        accountMerge.selectAll(); 
        accountMerge.mergeAccount();
        Account mergedMaster = [SELECT Phone, DMS_Address__c 
                                FROM Account WHERE Id = :master.Id];
        System.assert(mergedMaster.Phone == master.Phone);
        
        accountMerge.previous();
        
        // Stop Test
        Test.stopTest();
    }
    
    public static testMethod void testSelectSlaveAccount_NoSlave() {
        Account master = new Account(Master_Record__c = true, 
                                     DUP_Nummer__c = '110',
                                     Phone = '1234579',
                                     DMS_Address__c = 'dmsaddress1');
        master = (Account)UtilTestData.createSobject(master, 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        // Start Test
        Test.startTest();
        
        PageReference selectSlavePR = new PageReference('/apex/SelectSlaveAccount?' + master.Id);
        Test.setCurrentPage(selectSlavePR);
        AccountMergeController selectSlave = new AccountMergeController(
           new ApexPages.StandardController(master));
        System.assert(selectSlave.slaves.size() == 1);
        
        // Stop Test
        Test.stopTest();
    }
}