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
  
    /**
       US-CP-010 error message
     */
    public static final String ERROR_MSG_CP_010 = Label.Dealer_Has_SR_Code_1;
    
    /**
       US-CP-016 error message
     */
    public static final String ERROR_MSG_CP_016 = Label.Account_Cann_t_be_Customer;
    
    

    
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