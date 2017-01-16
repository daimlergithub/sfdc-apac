/*
    Type:       Schedule For Delete Task
    Purpose:    For Delete Task to Dealers 
    User Story: Retail Campaign
    Used By:    
    ---------------------------------------------------------------
    History:
        1. Shuang Li Created on 2014-05-12
*/

global class ScheduledDeleteTaskToDealers  implements Schedulable{

    global void execute(SchedulableContext SC) {
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
        List<Task> taskList = [Select Id From Task Where RecordTypeId = :cpRecordTypeMap.get('General Task').getRecordTypeId() And ActivityDate < :System.today()];
        system.debug('Task List :' +taskList);
        if(taskList.size() > 0){
            try {
                    Delete(taskList);
                }
            catch (DMLException e) {
                System.debug('Exception message is :' + e.getDMLMessage(0));
            }
        }
    }
}