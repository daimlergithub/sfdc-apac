/**
* Utility for lead trigger handler for MY(Malaysia)
* Author: Honey
* Created Date : 2017-10-10
*
*/
public class LeadTriggerHandlerMY implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
	     List < Lead__c > ldupdate = new List < Lead__c > ();
        
        boolean flag=true;
        LeadHelperMY leadRS= new LeadHelperMY();
			if(Trigger.isbefore && Trigger.isUpdate){
                LeadHelperBase.updatemarket(Trigger.New); 
                }
                if(Trigger.isbefore && Trigger.isinsert){
					LeadHelperBase.updatemarket(Trigger.New); 
                }
        
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                
            if(Trigger.isbefore && Trigger.isUpdate){
                if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){  
					if(Test.isRunningTest()){				
						leadRS.autoPopulateAssignDealer(trigger.New,Label.MY);		
					}					
					leadRS.updateOwner(Trigger.new);  
					leadRs.updateRetailLookups(trigger.New,Label.MY);
					
				}
				leadRS.updatecommunityURL(Trigger.new);
				if(Test.isRunningTest()){
					leadRS.leadValidation(trigger.New,Label.MY);
				}
                
            }
            
            if(Trigger.isbefore && Trigger.isinsert){
				if(Test.isRunningTest()){
					leadRS.leadValidation(trigger.New,Label.MY);
				}
				if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
					if(Test.isRunningTest()){
						leadRS.autoPopulateAssignDealer(trigger.New,Label.MY);
					}
					if(userInfo.getUserType() != 'PowerPartner'){
						leadRS.updateOwnerwithDealer(Trigger.new); 
					}
				}
                //Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community 
                leadRS.updatecommunityURL(Trigger.new);  
            }
            if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){ 
                
				
               // Added by Asish Nanda ,Test Cases : Conditions having When to Share Lead Record With Delaers
              	 if(Util_GetPermissionList.checkAccessOnUser(Label.LeadShareRecordswithDealers )){
                 leadRS.ShareRecordswithDealers(Trigger.new, Trigger.isupdate); 
				 }
                 leadRS.updateAllWorkflowsActionsAfterInsert(Trigger.new,true,Label.MY);
                // Added by Asish Nanda, Test Case-  A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
                  if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
				 leadRS.CreateRetailCopy(trigger.new, (Map < Id, Lead__C > ) Trigger.OldMap, isInsert, isUpdate,label.MY);
				 }
					 if (LeadHelperBase.booleanCampaignUpdate) {
						LeadHelperBase.booleanCampaignUpdate = false;
				
						//leadRS.CreateRetailCopy(trigger.new, (Map < Id, Lead__C > ) Trigger.OldMap, isInsert, isUpdate);
						if (Trigger.isUpdate) {
							Map < id, Lead__c > ldmap = new Map < id, Lead__c > ((Map < Id, Lead__C > ) Trigger.OldMap);
							for (Lead__c lds: (List < Lead__c > ) Trigger.new) {
								if (ldmap.containsKey(lds.Id) && lds.CAC_Lead_Status__c != ldmap.get(lds.Id).CAC_Lead_Status__c && lds.CAC_Lead_Status__c == 'Lost(Dealer)') {
									Lead__c ldclone = new Lead__c(id = lds.Id);
									ldclone.Lead_Lost_Date_Time__c = system.now();
									ldupdate.add(ldclone);
								}
							}
							if (ldupdate.size() > 0)
								update ldupdate;
							 if(Util_GetPermissionList.checkAccessOnUser(Label.LeadAL )){
							leadRS.CdmLeadcreate(trigger.new, (Map < Id, Lead__C > ) Trigger.OldMap,label.MY);
							}

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