/**
* Handler for Trigger on Case for IN(India)
* Author: Shashi Goswami
* Created Date : 18th April 2018
*/

public class triggercaseHandlerIN implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
            CaseHelperIN CaseHelperINInstance = new CaseHelperIN();
            String market = System.Label.IN;
            if(Trigger.isBefore){
                CaseHelperINInstance.updatemarket(Trigger.New);
                for(Case c: (List<Case>)Trigger.New){
                    c.MD__c= c.Market__c;
                }
                if(Trigger.isUpdate && INTriggerRecursionCheck.inCaseBefUpd == false){
                    INTriggerRecursionCheck.inCaseBefUpd = true;
                    //To set the associated Account's Customer Phase as Care for Complaints
                    if (INTriggerRecursionCheck.inCaseCustPhase == false){
                        INTriggerRecursionCheck.inCaseCustPhase = true;
                    	CaseHelperINInstance.changeCustomerPhase(Trigger.New);
                    }
                    if(Util_getPermissions.checkCustomPermission(Label.INRetail) && INTriggerRecursionCheck.inCaseCaseOwner == false){
                        //Update Owner of case to the GateKeeper of the Dealer added to case
                        INTriggerRecursionCheck.inCaseCaseOwner = true;
                        CaseHelperINInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,false, market);
                    }
                    CaseHelperINInstance.calculateCaseAge(Trigger.New);
                }
                if(Trigger.isInsert && INTriggerRecursionCheck.inCaseBefIns == false){
                    INTriggerRecursionCheck.inCaseBefIns = true;
                    if (INTriggerRecursionCheck.inCaseCustPhase == false){
                        INTriggerRecursionCheck.inCaseCustPhase = true;
                    	CaseHelperINInstance.changeCustomerPhase(Trigger.New);
                    }
                    //To count how many times a complaint was repeated
                    CaseHelperINInstance.countRepeatComplaintCase(trigger.new,true,market);
                    //To add whether a case is created by Wholesale or Retail user
                    CaseHelperINInstance.updateComplaintCreatorDepartment(Trigger.New);
                    if(Util_getPermissions.checkCustomPermission(Label.INRetail)){
                        if( INTriggerRecursionCheck.inCaseCaseOwner == false){
	                         INTriggerRecursionCheck.inCaseCaseOwner = true;
    	                    CaseHelperINInstance.updateCaseOwnerDependsonPrimaryCaseDealer(trigger.new,true, market);
                        }
                        //To change the Case Dealer same as the creator if the case is created by a dealer
                        CaseHelperINInstance.changeDealerAccount(Trigger.New, market);
                    }
                }
            }
            if(Trigger.isAfter){
                if(Trigger.isInsert){
                   if(Util_getPermissions.checkCustomPermission(Label.CreateRetailCopy) && INTriggerRecursionCheck.inCaseRetCpy == false){
                       INTriggerRecursionCheck.inCaseRetCpy = true;
                       //To create a Retail Copy(Account Link) of Case Account
                       CaseHelperINInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                   }
                   if(Util_getPermissions.checkCustomPermission(Label.INRetail) && INTriggerRecursionCheck.inCaseShare == false){
                       INTriggerRecursionCheck.inCaseShare = true;
                       //To share the Case record with the assigned dealers
                       CaseHelperINInstance.ShareRecordswithDealers(Trigger.new,false, market);
                   }
                   //To Calculate total complaints associated with an Account
                    if (INTriggerRecursionCheck.inCaseCompAmt == false){
                        INTriggerRecursionCheck.inCaseCompAmt = true;
                   		CaseHelperINInstance.calculateComplaintAmount(trigger.new,market); 
                    }

                }
                else if(Trigger.isUpdate){
                   if(Util_getPermissions.checkCustomPermission(Label.CreateRetailCopy) && INTriggerRecursionCheck.inCaseRetCpy == false){
                       INTriggerRecursionCheck.inCaseRetCpy = true;
                       CaseHelperINInstance.CreateRetailCopy(trigger.new, (Map < Id, Case > ) Trigger.OldMap, isInsert, isUpdate, market);
                   }
                   if(Util_getPermissions.checkCustomPermission(Label.INRetail) && INTriggerRecursionCheck.inCaseShare == false){
                       INTriggerRecursionCheck.inCaseShare = true;
                       CaseHelperINInstance.ShareRecordswithDealers(Trigger.new,true, market);
                   }
                   if (INTriggerRecursionCheck.inCaseCompAmt == false){
                        INTriggerRecursionCheck.inCaseCompAmt = true;
                   		CaseHelperINInstance.calculateComplaintAmount(trigger.new,market); 
                    }
                   //To revalidate Account's Customer Phase value if no Complaint is associated with the Account
                   CaseHelperINInstance.removeCustomerPhaseCare(Trigger.New);
                }
                else if(Trigger.isDelete){
                   if (INTriggerRecursionCheck.inCaseCompAmt == false){
                        INTriggerRecursionCheck.inCaseCompAmt = true;
                   		CaseHelperINInstance.calculateComplaintAmount(trigger.new,market); 
                    }
                }
            }
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to be added as required in market
    }
}