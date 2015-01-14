/*
    Type:       Test class
    Purpose:    Test Class for smartDealerCleanController
    User Story: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang created on 2014-03-17
*/
@isTest
private class smartDealerCleanControllerTest{
    static testMethod void testsmartDealerCleanController(){

        smart_SSI__c sSSI1 = new smart_SSI__c();
        SSI_Cleansing_Result__c fromSSI = new SSI_Cleansing_Result__c();
        SSI_Cleansing_Result__c toSSI = new SSI_Cleansing_Result__c();
        insert sSSI1;
        insert fromSSI;
        insert toSSI;
        
        ApexPages.standardController controller = new ApexPages.standardController(sSSI1);
        smartDealerCleanController extension = new smartDealerCleanController();
        extension.fromSSI = fromSSI;
        extension.toSSI = toSSI;
        extension.dealerClean();
        extension.fromSSI.SSI_Created_Date__c = date.newInstance(2014, 1, 1);
        extension.toSSI.SSI_Created_Date__c = date.newInstance(2013, 1, 1);
        extension.dealerClean();
        extension.fromSSI.SSI_Created_Date__c = date.newInstance(2014, 1, 1);
        extension.toSSI.SSI_Created_Date__c = date.newInstance(2015, 1, 1);
        extension.dealerClean();
        
        
    }
}