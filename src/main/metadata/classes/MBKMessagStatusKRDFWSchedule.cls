/**
 * Class Name	: MBKMessagStatusKRDFWSchedule.cls
 * Function		: 
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.11.05
 * Description	: 
*/
global with sharing class MBKMessagStatusKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
  		MBKMessageStatusKRDFWBatch StatusBatch = new MBKMessageStatusKRDFWBatch();
		Database.executeBatch(StatusBatch, 100);
	}    
}