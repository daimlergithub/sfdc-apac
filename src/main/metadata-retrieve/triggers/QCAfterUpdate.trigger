/*
    Type:       Trigger
    Purpose:    1. Share with QC record's CSR Name with Read only
                2. Update QC Approved of Survey Result to true if QC's Survey Result is not null and approved is true.
                3.  Auto track field history when QC record be changed.
    User Story: US-QC-012, US-QC-021, US-QC-011
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-April-2013 Sinow Zhang (NTTData)  Created
*/
trigger QCAfterUpdate on QC__c (after update) {
    if (!UtilCustomSettings.isEnabled('QCAfterUpdate')) {
        return;
    }

    // QC list for share
    List<QC__c> QCForShare = new List<QC__c>();
    
    // Set Survey Result ids
    Set<Id> SurveyResultIds = new Set<Id>();
    
    // QC Result Tracking records for insert
    List<QC_Result_Tracking__c> QCHistorys = new List<QC_Result_Tracking__c>();
    
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    Set<String> taskIds = new Set<String>();
    Set<String> failtaskIds = new Set<String>();
    
    for(QC__c qc : Trigger.new) {
        if(!qc.Calibration__c && qc.status__c == 'Complete' && qc.status__c != Trigger.oldMap.get(qc.Id).status__c) {
            QCForShare.add(qc);
        }
 
		// TODO Kernel fix
		/*
        if(qc.Survey_Result__c != null && Trigger.oldMap.get(qc.Id).Approved__c != 'Yes' && qc.Approved__c == 'Yes') {
            SurveyResultIds.add(qc.Survey_Result__c);
        }
		*/
        
        //If field value changed, create new QC history records
        if(qc.PACI__c != Trigger.oldMap.get(qc.Id).PACI__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Provide Accurate Complete Information', qc.PACI__c, Trigger.oldMap.get(qc.Id).PACI__c));
        }
        if(qc.Q1_Comments__c != Trigger.oldMap.get(qc.Id).Q1_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Provide Accurate Complete Info Comments', qc.Q1_Comments__c, Trigger.oldMap.get(qc.Id).Q1_Comments__c));
        }
        if(qc.DA__c != Trigger.oldMap.get(qc.Id).DA__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Document Accuracy', qc.DA__c, Trigger.oldMap.get(qc.Id).DA__c));
        }
        if(qc.Q2_Comments__c != Trigger.oldMap.get(qc.Id).Q2_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Document Accuracy Comments', qc.Q2_Comments__c, Trigger.oldMap.get(qc.Id).Q2_Comments__c));
        }
        if(qc.FTOP__c != Trigger.oldMap.get(qc.Id).FTOP__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Follow The Operation Process', qc.FTOP__c, Trigger.oldMap.get(qc.Id).FTOP__c));
        }
        if(qc.Q3_Comments__c != Trigger.oldMap.get(qc.Id).Q3_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Follow The Operation Process Comments', qc.Q3_Comments__c, Trigger.oldMap.get(qc.Id).Q3_Comments__c));
        }            
        if(qc.FQL__c != Trigger.oldMap.get(qc.Id).FQL__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Following Questionnaire Logic', qc.FQL__c, Trigger.oldMap.get(qc.Id).FQL__c));
        }
        if(qc.Q4_Comments__c != Trigger.oldMap.get(qc.Id).Q4_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Following Questionnaire Logic Comments', qc.Q4_Comments__c, Trigger.oldMap.get(qc.Id).Q4_Comments__c));
        }
        if(qc.CITQ__c != Trigger.oldMap.get(qc.Id).CITQ__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Correctly Interpret The Questionnaire', qc.CITQ__c, Trigger.oldMap.get(qc.Id).CITQ__c));
        }
        if(qc.Q5_Comments__c != Trigger.oldMap.get(qc.Id).Q5_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Correctly Interpret The Questio Comments', qc.Q5_Comments__c, Trigger.oldMap.get(qc.Id).Q5_Comments__c));
        }
        if(qc.FMSK__c != Trigger.oldMap.get(qc.Id).FMSK__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Familiar MBCL/Smart/ Knowledge', qc.FMSK__c, Trigger.oldMap.get(qc.Id).FMSK__c));
        }
        if(qc.Q6_Comments__c != Trigger.oldMap.get(qc.Id).Q6_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Familiar MBCL/Smart/ Knowledge Comments', qc.Q6_Comments__c, Trigger.oldMap.get(qc.Id).Q6_Comments__c));
        }
        if(qc.Responsibility__c != Trigger.oldMap.get(qc.Id).Responsibility__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Responsibility', qc.Responsibility__c, Trigger.oldMap.get(qc.Id).Responsibility__c));
        }
        if(qc.Q7_Comments__c != Trigger.oldMap.get(qc.Id).Q7_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Responsibility Comments', qc.Q7_Comments__c, Trigger.oldMap.get(qc.Id).Q7_Comments__c));
        }
        if(qc.SO__c != Trigger.oldMap.get(qc.Id).SO__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Opening', qc.SO__c, Trigger.oldMap.get(qc.Id).SO__c));
        }
        if(qc.Q8_Comments__c != Trigger.oldMap.get(qc.Id).Q8_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Opening Comments', qc.Q8_Comments__c, Trigger.oldMap.get(qc.Id).Q8_Comments__c));
        }
        if(qc.PPIS__c != Trigger.oldMap.get(qc.Id).PPIS__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Proper Pronunciation&Intonation&Speed', qc.PPIS__c, Trigger.oldMap.get(qc.Id).PPIS__c));
        }
        if(qc.Q9_Comments__c != Trigger.oldMap.get(qc.Id).Q9_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Proper Pronunciation&Intonation Comments', qc.Q9_Comments__c, Trigger.oldMap.get(qc.Id).Q9_Comments__c));
        }
        if(qc.SPL__c != Trigger.oldMap.get(qc.Id).SPL__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Polite Language', qc.SPL__c, Trigger.oldMap.get(qc.Id).SPL__c));
        }
        if(qc.Q10_Comments__c != Trigger.oldMap.get(qc.Id).Q10_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Polite Language Comments', qc.Q10_Comments__c, Trigger.oldMap.get(qc.Id).Q10_Comments__c));
        }
        if(qc.SSL__c != Trigger.oldMap.get(qc.Id).SSL__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Spoken Language', qc.SSL__c, Trigger.oldMap.get(qc.Id).SSL__c));
        }
        if(qc.Q11_Comments__c != Trigger.oldMap.get(qc.Id).Q11_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Conclusion Comments', qc.Q11_Comments__c, Trigger.oldMap.get(qc.Id).Q11_Comments__c));
        }
        if(qc.SC__c != Trigger.oldMap.get(qc.Id).SC__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Conclusion Comments', qc.SC__c, Trigger.oldMap.get(qc.Id).SC__c));
        }
        if(qc.Q13_Comments__c != Trigger.oldMap.get(qc.Id).Q13_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Spoken Language Comments', qc.Q13_Comments__c, Trigger.oldMap.get(qc.Id).Q13_Comments__c));
        }
        if(qc.CALA__c != Trigger.oldMap.get(qc.Id).CALA__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Listening Ability', qc.CALA__c, Trigger.oldMap.get(qc.Id).CALA__c));
        }
        if(qc.Q12_Comments__c != Trigger.oldMap.get(qc.Id).Q12_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Listening Comments', qc.Q12_Comments__c, Trigger.oldMap.get(qc.Id).Q12_Comments__c));
        }
        if(qc.CAI__c != Trigger.oldMap.get(qc.Id).CAI__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Initiative', qc.CAI__c, Trigger.oldMap.get(qc.Id).CAI__c));
        }
        if(qc.Q15_Comments__c != Trigger.oldMap.get(qc.Id).Q15_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Initiative Comments', qc.Q15_Comments__c, Trigger.oldMap.get(qc.Id).Q15_Comments__c));
        }
        if(qc.CARR__c != Trigger.oldMap.get(qc.Id).CARR__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Rapid Response', qc.CARR__c, Trigger.oldMap.get(qc.Id).CARR__c));
        }
        if(qc.Q14_Comments__c != Trigger.oldMap.get(qc.Id).Q14_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability Response Comments', qc.Q14_Comments__c, Trigger.oldMap.get(qc.Id).Q14_Comments__c));
        }
        if(qc.PFOCF__c != Trigger.oldMap.get(qc.Id).PFOCF__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Focus On Customer Fee', qc.PFOCF__c, Trigger.oldMap.get(qc.Id).PFOCF__c));
        }
        if(qc.Q16_Comments__c != Trigger.oldMap.get(qc.Id).Q16_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Focus On Customer Comments', qc.Q16_Comments__c, Trigger.oldMap.get(qc.Id).Q16_Comments__c));
        }
        if(qc.PPD__c != Trigger.oldMap.get(qc.Id).PPD__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Patience Degree', qc.PPD__c, Trigger.oldMap.get(qc.Id).PPD__c));
        }
        if(qc.Q17_Comments__c != Trigger.oldMap.get(qc.Id).Q17_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Patience Degree Comments', qc.Q17_Comments__c, Trigger.oldMap.get(qc.Id).Q17_Comments__c));
        }
        if(qc.PJ__c != Trigger.oldMap.get(qc.Id).PJ__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - JinYongYu', qc.PJ__c, Trigger.oldMap.get(qc.Id).PJ__c));
        }
        if(qc.Q18_Comments__c != Trigger.oldMap.get(qc.Id).Q18_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - JinYongYu Comments', qc.Q18_Comments__c, Trigger.oldMap.get(qc.Id).Q18_Comments__c));
        }
        if(qc.PHU__c != Trigger.oldMap.get(qc.Id).PHU__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Hang Up', qc.PHU__c, Trigger.oldMap.get(qc.Id).PHU__c));
        }
        if(qc.Q19_Comments__c != Trigger.oldMap.get(qc.Id).Q19_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Hang Up Comments', qc.Q19_Comments__c, Trigger.oldMap.get(qc.Id).Q19_Comments__c));
        }
        if(qc.Q0_Comments__c != Trigger.oldMap.get(qc.Id).Q0_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Clarify&Confirm Customer Requir Comments', qc.Q0_Comments__c, Trigger.oldMap.get(qc.Id).Q0_Comments__c));
        }
        if(qc.CCI_Comments__c != Trigger.oldMap.get(qc.Id).CCI_Comments__c) {
            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Collect Customer Information Comments', qc.CCI_Comments__c, Trigger.oldMap.get(qc.Id).CCI_Comments__c));
        }
           
        // Change the task status.
        if(qc.RecordTypeId == SSIQCRecordTypeId && qc.Qualified__c == 'Pass'){
            taskIds.add(qc.Task_ID__c);
        }
        if(qc.RecordTypeId == SSIQCRecordTypeId && qc.Qualified__c == 'Fail'){
            failtaskIds.add(qc.Task_ID__c);
        }
    }
    
    // Insert QC sharing records
    if(QCForShare.size() > 0) {
        QCHelper.ShareQCtoCSR(QCForShare);
    }
    
    // Update QC Approved of Survey Result
    if(SurveyResultIds.size() > 0) {
        QCHelper.UpdateQCApproved(SurveyResultIds);
    }
    
    // Insert QC History tracking records
    if(QCHistorys.size() > 0) {
        QCHelper.insertSobjects(QCHistorys);
    }
    
    // Change the task status.
    taskIds.remove(null);
    if(taskIds.size() > 0){
        QCHelper.changeTask(taskIds);
    }
    failtaskIds.remove(null);
    if(failtaskIds.size() > 0){
        QCHelper.changeFailTask(failtaskIds);
    }
}