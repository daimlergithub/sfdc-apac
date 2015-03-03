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
public class BatchUpdateRecordsTest {

    public static testMethod void testMyController() {
         
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        for(integer i = 0; i < 201; i++) {
            tasks.add(new Task(RecordTypeId = SMSRTID));
        }
        Insert tasks;
        
        Test.startTest();
        
        if (tasks.size() > 0) {
            Map<String, String> updateMap = new Map<String, String>();
            updateMap.put('Status', 'Closed');
            updateMap.put('Activity_Status__c', 'Sent');
    
            String queryIds = ' ';
            for(Task p : tasks){
                queryIds += '\''+ p.Id + '\'';
                queryIds += ',';
            }
            queryIds = queryIds.subString(0, queryIds.length()-1);
    
            String queryStr = 
                'Select Id, Status, Activity_Status__c From Task Where Id In (' + queryIds + ')';
                
            BatchUpdateRecords batcher = new BatchUpdateRecords(queryStr, updateMap);
            Database.executeBatch(batcher, 300);
        }
        
        Test.stopTest();
        
        Integer count  = [Select Count() From Task Where RecordTypeId = :SMSRTID And Status = 'Closed' And Activity_Status__c = 'Sent'];
        System.assertEquals(count, 201);
    }
}