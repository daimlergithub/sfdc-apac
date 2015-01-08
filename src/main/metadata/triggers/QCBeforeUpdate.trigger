/*
    Type:       Trigger
    Purpose:    1. Calculate total scores when qc is updated.
                2. Update Qualified value
                3. Set Total Score/Total Score1/Total Score2 to 0 when the status is Cancel or Disqualified
    User Story: US-QC-005, US-QC-021, CR-131111
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-April-2013 Sinow Zhang (NTTData)  Created
    Patrick Zhang add new logic branch on 2013-12-03
    2014-2-26 Updated by Justin Yu
*/
trigger QCBeforeUpdate on QC__c (before insert, before update) {

    if (!UtilCustomSettings.isEnabled('QCBeforeUpdate')) {
        return;
    }

    private static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
    private static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    
    for(QC__c qc : Trigger.new) {
        if(qc.RecordTypeId == IBQCRecordTypeId) {

            if (qc.Status__c != 'Cancel') {
                qc.Total_Score__c = QCHelper.IBCallTotalScore(qc);
            }else{
                qc.Total_Score__c = 0;
            }

        }
        if(qc.RecordTypeId == OBQCRecordTypeId) {
            if (qc.Status__c != 'Cancel') {
                qc.Total_Score__c = QCHelper.OBCallTotalScore(qc);
            }else{
                qc.Total_Score__c = 0;
            }
        }

        if(qc.RecordTypeId == SSIQCRecordTypeId) {
             
             if (qc.Status__c != 'Disqualified') {
                qc.Total_Score_1__c = QCHelper.SSITotalScore1(qc);
                qc.Total_Score_2__c = QCHelper.SSITotalScore2(qc);
                if(qc.status__c == 'Complete') {
                     qc.Qualified__c = QCHelper.SetQualified(qc);
                     qc.Completed_Time__c = Datetime.now();
                }
             }else{
                    qc.Total_Score_1__c = 0;
                    qc.Total_Score_2__c = 0;
                    qc.Qualified__c = 'Fail';
            }
        }

        if (Trigger.oldMap != null && Trigger.oldMap.containskey(qc.Id)){
            QC__c oldQc = Trigger.oldMap.get(qc.Id);
            if (qc.Approved__c == 'Yes' && oldQc.Approved__c != 'Yes') {
                qc.Approved_Time__c = Datetime.now();              
            }
        }
    }
    
    // Added by Justin -- 2014-2-26
    Set<String> taskIds = new Set<String>();
    for(QC__c qc : Trigger.new){
    	if(!Trigger.isUpdate || qc.Task_ID__c != Trigger.oldMap.get(qc.Id).Task_ID__c){
    		taskIds.add(qc.Task_ID__c);
    	}
    }
    
    if(taskIds.size() > 0){
	    Map<String, Task> tasks = new Map<String, Task>([select Id, Subject from Task where Id in :taskIds]);
	    for(QC__c qc : Trigger.new){
	    	Task task = tasks.get(qc.Task_ID__c);
	    	qc.TaskName__c = task != null ? task.Subject : null;
	    }
    }
}