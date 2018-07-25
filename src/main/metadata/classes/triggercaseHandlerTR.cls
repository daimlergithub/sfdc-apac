/**
* Handler for Trigger on Case for TR(Turkey)
* Author:Hildaa
*/

public class triggercaseHandlerTR implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperTR caseHelperBased = new CaseHelperTR();
        string market = System.Label.TR;
        if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
            
            if(trigger.isinsert && trigger.isbefore){
                caseHelperBased.countRepeatComplaintCase(trigger.new,true,market);
                caseHelperBased.updateCaseDeadLineAmount(trigger.new,market,null);
                CaseHelper.caseBeforeInsertUpdateEvents(trigger.New,true,false,(Map<Id,Case>)Trigger.oldMap);
                caseHelperBased.updatePrimaryCaseDealerbasedonCaseOwner(trigger.New,(Map<Id,Case>)Trigger.oldMap,true,false);
               caseHelperBased.updateCaseStatus(trigger.New,(Map<Id,Case>)Trigger.oldMap,true,false);
               caseHelperBased.updateTurnAroundTime(trigger.New,(Map<Id,Case>)Trigger.oldMap,true,false);
                
            }
            else if(trigger.isupdate &&trigger.isbefore){
                // caseHelperBased.updateCaseDeadLineAmount(trigger.new,market,(Map<Id,Case>)trigger.oldMap);
                CaseHelper.caseBeforeInsertUpdateEvents(trigger.New,false,true,(Map<Id,Case>)Trigger.oldMap);
                caseHelperBased.updatePrimaryCaseDealerbasedonCaseOwner(trigger.New,(Map<Id,Case>)Trigger.oldMap,false,true);
               caseHelperBased.updateCaseStatus(trigger.New,(Map<Id,Case>)Trigger.oldMap,false,true);
               caseHelperBased.updateTurnAroundTime(trigger.New,(Map<Id,Case>)Trigger.oldMap,false,true);
            }
            
            if (trigger.isAfter){
                if (trigger.isDelete){
                    caseHelperBased.calculateComplaintAmount(trigger.old,market);
                }
                else if (trigger.isInsert){
                    caseHelperBased.calculateComplaintAmount(trigger.new,market); 
                    if(Util_GetPermissionList.checkAccessOnUser(Label.TRRetail)){
                        caseHelperBased.ShareRecordswithDealers(Trigger.new,false, market);
                    }
                     if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                       //To create a Retail Copy(Account Link) of Case Account
                       caseHelperBased.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                   }
                    
                }else if (trigger.isUpdate){
                    caseHelperBased.calculateComplaintAmount(trigger.new,market);
                    if(Util_GetPermissionList.checkAccessOnUser(Label.TRRetail)){
                        caseHelperBased.ShareRecordswithDealers(Trigger.new,Trigger.isupdate, market);
                    }
                     if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                       //To create a Retail Copy(Account Link) of Case Account
                       caseHelperBased.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                   }
                }
                
            }
        }     
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
    
}