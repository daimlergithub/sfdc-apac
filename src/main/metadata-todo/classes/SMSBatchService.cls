global class SMSBatchService {

    webservice static String ActiveAll(Id CampaignId) {

        String errorMsg = '';
        List<SMS_Batch__c> SMSBatchs = [select id, name, Batch_Start__c, Batch_Status__c, TestRecipientGroup__c , Campaign__r.Template__c , Batch_Size__c from SMS_Batch__c where Campaign__c = :CampaignId and (Batch_Status__c = 'new' or Batch_Status__c = 'Suspended')];

        //if there is no records ,return error msg
        if(SMSBatchs.size() < 1){
            errorMsg = 'Failed. There is no valid SMS batch to be Actived.';
        }
        else{
            for (SMS_Batch__c SMSBatch : SMSBatchs){
                SMSBatch.Batch_Status__c = 'Active';
                SMSBatchSecdule BatchSecdule = new SMSBatchSecdule(CampaignId, SMSBatch);
                Long milliseconds = SMSBatch.Batch_Start__c.getTime() - DateTime.now().getTime();
                String batchId;
                if (milliseconds > 0){
                   integer mins = integer.valueOf(milliseconds / 60000);
                   batchId = System.scheduleBatch(BatchSecdule, 'SMSBatchSecdule_'+SMSBatch.name, mins, 200 );
                   SMSBatch.ScheduleJobID__c = batchId;
                }else{
                   errorMsg = 'Sorry there are SMS batches\' start time earlier than current time, please double check and try again';
                }
            }
            if(errorMsg==''){
                update SMSBatchs;
                Campaign  campaign = [SELECT SMS_Task_Verified__c FROM Campaign WHERE Id = :CampaignId];
                if(campaign.SMS_Task_Verified__c == false){
	            	campaign.SMS_Task_Verified__c = true;
	            	update campaign;
                }
            }
        }
        return errorMsg;
    }
    
    webservice static String SuspendAll(Id CampaignId){

        String errorMsg = '';
        List<SMS_Batch__c> SMSBatchs = [select ScheduleJobID__c, Batch_Status__c, Batch_Start__c from SMS_Batch__c where Campaign__c = :CampaignId and Batch_Status__c = 'Active'];
                    
        //if there is no records ,return error msg
        if(SMSBatchs.size() < 1){
            errorMsg = 'Failed. There is no valid SMS batch to be Suspended.';
        }else{
            for (SMS_Batch__c SMSBatch: SMSBatchs){

                Long milliseconds = SMSBatch.Batch_Start__c.getTime() - DateTime.now().getTime();
                if (milliseconds < 0){
                    SMSBatch.Batch_Status__c = 'Expired';
                }else{
                
                    SMSBatch.Batch_Status__c = 'Suspended';
                    system.abortJob(SMSBatch.ScheduleJobID__c);
                }
            }
            update SMSBatchs;
        }
        return errorMsg;
    }
}