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
      Database.executeBatch(runBatch);
   }
   
    public void oneTimeScheduleBatch(){
        //Run daily at 12 AM
        String cronExp ='0 0 0 ? * * *';
        System.schedule('Update Lead to Lost', cronExp, new LeadUpdateToLostJPSchedule());        
    }
    
}