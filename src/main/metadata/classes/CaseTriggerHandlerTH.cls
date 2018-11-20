/**
* Handler for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 23-Apr-2017
*/

public class CaseTriggerHandlerTH implements TriggerHandlerIf
{
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperTH caseHelperTHd = new CaseHelperTH();
      
        if(trigger.isinsert && trigger.isbefore){
            if(CaseHelperTH.booleanCampaignUpdate){
			CaseHelperTH.updateCaseClass(Trigger.new);
            system.debug('*****************case1');
                //CaseHelperTH.booleanCampaignUpdate=false;
                caseHelperTHd.countRepeatComplaintCase(trigger.new,true);
                caseHelperTHd.updateCaseDeadLineAmount(trigger.new);
                //caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true);
        caseHelperTHd.updateCaseCreator(trigger.new);
        caseHelperTHd.updatecommunityurl(Trigger.New);
        CaseHelperTH.changeDealerAccount(Trigger.New);
            }
        }
        else if(trigger.isupdate &&trigger.isbefore){
           if(CaseHelperTH.booleanCampaignUpdate){
				CaseHelperTH.updatestatusfields(Trigger.new, (Map < Id, Case > )Trigger.oldMap);
				CaseHelperTH.updateCaseClass(Trigger.new);
                CaseHelperTH.booleanCampaignUpdate=false;
                system.debug('*****************case2');
                CaseHelperBase.updatemarket(Trigger.New);
                caseHelperTHd.updatecommunityurl(Trigger.New);
                //caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false);
				CaseHelperTH.caseclose(trigger.new,Trigger.isInsert);
           }
        }
          
        if (trigger.isAfter){
            List <case> newcaselist = new List<case>();
                for (Sobject sobj:trigger.new){
                Case c=(case) sobj;
                      if(c.RecordTypeId  == caseMBComplaintRec_Id) newcaselist.add(c);
                  }
            if (trigger.isDelete){
                List <case> caselist = new List<case>();
                for (Sobject sobj:trigger.old){
                Case c=(case) sobj;
                      if(c.RecordTypeId  == caseMBComplaintRec_Id) caselist.add(c);
                  }
              if(caselist != null && !caselist.isEmpty()) caseHelperTHd .calculateComplaintAmount(caselist);
            }
            else if (trigger.isInsert){
            caseHelperTHd.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate);
			caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true);
              if(newcaselist != null && !newcaselist.isEmpty()) caseHelperTHd .calculateComplaintAmount(newcaselist); 
             
            }else if (trigger.isUpdate){
                caseHelperTHd.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate);
				caseHelperTHd.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false);
              if(newcaselist != null && !newcaselist.isEmpty())  caseHelperTHd.calculateComplaintAmount(newcaselist);
                CaseHelperTH.sendReminderEmail(Trigger.newMap,Trigger.oldMap);
                CaseHelperTH.callCaseUpdateInformaticaURL(Trigger.newMap,Trigger.oldMap);
            }
           
        }
        //share Record start
        if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){
            
            CaseHelperTH.ShareRecordswithDealers(Trigger.new,Trigger.isupdate);
        }
        //share Record end
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
      CaseHelperTH caseHelperTHd = new CaseHelperTH();
      CaseHelperTR caseHelperTRInst = new CaseHelperTR();
      List <case> caselist = new List<case>();
      if(!isDelete)
	  {
		  for (Sobject sobj:trigger.new){
			  Case c=(case) sobj;
			  if(c.market__c == 'TH') caselist.add(c);
		  }
          
		  if(trigger.isinsert && trigger.isbefore){
			  if(CaseHelperTH.booleanCampaignUpdate){
				  caseHelperTHd.updateCaseDeadLineAmount(caselist);
			  }
		  }
          //Added below code to call case share method for compass cases
          if (caselist !=null && !caselist.isEmpty() && trigger.isAfter ){
                    if (trigger.isInsert){
                        caseHelperTRInst.ShareCompassRecordswithDealers(caselist,false, 'TH');
                    }
                    if (trigger.isUpdate){
                        caseHelperTRInst.ShareCompassRecordswithDealers(caselist,Trigger.isupdate, 'TH');
                    }
          }
	  }
      
    }
    
}