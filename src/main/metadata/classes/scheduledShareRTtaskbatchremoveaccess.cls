global class scheduledShareRTtaskbatchremoveaccess implements Schedulable {
   global void execute(SchedulableContext sc) {
      ShareRTtaskbatchremoveaccess  b = new ShareRTtaskbatchremoveaccess(); 
      database.executebatch(b);
   }
}