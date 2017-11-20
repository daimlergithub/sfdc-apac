/**
 * Trigger Name	: TriggerMBK_Bulk_MessageKRDFW.cls
 * Object Name	: MBK Bulk Message
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.11.02
 * Description	: Campaign, Survry Bulk 메시지 전송데이터로 생성 
*/
trigger TriggerMBK_Bulk_MessageKRDFW on MBK_Bulk_Message__c (after insert) {
	new TriggerHandlerMBK_Bulk_MessageKRDFW().run();
}