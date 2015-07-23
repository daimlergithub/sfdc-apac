/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MassAssignRecallTasksTest {

    static testMethod void myUnitTest() {
        
        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id SSIRTID = rtMap.get('SSI Task').getRecordTypeId();
        Id OBTRTID = rtMap.get('OB Task').getRecordTypeId();
        
        List<User> newUsers = new List<User>();
        User user1  = new User();
        User user2 = new User();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        
            String[] csrProfiles = new String[]{
                    'CAC IB CSR', 'CAC IB TL', 'CAC IB SV', 'CAC IB QC', 'CAC IB Trainer',
                    'CAC OB CSR', 'CAC OB TL', 'CAC OB SV', 'CAC OB QC', 'CAC OB Trainer',
                    'CAC SSI CSR', 'CAC SSI TL', 'CAC SSI SV', 'CAC SSI QC', 'CAC SSI Trainer'
            };
            List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name In :csrProfiles];
            
            for(Profile p : profileIds){
                User usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                newUsers.add(usr);
            }
            
            insert newUsers;
            
            user1 = UtilTestData.createUser('SSI TL','CAC SSI TL');
            user2 = UtilTestData.createUser('OB TL','CAC OB TL');

        }
         
        Campaign pg = new Campaign(Name='Test');
        insert pg;
        
        Account acc = new Account(            
            LastName = 'Test-Customer',          
            Phone = '1234567',
            Area_Code__c = '010',                         
            ZipCode__c = '123456',            
            Recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()        
        );        
        insert acc;
        acc = [Select Customer_Number__c, PersonContactId From Account Where Id=:acc.Id];

        SSI__c ssi = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'
        );        
        insert ssi ;

        List<Task> ssiTasks = new List<Task>();
        for(Integer i=0; i<15; i++){
            Task t = new Task(
                RecordTypeId = SSIRTID,
                OwnerId = user1.Id,
                WhatId = ssi.Id,
                WhoId = acc.PersonContactId,
                Subject = 'OB Task',
                Dealer_Name__c = 'Test Dealer',
                DUP_Number__c = ''
            );
            ssiTasks.add(t);
        }
        insert ssiTasks;

        List<Task> nonDupTasks = new List<Task>();
        for(Integer i=0; i<15; i++){
            Task t = new Task(
                RecordTypeId = SSIRTID,
                OwnerId = user1.Id,
                WhatId = pg.Id,
                WhoId = acc.PersonContactId,
                Subject = 'OB Task',
                Dealer_Name__c = 'Test Dealer',
                DUP_Number__c = ''
            );
            nonDupTasks.add(t);
        }
        insert nonDupTasks;
        
        List<Task> dupTasks = new List<Task>();
        for(Integer i=0; i<200; i++){
            Task t = new Task(
                RecordTypeId = OBTRTID,
                OwnerId = user1.Id,
                WhatId = pg.Id,
                Subject = 'OB Task',
                Dealer_Name__c = 'Test Dealer',
                DUP_Number__c = '123'
            );
            dupTasks.add(t);
        }
        insert dupTasks;
        
        Test.startTest();
        
        ApexPages.standardController controller = new ApexPages.standardController(new OB_Task_Handing__c());
        ApexPages.currentPage().getParameters().put('dealername',EncodingUtil.urlEncode('Test Dealer', 'UTF-8'));
        MassAssignRecallTasksControllerExtension maCon = new MassAssignRecallTasksControllerExtension(controller);
        //maCon.getcampaignItems();
        maCon.getassignmentItems();
        maCon.displayByNum();
        System.assertEquals(maCon.th.Dealer_Name__c, 'Test Dealer');
        maCon.th.Subject__c = 'OB Task';
        //maCon.th.Campaign__c = pg.Id;       
        maCon.th.From__c = Date.today();
        maCon.th.To__c = Date.today();      
        maCon.th.Suspect_Dup__c = 'Non-Dup';
        maCon.assignment = 'Assignment';
        maCon.campaign = pg.Id;
        maCon.th.Customer_Name__c = 'Test-Customer';
        maCon.th.Customer_Number__c = acc.Customer_Number__c;
        maCon.th.Phone_Number__c = '1234567';
        maCon.taskOwnerIds = user1.Id;
        
        maCon.th.Call_Times__c = 1;             
        maCon.isSSITask = true;
        maCon.applyFilters();
        maCon.closeTasks();
        
        maCon.isSSITask = false;
        maCon.th.Call_Times__c = 0;      
        maCon.applyFilters();
        //System.assertEquals(maCon.th.Tasks_Found__c, 15);  
        
        
        maCon.th.Suspect_Dup__c = 'Dup';
        maCon.applyFilters();
        System.assertEquals(maCon.th.Tasks_Found__c, 200);
        
        maCon.csrIds = newUsers[0].Id + ';' + newUsers[1].Id;
        maCon.th.By_Number__c = 20;
        maCon.assignTasks();
        Integer u0Count = [Select Count() From Task Where OwnerId = :newUsers[0].Id];
        System.assertEquals(u0Count, 0);  
        Integer u1Count = [Select Count() From Task Where OwnerId = :newUsers[1].Id];
        System.assertEquals(u1Count, 0);  
        
        maCon.th.Evenly_Location__c = false;
        maCon.th.By_Number__c = null;
        maCon.assignTasks();

        System.runAs ( user1 ) {  

            maCon.applyFilters();
            //System.assertEquals(maCon.th.Tasks_Found__c, 200);  
                    
            maCon.csrIds = newUsers[2].Id + '-ERROR';
            maCon.th.By_Number__c = 20;
            maCon.assignTasks();

            maCon.csrIds = newUsers[2].Id + ';' + newUsers[3].Id + ';' + newUsers[4].Id;
            maCon.th.Evenly_Location__c = true;
            maCon.displayByNum();
            maCon.th.By_Number__c = 20;
            maCon.assignTasks();
            
            
        }
        
        Integer u2Count = [Select Count() From Task Where OwnerId = :newUsers[2].Id];
        System.assertEquals(u2Count, 0);  
        Integer u3Count = [Select Count() From Task Where OwnerId = :newUsers[3].Id];
        System.assertEquals(u3Count, 0);  
        Integer u4Count = [Select Count() From Task Where OwnerId = :newUsers[4].Id];
        System.assertEquals(u4Count, 0);       
        
        maCon.assignment = 'Recall';
        maCon.applyFilters();
        
        Test.stopTest();
    }
}