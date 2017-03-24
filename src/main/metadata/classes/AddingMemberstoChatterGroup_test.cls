/**
    *@Description : This Class will incresse coverage AddingMemberstoChatterGroup.
    *@Author : Kiran P.
    *@Date : 4/12/2017
    *@Release : Japan J4
    */
@isTest
public class AddingMemberstoChatterGroup_test{
    public static testMethod void AddingMemberstoChatterGroup_MT(){
        Id JobId ;
        Profile p = [SELECT Id FROM Profile WHERE Name='Japan CRM']; 
        CollaborationGroup gp = new CollaborationGroup(Name = 'Dealer Community1',CollaborationType = 'Private');
       insert gp;   
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,market__c = 'JP', 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser23@testorg.com');
            
            //CollaborationGroup Chattergrp = [SELECT Id, Name From CollaborationGroup WHERE Name =: 'All MBJ Users' LIMIT 1];
            system.runAs(u){
            test.StartTest();
            AddingMemberstoChatterGroup obj = new AddingMemberstoChatterGroup();
            
           JobId  = Database.executeBatch(obj,300);
           test.StopTest(); 
            }
      //System.abortJob(JobId);      
    }

}