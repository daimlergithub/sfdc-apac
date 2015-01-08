/*
    Type:       Extension for QC standard page  "Mass Calibration" Button - QCMassCalibration page
    Purpose:    Generate Calibrated QCs for each user you selected based on the QCs you've chosen.
    User Story: 
    CR: CR-000142, CR-000143, CR-000144
    Used By:    QcMassCalibration.page
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang created on 2013-10-31
    2. Patrick Zhang modified on 2013-12-06
        Change Profile to Role

*/
public class QCMassCalibrationController{

    public String[] arrObjIds;
    public List<QCUsersWrapper> qcUsersList = new List<QCUsersWrapper>();
    //页面选择的QC CSR
    List<User> selectedUsers = new List<User>();
    //
    String host = ApexPages.currentPage().getHeaders().get('Host');

    public QCMassCalibrationController(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        if (params != null && params.size() > 0) {
            String strObjIds = params.get('objIds');
            arrObjIds = strObjIds.split(',');   
        }
    }

    public List<QCUsersWrapper> getqcUsers(){
        // Profile的选取到底有几个，待定
        // String[] qcProfiles = new String[]{'CAC SSI QC', 'CAC SSI Trainer', 'CAC IB QC', 'CAC OB QC'};
        // String[] calibrateRoles = new String[]{'IB_TL', 'OB_TL', 'SSI_TL',
        //                                        'IB_Supervisor', 'OB_Supervisor', 'SSI_Supervisor',
        //                                        'OB_IB', 'OM_OB', 
        //                                        'QC_IB', 'QC_OB', 'QC_SSI', 'E_QC',
        //                                        'Training_SSI', 'Training_OB', 'Training_IB',
        //                                        'QC_Supervisor',
        //                                        'QTM',
        //                                        'CRM_Manager_CAC_Data'};
        String[] calibrateRoles = new String[]{'IB TL', 'OB TL', 'SSI TL',
                                               'IB Supervisor', 'OB Supervisor', 'SSI Supervisor',
                                               'OM IB', 'OM OB', 
                                               'QC IB', 'QC OB', 'QC SSI', 'E-QC',
                                               'Training SSI', 'Training OB', 'Training IB',
                                               'QC Supervisor',
                                               'QTM',
                                               'CRM Manager - CAC & Data Mgt'};
        List<UserRole> roleIds = [SELECT Id 
                                  FROM UserRole  
                                  WHERE Name IN :calibrateRoles];
        // List<Profile> qcIds = [
        //     SELECT Id 
        //     FROM Profile 
        //     WHERE Name IN :qcProfiles];
        // List<User> qcUsers = [
        //     SELECT Id, Name, Email, UserRole.Name
        //     FROM User
        //     WHERE ProfileId in :qcIds AND IsActive = true];
        List<User> qcUsers = [SELECT Id, Name, Email, UserRole.Name
                              FROM User
                              WHERE UserRoleId in :roleIds AND IsActive = true];

        List<AggregateResult> amounts = [
            SELECT ownerid, COUNT(id) num
            FROM QC__c
            WHERE ownerid IN :qcUsers
            GROUP BY ownerid];

        for (User qc : qcUsers) {
            // Amount of QC tasks for each QC CSR
            Integer amount;
            for (AggregateResult amo : amounts) {
                if (amo.get('ownerid') == qc.Id) {
                    amount = (Integer)amo.get('num');
                    break;
                }
            }
            
            qcUsersList.add(new QCUsersWrapper(qc, amount));
        }

        return qcUsersList;
    }

    public class QCUsersWrapper{
        public User qc{get; set;}
        public Boolean selected{get; set;}
        public Integer amount{get; set;}
        public QCUsersWrapper(User a, Integer amount){
            qc = a;
            selected = false;
            this.amount = amount;
        }
    }

    public PageReference massCalibrate(){

        String qcPrefix = Schema.getGlobalDescribe().get('QC__c').getDescribe().getKeyPrefix();
        //New Calibration QC list
        List<QC__c> newQCs = new List<QC__c>();
        QC__c newQC;
        // Selected users list
        for (QCUsersWrapper userwrapper : qcUsersList) {
            if (userwrapper.selected == true) {
                selectedUsers.add(userwrapper.qc);
            }
        }

        if (arrObjIds.size() > 0 && selectedUsers.size() > 0) {
            //QC selected list
            List<QC__c> qcs = [
                SELECT Id, SSI__c, Survey_Result__c, RecordTypeId
                FROM QC__c
                WHERE Id IN :arrObjIds];
            //Generate a Calibration QC for each selected QC on every selected user
            for (QC__c qc : qcs) {
                for (User u: selectedUsers) {
                    newQC = new QC__c();
                    newQC.OwnerId = u.Id;
                    newQC.Calibration__c = True;
                    newQC.SSI__c = qc.SSI__c;
                    newQC.Survey_Result__c = qc.Survey_Result__c;
                    newQC.RecordTypeId = qc.RecordTypeId;
                    newQCs.add(newQC);
                }
            }

            // Generate mass calibration
            try{
                insert(newQCs);
                newQCs = [Select Owner.Email From QC__c Where Id In : newQCs];
                sendMassEmail(selectedUsers, newQCs);
                PageReference forward = new PageReference('/' + qcPrefix);
                forward.setRedirect(true);
                return forward;
            }catch(DMLException e){
                System.debug('DMLException Exception: ' + e);
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.QC_Mass_Calibration_Error_Message));
        }
        return null;
    }

    @TestVisible
    private void sendMassEmail(List<User> selectedUsers, List<QC__c> newQCs){
        if (selectedUsers != null && selectedUsers.size() > 0) {

            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

            // for (User u : selectedUsers) {
                for (QC__c qc : newQCs) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{qc.Owner.Email};
                    // System.debug('邮件开始了。');
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('New Calibration QC');
                    mail.setPlainTextBody('You have been assigned a Calibration QC. \nClick here:https://' + host + '/' + qc.Id);
                    mails.add(mail);
                    // System.debug('邮件结束了');
                }
            // }

            if (mails.size() > 0) {
            	try {
                	Messaging.sendEmail(mails);
                }
        		catch(Exception ex) {
            		system.debug('Send Mass Email Exception : sendMassEmail :' + ex.getMessage());
        		}
            }
            
        }
    }
}