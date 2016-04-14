@isTest
public with sharing class TaskDeletingControllerTest 
{
private static Task t;
private static User usr;
private static User user;
public static void preparedTestData(List<Profile> userProfile)
{

        usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                      insert usr;
     user = [select Profile.Name from User where profileid =:userProfile.get(0).id limit 1];
}
  static testMethod void testTaskDeletingController()
  {
    List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='Central CRM Manager' OR Name='Central AS Marketing Manager' OR  Name='Central AS Marketing Staff' OR Name='CAC IT Manager']);
    //data for user object
       
              preparedTestData(userProfile);                           
              system.runas(user)
               {
               Test.startTest();
               prepareTestData();
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
                              
               //Assert deleted Task:
               List<Task> deletedTask = [Select Id, isDeleted From Task Where Subject = 'test'];
               Test.stopTest();
               system.assertEquals(0,deletedTask.size());
                }
           
  }  
  static testMethod void TestRemoveTask_ElseConditon()
  {
    
        List<Profile> userProfile= new List<Profile>([SELECT Id FROM profile WHERE name='CAC Data Manager']);       
       //data for user object
    
              preparedTestData(userProfile);
               system.runas(user)
               {               
               Test.startTest();
               prepareTestData();
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
               List<Task> deletedTask = [Select Id, isDeleted From Task Where Subject = 'test'];
               Test.stopTest();
               system.assertEquals(1,deletedTask.size());
               }
  }
  
  static void prepareTestData()
      {
      //Test Data for the task object
               t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
      }
}