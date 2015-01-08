/*
    Type:       Test class
    Purpose:    Test Class for QCMassCalibrationController
    User Story: CR-000142, CR-000143, CR-000144
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang created on 2013-12-06
*/
@isTest
private class QCMassCalibrationControllerTest{

    static testMethod void testMassCalibrate(){
        User user1 = UtilTestData.createUser('QTM', 'CAC QC SV/TQM');
        System.debug('-------user1-------:'+user1);
        System.runAs(user1){
            String[] calibrateRoles = new String[]{'IB TL', 'OB TL', 'SSI TL',
                                               'IB Supervisor', 'OB Supervisor', 'SSI Supervisor',
                                               'OM IB', 'OM OB', 
                                               'QC IB', 'QC OB', 'QC SSI', 'E-QC',
                                               'Training SSI', 'Training OB', 'Training IB',
                                               'QC Supervisor',
                                               'QTM',
                                               'CRM Manager - CAC & Data Mgt'};
            List<UserRole> urs = new List<UserRole>();
            
            for (Integer i =0; i<calibrateRoles.size(); i++) {
                UserRole ur = new UserRole();
                ur.Name = calibrateRoles[i];
                urs.add(ur);
            }
            insert urs;
            List<User> newUsers = new List<User>();
            Profile pro = [SELECT Id FROM Profile limit 1];
            for (UserRole ur : urs) {
                User usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.UserRoleId = ur.Id;
                usr.ProfileId = pro.Id;
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.Localesidkey='en_US';
                newUsers.add(usr);
            }
            insert newUsers;

            List<QC__c> qcs = new List<QC__c>();
            for (Integer i = 0; i < 5; i++) {
                QC__c qc = new QC__c();
                qc.Calibration__c = False;
                qcs.add(qc);
            }
            insert qcs;

            Test.startTest();

            ApexPages.currentPage().getParameters().put('objIds',qcs[0].Id);

            QCMassCalibrationController qcc = new QCMassCalibrationController();
            System.debug('容量为：' + qcc.arrObjIds.size());
            List<QCMassCalibrationController.QCUsersWrapper> users = qcc.getqcUsers();
            
            PageReference pr0 = qcc.massCalibrate();
            qcc.qcUsersList[0].selected = true;
            PageReference pr1 = qcc.massCalibrate();

            QCMassCalibrationController qcc1 = new QCMassCalibrationController();
            PageReference pr2 = qcc1.massCalibrate();

            Test.stopTest();
        }
    }

    static testMethod void testSendMassMail(){
            
            List<User> usrs = [SELECT Id, Email FROM User LIMIT 1];
            usrs[0].Email = 'patrick.zhang@qq.com';
            List<QC__c> qcs = new List<QC__c>();
            QC__c qc = new QC__c();
            qc.Calibration__c = False;
            System.debug('是：' + usrs[0].Id);
            qc.OwnerId = usrs[0].Id;
            
            qcs.add(qc);
            insert qcs;
            
            Test.startTest();
            QCMassCalibrationController qcc = new QCMassCalibrationController();
            qcs = [SELECT Owner.Email FROM QC__c WHERE Id IN :qcs];
            System.debug('Id是：' + qcs[0].Owner.Id);
            System.debug('信息是：' + qcs[0].Owner.LastName + ',' + qcs[0].Owner.Alias + ',' + qcs[0].Owner.Email);
            
            try{
                qcc.sendMassEmail(usrs, qcs);
            }catch(Exception e){
                System.debug('Error Message: ' + e);
            }
            

            Test.stopTest();

    }
}