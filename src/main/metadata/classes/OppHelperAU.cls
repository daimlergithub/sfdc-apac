public without sharing class OppHelperAU {
       String Market = System.Label.AU;
        OppHelperBase helperBase = new OppHelperBase();
    
    public void mapCarModelToOpporutnity(Map<Id,Opportunity> mapIdOpportunity)
    {
        OppHelperBase.mapCarModelToOpportunity(mapIdOpportunity);
    }
    
    //Added by Harshit
    public void SetCloseDate(List<Opportunity> oppNewList)
    {
        //OppHelperBase.mapCarModelToOpportunity(mapIdOpportunity);
        for(Opportunity opp : oppNewList)
        {
            Date dueDate = System.today() +90;  
            opp.CloseDate =dueDate ;
            system.debug('inside trigger'+opp.CloseDate);
        }
    }
    
    //Madhusudhan CS added as per MBANZ-139
    // When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    public void updateOwnerwithDealer(List<Opportunity> leads){
        helperBase.updateOwnerwithDealer(leads,Market); 
    }
    
    //Madhusudhan CS added as per MBANZ-139
    // Conditions having When to Share Lead Record With Delaers
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
        helperBase.ShareRecordswithDealers(leadList,flag,Market);        
    }
    
    //Madhusudhan CS added as per MBANZ-139
    // A retail Copy (Retail Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    Public void CreateRetailCopy(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        OppHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
    }
    //Madhusudhan CS added as per MBANZ-403
    public void beforeInsertOpportunity(list<Opportunity> listNewOpps,boolean isInsert)
    {
        
        OppHelperBase.updateOpportunityFieldsBeforeInsert(listNewOpps,isInsert);
    }
    //Madhusudhan CS added as per MBANZ-403
    public void beforeUpdateOpportunity(list<Opportunity> listNewOpps,map<id,Opportunity> OppsOldMap,boolean isUpdate)
    {
        
        OppHelperBase.updateOpportunityFieldsBeforeUpdate(listNewOpps,OppsOldMap,isUpdate);
    }
}
