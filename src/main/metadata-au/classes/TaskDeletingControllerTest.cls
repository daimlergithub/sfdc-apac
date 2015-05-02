@isTest
public class TaskDeletingControllerTest 
{
  static testMethod void testTaskDeletingController()
  {
   
    List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='Central CRM Manager' OR Name='Central AS Marketing Manager' OR  Name='Central AS Marketing Staff' OR Name='CAC IT Manager']);
       
    //data for user object
       User usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                      insert usr;
                                         
              User user = [select Profile.Name from User where profileid =:userProfile.get(0).id];
              system.runas(user)
               {
               //Test Data for the task object
               Task t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
                Test.startTest();
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
  
  
   List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='CAC Data Manager' ]);
       
       //data for user object
       User usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                      insert usr;
     
    User user = [select Profile.Name from User where profileid =:userProfile.get(0).id] ;
               system.runas(user)
               {
               //Test Data for the task object
               Task t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
               Test.startTest();
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
               Test.stopTest();
               }
  }
}