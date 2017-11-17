/**
 * Class Name	: MBKMessagScheduleSendMMSKRDFWSchedule.cls
 * Function		: MBK Message Schedule Send Schedule MMS전송
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 
*/
global with sharing class MBKMessagScheduleSendMMSKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
  		MBKMessageScheduleSendKRDFWBatch mmsBatch = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatch.channel = 'M';
		Database.executeBatch(mmsBatch, 10);
	}    
}