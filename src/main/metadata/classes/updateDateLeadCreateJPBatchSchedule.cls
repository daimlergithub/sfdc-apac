global class updateDateLeadCreateJPBatchSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      updateDateLeadCreateJPBatch runBatch = new updateDateLeadCreateJPBatch();
      Database.executeBatch(runBatch);
   }
   
    public void oneTimeScheduleBatch(){
        //Run daily at 11 PM
        String cronExp ='0 0 23 ? * *';
		String jobName= 'Update Lead Assigned Date ' + System.today();
        System.schedule(jobName, cronExp, new updateDateLeadCreateJPBatchSchedule());        
    }
    
}