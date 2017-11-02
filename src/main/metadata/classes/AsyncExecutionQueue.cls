public class AsyncExecutionQueue implements Queueable {
List<Account>Acc=new List<Account>();
public AsyncExecutionQueue(List<Account> acctoupdate){
this.Acc=acctoupdate;
}
public void execute(QueueableContext context) {
                //update acc;
                DMLManagerService.updateAsSystem(acc);
    }
}