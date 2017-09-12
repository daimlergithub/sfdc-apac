public class GlobalUtilityScheduleDFW implements Schedulable {
  public void execute(SchedulableContext sc){
   GlobalUtilityDFW utility= GlobalUtilityDFW.getInstance();
   utility.CheckDebugInfoLog();
 }
}