/*  Class: TriggerOpportunityTriggerHandlerIN
    Created By: Shashi Goswami
    Date: 2018/03/28
*/
public class TriggerOpportunityTriggerHandlerIN implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       List < Opportunity > ldupdate = new List < Opportunity > ();
        System.debug('IN trigger handler called');
    
        boolean flag=true;
        OppHelperIN leadRS= new OppHelperIN();
        
        if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                
            if(Trigger.isbefore && Trigger.isUpdate){
                leadRS.updateOwner(Trigger.new);  
                leadRs.updateRetailLookups(trigger.New,Label.IN);
                /*leadRS.updatecommunityURL(Trigger.new);
                */
                leadRs.checkAddress(Trigger.new);//Added by Shashi for Address Check while booking
                leadRs.changeCustomerPhase(Trigger.new);//Added by Shashi to update customer phase of account based on Opportunity
                System.debug('After Custom phase called1');
                leadRs.changeActivityOwner(Trigger.new);//Added by Shashi to Change the owner of Activities when Opportunity owner is changed
            }
            
            if(Trigger.isbefore && Trigger.isinsert){
                leadRS.updateOwnerwithDealer(Trigger.new); 
                /*leadRS.updatecommunityURL(Trigger.new);  */
                leadRs.checkAddress(Trigger.new);//Added by Shashi for Address Check while booking
                leadRs.changeCustomerPhase(Trigger.new);//Added by Shashi to update customer phase of account based on Opportunity
                System.debug('After Custom phase called2');
                leadRs.changeActivityOwner(Trigger.new);//Added by Shashi to Change the owner of Activities when Opportunity owner is changed
            }
            if(Trigger.isafter && (Trigger.isinsert||Trigger.isUpdate)){ 
        
                 leadRS.ShareRecordswithDealers(Trigger.new, Trigger.isupdate); 
                 leadRS.CreateRetailCopy(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, isInsert, isUpdate,label.IN);
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
              
              leadRS.CdmLeadcreate(trigger.new, (Map < Id, Opportunity> ) Trigger.OldMap,label.IN);

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