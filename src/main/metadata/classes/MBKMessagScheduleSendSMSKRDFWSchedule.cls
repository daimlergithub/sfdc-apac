/**
 * Class Name	: MBKMessagScheduleSendSMSKRDFWSchedule.cls
 * Function		: MBK Message Schedule Send Schedule SMS전송
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 
*/
global with sharing class MBKMessagScheduleSendSMSKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
  		MBKMessageScheduleSendKRDFWBatch mmsBatch = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatch.channel = 'S';
		Database.executeBatch(mmsBatch, 100);
	}    
}