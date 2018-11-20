/*Class to run match merge for India market per schedule*/
global class scheduleRetailMatchMergeBatchIN implements Schedulable{
     public void execute(SchedulableContext sc){
        String Market = System.label.IN;
        retailMatchMergeBatchMY rmm=new retailMatchMergeBatchMY(Market);
    Database.executeBatch(rmm);
    }
}