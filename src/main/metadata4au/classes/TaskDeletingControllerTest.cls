@isTest
public class TaskDeletingControllerTest 
{
	static testMethod void testTaskDeletingController()
	{
		Test.startTest();
	    List<Profile> userProfile = new List<Profile>([SELECT Id FROM profile WHERE name='Central CRM Manager' ]);
	   
	   //data for user object
	   User usr = new User(alias = 'standt', email = 'test@9876test.com', 
	                                  emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
	                                  localesidkey = 'en_US', profileid = userProfile.get(0).id ,
	                                  timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
	                                  insert usr;
	     //Test Data for the task object
	     Task t = new Task(subject='test', ActivityDate=Date.Today(),Status='Not Started',Priority='Normal');
	     insert t;
	        String profiles='Central CRM Manager';
	             ApexPages.StandardController sc = new ApexPages.StandardController(t);
	             TaskDeletingController  td=new TaskDeletingController(sc);
	             td.removeTask();
	         delete t;
		Test.stopTest();
		system.assertequals(t.Status,'Not Started');
		system.assertequals(t.Priority,'Normal');
	}
}