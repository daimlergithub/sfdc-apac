/*
    Type:       Test class
    Purpose:    Test Class for SSIScheduleMassCarDeletion
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang Created on 2013-11-15
*/
@isTest
private class SSIScheduleMassCarDeletionTest{

    static testMethod void testScheduleMassCarDeletion(){

        //Prepare test data
        List<SSI__c> ssis = new List<SSI__c>();
        SSI__c ssi1 = new SSI__c(CUSTOMERNAME__C='zhang21', STATUS__C='original', VEHICLEDESC__C='smart1 典雅');
        SSI__c ssi2 = new SSI__c(CUSTOMERNAME__C='zhang22', STATUS__C='Pending', VEHICLEDESC__C='smart2 运动');
        SSI__c ssi3 = new SSI__c(CUSTOMERNAME__C='zhang23', STATUS__C='original', VEHICLEDESC__C='smart3 Compact');
        SSI__c ssi4 = new SSI__c(CUSTOMERNAME__C='zhang24', STATUS__C='original', VEHICLEDESC__C=' smart4');
        SSI__c ssi5 = new SSI__c(CUSTOMERNAME__C='zhang25', STATUS__C='original', VEHICLEDESC__C='sma rt5');
        SSI__c ssi6 = new SSI__c(CUSTOMERNAME__C='zhang26', STATUS__C='original', VEHICLEDESC__C='典雅mart6');

        ssis.add(ssi1);
        ssis.add(ssi2);
        ssis.add(ssi3);
        ssis.add(ssi4);
        ssis.add(ssi5);
        ssis.add(ssi6);

        Test.startTest();

        insert ssis;
        SSIScheduleMassCarDeletion ssmcd = new SSIScheduleMassCarDeletion();
        System.Schedule('SSI Daily Delete Smart Cars', '0 33 15 * * ?', ssmcd);

        Test.stopTest();
    }
}