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
        if(trigger.isBefore){
            if(trigger.isinsert){
                BbqTriggerHelperBase.autoPopulateDealerEmailAddress(trigger.new);
            }
        }
            
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){    
        List<Referral__c> ReferralList = Trigger.new;
        if(!ReferralList.isEmpty() && ReferralList.size() > 0 && TriggerRecursiveCheck.ReferralCalcFlag == true){
            //setting to false to prevent execution of these methods again in same transaction
            TriggerRecursiveCheck.ReferralCalcFlag = false;            
            if(trigger.isAfter){
                if(trigger.isInsert){
                    BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
                    BbqTriggerHelperBase.taskCreation(Trigger.new);
                }
                else if(trigger.isUpdate){                
                    BbqTriggerHelperBase.pointCalculation(Trigger.new,(Map<id,Referral__c>)Trigger.newMap,(Map<id,Referral__c>)Trigger.oldMap);
                }
            }     
            if(trigger.isBefore){
                if(trigger.isinsert){
                    BbqTriggerHelperBase.autoPopulateDealerEmailAddress(trigger.new);
                }
            }
            
        }
        
    }
}