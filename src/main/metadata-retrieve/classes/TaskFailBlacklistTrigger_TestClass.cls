/*
    Type:       Test Class
    Purpose:    Task for updating account black list
    User Story: 	
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
*/
@isTest
public class TaskFailBlacklistTrigger_TestClass{
    static testmethod void runTaskFailBlacklistTrigger(){
    	Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> tkRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     	// Person Account.
        Id tkSMS_recordTypeId = tkRecordTypeMap_test.get('SMS').getRecordTypeId();
        
        // Person Contact                
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='Baoshan district',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );        
        insert(testPerAcc);        
        
 		testPerAcc = [Select Id, PersonContactId From Account Where Id = :testPerAcc.Id]; 
		
        Task testSMSTask = new Task(Subject='SMS TEST',
                                    WhoId=testPerAcc.PersonContactId,
                                    Activity_Status__c='Sent'
        							);
        insert testSMSTask;
        
        testSMSTask.Activity_Status__c='Fail-Blacklist';
        
        update testSMSTask;
		        
    }
}