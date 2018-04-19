/**
* Handler for Trigger on Case for MY(Malaysia)
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class triggercaseHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperMY CaseHelperMYInstance = new CaseHelperMY();
        string market = System.Label.MarketMY;
		   if(Trigger.isbefore && Trigger.isUpdate){
         CaseHelperMYInstance.updatemarket(Trigger.New);
         }
             if(Trigger.isbefore && Trigger.isinsert){
              CaseHelperMYInstance.updatemarket(Trigger.New);
             }
        //Harshit added to check for User permission-Access Management- on 09-10-2017
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
        
            if(trigger.isinsert && trigger.isbefore){
				CaseHelperMYInstance.countRepeatComplaintCase(trigger.new,true,market);
				CaseHelperMYInstance.updateCaseDeadLineAmount(trigger.new,market,null);
			if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
               CaseHelperMYInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
			   }
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
				CaseHelperMYInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true, market);
				CaseHelperMYInstance.updateCaseCreator(trigger.new, market);
				CaseHelperMYInstance.changeDealerAccount(Trigger.New, market);
			}
			CaseHelperMYInstance.updatecommunityurl(Trigger.New, market);
           // CaseHelperMYInstance.updatemarket(Trigger.New);
           }
           else if(trigger.isupdate &&trigger.isbefore){
               CaseHelperMYInstance.updatemarket(Trigger.New);
               CaseHelperMYInstance.updatecommunityurl(Trigger.New, market);
               CaseHelperMYInstance.updateCaseDeadLineAmount(trigger.new,market,(Map<Id,Case>)trigger.oldMap);
			   if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
				CaseHelperMYInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
			   }
               CaseHelperMYInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false, market);
           }
          
         if (trigger.isAfter){
            if (trigger.isDelete){
               CaseHelperMYInstance.calculateComplaintAmount(trigger.old,market);
            }
            else if (trigger.isInsert){
		/*	  if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
					CaseHelperMYInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
			   }*/
               CaseHelperMYInstance.calculateComplaintAmount(trigger.new,market); 
             
            }else if (trigger.isUpdate){
               CaseHelperMYInstance.calculateComplaintAmount(trigger.new,market);
            }
        }
        //share Record start
        if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
				CaseHelperMYInstance.ShareRecordswithDealers(Trigger.new,Trigger.isupdate, market);
				}
        }
        //share Record end
		  if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            CaseHelperMYInstance.beforeInsertUpdateVehicleInfo(Trigger.new);
        }
       }     
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}