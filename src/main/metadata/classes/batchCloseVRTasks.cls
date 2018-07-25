global class batchCloseVRTasks implements Database.Batchable<sObject>,Database.Stateful, Schedulable {
	global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='select Id,Car_Relation__c,End_Date__c,Market__c,Purchase_Date__c,Task_Limit__c from Vehicle_Relationship__c where Car_Relation__c =\'Sales\' and End_Date__c = null and Market__c = \'TR\'';
        return Database.getQueryLocator(query);
    }
	global void execute(Database.BatchableContext bc, List<Vehicle_Relationship__c> scope)
    {
        system.debug(scope+'[[[]]]');
		set<id> vrIds = new set<Id>();
		for(Vehicle_Relationship__c vr :scope)
		{
			if(vr.Task_Limit__c+120 == System.today())
				vrIds.add(vr.id);
		}
		sObjectMerge.autoCloseTasks(vrIds);
	}
    global void finish(Database.BatchableContext bc)
    {
        
    }
    global void execute(SchedulableContext ctx) {
       
       batchCloseVRTasks batchSch = New batchCloseVRTasks();
       Database.executeBatch(batchSch,50);
       
    }
}