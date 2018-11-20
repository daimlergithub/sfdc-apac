global class scheduleRetailMatchMergeBatchTR implements Schedulable{
     public void execute(SchedulableContext sc){
        String Market = System.label.TR;
        retailMatchMergeBatchMY rmm=new retailMatchMergeBatchMY(Market);
		Database.executeBatch(rmm);
    }
}