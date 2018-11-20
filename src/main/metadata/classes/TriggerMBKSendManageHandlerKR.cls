/**
 * Created by user on 2018-06-21.
 */

public without sharing class TriggerMBKSendManageHandlerKR implements TriggerHandlerIf{

    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        MBKSendManageHelperKR.insertUpdateMessageManage((List<MBKSendManage__c>) trigger.new);
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }

}