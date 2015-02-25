/*
    Type:       Utility for QCAfterUpdate, QCBeforeUpdate
    Purpose:    1. Calculate total scores when qc is updated.
                2. Update QC Approved of Survey Result to true if QC's Survey Result is not null and approved is true.
                3. Share with QC record's CSR Name with Read only.
                4. Auto track field history when QC record be changed.
    User Story: US-QC-005, US-QC-012, US-QC-021, US-QC-011 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. 27-April-2013 Sinow Zhang (NTTData)  Created
*/
public class QCHelper {
    // Variables for calculate total score  
    private static Decimal passedQuestions;
    private static Decimal filledQuestions;
    private static Decimal failedFatalQuestions;
    private static Decimal failedFatalQuestionsForSSI2;
    
    public static void insertSobjects(List<Sobject> sos) {
        try {
            insert sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
        }
    }
    
    private static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
        }
    }
    
    public static Decimal IBCallTotalScore(QC__c qc) {
        passedQuestions = 0;
        filledQuestions = 0;
        failedFatalQuestions = 0;
        
        //summary passedQuestions
        if(qc.CCCR__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CCI__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PACI__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.DA__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.FTOP__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.FMSK__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.Responsibility__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SO__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PPIS__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SPL__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SSL__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SC__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CALA__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CAI__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CARR__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PFOCF__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PPD__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PJ__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PS__c == 'Pass') {
            passedQuestions += 1;
        }
        
        //summary filledQuestions
        if(qc.CCCR__c == 'Pass' || qc.CCCR__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CCI__c == 'Pass' || qc.CCI__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PACI__c == 'Pass' || qc.PACI__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.DA__c == 'Pass' || qc.DA__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.FTOP__c == 'Pass' || qc.FTOP__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.FMSK__c == 'Pass' || qc.FMSK__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.Responsibility__c == 'Pass' || qc.Responsibility__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SO__c == 'Pass' || qc.SO__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PPIS__c == 'Pass' || qc.PPIS__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SPL__c == 'Pass' || qc.SPL__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SSL__c == 'Pass' || qc.SSL__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SC__c == 'Pass' || qc.SC__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CALA__c == 'Pass' || qc.CALA__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CAI__c == 'Pass' || qc.CAI__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CARR__c == 'Pass' || qc.CARR__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PFOCF__c == 'Pass' || qc.PFOCF__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PPD__c == 'Pass' || qc.PPD__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PJ__c == 'Pass' || qc.PJ__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PS__c == 'Pass' || qc.PS__c == 'Fail') {
            filledQuestions += 1;
        }
        
        //summary failedFatalQuestions
        if(qc.CCCR__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PACI__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.CCI__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.DA__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.FTOP__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PFOCF__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PPD__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PJ__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        return (filledQuestions > 0 && (passedQuestions / filledQuestions - 0.1 * failedFatalQuestions) > 0) ? (passedQuestions / filledQuestions - 0.1 * failedFatalQuestions) * 100 : 0;
    }
    
    public static Decimal OBCallTotalScore(QC__c qc) {
        passedQuestions = 0;
        filledQuestions = 0;
        failedFatalQuestions = 0;
    
        //summary passedQuestions
        if(qc.PACI__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.DA__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.FTOP__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.FQL__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CITQ__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.FMSK__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.Responsibility__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SO__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PPIS__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SPL__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SSL__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.SC__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CALA__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CAI__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.CARR__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PFOCF__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PPD__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PJ__c == 'Pass') {
            passedQuestions += 1;
        }
        if(qc.PHU__c == 'Pass') {
            passedQuestions += 1;
        }
        
        //summary filledQuestions
        if(qc.PACI__c == 'Pass' || qc.PACI__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.DA__c == 'Pass' || qc.DA__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.FTOP__c == 'Pass' || qc.FTOP__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.FQL__c == 'Pass' || qc.FQL__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CITQ__c == 'Pass' || qc.CITQ__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.FMSK__c == 'Pass' || qc.FMSK__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.Responsibility__c == 'Pass' || qc.Responsibility__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SO__c == 'Pass' || qc.SO__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PPIS__c == 'Pass' || qc.PPIS__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SPL__c == 'Pass' || qc.SPL__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SSL__c == 'Pass' || qc.SSL__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.SC__c == 'Pass' || qc.SC__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CALA__c == 'Pass' || qc.CALA__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CAI__c == 'Pass' || qc.CAI__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.CARR__c == 'Pass' || qc.CARR__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PFOCF__c == 'Pass' || qc.PFOCF__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PPD__c == 'Pass' || qc.PPD__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PJ__c == 'Pass' || qc.PJ__c == 'Fail') {
            filledQuestions += 1;
        }
        if(qc.PHU__c == 'Pass' || qc.PHU__c == 'Fail') {
            filledQuestions += 1;
        }
        
        //summary failedFatalQuestions
        if(qc.PACI__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.DA__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.FTOP__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PFOCF__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PPD__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        if(qc.PJ__c == 'Fail') {
            failedFatalQuestions += 1;
        }
        
        return (filledQuestions > 0 && (passedQuestions / filledQuestions - 0.1 * failedFatalQuestions) > 0) ? (passedQuestions / filledQuestions - 0.1 * failedFatalQuestions) * 100 : 0;
    }
    
    public static Decimal SSITotalScore1(QC__c qc) {
        failedFatalQuestions = 0;

        //summary failedFatalQuestions
        if(qc.DA__c == 'middle' || qc.DA__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.FTOP__c == 'middle' || qc.FTOP__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.FQL__c == 'middle' || qc.FQL__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.PFOCF__c == 'middle' || qc.PFOCF__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.PPD__c == 'middle' || qc.PPD__c == 'Low') {
            failedFatalQuestions += 1;
        }
        
        return (SSIFilledQuestions(qc) > 0 && (SSIPassedQuestions(qc) / SSIFilledQuestions(qc) - 0.1 * failedFatalQuestions) > 0) ? (SSIPassedQuestions(qc) / SSIFilledQuestions(qc) - 0.1 * failedFatalQuestions) * 100 : 0;
    }

    public static Decimal SSITotalScore2(QC__c qc) {
        failedFatalQuestionsForSSI2 = 0;
        
        //summary failedFatalQuestionsForSSI2
        if(qc.DA__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.CITQ__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.FMSK__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.FTOP__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.FQL__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.SO__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.PPIS__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.SPL__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.SSL__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.SC__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.CALA__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.CAI__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.PFOCF__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.PPD__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.PJ__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        if(qc.PHU__c == 'Low') {
            failedFatalQuestionsForSSI2 += 1;
        }
        
        return (SSIFilledQuestions(qc) > 0 && (SSIPassedQuestions2(qc) / SSIFilledQuestions(qc) - 0.1 * failedFatalQuestionsForSSI2) > 0) ? (SSIPassedQuestions2(qc) / SSIFilledQuestions(qc) - 0.1 * failedFatalQuestionsForSSI2) * 100 : 0;
    }

    private static Decimal SSIPassedQuestions(QC__c qc) {
        passedQuestions = 0;
        
        //summary passedQuestions
        if(qc.PACI__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.DA__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.CITQ__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.FMSK__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.FTOP__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.FQL__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.SO__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PPIS__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.SPL__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.SSL__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.SC__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.CALA__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.CAI__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.CARR__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PFOCF__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PPD__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PJ__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PS__c == 'High') {
            passedQuestions += 1;
        }
        if(qc.PHU__c == 'High') {
            passedQuestions += 1;
        }
        return passedQuestions;
    }
    
    private static Decimal SSIPassedQuestions2(QC__c qc) {
        passedQuestions = 0;
        
        //summary passedQuestions
        if(qc.PACI__c == 'High' || qc.PACI__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.DA__c == 'High' || qc.DA__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.CITQ__c == 'High' || qc.CITQ__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.FMSK__c == 'High' || qc.FMSK__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.FTOP__c == 'High' || qc.FTOP__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.FQL__c == 'High' || qc.FQL__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.SO__c == 'High' || qc.SO__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PPIS__c == 'High' || qc.PPIS__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.SPL__c == 'High' || qc.SPL__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.SSL__c == 'High' || qc.SSL__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.SC__c == 'High' || qc.SC__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.CALA__c == 'High' || qc.CALA__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.CAI__c == 'High' || qc.CAI__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.CARR__c == 'High' || qc.CARR__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PFOCF__c == 'High' || qc.PFOCF__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PPD__c == 'High' || qc.PPD__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PJ__c == 'High' || qc.PJ__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PS__c == 'High' || qc.PS__c == 'middle') {
            passedQuestions += 1;
        }
        if(qc.PHU__c == 'High' || qc.PHU__c == 'middle') {
            passedQuestions += 1;
        }
        return passedQuestions;
    }

    private static Decimal SSIFilledQuestions(QC__c qc) {
        filledQuestions = 0;
        
        //summary filledQuestions
        if(qc.PACI__c == 'High' || qc.PACI__c == 'middle' || qc.PACI__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.DA__c == 'High' || qc.DA__c == 'middle' || qc.DA__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CITQ__c == 'High' || qc.CITQ__c == 'middle' || qc.CITQ__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FMSK__c == 'High' || qc.FMSK__c == 'middle' || qc.FMSK__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FTOP__c == 'High' || qc.FTOP__c == 'middle' || qc.FTOP__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FQL__c == 'High' || qc.FQL__c == 'middle' || qc.FQL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SO__c == 'High' || qc.SO__c == 'middle' || qc.SO__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PPIS__c == 'High' || qc.PPIS__c == 'middle' || qc.PPIS__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SPL__c == 'High' || qc.SPL__c == 'middle' || qc.SPL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SSL__c == 'High' || qc.SSL__c == 'middle' || qc.SSL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SC__c == 'High' || qc.SC__c == 'middle' || qc.SC__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CALA__c == 'High' || qc.CALA__c == 'middle' || qc.CALA__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CAI__c == 'High' || qc.CAI__c == 'middle' || qc.CAI__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CARR__c == 'High' || qc.CARR__c == 'middle' || qc.CARR__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PFOCF__c == 'High' || qc.PFOCF__c == 'middle' || qc.PFOCF__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PPD__c == 'High' || qc.PPD__c == 'middle' || qc.PPD__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PJ__c == 'High' || qc.PJ__c == 'middle' || qc.PJ__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PS__c == 'High' || qc.PS__c == 'middle' || qc.PS__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PHU__c == 'High' || qc.PHU__c == 'middle' || qc.PHU__c == 'Low') {
            filledQuestions += 1;
        }
        
        return filledQuestions;
    }
    
    public static void ShareQCtoCSR(List<QC__c> qcs) {
        List<QC__Share> sharingQCs = new List<QC__Share>();
        Set<Id> qcIds = new Set<Id>();
        Set<Id> existQCIds = new Set<Id>();
        for(QC__c qc : qcs) {
            qcIds.add(qc.Id);
        }
        
        //get the exsit qc ids for check later
        for(QC__share existqc : [select Id from QC__share where ParentID in :qcIds and RowCause = 'Manual']) {
            existQCIds.add(existqc.Id);
        }
        for(QC__c qc : qcs) {
            //if no exist qc record, create a new share qc.
            if(!existQCIds.contains(qc.Id)) {
                try {
                    QC__Share share = new QC__Share();
                    share.AccessLevel = 'Edit';
                    share.ParentID = qc.Id;
                    share.RowCause = Schema.QC__Share.RowCause.Manual;
                    share.UserOrGroupId = qc.CSR_Name__c;
                    sharingQCs.add(share);
                }
                catch(Exception ex) {
                    system.debug('Share record is exist already' + ex);
                }
            }
        }
        if(sharingQCs.size() > 0) {
            insertSobjects(sharingQCs);
        }
    }
    
    public static void UpdateQCApproved(Set<Id> SurveyResultIds) {

    }
    
    //Creates new QC historys.
    public static QC_Result_Tracking__c newQCHistory(Id qcId, String label, String newValue, String oldValue) {
        QC_Result_Tracking__c qrt = new QC_Result_Tracking__c();
        qrt.QC__c = qcId;
        qrt.User__c = UserInfo.getUserId();
        qrt.Action__c = 'Changed ' + label + ' from <b>' + oldValue + '</b> to <b>' + newValue + '</b>';
        return qrt;
    }
    
    public static String SetQualified(QC__c qc) {

        if((qc.DA__c == 'middle' || qc.DA__c == 'High') && (qc.CITQ__c == 'middle' || qc.CITQ__c == 'High') && 
           (qc.FMSK__c == 'middle' || qc.FMSK__c == 'High') && (qc.FTOP__c == 'middle' || qc.FTOP__c == 'High') && 
           (qc.FQL__c == 'middle' || qc.FQL__c == 'High') && (qc.SO__c == 'middle' || qc.SO__c == 'High') &&
           (qc.PPIS__c == 'middle' || qc.PPIS__c == 'High') && (qc.SPL__c == 'middle' || qc.SPL__c == 'High') &&
           (qc.SSL__c == 'middle' || qc.SSL__c == 'High') && (qc.SC__c == 'middle' || qc.SC__c == 'High') &&
           (qc.CALA__c == 'middle' || qc.CALA__c == 'High') && (qc.CAI__c == 'middle' || qc.CAI__c == 'High') &&
           (qc.PFOCF__c == 'middle' || qc.PFOCF__c == 'High') && (qc.PPD__c == 'middle' || qc.PPD__c == 'High') &&
           (qc.PJ__c == 'middle' || qc.PJ__c == 'High') && (qc.PHU__c == 'middle' || qc.PHU__c == 'High')) {
            return 'Pass';
        }
        return 'Fail';
    }
    
    public static void changeTask(Set<String> taskIds){
    	List<Task> changedTasks = new List<Task>();
    	for(Task task : [select Status from Task where Id in :taskIds]){
    		task.Activity_Status__c = 'QC Successful';
    		changedTasks.add(task);
    	}
    	update changedTasks;
    }

    public static void changeFailTask(Set<String> taskIds){
        List<Task> changedTasks = new List<Task>();
        for(Task task : [select Status from Task where Id in :taskIds]){
            task.Activity_Status__c = 'Expired';
            changedTasks.add(task);
        }
        update changedTasks;
    }
}