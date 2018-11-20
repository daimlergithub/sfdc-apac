/*
 * To run this schedule-
 * In Anoynomous block enter below code
 * LeadUpdateToLostJPSchedule luScheduleRun= new LeadUpdateToLostJPSchedule();
 * luScheduleRun.oneTimeScheduleBatch();
 * 
*/
global class LeadUpdateToLostJPSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      LeadUpdateToLostJPBatch runBatch = new LeadUpdateToLostJPBatch();
	  If(Test.isRunningTest()){
	    Database.executeBatch(runBatch);
	  }
	  else {
        Database.executeBatch(runBatch,1);
		}
   }
   
    public void oneTimeScheduleBatch(){
        //Run daily at 11 PM
        String cronExp ='0 0 23 ? * *';
		String jobName= 'Update Lead to Lost '+ System.today();
        System.schedule(jobName, cronExp, new LeadUpdateToLostJPSchedule());        
    }
    
}