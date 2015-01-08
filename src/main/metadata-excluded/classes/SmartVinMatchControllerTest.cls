/*
    Type:       Test class
    Purpose:    Test Class for smart Vin Match process
    User Story: US-SMART_SSI-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Shuang Li created on 2014-03-18
*/
@isTest
private class SmartVinMatchControllerTest{
    static testMethod void testVinMatch(){

        User user1 = UtilTestData.createUser('Sinotrust', 'BMBS Sinotrust User');

        System.debug('-------user1-------:'+user1);

        // Prepare test data
        // Account data
        System.runAs(user1){
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 24; i++) {
            Account acct = new Account();
            acct.LastName = 'zhang';
            acct.FirstName = 'patrick' + i; 
            if (i < 10) {
                acct.PersonMobilePhone = '1865842503' + i ;
            }else{
                acct.PersonMobilePhone = '186584250' + i ;
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
        List<smart_SSI__c> ssis = new List<smart_SSI__c>();
        for (Integer i = 0; i < 15; i++) {
            smart_SSI__c validSSI = new smart_SSI__c();
            validSSI.CustomerName__c = accts[i].Full_Name__c;
            validSSI.Status__c = 'All Valid';
            if (i <= 11) {
                validSSI.InvoiceDate__c = Date.newInstance(2013, (i+1), 1);
            }else{
                validSSI.InvoiceDate__c = Date.newInstance(2013, (i-11), 1);
            }
            validSSI.VehicleUSvin__c = ves[i].UsVIN__c;
            validSSI.HomeMobilePhone__c = accts[i].PersonMobilePhone;
            //走有效SSI的小分支
            if (i == 14) {
                validSSI.HomeMobilePhone__c = '13777778888';
            }
            ssis.add(validSSI);
        }
        for (Integer i = 0; i < 5; i++) {
            smart_SSI__c invalidSSI = new smart_SSI__c();
            invalidSSI.CustomerName__c = accts[i].Full_Name__c;
            invalidSSI.Status__c = 'All Valid';
            invalidSSI.InvoiceDate__c = Date.newInstance(2013, (i+5), 1);
            invalidSSI.VehicleUSvin__c = ves[i+15].UsVIN__c;
            //走无效SSI的分支
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


        Test.startTest();

        SmartVinMatchController con = new SmartVinMatchController();
        PageReference pr = con.vinMatch();

        SmartVinMatchController con2 = new SmartVinMatchController();
        // SSI__c ssi1 = new SSI__c();
        // ssi1.InvoiceDate__c = Date.newInstance(2013, 7, 15);
        Task task1 = new Task();
        task1.Activity_Date__c = Date.newInstance(2013, 7, 15);
        con2.fromTask = task1;
        PageReference pr2 = con2.vinMatch();

        SmartVinMatchController con3 = new SmartVinMatchController();
        // SSI__c ssi2 = new SSI__c();
        // ssi2.InvoiceDate__c = Date.newInstance(2013, 7, 15);
        Task task2 = new Task();
        task2.Activity_Date__c = Date.newInstance(2013, 7, 15);
        con3.toTask = task2;
        PageReference pr3 = con3.vinMatch();

        SmartVinMatchController con4 = new SmartVinMatchController();
        // SSI__c ssi3 = new SSI__c();
        // ssi3.InvoiceDate__c = Date.newInstance(2013, 11, 15);
        // SSI__c ssi4 = new SSI__c();
        // ssi4.InvoiceDate__c = Date.newInstance(2013, 3, 15);
        Task task3 = new Task();
        task3.Activity_Date__c = Date.newInstance(2013, 11, 15);
        Task task4 = new Task();
        task4.Activity_Date__c = Date.newInstance(2013, 3, 15);
        con4.fromTask = task4;
        con4.toTask = task3;
        PageReference pr4 = con4.vinMatch();

        SmartVinMatchController con5 = new SmartVinMatchController();
        Task task5 = new Task();
        task5.Activity_Date__c = Date.newInstance(2013, 7, 5);
        Task task6 = new Task();
        task6.Activity_Date__c = Date.newInstance(2013, 9, 5);
        con5.fromTask = task6;
        con5.toTask = task5;
        PageReference pr5 = con5.vinMatch();
        System.assertEquals(null, pr5);

        Test.stopTest();
    }
    }
}