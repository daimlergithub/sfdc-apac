@isTest
public class TaskDeletingControllerTest 
{
  static testMethod void testTaskDeletingController()
  {
    Test.startTest();
                                 List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='Central CRM Manager' OR Name='Central AS Marketing Manager' OR  Name='Central AS Marketing Staff' OR Name='CAC IT Manager']);
       
       //data for user object
       User usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                      insert usr;
                                         
                                     User user = [select Profile.Name from User where Profile.Name='Central CRM Manager' OR Profile.Name='Central AS Marketing Manager' OR Profile.Name='Central AS Marketing Staff' OR Profile.Name='CAC IT Manager'] ;
                                    system.debug('@@@ user records '+user);
                                                                        system.debug('@@@ user records Profile.Name'+user.Profile.Name);
    system.runas(user){

               //Test Data for the task object
               Task t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
               
               //Assert deleted Task:
               List<Task> deletedTask = [Select Id, isDeleted From Task Where Subject = 'test'];
               system.assertEquals(0,deletedTask.size());
               system.debug('Deleted Task :' +deletedTask );
    }
    Test.stopTest();
  }
  
  static testMethod void testremoveTasktest()
  {
  
  Test.startTest();
   List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='CAC Data Manager' ]);
       
       //data for user object
       User usr = new User(alias = 'standt', email = 'test@9876test.com', 
                                      emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                      localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                      insert usr;
    
     
                                    User user = [select Profile.Name from User where Profile.Name='CAC Data Manager'] ;
                                    system.debug('@@@ user records '+user);
                                                                        system.debug('@@@ user records Profile.Name'+user.Profile.Name);
    system.runas(user){

               //Test Data for the task object
               Task t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
               insert t;
               String profiles='CAC Data Manager';
               ApexPages.StandardController sc = new ApexPages.StandardController(t);
               TaskDeletingController  td=new TaskDeletingController(sc);
               td.removeTask();
               //Assert deleted Task:
               List<Task> deletedTask = [Select Id, isDeleted From Task Where Subject = 'test'];
               system.assertnotEquals(0,deletedTask.size());
               system.debug('Deleted Task :' +deletedTask );
    }
    Test.stopTest();
   

  }
  
}