/*
 * To run this schedule-
 * In Anoynomous block enter below code
 * C2C_AccountlinkShareJPSchedule c2cScheduleRun= new C2C_AccountlinkShareJPSchedule();
 * c2cScheduleRun.oneTimeScheduleBatch();
 * 
*/
global class C2C_AccountlinkShareJPSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      C2C_AccountlinkShareJPBatch runBatch = new C2C_AccountlinkShareJPBatch();
      Database.executeBatch(runBatch,50);
   }
   
    public void oneTimeScheduleBatch(){
        //Run daily at 11 PM
        String cronExp ='0 0 23 ? * *';
		String jobName= 'Share Retail Copy JP ' + System.today();
        System.schedule(jobName, cronExp, new C2C_AccountlinkShareJPSchedule());        
    }
    
}