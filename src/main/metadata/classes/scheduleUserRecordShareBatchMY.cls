global class scheduleUserRecordShareBatchMY  implements Schedulable{
     public void execute(SchedulableContext sc){
        String Market = System.label.MarketMY;
        UserRecordShareBatchMY ur=new UserRecordShareBatchMY (Market);
    Database.executeBatch(ur);
    }
}