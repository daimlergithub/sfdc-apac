/*  Class: TriggerOpportunityTriggerHandlerTR
    Created By: Hildaa
    Date: 2018/05/14
*/
public class TriggerOpportunityTriggerHandlerTR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {

        List < Opportunity > ldupdate = new List < Opportunity > ();
        System.debug('TR trigger handler called');
        user usr = [select id, name, profile.Name from user where id =: userinfo.getuserid()];
        boolean flag = true;
        OppHelperTR leadRS = new OppHelperTR();

        if (Util_getPermissions.checkCustomPermission(Label.TRGeneric)) {

            if (Trigger.isbefore && Trigger.isUpdate) {
                leadRS.updateOwner(Trigger.new);
                leadRs.updateRetailLookups(trigger.New, Label.TR);
                leadRs.populateContact(trigger.New,true,(Map < Id, Opportunity > ) Trigger.OldMap);
                //leadRs.checkAddress(Trigger.new);
                //if(usr.profile.Name != 'Marketing Administrator')
                // leadRs.changeCustomerPhase(Trigger.new);
                System.debug('After Custom phase called1');
                leadRs.changeActivityOwner(Trigger.new);
            }

            if (Trigger.isbefore && Trigger.isinsert) {
                leadRS.updateOwnerwithDealer(Trigger.new);
                leadRs.populateContact(trigger.New,false,(Map < Id, Opportunity > ) Trigger.OldMap);
                if (userInfo.getUserType() == 'PowerPartner')
                    leadRS.updateassignedDealerAccount(trigger.New);
                //leadRs.checkAddress(Trigger.new);
                //if(usr.profile.Name != 'Marketing Administrator')
                //leadRs.changeCustomerPhase(Trigger.new);
                //leadRs.populateformAssemblyURL(trigger.new);
                System.debug('After Custom phase called2');
                leadRs.changeActivityOwner(Trigger.new);
            }
            if (Trigger.isafter && (Trigger.isinsert || Trigger.isUpdate)) {

                leadRS.ShareRecordswithDealers(Trigger.new, Trigger.isupdate);
                leadRS.CreateRetailCopy(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, isInsert, isUpdate, label.TR);
				if (Trigger.isinsert) {
					leadRs.changeCustomerPhase(Trigger.new);
				}
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

                        OppHelperTR.updaterelatedOppRecord((List < Opportunity > ) trigger.new, ldmap);

                    }
                }
                OppHelperTR.calculateSLATime(trigger.new);
            }
            if (Trigger.isafter && Trigger.isUpdate) {
                leadRS.CdmLeadcreate(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, label.TR,true);
            }
        }

    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
		 List<Opportunity> OppListNewList = Trigger.new;
         OppHelperTR opphelper = new OppHelperTR();
            if( !trigger.isdelete && !OppListNewList.isEmpty() && OppListNewList.size() > 0 && OppListNewList [0].Market__c == Label.TR){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   
                   opphelper.ShareRecordswithDealers(OppListNewList, Trigger.isupdate);
                   opphelper.afterInsertEventShareAccountInt(OppListNewList);
               }
               /*if (Trigger.isafter && Trigger.isinsert) {
                opphelper.CdmLeadcreate(trigger.new, (Map < Id, Opportunity > ) Trigger.OldMap, label.TR);
            }*/
            if (Trigger.isbefore && Trigger.isinsert) {
                OppHelperTR.mapRetailCopy(trigger.new);
               // opphelper.populateformAssemblyURL(trigger.new);
            }
               
           }
    }

}