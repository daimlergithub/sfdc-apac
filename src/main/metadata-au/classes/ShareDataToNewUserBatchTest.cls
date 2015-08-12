@isTest
public with sharing class ShareDataToNewUserBatchTest 
{
    public static User usr; 
    public static string tstuser;
    public static id useid;
    public static set<id> setid;
    public static List<User> user = Database.query('select id from user');
    public static  String sobjectNameStr;
    public static Profile userProfile = [select Id from Profile where Name = 'System Administrator' limit 1];
    public static Id vechID = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static Id vechrelaID = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    public static List<string> condition;
    public static string accesslevel = 'Read';
    public static void createuser()
    {
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
        
    }
    public static testmethod void testbatch1()
    {
        Account acc1 = new Account();
        acc1.LastName ='testaccount';
        acc1.Mobile__c ='74389594303';
        acc1.FirstName ='batch';
        acc1.Email__c ='ssibatch@test.com';
        acc1.Salutation ='Brother';
        insert acc1;
        
       
        createuser();
        AccountShare share = new AccountShare();
        share.AccountAccessLevel = accesslevel;
        share.AccountId = acc1.Id;
        share.UserOrGroupId = usr.id;
        share.OpportunityAccessLevel = accesslevel;
        insert share;
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'Account';
             
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('Account', sobjectNameStr, share);
    }

public static testmethod void testbatch2()
    {
        
        Vehicle__c vehc1 = new Vehicle__c();
        vehc1.Vehicle_Name__c ='Test1';
        vehc1.UsVIN__c ='abchgdtrsghtredfr';
        vehc1.RecordTypeId = vechID;
        insert vehc1;
        
        createuser();
        Vehicle__Share vehshare = new Vehicle__Share();
        vehshare.AccessLevel = accesslevel;
        vehshare.ParentId = vehc1.Id ;
        vehshare.RowCause = Schema.Vehicle__Share.RowCause.Manual;
        vehshare.UserOrGroupId = usr.Id ;
        insert vehshare;
        
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'Vehicle';
        
        
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('Vehicle',sobjectNameStr,vehshare);
    }
    
    public static testmethod void testbatch3()        
    {
        
         
        Vehicle__c vehc1 = new Vehicle__c();
        vehc1.Vehicle_Name__c ='Test1';
        vehc1.UsVIN__c ='abchgdtrsghtredfr';
        vehc1.RecordTypeId = vechID;
        insert vehc1;
        
        
        Vehicle_Relationship__c vehcrel =new Vehicle_Relationship__c();
        vehcrel.RecordTypeId = vechrelaID;
        vehcrel.Car_Relation__c ='Driver';
        vehcrel.Vehicle_ID__c = vehc1.Id ;
        insert vehcrel;
        
        createuser();       
        Vehicle_Relationship__Share vehrelshare = new Vehicle_Relationship__Share();
        vehrelshare.AccessLevel = 'Read';
        vehrelshare.ParentId = vehcrel.Id ;
        vehrelshare.RowCause = Schema.Vehicle__Share.RowCause.Manual;
        vehrelshare.UserOrGroupId = usr.Id;
        insert vehrelshare;
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'VehicleRelation';
        
        
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('VehicleRelation',sobjectNameStr,vehrelshare);
    }
}