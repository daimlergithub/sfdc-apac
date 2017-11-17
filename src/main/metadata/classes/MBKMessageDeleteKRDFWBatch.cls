/**
 * Class Name	: MBKMessageDeleteKRDFWBatch.cls
 * Function		: MBK Message Delete Batch
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 기간(system.label.MBKMessageLogDelete) 이전 레코드 삭제	
*/
global class MBKMessageDeleteKRDFWBatch implements Database.Batchable<sObject>{
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		integer deleteDate = integer.valueOf(system.label.MBKMessageLogDelete);
		String nowDay = String.valueOf(date.today().addDays(-deleteDate)) + 'T15:00:00Z';
		String query = 'SELECT Id FROM MBK_Messages__c WHERE processed__c = true AND Set_Sending_Time__c < ' + nowDay;
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<MBK_Messages__c> deleteRecords = (List<MBK_Messages__c>)scope; 
		delete deleteRecords;
	}
	
	global void finish(Database.BatchableContext BC) {
	} 
}