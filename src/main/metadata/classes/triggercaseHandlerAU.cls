/**
* Handler for Trigger on Case for AU(Australia)
* Author:Madhusudhan
* Created Date : 11th Oct 2018
*/

public class triggercaseHandlerAU implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperAU CaseHelperAUInstance = new CaseHelperAU();        
        string market = System.Label.AU;

        if(Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric)){
          market=System.Label.NZ;


        }

         if(Trigger.isbefore && Trigger.isUpdate){
          CaseHelperAUInstance.updatemarket(Trigger.New);
       }
             if(Trigger.isbefore && Trigger.isinsert){
          CaseHelperAUInstance.updatemarket(Trigger.New);
             }

       if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)||Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric)){

            if(trigger.isinsert && trigger.isbefore){
        CaseHelperAUInstance.countRepeatComplaintCase(trigger.new,true,market);
        CaseHelperAUInstance.updateCaseDeadLineAmount(trigger.new,market,null);
        CaseHelperAUInstance.beforeInsertUpdateVehicleInfo(Trigger.new);
      if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail)||Util_GetPermissionList.checkAccessOnUser(Label.NZRetail)){
         CaseHelperAUInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true, market);
        CaseHelperAUInstance.updateCaseCreator(trigger.new, market);
        CaseHelperAUInstance.changeDealerAccount(Trigger.New, market);
      }
      CaseHelperAUInstance.updatecommunityurl(Trigger.New, market);
           
           }
           else if(trigger.isupdate &&trigger.isbefore){
               CaseHelperAUInstance.updatemarket(Trigger.New);
         CaseHelperAUInstance.beforeInsertUpdateVehicleInfo(Trigger.new);
               CaseHelperAUInstance.updatecommunityurl(Trigger.New, market);
               CaseHelperAUInstance.updateCaseDeadLineAmount(trigger.new,market,(Map<Id,Case>)trigger.oldMap);
               CaseHelperAUInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false, market);
           }
          
         if (trigger.isAfter){
            if (trigger.isDelete){
               CaseHelperAUInstance.calculateComplaintAmount(trigger.old,market);
            }
            else if (trigger.isInsert){
          if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
          CaseHelperAUInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
         }
               CaseHelperAUInstance.calculateComplaintAmount(trigger.new,market); 
             
            }else if (trigger.isUpdate){
        if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
          CaseHelperAUInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
           }
               CaseHelperAUInstance.calculateComplaintAmount(trigger.new,market);
        // CaseHelperAUInstance.callCaseUpdateInformaticaURL(Trigger.newMap);
            }
        }
        //share Record start
        if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){
      if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail)||Util_GetPermissionList.checkAccessOnUser(Label.NZRetail)){
        CaseHelperAUInstance.ShareRecordswithDealers(Trigger.new,Trigger.isupdate, market);
        }
        }
        //share Record end
    
       }     
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}