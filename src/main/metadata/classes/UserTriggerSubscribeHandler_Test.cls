/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:02-Aug-2018
* Company:Infosys Ltd
* Description:Test class for UserTriggerSubscribeHandler class.
* **********************************************************************************/
@isTest
public class UserTriggerSubscribeHandler_Test {
    @isTest
    public static void userTriggerRCP_Test(){
        user usr ;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = p.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
				Subscribe__c = false               
            );            
            insert usr;
            usr.Subscribe__c = true;
            update usr;
            //usr.Subscribe__c = false;
            //update usr;            
        }
    }    
    @isTest
    public static void userTriggerRCP_Test1(){
        user usr ;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = p.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
				Subscribe__c = false,
                Market__c = 'ID'
            );            
            insert usr;
            usr.Subscribe__c = true;
            update usr;
            usr.Subscribe__c = false;
            update usr;            
        }
    }
}