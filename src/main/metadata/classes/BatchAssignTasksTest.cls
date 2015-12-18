@isTest
public class BatchAssignTasksTest {
    
    private static list<user> lstUsers= new list<user>();
    static
    {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser)
        {
			List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
			insert updatecustomsettings;
			
            String[] csrProfiles = new String[]{
                    'CAC IB CSR', 'CAC IB TL', 'CAC IB QC', 'CAC OB CSR', 'CAC OB TL', 'CAC OB QC', 'CAC SSI CSR', 'CAC SSI TL', 'CAC SSI SV', 'CAC SSI QC', 'CAC SSI Trainer'};
               // String[] csrProfiles = new String[]{'System Administrator', 'CAC IB TL'};
            List<Profile> profileIds = [Select Id From Profile Where Name In :csrProfiles];
            for(Profile p : profileIds)
            {
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
                lstUsers.add(usr);
            }
            insert lstUsers;
        }
    }

    public static testMethod void testBatchAssignTasks()
    {
        Test.startTest();
       String csrIds = lstUsers[0].Id + ';' + lstUsers[1].Id;
        List<String> ids = csrIds.split(';');
        for(Integer i=0;i<ids.size();i++)
        {
            ids[i] = ids[i].trim();
        }
        List<User> users = [Select Id From User Where Id In :ids];
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        SSI__c ssi = new SSI__c(        
            Status__c = 'Matched',    
            DealerName__c = 'Test Dealer',
            CustomerName__c = 'Test-Customer',          
            OfficePhone__c = '1234567'       
        );        
        insert ssi ;
        for(integer i = 0; i < 10; i++) 
        {           
            tasks.add(new Task(RecordTypeId = SMSRTID,WhatId = ssi.Id));
        }
        Insert tasks;
        if (!tasks.isEmpty()) 
        {
    
            String queryIds = ' ';
            for(Task p : tasks){
                queryIds += '\''+ p.Id + '\'';
                queryIds += ',';
            }
            queryIds = queryIds.subString(0, queryIds.length()-1);
            
            String queryStr = 'Select Id, OwnerId From Task Where Id In (' + queryIds + ') ';
            
            BatchAssignTasks batcher = new BatchAssignTasks(queryStr, users);
            Database.executeBatch(batcher, 300);
        }
        Test.stopTest();
        system.assertequals([select Id, Name,ownerId from SSI__c where Id = :ssi.id].ownerId,users[1].Id);
    }
}