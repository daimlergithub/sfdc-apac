/*
    Type:       Test Class
    Purpose:    Test Class for BatchDataShareForExistTask
    User Story: Data Sharing V1.0
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-06-12
*/
@isTest
public class BatchDataShareForExistTaskTest {

    public static testMethod void testMyController() {
        
        Task tk1 = new Task();
        UtilTestData.createSobject(tk1, UtilTestData.TASK_RT_EDM);
        tk1.Status = 'Closed';
        update tk1;
        
        Test.startTest();
        
        BatchDataShareForExistTask batcher = new BatchDataShareForExistTask();
        Database.executeBatch(batcher, 300);
        tk1 = [select Status,RecordType.Name, IsVisibleInSelfService From Task where Id = :tk1.Id];
        System.assertEquals(tk1.IsVisibleInSelfService, true);
        
        Test.stopTest();
    }
}