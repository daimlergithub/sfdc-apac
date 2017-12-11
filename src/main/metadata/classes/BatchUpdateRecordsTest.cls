@isTest
public class BatchUpdateRecordsTest {

    public static testMethod void testMyController() {
         
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
         Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
               insert personAcc;
        for(integer i = 0; i < 201; i++) {
            tasks.add(new Task(RecordTypeId = SMSRTID, WhatId = personAcc.id));
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