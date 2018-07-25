/*  Class: TriggerOpportunityTriggerHandlerTR
    Created By: Hildaa
    Date: 2018/05/14
*/
public class TriggerOpportunityTriggerHandlerTR implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    
       List < Opportunity > ldupdate = new List < Opportunity > ();
        System.debug('TR trigger handler called');
    	user usr = [select id,name,profile.Name from user where id =: userinfo.getuserid()];
        boolean flag=true;
        OppHelperTR leadRS= new OppHelperTR();
        
        if(Util_getPermissions.checkCustomPermission(Label.TRGeneric)){
                
            if(Trigger.isbefore && Trigger.isUpdate){
                leadRS.updateOwner(Trigger.new);  
                leadRs.updateRetailLookups(trigger.New,Label.TR);
               
                leadRs.checkAddress(Trigger.new);
		 if(usr.profile.Name != 'Marketing Administrator')
        	        leadRs.changeCustomerPhase(Trigger.new);
                System.debug('After Custom phase called1');
                leadRs.changeActivityOwner(Trigger.new);
            }
            
            if(Trigger.isbefore && Trigger.isinsert){
                leadRS.updateOwnerwithDealer(Trigger.new); 
               
                leadRs.checkAddress(Trigger.new);
		 if(usr.profile.Name != 'Marketing Administrator')
	                leadRs.changeCustomerPhase(Trigger.new);
                System.debug('After Custom phase called2');
                leadRs.changeActivityOwner(Trigger.new);
            }
            if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){ 
        
                 leadRS.ShareRecordswithDealers(Trigger.new, Trigger.isupdate); 
                 leadRS.CreateRetailCopy(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, isInsert, isUpdate,label.TR);
           if (oppHelperBase.booleanCampaignUpdate) {
                oppHelperBase.booleanCampaignUpdate = false;
        
            if (Trigger.isUpdate) {
              Map < id, Opportunity > ldmap = new Map < id, Opportunity > ((Map < Id, Opportunity > ) Trigger.OldMap);
              for (Opportunity lds: (List < Opportunity > ) Trigger.new) {
                if (ldmap.containsKey(lds.Id) && lds.stagename != ldmap.get(lds.Id).stageName && lds.stageName == 'Closed Lost') {
                  Opportunity ldclone = new Opportunity(id = lds.Id);
                  ldclone.Lost_Date__c = system.Today();
                  ldupdate.add(ldclone);
                }
              }
              if (ldupdate.size() > 0)
                update ldupdate;
              
             OppHelperTR.updaterelatedOppRecord((List < Opportunity > )trigger.new,ldmap);

            }
                }
                OppHelperTR.calculateSLATime(trigger.new);
            }
			 if(Trigger.isafter && Trigger.isinsert){ 
				leadRS.CdmLeadcreate(trigger.new, (Map < Id, Opportunity> ) Trigger.OldMap,label.TR);
			 }
        }
  
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}
