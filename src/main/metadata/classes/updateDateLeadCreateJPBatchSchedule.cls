global class updateDateLeadCreateJPBatchSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      updateDateLeadCreateJPBatch runBatch = new updateDateLeadCreateJPBatch();
      Database.executeBatch(runBatch);
   }
   
    public void oneTimeScheduleBatch(){
        //Run daily at 12 AM
        String cronExp ='0 0 0 ? * * *';
        System.schedule('Update Lead Assigned Date', cronExp, new updateDateLeadCreateJPBatchSchedule());        
    }
    
}