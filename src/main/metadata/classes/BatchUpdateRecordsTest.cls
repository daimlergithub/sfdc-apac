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
        
        if (!tasks.isEmpty()) {
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