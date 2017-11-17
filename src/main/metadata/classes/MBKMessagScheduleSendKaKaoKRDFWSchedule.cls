/**
 * Class Name	: MBKMessagScheduleSendMMSKRDFWSchedule.cls
 * Function		: MBK Message Schedule Send Schedule KaKao전송
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 
*/
global with sharing class MBKMessagScheduleSendKaKaoKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
  		MBKMessageScheduleSendKRDFWBatch mmsBatch = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatch.channel = 'A';
		Database.executeBatch(mmsBatch, 100);
	}    
}