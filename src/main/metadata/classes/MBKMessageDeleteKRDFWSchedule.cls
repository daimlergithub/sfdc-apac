/**
 * Class Name	: MBKMessageDeleteKRDFWSchedule.cls
 * Function		: MBK Message Delete Batch Schedule
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 삭제 배치 스케줄러(배치 사이즈 1000)
*/
global with sharing class MBKMessageDeleteKRDFWSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
		Database.executeBatch(new MBKMessageDeleteKRDFWBatch(), 1000);
	}

}