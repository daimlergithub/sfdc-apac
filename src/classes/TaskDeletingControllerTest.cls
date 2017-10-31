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
               //prepareTestData();
               t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
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
               t1 = new Task(subject='test1', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
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