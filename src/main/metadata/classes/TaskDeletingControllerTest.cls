@isTest
public with sharing class TaskDeletingControllerTest 
{
private static Task t;
private static Task t1;
private static User usr;
private static User user;
private static User user1;
public static void preparedTestData(List<Profile> userProfile)
{

        usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
       insert usr;
    // user = [select Profile.Name from User where profileid =:userProfile.get(0).id];
    
}
  static testMethod void testTaskDeletingController()
  {
  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
  insert updatecustomsettings;

    List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='Central AS Marketing Manager']);
    //data for user object
       
              preparedTestData(userProfile);                           
              system.runas(usr)
               {
                   
               Test.startTest();
               Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
               insert personAcc;
               //prepareTestData();
               t = new Task(subject='test',whatid = personAcc.id, ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
                              
               //Assert deleted Task:
               Integer deletedTask = [Select count() From Task Where id = :t.Id];
               Test.stopTest();
               system.assertEquals(0,deletedTask);
              }
           
  }  

  static testMethod void TestRemoveTask_ElseConditon()
  {
  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
  insert updatecustomsettings;
        List<Profile> userProfile= new List<Profile>([SELECT Id FROM profile WHERE name='IntegrationAPI']);       
       //data for user object
               Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
               insert personAcc;               
               
               t1 = new Task(subject='test1',WhatId = personAcc.id, ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t1;
              preparedTestData(userProfile);
               system.runas(usr)
               {               
               Test.startTest();
              // prepareTestData();
               ApexPages.StandardController sc = new ApexPages.StandardController(t1);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
               Integer deletedTask = [Select count() From Task Where id = :t1.id];
               Test.stopTest();
               system.assertEquals(1,deletedTask);
               }
  }
  
 }