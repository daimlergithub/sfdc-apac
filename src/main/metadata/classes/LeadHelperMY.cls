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
        helperBase.updateOwnerwithDealer(leads,Market); 
    }
	
    //Added by Asish Nanda, it will handle the lead reassign(Dealer Gate Keeper/ Sales Consultant/Sales Advisor) functionality  
    public void updateOwner(List<lead__c> leads){        
            helperBase.updateOwner(leads,Market);								 
    }
	
    /*
    Added by : Asish Nanda
   Test Cases : Conditions having When to Share Lead Record With Delaers
    */
    
    public  void ShareRecordswithDealers(List<lead__c> leadlist,Boolean flag){
     helperBase.ShareRecordswithDealers(leadList,flag,market);        
    }
    
  // Added by Asish Nanda, Test Case-  A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    Public void CreateRetailCopy(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        LeadHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
    }
	
   // Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community 
    public void updatecommunityURL(List<Lead__c> Leadlist){
        LeadHelperBase.updatecommunityurl(Leadlist, Market);
    }
	
	 public void CdmLeadcreate(List < Lead__c > leadlist, map < id, Lead__c > leadOldMap,string market)
    {
        helperBase.CdmLeadcreate(leadlist, leadOldMap,market);
    }
	
	public void updateRetailLookups(List < Lead__c > leadlist,string market){
		LeadHelperBase.updateRetailLookups(Trigger.New,market);
    }
	

}
