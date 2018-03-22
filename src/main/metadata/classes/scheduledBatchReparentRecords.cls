global class scheduledBatchReparentRecords implements Schedulable{
    global void execute(SchedulableContext SC)
    {
        batchReparentRecords batch=new batchReparentRecords();
		Database.executeBatch(batch);
    }

}