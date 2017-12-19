public class EmailNotificationSchedulerClass implements Schedulable
{
	public void execute(SchedulableContext sc) 
	  {
	        Database.executeBatch(new EmailNotificationfor5days10days15days(), 2000);
	  }  
}