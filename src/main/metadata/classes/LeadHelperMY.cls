/**
* Utility for Trigger on Lead__c for MY(Malaysia)
*It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Honey
* Created Date : 2017-10-10
*/
public without sharing class  LeadHelperMY{
    
    String Market = System.Label.MarketMY;
    
    LeadHelperBase helperBase = new LeadHelperBase();
    //it will handle the lead reassign functionality befor insert the lead  
    public void updateOwnerwithDealer(List<lead__c> leads){  
        helperBase.updateOwnerwithDealer(leads,Market);
    }
    //this will update dealername once the dealer is assigned.
    public void updateAllWorkflowsActionsAfterInsert(List<lead__c> leads,boolean flag){
        helperBase.updateAllWorkflowsActionsAfterInsert(leads,flag,Market);
    }
    
    //it will handle the lead reassign functionality befor update the lead  
    public void updateOwner(List<lead__c> leads){
        helperBase.updateOwner(leads,Market);
    }
    //it will handle all SARI validations of lead module
    public  void leadValidation(List<lead__c> leadlist){
        helperBase.leadValidation(leadList,Market);    
    }
    //create retail copy
    public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate)
    {
        helperBase.CreateRetailCopy(leadlist, leadOldMap, isInsert, isUpdate);
    }
    //Create Lead
     public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap)
    {
        helperBase.CdmLeadcreate(leadlist, leadOldMap);
    }
}