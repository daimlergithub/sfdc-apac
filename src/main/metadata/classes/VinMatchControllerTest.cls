/*
    Type:       Test class
    Purpose:    Test Class for Vin Match process
    User Story: CR-000099
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang created on 2013-12-04
    2. Patrick Zhang add new Test Scenario on 2013-12-11
*/
@isTest
private class VinMatchControllerTest{

private static String ssiPrefix = Schema.getGlobalDescribe().get('SSI__c').getDescribe().getKeyPrefix();
   
         static testMethod void testVinMatch_TaskStart_and_Enddate_Elsecondition()
      {
        Test.startTest();
        prepareTestData();
        VinMatchController con5 = new VinMatchController();
        Task task5 = new Task();
        task5.Activity_Date__c = Date.newInstance(2013, 7, 5);
        Task task6 = new Task();
        task6.Activity_Date__c = Date.newInstance(2013, 9, 5);
        con5.fromTask = task6;
        con5.toTask = task5;
        PageReference pr5 = con5.vinMatch();
        Test.stopTest();
        System.assertEquals(null, pr5);

        }
        
      static testMethod void testdealerClean_NoTasksSpecified()
      {
         Test.startTest();
        prepareTestData();
        VinMatchController con = new VinMatchController();
        PageReference pr = con.dealerClean();
        Test.stopTest();
        System.assertEquals(null, pr);
      }
     
     static testMethod void testdealerClean_TaskStart_and_Enddate_Status()
      {
          prepareTestData();
        Test.startTest();
        VinMatchController con4 = new VinMatchController();
        SSI_Cleansing_Result__c ssi3=new SSI_Cleansing_Result__c();
        ssi3.SSI_Created_Date__c= Date.newInstance(2013, 11, 15);
        SSI_Cleansing_Result__c ssi4=new SSI_Cleansing_Result__c();
        ssi4.SSI_Created_Date__c = Date.newInstance(2013, 3, 15);
        con4.fromSSI = ssi4;
        con4.toSSI= ssi3;
        PageReference pr4 = con4.dealerClean();
        Test.stopTest();
        System.assertNotEquals(null,pr4);
        System.assertEquals('/'+ssiPrefix ,pr4.getUrl());   
       } 
       
        static testMethod void testdealerClean_TaskStart_and_Enddate()
      {
          prepareTestData();
        Test.startTest();
        VinMatchController con5 = new VinMatchController();
        SSI_Cleansing_Result__c ssi5=new SSI_Cleansing_Result__c();
        ssi5.SSI_Created_Date__c  = Date.newInstance(2013, 7, 5);
        SSI_Cleansing_Result__c ssi6=new SSI_Cleansing_Result__c();
        ssi6.SSI_Created_Date__c = Date.newInstance(2013, 9, 5);
        con5.fromSSI = ssi6;
        con5.toSSI = ssi5;
        PageReference pr5 = con5.dealerClean();
        Test.stopTest();
        System.assertEquals(null, pr5); 
       }
        
      static void prepareTestData()
      {
          List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;
          Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Account.getRecordTypeInfosByName();
          Id dlrrtid = rtMap.get('Person Account').getRecordTypeId();
       List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 24; i++) {
            Account acct = new Account();
            acct.LastName= 'zhang';
            acct.FirstName = 'patrick' + i; 
            acct.RecordtypeId = dlrrtid;
            if (i < 10) {
                acct.Phone = '186584250' + i ;
            }else{
                acct.Phone = '186584250' + i ;
            }
            accts.add(acct);
        }
        insert accts;
        //Vehicle data
        List<Vehicle__c> ves = new List<Vehicle__c>();
        for (Integer i = 0; i < 20 ; i++) {
            Vehicle__c ve = new Vehicle__c();
            if (i < 10) {
                ve.UsVIN__c = 'WDCCB5EE9CA00000' + i;
            }else{
                ve.UsVIN__c = 'WDCCB5EE9CA0000' + i;
            }
            ves.add(ve);
        }
        insert ves;
        // Vehicle Relationship data
        List<Vehicle_Relationship__c> vrs = new List<Vehicle_Relationship__c>();
        for (Integer i = 0; i < 20; i++ ) {
            Vehicle_Relationship__c vr = new Vehicle_Relationship__c();
            vr.Contact__c = accts[i].Id;
            vr.Vehicle_ID__c = ves[i].Id;
            vrs.add(vr);
        }
        insert vrs;
        // SSI data
        List<SSI__c> ssis = new List<SSI__c>();
        for (Integer i = 0; i < 15; i++) {
            SSI__c validSSI = new SSI__c();
            validSSI.CustomerName__c = accts[i].Full_Name__c;
            validSSI.Status__c = 'All Valid';
            if (i <= 11) {
                validSSI.InvoiceDate__c = Date.newInstance(2013, (i+1), 1);
            }else{
                validSSI.InvoiceDate__c = Date.newInstance(2013, (i-11), 1);
            }
            validSSI.VehicleUSvin__c = ves[i].UsVIN__c;
            validSSI.HomeMobilePhone__c = accts[i].PersonMobilePhone;
            //Effective small branch of SSI
            if (i == 14) {
                validSSI.HomeMobilePhone__c = '13777778888';
            }
            ssis.add(validSSI);
        }
        for (Integer i = 0; i < 5; i++) {
            SSI__c invalidSSI = new SSI__c();
            invalidSSI.CustomerName__c = accts[i].Full_Name__c;
            invalidSSI.Status__c = 'All Valid';
            invalidSSI.InvoiceDate__c = Date.newInstance(2013, (i+5), 1);
            invalidSSI.VehicleUSvin__c = ves[i+15].UsVIN__c;
            //Invalid SSI branch
            if (i == 4) {
                invalidSSI.VehicleUSvin__c = 'WDCCB5EE9CA000333';
            }
            ssis.add(invalidSSI);
        }
        insert ssis;
        // SSISV Profile data
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'CAC SSI SV' LIMIT 1];
        List<User> svs = new List<User>();
        User sv = new User();
        sv.ProfileId = pro.Id;
        sv.UserName = 'PatrickTest@ibreakingpoint.com';
        sv.LastName = 'Test User';
        sv.Email = 'test001@daimler.com.full';
        sv.Alias = 'test';
        sv.TimeZoneSidKey = 'Asia/Shanghai';
        sv.EmailEncodingKey = 'UTF-8';
        sv.LanguageLocaleKey = 'en_US';
        sv.localesidkey='en_US';
        svs.add(sv);
        insert svs;
      }
}