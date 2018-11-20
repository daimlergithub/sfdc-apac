/* Added by sravanthi gudibandi for KR Market*/
/*Class to run match merge for Korea market per schedule*/
global class scheduleRetailMatchMergeBatchKR implements Schedulable{
     public void execute(SchedulableContext sc){
        String Market = System.label.KR;
        retailMatchMergeBatchMY rmm=new retailMatchMergeBatchMY(Market);
    Database.executeBatch(rmm);
    }
}