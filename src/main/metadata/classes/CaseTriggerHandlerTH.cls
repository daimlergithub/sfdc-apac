/**
* Handler for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 23-Apr-2017
*/

public class CaseTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperTH caseHelperTHd = new CaseHelperTH();
        
        if(trigger.isinsert && trigger.isbefore){
            if(CaseHelperTH.booleanCampaignUpdate){
            system.debug('*****************case1');
                CaseHelperTH.booleanCampaignUpdate=false;
                caseHelperTHd.countRepeatComplaintCase(trigger.new,true);
                caseHelperTHd.updateCaseDeadLineAmount(trigger.new);
                caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true);
        caseHelperTHd.updateCaseCreator(trigger.new);
        caseHelperTHd.updatecommunityurl(Trigger.New);
            }
        }
        else if(trigger.isupdate &&trigger.isbefore){
           if(CaseHelperTH.booleanCampaignUpdate){
                CaseHelperTH.booleanCampaignUpdate=false;
                system.debug('*****************case2');
                CaseHelperBase.updatemarket(Trigger.New);
                caseHelperTHd.updatecommunityurl(Trigger.New);
             // caseHelperTHd.updateCaseDeadLineAmount(trigger.new);
                caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false);
           }
        }
          
        if (trigger.isAfter){
            if (trigger.isDelete){
               caseHelperTHd .calculateComplaintAmount(trigger.old);
            }
            else if (trigger.isInsert){
               caseHelperTHd .calculateComplaintAmount(trigger.new); 
             
            }else if (trigger.isUpdate){
				caseHelperTHd.calculateComplaintAmount(trigger.new);
				CaseHelperTH.sendReminderEmail(Trigger.newMap,Trigger.oldMap);
            }
           
        }
        //share Record start
        if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){
			caseHelperTHd.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate);
            CaseHelperTH.ShareRecordswithDealers(Trigger.new,Trigger.isupdate);
        }
        //share Record end
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}