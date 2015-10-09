/*
    Type:       Utility for Account trigger
    Purpose:    
                
    User Story: US-CP-010 , US-CP-016, US-CP-017
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-06-05
    2. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, 
    when Allow Data Sharing changed to yes, update lead's owner.
*/
public class AccountHelper {

    Private static Id dealerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

    /**
       US-CP-010 error message
     */
    public static final String ERROR_MSG_CP_010 = Label.Dealer_Has_SR_Code_1;
    
    /**
       US-CP-016 error message
     */
    public static final String ERROR_MSG_CP_016 = Label.Account_Cann_t_be_Customer;
    
    /**
       get record counts from accout which 
       Dealer_Default_Flag__c = true and "Dealer DMS SR Code 1" has a value
       return a Map Key is Dealer_DMS_SR_Code__c , 
       and value is boolean , if had records is false , if no is true
     */
    public static Map<String, boolean> getDealerCountInfo(List<String> dealerCodes){
        Map<String, boolean> cp010Map = new Map<String, boolean>();
        
        for(sObject obj : [select count(id) sumNum,Dealer_DMS_SR_Code__c from Account where RecordTypeId =: dealerRTId And Dealer_Default_Flag__c = true And Dealer_DMS_SR_Code__c in :dealerCodes group by Dealer_DMS_SR_Code__c ]){
            cp010Map.put(String.valueOf(obj.get('Dealer_DMS_SR_Code__c')), obj.get('sumNum')==0 ? true : false);
        }
        
        return cp010Map;
    }
    
    /**
       get record counts from Vehichle relationShip which Contact is current Acount.
       return a Map Key is Contact__c , 
       and value is boolean , if had records is false , if no is true
     */
    public static Set<Id> getVSCountInfo(List<id> ids){
        Set<Id> cp016Map = new Set<Id>();
        
        for(Vehicle_Relationship__c obj : [select Contact__c from Vehicle_Relationship__c where Contact__c in :ids ]){
            cp016Map.add(obj.Contact__c);
        }
        
        return cp016Map;
    }

    
    //when Allow Data Sharing changed to yes, update lead's owner.
    public static void updateLeads(Set<Id> contactIds) {
        List<Lead__c> leads = [select Id, Dealer_LMS__c, RecordTypeId, Need_Assign_To_Dealer__c, Assigned_Dealer__c from Lead__c where Contact__c in :contactIds and Need_Assign_To_Dealer__c = 'Need' and Assigned_Dealer__c != null];
        Set<Id> dealerIds = new Set<Id>();
        for(Lead__c lead : leads) {
            dealerIds.add(lead.Assigned_Dealer__c);
        }
        
        if(leads.size() > 0) {
            LeadHelper.UpdateLeadOwnerFromContact(dealerIds, leads);
        }
    }   
}