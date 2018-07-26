global class scheduleRetailMatchMergeBatchMY implements Schedulable{
     public void execute(SchedulableContext sc){
        String Market = System.label.MarketMY;
        retailMatchMergeBatchMY rmm=new retailMatchMergeBatchMY(Market);
		Database.executeBatch(rmm);
    }
}