/*
    Type:       Test Class for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City and Province 
    User Story: US-DS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28
*/
@isTest
private class TriggerAccountTest {
    public static testMethod void testLinkDealerCity() {
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        // Update Dealer City and Province according to dealerCity
        dealer.City__c = 'Dongcheng District';
        dealer.Province__c = 'Beijing';
        update dealer;
    }

    public testMethod static void testUpdateLeadDataSharing() {
        Account personAccount = new Account();
        UtilTestData.createSobject(personAccount, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        Lead__c lead = new Lead__c(Contact__c = personAccount.Id);
        UtilTestData.createSobject(lead, UtilTestData.LEAD_RT_SALES_LEADS);

        personAccount.Allow_Data_Sharing__c = 'Yes';
        update personAccount;

        lead = [SELECT Allow_Data_Sharing__c FROM Lead__c WHERE Id = :lead.Id];
        System.assert(lead.Allow_Data_Sharing__c == true);
    }
}