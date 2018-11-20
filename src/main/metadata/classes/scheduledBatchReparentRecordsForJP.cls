/*
Created By: Dheeraj
Created Date: 31/10/2018
Description: This method is used for scheduling the job for reparent Notes and Attachments. This code copied from the class scheduledBatchReparentRecords.
*/
global class scheduledBatchReparentRecordsForJP implements Schedulable{
    global void execute(SchedulableContext SC){
        Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        Boolean jpSwitchEnabledFlag = false;
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Re-parent Notes and Attachments')){
            jpSwitchEnabledFlag = jpSwitchMap.get('Re-parent Notes and Attachments').Enable_Flag__c;
        }
        
        if(jpSwitchEnabledFlag){
            batchReparentRecordsForJP batch=new batchReparentRecordsForJP();
            Database.executeBatch(batch);
        }
    }
}