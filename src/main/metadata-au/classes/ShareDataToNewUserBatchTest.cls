@isTest
public with sharing class ShareDataToNewUserBatchTest 
{
    public static User usr; 
    public static Profile userProfile = [select Id from Profile where Name = 'System Administrator' limit 1];
    public static testmethod void testbatch1()
    {
        Account acc1 = new Account();
        acc1.LastName ='testaccount';
        acc1.Mobile__c ='74389594303';
        acc1.FirstName ='batch';
        acc1.Email__c ='ssibatch@test.com';
        acc1.Salutation ='Brother';
        insert acc1;
        
        usr = new User(
            Username = System.now().millisecond() +math.random()+ '987654321test12345@test.com',
            FirstName = 'firstname',
            ProfileId = userProfile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert usr;
        
        AccountShare accshare = new AccountShare();
        accshare.UserOrGroupId = usr.Id;
        accshare.AccountAccessLevel ='read';
        accshare.OpportunityAccessLevel ='read';
        accshare.AccountId=acc1.id;
        insert accshare;
        
        
        
        test.startTest();
        /*ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch();
        Database.executeBatch(schdata);*/
        test.stopTest();
    }
}