/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class QCMassApprovalControllerTest {

    static testMethod void myUnitTest() {
    
        SSI__c ssi = new SSI__c();
        insert ssi;
        
        Survey_Result__c sr = new Survey_Result__c();
        sr.SSI_Record__c = ssi.Id;
        insert sr;
        
        QC__c qc1 = new QC__c(Survey_Result__c = sr.Id, SSI__c = ssi.Id, Status__c = 'Complete');
        insert qc1;
        qc1.Qualified__c = 'Pass';
        update qc1;
        
        QC__c qc2 = new QC__c(Survey_Result__c = sr.Id, SSI__c = ssi.Id, Status__c = 'Complete');
        insert qc2;
        qc2.Qualified__c = 'Fail';
        update qc2;
    
        // Test Start
        Test.startTest();
        
        PageReference pr = new PageReference('/apex/QCMassApproval?objIds=' + qc1.Id + ',' + qc2.Id);
        Test.setCurrentPage(pr);
        
        QCMassApprovalController con = new QCMassApprovalController();
        con.massApproved();
        
        qc1 = [Select Approved__c From QC__c Where Id = :qc1.Id];
        qc2 = [Select Approved__c From QC__c Where Id = :qc2.Id];
        
        System.assertEquals(qc1.Approved__c, 'Yes');
        System.assertEquals(qc2.Approved__c, null);
        
        Test.stopTest();
    }
}