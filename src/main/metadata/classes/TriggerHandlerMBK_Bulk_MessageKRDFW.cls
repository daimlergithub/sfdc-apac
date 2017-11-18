public with sharing class TriggerHandlerMBK_Bulk_MessageKRDFW extends TriggerHandlerUtilKRDFW{    
 	
	public TriggerHandlerMBK_Bulk_MessageKRDFW(){ 
		this.setMaxLoopCount(10);
	}
	
	public override void afterInsert(){
		List<MBK_Bulk_Message__c> mbkBulks = Trigger.new;
		bulkMessageInsert(mbkBulks);			
	}
	
	private void bulkMessageInsert(List<MBK_Bulk_Message__c> mbkBulks){
		for(MBK_Bulk_Message__c temp:mbkBulks){
			if(!temp.PageSearch__c){
				MBKBulkMessageCreateKRDFWBatch bulkBatch = new MBKBulkMessageCreateKRDFWBatch();
				//bulkBatch.batchId = temp.Source_Object_Id__c;
				bulkBatch.batchId = temp.Id;
				bulkBatch.batchType = temp.Source_Object__c;
				database.executeBatch(bulkBatch, 1);
			}
		}
	}
}