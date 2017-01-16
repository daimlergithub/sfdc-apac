/*
    Type:       Test class
    Purpose:    Test Class for TrackingQCHistory, ShareQCtoCSR, CalculateTotalScore
    User Story: US-QC-011, US-QC-012, US-QC-005 US-QC-021
    Used By:  History:
    1. 12-April-2013 Sinow Zhang (NTTData)  Created
*/
@isTest
public with sharing class QCHelperTest {
    
    //Variables
       public static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
       public static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
       public static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
       public static string Complete = 'Complete'; 
       public static string Pass = 'Pass';
       public static string acem = 'acem';
       public static string High = 'High';
       public static string Fail = 'Fail';
       public static string Medium = 'Medium';
       public static string Low = 'Low';
       public static string en_US = 'en_US';
       public static Profile IBProfile = [select Id from Profile where Name = 'CAC IB CSR'];
       public static Profile OBProfile = [select Id from Profile where Name = 'CAC OB CSR'];
       public static Profile SSIProfile = [select Id from Profile where Name = 'CAC SSI CSR'];
      
       public static User IBCSRUser ;     
       public static User OBCSRUser ;
       public static User SSICSRUser ;
       public static QC__c qc;
    
    @isTest
    public static void testQC1() {
        //Gets qc record type ids
        
        createTestData();
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        createQC(IBQCRecordTypeId,IBCSRUser.Id);
        Test.startTest();
         
        qc = [select Id, Status__c, PACI__c, Q1_Comments__c, DA__c, Q2_Comments__c, FTOP__c, Q3_Comments__c, FQL__c, Q4_Comments__c, CITQ__c, Q5_Comments__c, FMSK__c, Q6_Comments__c, Responsibility__c, Q7_Comments__c, SO__c, Q8_Comments__c, PPIS__c, Q9_Comments__c, SPL__c, Q10_Comments__c, SSL__c, Q11_Comments__c, SC__c, Q13_Comments__c, CALA__c, Q12_Comments__c, CAI__c, Q15_Comments__c, CARR__c, Q14_Comments__c, PFOCF__c, Q16_Comments__c, PPD__c, Q17_Comments__c, PJ__c, Q18_Comments__c, PHU__c, Q19_Comments__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = Pass;
        qc.CCI__c = Pass;
        qc.PACI__c = Pass;
        qc.DA__c = Pass;
        qc.FTOP__c = Pass;
        qc.FMSK__c = Pass;
        qc.Responsibility__c = Pass;
        qc.SO__c = Pass;
        qc.PPIS__c = Pass;
        qc.SPL__c = Pass;
        qc.SSL__c = Pass;
        qc.SC__c = Pass;
        qc.CALA__c = Pass;
        qc.CAI__c = Pass;
        qc.CARR__c = Pass;
        qc.PFOCF__c = Pass;
        qc.PPD__c = Pass;
        qc.PJ__c = Pass;
        qc.PS__c = Pass;
        qc.FQL__c = Pass;
        qc.CITQ__c = Pass;
        qc.PHU__c = Pass;
        qc.Q1_Comments__c = acem;
        qc.Q2_Comments__c = acem;
        qc.Q3_Comments__c = acem;
        qc.Q4_Comments__c = acem;
        qc.Q5_Comments__c = acem;
        qc.Q6_Comments__c = acem;
        qc.Q7_Comments__c = acem;
        qc.Q8_Comments__c = acem;
        qc.Q9_Comments__c = acem;
        qc.Q10_Comments__c = acem;
        qc.Q11_Comments__c = acem;
        qc.Q12_Comments__c = acem;
        qc.Q13_Comments__c = acem;
        qc.Q14_Comments__c = acem;
        qc.Q15_Comments__c = acem;
        qc.Q16_Comments__c = acem;
        qc.Q17_Comments__c = acem;
        qc.Q18_Comments__c = acem;
        qc.Q19_Comments__c = acem;
        update qc;
        Decimal IbTotalScore = QCHelper.IBCallTotalScore(qc);
        
        system.assertNotEquals(null, IbTotalScore);
        
        system.debug([select Total_Score__c from QC__c where Id = :qc.Id].Total_Score__c == 100.00); 
    
        createQC(OBQCRecordTypeId,OBCSRUser.Id);
        
        qc = [select Id, Status__c, PACI__c, DA__c, FTOP__c, FQL__c, CITQ__c, FMSK__c, Responsibility__c, SO__c, PPIS__c, SPL__c, SSL__c, SC__c, CALA__c, CAI__c, CARR__c, PFOCF__c, PPD__c, PJ__c, PHU__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = Pass;
        qc.CCI__c = Pass;
        qc.PACI__c = Pass;
        qc.DA__c = Pass;
        qc.FTOP__c = Pass;
        qc.FMSK__c = Pass;
        qc.Responsibility__c = Pass;
        qc.SO__c = Pass;
        qc.PPIS__c = Pass;
        qc.SPL__c = Pass;
        qc.SSL__c = Pass;
        qc.SC__c = Pass;
        qc.CALA__c = Pass;
        qc.CAI__c = Pass;
        qc.CARR__c = Pass;
        qc.PFOCF__c = Pass;
        qc.PPD__c = Pass;
        qc.PJ__c = Pass;
        qc.PS__c = Pass;
        qc.FQL__c = Pass;
        qc.CITQ__c = Pass;
        qc.PHU__c = Pass;
        update qc;
       QCHelper.OBCallTotalScore(qc);
        SSI__c ssi = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'       
        );        
        insert ssi ;
        createQC(SSIQCRecordTypeId,SSICSRUser.Id);
        qc.SSI__c = ssi.id;
        update qc;
        
        
        qc = [select Id, Status__c, PACI__c, DA__c, FTOP__c, FQL__c, CITQ__c, FMSK__c, Responsibility__c, SO__c, PPIS__c, SPL__c, SSL__c, SC__c, CALA__c, CAI__c, CARR__c, PFOCF__c, PPD__c, PJ__c, PHU__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = High;
        qc.CCI__c = High;
        qc.PACI__c = High;
        qc.DA__c = High;
        qc.FTOP__c = High;
        qc.FMSK__c = High;
        qc.Responsibility__c = High;
        qc.SO__c = High;
        qc.PPIS__c = High;
        qc.SPL__c = High;
        qc.SSL__c = High;
        qc.SC__c = High;
        qc.CALA__c = High;
        qc.CAI__c = High;
        qc.CARR__c = High;
        qc.PFOCF__c = High;
        qc.PPD__c = High;
        qc.PJ__c = High;
        qc.PS__c = High;
        qc.FQL__c = High;
        qc.CITQ__c = High;
        qc.PHU__c = High;
        update qc;
       
        qc.Approved__c = 'Yes';
        update qc;
        QCHelper.SSIPassedQuestions2(qc);
        QCHelper.newQCHistory(qc.id,'label','newValue','oldValue');
        List<QC__c> QcList = new List<QC__c>(); 
              qc.RecordTypeId = SSIQCRecordTypeId;
        QcList.add(qc);
        QCHelper.ShareQCtoCSR(QcList);   
              Map<Id,QC__c> QcMap = new Map<Id,QC__c>();
        QcMap.put(qc.Id, qc);
        QCHelper.beforeInsertUpdateEvents(QcList, QcMap, true, true);
        Test.stopTest();
    }
   
    @isTest
    public static void testQC2() {
        //Gets qc record type ids
        createTestData();
        createQC(IBQCRecordTypeId,IBCSRUser.Id);
        Test.startTest();
        qc = [select Id, Status__c, PACI__c, Q1_Comments__c, DA__c, Q2_Comments__c, FTOP__c, Q3_Comments__c, FQL__c, Q4_Comments__c, CITQ__c, Q5_Comments__c, FMSK__c, Q6_Comments__c, Responsibility__c, Q7_Comments__c, SO__c, Q8_Comments__c, PPIS__c, Q9_Comments__c, SPL__c, Q10_Comments__c, SSL__c, Q11_Comments__c, SC__c, Q13_Comments__c, CALA__c, Q12_Comments__c, CAI__c, Q15_Comments__c, CARR__c, Q14_Comments__c, PFOCF__c, Q16_Comments__c, PPD__c, Q17_Comments__c, PJ__c, Q18_Comments__c, PHU__c, Q19_Comments__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = Fail;
        qc.CCI__c = Fail;
        qc.PACI__c = Fail;
        qc.DA__c = Fail;
        qc.FTOP__c = Fail;
        qc.FMSK__c = Fail;
        qc.Responsibility__c = Fail;
        qc.SO__c = Fail;
        qc.PPIS__c = Fail;
        qc.SPL__c = Fail;
        qc.SSL__c = Fail;
        qc.SC__c = Fail;
        qc.CALA__c = Fail;
        qc.CAI__c = Fail;
        qc.CARR__c = Fail;
        qc.PFOCF__c = Fail;
        qc.PPD__c = Fail;
        qc.PJ__c = Fail;
        qc.PS__c = Fail;
        qc.FQL__c = Fail;
        qc.CITQ__c = Fail;
        qc.PHU__c = Fail;
        qc.Q1_Comments__c = acem;
        qc.Q2_Comments__c = acem;
        qc.Q3_Comments__c = acem;
        qc.Q4_Comments__c = acem;
        qc.Q5_Comments__c = acem;
        qc.Q6_Comments__c = acem;
        qc.Q7_Comments__c = acem;
        qc.Q8_Comments__c = acem;
        qc.Q9_Comments__c = acem;
        qc.Q10_Comments__c = acem;
        qc.Q11_Comments__c = acem;
        qc.Q12_Comments__c = acem;
        qc.Q13_Comments__c = acem;
        qc.Q14_Comments__c = acem;
        qc.Q15_Comments__c = acem;
        qc.Q16_Comments__c = acem;
        qc.Q17_Comments__c = acem;
        qc.Q18_Comments__c = acem;
        qc.Q19_Comments__c = acem;
        update qc;
          QCHelper.IBCallTotalScore(qc);
        
              
        
        system.debug([select Total_Score__c from QC__c where Id = :qc.Id].Total_Score__c == 100.00); 
        SSI__c ssi = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'       
        );        
        insert ssi ;
        
        createQC(OBQCRecordTypeId,OBCSRUser.Id);
        qc.SSI__c = ssi.id;
        update qc;
        
        qc = [select Id, Status__c, PACI__c, DA__c, FTOP__c, FQL__c, CITQ__c, FMSK__c, Responsibility__c, SO__c, PPIS__c, SPL__c, SSL__c, SC__c, CALA__c, CAI__c, CARR__c, PFOCF__c, PPD__c, PJ__c, PHU__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = Fail;
        qc.CCI__c = Fail;
        qc.PACI__c = Fail;
        qc.DA__c = Fail;
        qc.FTOP__c = Fail;
        qc.FMSK__c = Fail;
        qc.Responsibility__c = Fail;
        qc.SO__c = Fail;
        qc.PPIS__c = Fail;
        qc.SPL__c = Fail;
        qc.SSL__c = Fail;
        qc.SC__c = Fail;
        qc.CALA__c = Fail;
        qc.CAI__c = Fail;
        qc.CARR__c = Fail;
        qc.PFOCF__c = Fail;
        qc.PPD__c = Fail;
        qc.PJ__c = Fail;
        qc.PS__c = Fail;
        qc.FQL__c = Fail;
        qc.CITQ__c = Fail;
        qc.PHU__c = Fail;
        update qc;
        QCHelper.OBCallTotalScore(qc);
        SSI__c ssi2 = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'       
        );        
        insert ssi2 ;
        
        createQC(SSIQCRecordTypeId,SSICSRUser.Id);
        qc.SSI__c = ssi2.id;
        update qc;
        
        qc = [select Id, Status__c, PACI__c, DA__c, FTOP__c, FQL__c, CITQ__c, FMSK__c, Responsibility__c, SO__c, PPIS__c, SPL__c, SSL__c, SC__c, CALA__c, CAI__c, CARR__c, PFOCF__c, PPD__c, PJ__c, PHU__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.CCCR__c = High;
        qc.CCI__c = High;
        qc.PACI__c = High;
        qc.DA__c = High;
        qc.FTOP__c = High;
        qc.FMSK__c = High;
        qc.Responsibility__c = High;
        qc.SO__c = High;
        qc.PPIS__c = High;
        qc.SPL__c = High;
        qc.SSL__c = High;
        qc.SC__c = High;
        qc.CALA__c = High;
        qc.CAI__c = High;
        qc.CARR__c = High;
        qc.PFOCF__c = High;
        qc.PPD__c = High;
        qc.PJ__c = High;
        qc.PS__c = High;
        qc.FQL__c = High;
        qc.CITQ__c = High;
        qc.PHU__c = High;
        update qc;
       Decimal passedQuestions = QCHelper.SSIPassedQuestions(qc);
             QCHelper.SetQualified(qc);

        qc.Approved__c = 'Yes';
        update qc;
        Test.stopTest();
        system.assertNotEquals(null, passedQuestions);
    }
    
     @isTest
    public static void testQC3() {
        //Gets qc record type ids
        createTestData();
        createQC(IBQCRecordTypeId,IBCSRUser.Id);
        
        
        qc = [select Id, Status__c, PACI__c, Q1_Comments__c, DA__c, Q2_Comments__c, FTOP__c, Q3_Comments__c, FQL__c, Q4_Comments__c, CITQ__c, Q5_Comments__c, FMSK__c, Q6_Comments__c, Responsibility__c, Q7_Comments__c, SO__c, Q8_Comments__c, PPIS__c, Q9_Comments__c, SPL__c, Q10_Comments__c, SSL__c, Q11_Comments__c, SC__c, Q13_Comments__c, CALA__c, Q12_Comments__c, CAI__c, Q15_Comments__c, CARR__c, Q14_Comments__c, PFOCF__c, Q16_Comments__c, PPD__c, Q17_Comments__c, PJ__c, Q18_Comments__c, PHU__c, Q19_Comments__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.DA__c=Medium;
        qc.FTOP__c =Medium;
        qc.FQL__c = Medium;
        qc.PFOCF__c = Medium;
        qc.PPD__c =Medium;
        qc.PACI__c=Medium;
        qc.CARR__c=Medium;
        qc.PS__c=Medium;
        Test.startTest();
        update qc;
        QCHelper.SSITotalScore1(qc);
        QCHelper.SetQualified(qc);
        Decimal tests = QCHelper.SSITotalScore1(qc);
        Test.stopTest();
        system.assertNotEquals(null, tests);
        
        }
    
        
         @isTest
    public static void testQC4() {
        //Gets qc record type ids
        createTestData();
        createQC(IBQCRecordTypeId,IBCSRUser.Id);
        
        
        qc = [select Id, Status__c, PACI__c, Q1_Comments__c, DA__c, Q2_Comments__c, FTOP__c, Q3_Comments__c, FQL__c, Q4_Comments__c, CITQ__c, Q5_Comments__c, FMSK__c, Q6_Comments__c, Responsibility__c, Q7_Comments__c, SO__c, Q8_Comments__c, PPIS__c, Q9_Comments__c, SPL__c, Q10_Comments__c, SSL__c, Q11_Comments__c, SC__c, Q13_Comments__c, CALA__c, Q12_Comments__c, CAI__c, Q15_Comments__c, CARR__c, Q14_Comments__c, PFOCF__c, Q16_Comments__c, PPD__c, Q17_Comments__c, PJ__c, Q18_Comments__c, PHU__c, Q19_Comments__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.DA__c=Low;
        qc.CITQ__c = Low;
       qc.FMSK__c = Low;
        qc.FQL__c = Low;
        qc.SO__c = Low;
        qc.PPIS__c = Low;
        qc.SPL__c = Low;
        qc.SC__c = Low;
        qc.CALA__c = Low;
        qc.CAI__c = Low;
        qc.PFOCF__c = Low;
        qc.PPD__c = Low;
        qc.PJ__c = Low;
        qc.PHU__c = Low;
        Test.startTest();
        update qc;
        
        Decimal tests = QCHelper.SSITotalScore1(qc);
        system.assertNotEquals(null, tests);
        Test.stopTest();
        
        }
         @isTest
    public static void testQC5() {
        //Gets qc record type ids
        createTestData();
        createQC(IBQCRecordTypeId,IBCSRUser.Id);
        
        qc = [select Id, Status__c, PACI__c, Q1_Comments__c, DA__c, Q2_Comments__c, FTOP__c, Q3_Comments__c, FQL__c, Q4_Comments__c, CITQ__c, Q5_Comments__c, FMSK__c, Q6_Comments__c, Responsibility__c, Q7_Comments__c, SO__c, Q8_Comments__c, PPIS__c, Q9_Comments__c, SPL__c, Q10_Comments__c, SSL__c, Q11_Comments__c, SC__c, Q13_Comments__c, CALA__c, Q12_Comments__c, CAI__c, Q15_Comments__c, CARR__c, Q14_Comments__c, PFOCF__c, Q16_Comments__c, PPD__c, Q17_Comments__c, PJ__c, Q18_Comments__c, PHU__c, Q19_Comments__c from QC__c where Id = :qc.Id];
        qc.Status__c = Complete;
        qc.DA__c=Low;
        qc.CITQ__c = Low;
       qc.FMSK__c = Low;
       qc.FTOP__c = Low;
        qc.FQL__c = Low;
        qc.SO__c = Low;
        qc.PPIS__c = Low;
        qc.SPL__c = Low;
        qc.SSL__c = Low;
        qc.SC__c = Low;
        qc.CALA__c = Low;
        qc.CAI__c = Low;
        qc.PFOCF__c = Low;
        qc.PPD__c = Low;
        qc.PJ__c = Low;
        qc.PHU__c = Low;
        qc.PACI__c=Low;
        qc.CARR__c=Low;
        qc.PS__c=Low;
        Test.startTest();
        update qc;
         Decimal tests = QCHelper.SSITotalScore2(qc);
        Set<String> taskIds=new set<String>();
        QCHelper.changeTask(taskIds);
        QCHelper.changeFailTask(taskIds);
        Test.stopTest();
        system.assertNotEquals(null, tests);
        
        }
    static void createTestData()
    {
        
         IBCSRUser = new User(ProfileId = IBProfile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US);
         OBCSRUser = new User(ProfileId = OBProfile.Id, isActive = true, Username = 'lai2@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney2',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US);
         SSICSRUser = new User(ProfileId = SSIProfile.Id, isActive = true, Username = 'lai3@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney3',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US);
        
        insert IBCSRUser; 
        insert OBCSRUser;
        insert SSICSRUser;
        
    }
    
    static void createQC(String recType,id csrUsrId)
    {
        qc = new QC__c(CSR_Name__c = csrUsrId, Status__c = 'Open', recordTypeId = recType);
        insert qc;
        
        
    }
}