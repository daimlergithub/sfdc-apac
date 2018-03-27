/************************************************************************************
* Created By:Sarath Kumar M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description:Handler to call BbqTriggerHelperBase class
*********************************************************************************************/
public class BbqTriggerHandler implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isAfter){
            if(trigger.isInsert){
                BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
                BbqTriggerHelperBase.taskCreation(Trigger.new);
            }
            else if(trigger.isUpdate){                
                BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
            }
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){    
        
                if(trigger.isAfter){
                    if(trigger.isInsert){
                        BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
                        BbqTriggerHelperBase.taskCreation(Trigger.new);
                    }
                    else if(trigger.isUpdate){                
                        BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
                    }
                }          
            
        }
        
}