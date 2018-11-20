/**
* Handler for Trigger on Case for Factory Model
* Author: Shashi
* Created Date : 06th Oct 2018
*/

public class triggercaseHandlerFM implements TriggerHandlerIf
{
    Public User u= Utility_FM.getLoggedInUserInfo();
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperFM CaseHelperFMInstance = new CaseHelperFM();
        List<Case> CaseList = trigger.new;
        String market = u.market__c;
        
        if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
            if (trigger.isbefore){
                if(trigger.isinsert){
                    CaseHelperFM.updatemarket(trigger.new);
                    CaseHelperFMInstance.countRepeatComplaintCase(trigger.new,true,market);
                    CaseHelperFMInstance.updateCaseDeadLineAmount(trigger.new,market,null);
                    CaseHelperFMInstance.beforeInsertUpdateVehicleInfo(Trigger.new);
                    
                    if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){
                        CaseHelperFMInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true, market);
                        CaseHelperFMInstance.updateCaseCreator(trigger.new, market);
                        CaseHelperFMInstance.changeDealerAccount(Trigger.New, market);
                    }
                    //----------CaseHelperFMInstance.updatecommunityurl(Trigger.New, market);
                }
                else if(trigger.isupdate){
                    CaseHelperFM.updatemarket(trigger.new);
                    CaseHelperFMInstance.beforeInsertUpdateVehicleInfo(Trigger.new);
                    //-----------CaseHelperFMInstance.updatecommunityurl(Trigger.New, market);
                    CaseHelperFMInstance.updateCaseDeadLineAmount(trigger.new,market,(Map<Id,Case>)trigger.oldMap);
                    CaseHelperFMInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false, market);
                }
            }
            if (trigger.isAfter){
                if (trigger.isDelete){
                    CaseHelperFMInstance.calculateComplaintAmount(trigger.old,market);
                }
                else if (trigger.isInsert){
                    if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                        CaseHelperFMInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                    }
                    CaseHelperFMInstance.calculateComplaintAmount(trigger.new,market); 
                }
                else if (trigger.isUpdate){
                    if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                        CaseHelperFMInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                    }
                    CaseHelperFMInstance.calculateComplaintAmount(trigger.new,market);
                    //---------CaseHelperFMInstance.callCaseUpdateInformaticaURL(Trigger.newMap);
                }
                
                //share Record start
                if((Trigger.isinsert||Trigger.isUpdate)){
                    if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){
                        CaseHelperFMInstance.ShareRecordswithDealers(Trigger.new,Trigger.isupdate, market);
                    }
                }
                //share Record end
            }
            
            //to call market specific trigger handler
        	FMMarketTriggerFactory.run('Case', u.Market__c, true, true, true, true, true);
       
        }     
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}