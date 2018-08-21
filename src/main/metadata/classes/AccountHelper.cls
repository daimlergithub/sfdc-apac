/**
** Utility for Account trigger
** when Allow Data Sharing changed to yes, update lead's owner
** Created By: Bing Bai
** Date: 2013-06-05
** User Story: US-CP-010 , US-CP-016, US-CP-017
** Modified By : 
** Modified date : 27-oct-2015
** Modified date : 27-oct-2018
**/

public class AccountHelper { 
 
    /**
       US-CP-010 error message
     */
    public static final String ERROR_MSG_CP_010 = Label.Dealer_Has_SR_Code_1;
    
    /**
       US-CP-016 error message
     */
    public static final String ERROR_MSG_CP_016 = Label.Account_Cann_t_be_Customer;
    
/**	
* @Description: when Allow Data Sharing changed to yes, update lead's owner.
* @author:  Bing Bai
* @Date: 2013-06-05(mm/dd/yy)
* @param:  Set of dealer Id's
* @return: 
* @see:  AccountHelper
*/
 
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
