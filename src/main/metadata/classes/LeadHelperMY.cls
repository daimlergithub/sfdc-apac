/**
* Utility for Trigger on Lead__c for MY(Malaysia)
*It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Honey
* Created Date : 2017-10-10
*/
public without sharing  class  LeadHelperMY{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    String Market = System.Label.MarketMY;
    
    LeadHelperBase helperBase = new LeadHelperBase();
    //it will handle the lead reassign functionality befor insert the lead  
    // Added by Laqshay Arora Test Case- When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    public void updateOwnerwithDealer(List<lead__c> leads){
        List<Lead__c> ldowner = new List<Lead__c>();
        for(Lead__c l : leads){
            if((Trigger.isInsert && l.assigned_dealer__c != NULL) || (Trigger.isUpdate && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                l.Assigned_Date_Time__c = System.now();
                l.CAC_Lead_Status__c = 'Assigned';
                ldowner.add(l);
            }
        }
        if(!ldowner.isEmpty()){
           helperBase.updateOwnerwithDealer(ldowner,Market); 
        }
    }
    //this will update dealername once the dealer is assigned.
    public void updateAllWorkflowsActionsAfterInsert(List<lead__c> leads,boolean flag){
        helperBase.updateAllWorkflowsActionsAfterInsert(leads,flag,Market);
    }
   
    //Added by Asish Nanda, it will handle the lead reassign(Dealer Gate Keeper/ Sales Consultant/Sales Advisor) functionality  
    public void updateOwner(List<lead__c> leads){
        List<Lead__c> ldowner = new List<Lead__c>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Lead__c ld : leads){
            if(((Lead__c)Trigger.newMap.get(ld.id)).Sales_Consultant__c != NULL){
                sConid.add(((Lead__c)Trigger.newMap.get(ld.id)).Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        for(User usr : [Select id, contactID from user where contactID in :sConid]){
            mConToUsr.put(usr.contactID, usr.ID);
        }
        for(Lead__c l : leads){
            if(((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c !=((Lead__c)Trigger.oldMap.get(l.id)).Sales_Consultant__c && ((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c != NULL  && (l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId)){
                l.ownerID = mConToUsr.get(((Lead__c)Trigger.newMap.get(l.id)).Sales_Consultant__c);
            }
            else if(((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c !=((Lead__c)Trigger.oldMap.get(l.id)).Service_Advisor__c && ((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c != NULL  && (l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId)){
                l.ownerID = ((Lead__c)Trigger.newMap.get(l.id)).Service_Advisor__c;
            }
            else if((Trigger.isInsert && l.assigned_dealer__c != NULL) || (Trigger.isUpdate && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                l.Assigned_Date_Time__c = System.now();
                l.CAC_Lead_Status__c = 'Assigned';
                ldowner.add(l);
            }
            else{
                ldowner.add(l);
            }
        }
        if(!ldowner.isEmpty()){
            helperBase.updateOwner(ldowner,Market);
        }
    }
    //it will handle all SARI validations of lead module
    public  void leadValidation(List<lead__c> leadlist){
        helperBase.leadValidation(leadList,Market);    
    }
    /*
    Added by : Asish Nanda
   Test Cases : Conditions having When to Share Lead Record With Delaers
    */
    
    public  void ShareRecordswithDealers(List<lead__c> leadlist,Boolean flag){
     helperBase.ShareRecordswithDealers(leadList,flag,market);    
    
    }
    
  // Added by Asish Nanda, Test Case-  A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
     Public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate) {
        set < String > contactId = new set < String > ();
        for (Lead__c le: leadlist) {
            if (le.Assigned_Dealer__c != null && le.Market__c== 'MY') {
                if (isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                    contactId.add(le.id);
                }
            }
        }
        if (contactId.size() > 0) {
            LeadHelperBase.createAccountLinkRecord(contactId);
        }
    }
   // Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community 
   // public void updatecommunityURL(List<Lead__c> Leadlist){
      //  LeadHelperBase.updatecommunityurl(Leadlist, Market);
   // }
	 public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap)
    {
        helperBase.CdmLeadcreate(leadlist, leadOldMap);
    }

}