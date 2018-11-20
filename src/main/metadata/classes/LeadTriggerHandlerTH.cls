/**
 * Utility for lead trigger handler for TH(Thailand)
 * Author: Dhanamjaya
 * Created Date : 2017-01-23
 */
public class LeadTriggerHandlerTH implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        List<Lead__c> newlead2List = Trigger.new;
        List<Lead__c> newleadList = new List<Lead__c>();
        if(newlead2List!=null && newlead2List.size()>0)
        {
            for(Lead__c newLead: newlead2List){
                if(newLead.MD__c == 'TH'){
                    newleadList.add(newLead);
                }
            }
        }
        List < Lead__c > ldupdate = new List < Lead__c > ();
        user usr = [select id, profileId, profile.Name from User WHERE Id =: userInfo.getUserId()];
        boolean flag = true;
        LeadHelperTH leadRS = new LeadHelperTH();

        if (Trigger.isbefore && Trigger.isUpdate) {
            LeadHelperBase.updatemarket(newleadList);
            leadRS.updateAllWorkflowsActionsAfterInsert(newleadList, trigger.isupdate);
            leadRS.leadValidation(newleadList);
            leadRS.updateOwner(newleadList);
        }

        if (Trigger.isbefore && Trigger.isinsert) {
            leadRS.leadValidation(newleadList);
            leadRS.updateOwnerwithDealer(newleadList);
            LeadHelperTH.changeDealerAccount(newleadList);
        }
        if (Trigger.isafter && (Trigger.isinsert || Trigger.isUpdate) && usr.Profile.Name != 'IntegrationAPI') {
        LeadHelperTH.UpdateRetailCampaingAmount(newleadList);
            if (LeadHelperTH.booleanCampaignUpdate) {
                LeadHelperTH.booleanCampaignUpdate = false;
                leadRS.updateAllWorkflowsActionsAfterInsert(newleadList, trigger.isupdate);
                LeadHelperTH.ShareRecordswithDealers(newleadList, Trigger.isupdate);
                leadRS.CreateRetailCopy(newleadList, (Map < Id, Lead__C > ) Trigger.OldMap, isInsert, isUpdate);
                if(Trigger.isUpdate){
                    Map < id, Lead__c > ldmap = new Map < id, Lead__c > ((Map < Id, Lead__C > ) Trigger.OldMap);
                    for (Lead__c lds: newleadList) {
                        if (ldmap.containsKey(lds.Id) && lds.CAC_Lead_Status__c != ldmap.get(lds.Id).CAC_Lead_Status__c && lds.CAC_Lead_Status__c == 'Lost(Dealer)') {
                            Lead__c ldclone = new Lead__c(id = lds.Id);
                            ldclone.Lead_Lost_Date_Time__c = system.now();
                            ldupdate.add(ldclone);
                        }
                    }
                    if (ldupdate.size() > 0)
                        update ldupdate;
                    leadRS.CdmLeadcreate(newleadList, (Map < Id, Lead__C > ) Trigger.OldMap);
                }
            }
        }
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter){
        // Implementation to addedd as required in market
        LeadHelperTH leadRS = new LeadHelperTH();
        //Added below code for Calling Informatica service for Integration user By Ashish Jadhav 23 july, 2018 for Update
        List<Lead__c> lead2List = Trigger.new;
        List<Lead__c> leadList = new List<Lead__c>();
        //Map<Id,SObject> leadOldMap= Trigger.oldMap;
        if(lead2List!=null && lead2List.size()>0)
        {
            for(Lead__c leadNew: lead2List){
                if(leadNew.MD__c == 'TH'){
                    leadList.add(leadNew);
                }
            }
        }
        if(!isDelete){
            if(leadList != null && leadList.size() > 0){
                if(Trigger.isafter && Trigger.isinsert){
                    Map<Id, Lead__c> ldForCDM = new Map<Id, Lead__c>();
                    for (Lead__c ld: leadList){
                        if (String.isnotblank(ld.StouchLeadID__c)){
                            ldForCDM.put(ld.id,ld);
                        }
                    }
                    System.debug('call to CDM Service');
                    if(ldForCDM != null && ldForCDM.size() > 0)
                        leadRS.CdmLeadcreate(leadList, (Map < Id, Lead__C > ) ldForCDM);
                }
            }
        }
    }
}