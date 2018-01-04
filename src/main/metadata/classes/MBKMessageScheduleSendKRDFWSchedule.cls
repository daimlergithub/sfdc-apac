/**
 * Class Name	: MBKMessageScheduleSendKRDFWSchedule.cls
 * Function		: MBK Message Schedule Send Schedule KaKao, SMS, MMS전송
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.12.19
 * Description	: 
*/
global with sharing class MBKMessageScheduleSendKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {	
    	
    	//KaKao 전송
  		MBKMessageScheduleSendKRDFWBatch mmsBatchA = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatchA.channel = 'A';
		Database.executeBatch(mmsBatchA, 100);
		
		//MMS 전송
   		MBKMessageScheduleSendKRDFWBatch mmsBatchM = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatchM.channel = 'M';
		Database.executeBatch(mmsBatchM, 10);
    
    	//SMS 전송
  		MBKMessageScheduleSendKRDFWBatch mmsBatchS = new MBKMessageScheduleSendKRDFWBatch();
  		mmsBatchS.channel = 'S';
		Database.executeBatch(mmsBatchS, 100);    
		
		//Status체크 전송
  		MBKMessageStatusKRDFWBatch StatusBatch = new MBKMessageStatusKRDFWBatch();
		Database.executeBatch(StatusBatch, 100);		
    }
}