global class schduleUpdateRTwithWSAccountANZ implements Schedulable {

   global void execute(SchedulableContext ctx) {
      UpdateRTwithWSAccountANZ p = new UpdateRTwithWSAccountANZ();
        database.executeBatch(p,50);// Batch -scope size is 50
   }   
   
   //  scheduling a repeating job - currently set for Everyday 2200hrs.
    /*
    global static String scheduleMeEveryDay22Hrs() {
    schduleUpdateRTwithWSAccountANZ SC = new schduleUpdateRTwithWSAccountANZ(); 
    return System.schedule('schduleUpdateRTwithWSAccountANZ - Everyday 10PM', '0 0 22 * * ? *', SC);
    }
    */
    
}