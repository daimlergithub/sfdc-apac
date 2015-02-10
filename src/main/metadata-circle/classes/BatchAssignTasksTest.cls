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
public class BatchAssignTasksTest {

    public static testMethod void testMyController() {
       
        List<User> newUsers = new List<User>();
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

        }
		//TODO-added null checks
		String csrIds;
		if(newUsers.size()>10)
			csrIds = newUsers[10].Id + ';' + newUsers[11].Id;
		//TODO-added null checks
		List<String> ids;
		if(csrIds!=null)
		{
			ids = csrIds.split(';');
	   		for(Integer i=0;i<ids.size();i++){
		        ids[i] = ids[i].trim();
		    }
		}
		//TODO-added null checks    
		List<User> users;
		if(ids!=null)
        users = [Select Id From User Where Id In :ids];
        
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        SSI__c ssi = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'       
        );        
        insert ssi ;
        for(integer i = 0; i < 201; i++) {
            tasks.add(new Task(RecordTypeId = SMSRTID,WhatId = ssi.Id));
        }
        Insert tasks;
        
        Test.startTest();
        
        if (tasks.size() > 0) {
    
            String queryIds = ' ';
            for(Task p : tasks){
                queryIds += '\''+ p.Id + '\'';
                queryIds += ',';
            }
            queryIds = queryIds.subString(0, queryIds.length()-1);
    
            String queryStr = 
                    'Select Id, OwnerId From Task Where Id In (' + queryIds + ') ';
                
            BatchAssignTasks batcher = new BatchAssignTasks(queryStr, users);
            Database.executeBatch(batcher, 300);
        }
        
        Test.stopTest();
        
        //Integer count  = [Select Count() From Task Where RecordTypeId = :SMSRTID And Status = 'Closed' And Activity_Status__c = 'Sent'];
        //System.assertEquals(count, 201);
    }
}