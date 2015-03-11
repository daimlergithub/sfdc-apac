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
    private static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
    private static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    
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
        if(qc.DA__c == 'Medium' || qc.DA__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.FTOP__c == 'Medium' || qc.FTOP__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.FQL__c == 'Medium' || qc.FQL__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.PFOCF__c == 'Medium' || qc.PFOCF__c == 'Low') {
            failedFatalQuestions += 1;
        }
        if(qc.PPD__c == 'Medium' || qc.PPD__c == 'Low') {
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
        if(qc.PACI__c == 'High' || qc.PACI__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.DA__c == 'High' || qc.DA__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.CITQ__c == 'High' || qc.CITQ__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.FMSK__c == 'High' || qc.FMSK__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.FTOP__c == 'High' || qc.FTOP__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.FQL__c == 'High' || qc.FQL__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.SO__c == 'High' || qc.SO__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PPIS__c == 'High' || qc.PPIS__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.SPL__c == 'High' || qc.SPL__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.SSL__c == 'High' || qc.SSL__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.SC__c == 'High' || qc.SC__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.CALA__c == 'High' || qc.CALA__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.CAI__c == 'High' || qc.CAI__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.CARR__c == 'High' || qc.CARR__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PFOCF__c == 'High' || qc.PFOCF__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PPD__c == 'High' || qc.PPD__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PJ__c == 'High' || qc.PJ__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PS__c == 'High' || qc.PS__c == 'Medium') {
            passedQuestions += 1;
        }
        if(qc.PHU__c == 'High' || qc.PHU__c == 'Medium') {
            passedQuestions += 1;
        }
        return passedQuestions;
    }

    private static Decimal SSIFilledQuestions(QC__c qc) {
        filledQuestions = 0;
        
        //summary filledQuestions
        if(qc.PACI__c == 'High' || qc.PACI__c == 'Medium' || qc.PACI__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.DA__c == 'High' || qc.DA__c == 'Medium' || qc.DA__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CITQ__c == 'High' || qc.CITQ__c == 'Medium' || qc.CITQ__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FMSK__c == 'High' || qc.FMSK__c == 'Medium' || qc.FMSK__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FTOP__c == 'High' || qc.FTOP__c == 'Medium' || qc.FTOP__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.FQL__c == 'High' || qc.FQL__c == 'Medium' || qc.FQL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SO__c == 'High' || qc.SO__c == 'Medium' || qc.SO__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PPIS__c == 'High' || qc.PPIS__c == 'Medium' || qc.PPIS__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SPL__c == 'High' || qc.SPL__c == 'Medium' || qc.SPL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SSL__c == 'High' || qc.SSL__c == 'Medium' || qc.SSL__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.SC__c == 'High' || qc.SC__c == 'Medium' || qc.SC__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CALA__c == 'High' || qc.CALA__c == 'Medium' || qc.CALA__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CAI__c == 'High' || qc.CAI__c == 'Medium' || qc.CAI__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.CARR__c == 'High' || qc.CARR__c == 'Medium' || qc.CARR__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PFOCF__c == 'High' || qc.PFOCF__c == 'Medium' || qc.PFOCF__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PPD__c == 'High' || qc.PPD__c == 'Medium' || qc.PPD__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PJ__c == 'High' || qc.PJ__c == 'Medium' || qc.PJ__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PS__c == 'High' || qc.PS__c == 'Medium' || qc.PS__c == 'Low') {
            filledQuestions += 1;
        }
        if(qc.PHU__c == 'High' || qc.PHU__c == 'Medium' || qc.PHU__c == 'Low') {
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
            UtilSobject.insertSobjects(sharingQCs);
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

        if((qc.DA__c == 'Medium' || qc.DA__c == 'High') && (qc.CITQ__c == 'Medium' || qc.CITQ__c == 'High') && 
           (qc.FMSK__c == 'Medium' || qc.FMSK__c == 'High') && (qc.FTOP__c == 'Medium' || qc.FTOP__c == 'High') && 
           (qc.FQL__c == 'Medium' || qc.FQL__c == 'High') && (qc.SO__c == 'Medium' || qc.SO__c == 'High') &&
           (qc.PPIS__c == 'Medium' || qc.PPIS__c == 'High') && (qc.SPL__c == 'Medium' || qc.SPL__c == 'High') &&
           (qc.SSL__c == 'Medium' || qc.SSL__c == 'High') && (qc.SC__c == 'Medium' || qc.SC__c == 'High') &&
           (qc.CALA__c == 'Medium' || qc.CALA__c == 'High') && (qc.CAI__c == 'Medium' || qc.CAI__c == 'High') &&
           (qc.PFOCF__c == 'Medium' || qc.PFOCF__c == 'High') && (qc.PPD__c == 'Medium' || qc.PPD__c == 'High') &&
           (qc.PJ__c == 'Medium' || qc.PJ__c == 'High') && (qc.PHU__c == 'Medium' || qc.PHU__c == 'High')) {
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
    
    public static void beforeInsertUpdateEvents(list<QC__c> QCNew,map<id,QC__c> QCOldMap,boolean isInsert,boolean isUpdate)
    {
    	for(QC__c qc : QCNew)
    	{
	        if(qc.RecordTypeId == IBQCRecordTypeId)
	        {
	
	            if (qc.Status__c != 'Cancel')
	            {
	                qc.Total_Score__c = IBCallTotalScore(qc);
	            }
	            else
	            {
	                qc.Total_Score__c = 0;
	            }
	
	        }
	        if(qc.RecordTypeId == OBQCRecordTypeId)
	        {
	            if (qc.Status__c != 'Cancel')
	            {
	                qc.Total_Score__c = OBCallTotalScore(qc);
	            }
	            else
	            {
	                qc.Total_Score__c = 0;
	            }
	        }
	
	        if(qc.RecordTypeId == SSIQCRecordTypeId)
	        {
	             if (qc.Status__c != 'Disqualified')
	             {
	                qc.Total_Score_1__c = QCHelper.SSITotalScore1(qc);
	                qc.Total_Score_2__c = QCHelper.SSITotalScore2(qc);
	                if(qc.status__c == 'Complete')
	                {
	                     qc.Qualified__c = QCHelper.SetQualified(qc);
	                     qc.Completed_Time__c = Datetime.now();
	                }
	             }
	             else
	             {
                    qc.Total_Score_1__c = 0;
                    qc.Total_Score_2__c = 0;
                    qc.Qualified__c = 'Fail';
	            }
	        }
	
	        if (QCOldMap != null && QCOldMap.containskey(qc.Id))
	        {
	            QC__c oldQc = QCOldMap.get(qc.Id);
	            if (qc.Approved__c == 'Yes' && oldQc.Approved__c != 'Yes')
	            {
	                qc.Approved_Time__c = Datetime.now();              
	            }
	        }
	    }
	    
	    // Added by Justin -- 2014-2-26
	    Set<String> taskIds = new Set<String>();
	    for(QC__c qc : QCNew)
	    {
	    	if(!isUpdate || qc.Task_ID__c != QCOldMap.get(qc.Id).Task_ID__c)
	    	{
	    		taskIds.add(qc.Task_ID__c);
	    	}
	    }
	    
	    if(taskIds!=null && !taskIds.isEmpty())
	    {
		    Map<String, Task> tasks = new Map<String, Task>([select Id, Subject from Task where Id in :taskIds]);
		    for(QC__c qc : QCNew)
		    {
		    	Task task = tasks.get(qc.Task_ID__c);
		    	qc.TaskName__c = task != null ? task.Subject : null;
		    }
	    }
    }
    
    public static void afterInsertUpdateEvents(list<QC__c> QCNew,map<id,QC__c> QCOldMap,boolean isInsert,boolean isUpdate)
    {
    	List<QC__c> QCForShare = new List<QC__c>();
    
	    // Set Survey Result ids
	    Set<Id> SurveyResultIds = new Set<Id>();
	    
	    // QC Result Tracking records for insert
	    List<QC_Result_Tracking__c> QCHistorys = new List<QC_Result_Tracking__c>();
	    
	    Set<String> taskIds = new Set<String>();
	    Set<String> failtaskIds = new Set<String>();
	    
	    for(QC__c qc : QCNew)
	    {
	        if(!qc.Calibration__c && qc.status__c == 'Complete' && qc.status__c != QCOldMap.get(qc.Id).status__c)
	        {
	            QCForShare.add(qc);
	        }
	 
			// TODO Kernel fix
			/*
	        if(qc.Survey_Result__c != null && Trigger.oldMap.get(qc.Id).Approved__c != 'Yes' && qc.Approved__c == 'Yes') {
	            SurveyResultIds.add(qc.Survey_Result__c);
	        }
			*/
	        
	        //If field value changed, create new QC history records
	        if(qc.PACI__c != QCOldMap.get(qc.Id).PACI__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Provide Accurate Complete Information', qc.PACI__c, QCOldMap.get(qc.Id).PACI__c));
	        }
	        if(qc.Q1_Comments__c != QCOldMap.get(qc.Id).Q1_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Provide Accurate Complete Info Comments', qc.Q1_Comments__c, QCOldMap.get(qc.Id).Q1_Comments__c));
	        }
	        if(qc.DA__c != QCOldMap.get(qc.Id).DA__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Document Accuracy', qc.DA__c, QCOldMap.get(qc.Id).DA__c));
	        }
	        if(qc.Q2_Comments__c != QCOldMap.get(qc.Id).Q2_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Document Accuracy Comments', qc.Q2_Comments__c, QCOldMap.get(qc.Id).Q2_Comments__c));
	        }
	        if(qc.FTOP__c != QCOldMap.get(qc.Id).FTOP__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Follow The Operation Process', qc.FTOP__c, QCOldMap.get(qc.Id).FTOP__c));
	        }
	        if(qc.Q3_Comments__c != QCOldMap.get(qc.Id).Q3_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Follow The Operation Process Comments', qc.Q3_Comments__c, QCOldMap.get(qc.Id).Q3_Comments__c));
	        }            
	        if(qc.FQL__c != QCOldMap.get(qc.Id).FQL__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Following Questionnaire Logic', qc.FQL__c, QCOldMap.get(qc.Id).FQL__c));
	        }
	        if(qc.Q4_Comments__c != QCOldMap.get(qc.Id).Q4_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Following Questionnaire Logic Comments', qc.Q4_Comments__c, QCOldMap.get(qc.Id).Q4_Comments__c));
	        }
	        if(qc.CITQ__c != QCOldMap.get(qc.Id).CITQ__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Correctly Interpret The Questionnaire', qc.CITQ__c, QCOldMap.get(qc.Id).CITQ__c));
	        }
	        if(qc.Q5_Comments__c != QCOldMap.get(qc.Id).Q5_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Correctly Interpret The Questio Comments', qc.Q5_Comments__c, QCOldMap.get(qc.Id).Q5_Comments__c));
	        }
	        if(qc.FMSK__c != QCOldMap.get(qc.Id).FMSK__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Familiar MBCL/Smart/ Knowledge', qc.FMSK__c, QCOldMap.get(qc.Id).FMSK__c));
	        }
	        if(qc.Q6_Comments__c != QCOldMap.get(qc.Id).Q6_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Familiar MBCL/Smart/ Knowledge Comments', qc.Q6_Comments__c, QCOldMap.get(qc.Id).Q6_Comments__c));
	        }
	        if(qc.Responsibility__c != QCOldMap.get(qc.Id).Responsibility__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Responsibility', qc.Responsibility__c, QCOldMap.get(qc.Id).Responsibility__c));
	        }
	        if(qc.Q7_Comments__c != QCOldMap.get(qc.Id).Q7_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Responsibility Comments', qc.Q7_Comments__c, QCOldMap.get(qc.Id).Q7_Comments__c));
	        }
	        if(qc.SO__c != QCOldMap.get(qc.Id).SO__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Opening', qc.SO__c, QCOldMap.get(qc.Id).SO__c));
	        }
	        if(qc.Q8_Comments__c != QCOldMap.get(qc.Id).Q8_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Opening Comments', qc.Q8_Comments__c, QCOldMap.get(qc.Id).Q8_Comments__c));
	        }
	        if(qc.PPIS__c != QCOldMap.get(qc.Id).PPIS__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Proper Pronunciation&Intonation&Speed', qc.PPIS__c, QCOldMap.get(qc.Id).PPIS__c));
	        }
	        if(qc.Q9_Comments__c != QCOldMap.get(qc.Id).Q9_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Proper Pronunciation&Intonation Comments', qc.Q9_Comments__c, QCOldMap.get(qc.Id).Q9_Comments__c));
	        }
	        if(qc.SPL__c != QCOldMap.get(qc.Id).SPL__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Polite Language', qc.SPL__c, QCOldMap.get(qc.Id).SPL__c));
	        }
	        if(qc.Q10_Comments__c != QCOldMap.get(qc.Id).Q10_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Polite Language Comments', qc.Q10_Comments__c, QCOldMap.get(qc.Id).Q10_Comments__c));
	        }
	        if(qc.SSL__c != QCOldMap.get(qc.Id).SSL__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Spoken Language', qc.SSL__c, QCOldMap.get(qc.Id).SSL__c));
	        }
	        if(qc.Q11_Comments__c != QCOldMap.get(qc.Id).Q11_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Conclusion Comments', qc.Q11_Comments__c, QCOldMap.get(qc.Id).Q11_Comments__c));
	        }
	        if(qc.SC__c != QCOldMap.get(qc.Id).SC__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Standard Conclusion Comments', qc.SC__c, QCOldMap.get(qc.Id).SC__c));
	        }
	        if(qc.Q13_Comments__c != QCOldMap.get(qc.Id).Q13_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Specification - Spoken Language Comments', qc.Q13_Comments__c, QCOldMap.get(qc.Id).Q13_Comments__c));
	        }
	        if(qc.CALA__c != QCOldMap.get(qc.Id).CALA__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Listening Ability', qc.CALA__c, QCOldMap.get(qc.Id).CALA__c));
	        }
	        if(qc.Q12_Comments__c != QCOldMap.get(qc.Id).Q12_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Listening Comments', qc.Q12_Comments__c, QCOldMap.get(qc.Id).Q12_Comments__c));
	        }
	        if(qc.CAI__c != QCOldMap.get(qc.Id).CAI__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Initiative', qc.CAI__c, QCOldMap.get(qc.Id).CAI__c));
	        }
	        if(qc.Q15_Comments__c != QCOldMap.get(qc.Id).Q15_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Initiative Comments', qc.Q15_Comments__c, QCOldMap.get(qc.Id).Q15_Comments__c));
	        }
	        if(qc.CARR__c != QCOldMap.get(qc.Id).CARR__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability - Rapid Response', qc.CARR__c, QCOldMap.get(qc.Id).CARR__c));
	        }
	        if(qc.Q14_Comments__c != QCOldMap.get(qc.Id).Q14_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Communicate Ability Response Comments', qc.Q14_Comments__c, QCOldMap.get(qc.Id).Q14_Comments__c));
	        }
	        if(qc.PFOCF__c != QCOldMap.get(qc.Id).PFOCF__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Focus On Customer Fee', qc.PFOCF__c, QCOldMap.get(qc.Id).PFOCF__c));
	        }
	        if(qc.Q16_Comments__c != QCOldMap.get(qc.Id).Q16_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Focus On Customer Comments', qc.Q16_Comments__c, QCOldMap.get(qc.Id).Q16_Comments__c));
	        }
	        if(qc.PPD__c != QCOldMap.get(qc.Id).PPD__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Patience Degree', qc.PPD__c, QCOldMap.get(qc.Id).PPD__c));
	        }
	        if(qc.Q17_Comments__c != QCOldMap.get(qc.Id).Q17_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Patience Degree Comments', qc.Q17_Comments__c, QCOldMap.get(qc.Id).Q17_Comments__c));
	        }
	        if(qc.PJ__c != QCOldMap.get(qc.Id).PJ__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - JinYongYu', qc.PJ__c, QCOldMap.get(qc.Id).PJ__c));
	        }
	        if(qc.Q18_Comments__c != QCOldMap.get(qc.Id).Q18_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - JinYongYu Comments', qc.Q18_Comments__c, QCOldMap.get(qc.Id).Q18_Comments__c));
	        }
	        if(qc.PHU__c != QCOldMap.get(qc.Id).PHU__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Hang Up', qc.PHU__c, QCOldMap.get(qc.Id).PHU__c));
	        }
	        if(qc.Q19_Comments__c != QCOldMap.get(qc.Id).Q19_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Perception - Hang Up Comments', qc.Q19_Comments__c, QCOldMap.get(qc.Id).Q19_Comments__c));
	        }
	        if(qc.Q0_Comments__c != QCOldMap.get(qc.Id).Q0_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Clarify&Confirm Customer Requir Comments', qc.Q0_Comments__c, QCOldMap.get(qc.Id).Q0_Comments__c));
	        }
	        if(qc.CCI_Comments__c != QCOldMap.get(qc.Id).CCI_Comments__c) {
	            QCHistorys.add(QCHelper.newQCHistory(qc.Id, 'Collect Customer Information Comments', qc.CCI_Comments__c, QCOldMap.get(qc.Id).CCI_Comments__c));
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
	    if(QCForShare!=null && !QCForShare.IsEmpty())
	    {
	        ShareQCtoCSR(QCForShare);
	    }
	    
	    // Update QC Approved of Survey Result
	    if(SurveyResultIds!=null && !SurveyResultIds.IsEmpty())
	    {
	        UpdateQCApproved(SurveyResultIds);
	    }
	    
	    // Insert QC History tracking records
	    if(QCHistorys!=null && !QCHistorys.IsEmpty()) {
	        UtilSobject.insertSobjects(QCHistorys);
	    }
	    
	    // Change the task status.
	    taskIds.remove(null);
	    if(taskIds!=null && !taskIds.IsEmpty())
	    {
	        changeTask(taskIds);
	    }
	    failtaskIds.remove(null);
	    if(failtaskIds!=null && !failtaskIds.IsEmpty())
	    {
	        changeFailTask(failtaskIds);
	    }
    }
}