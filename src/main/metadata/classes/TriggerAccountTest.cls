/*
    Type:       Test Class for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City and Province 
    User Story: US-DS-001
    1. Mouse Created on 2013-03-28
*/
@isTest
private with sharing class TriggerAccountTest {
public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void testLinkDealerCity() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;
    Test.startTest();
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

        // Update Dealer City and Province according to dealerCity
        dealer.City__c = 'Dongcheng District';
        dealer.Province__c = 'Beijing';
        update dealer;
        dealer = [select City__c,Province__c from Account where id =:dealer.id];
         Test.stopTest();
        system.assert(dealer.City__c =='Dongcheng District');
        system.assert(dealer.Province__c == 'Beijing');
    }

    public testMethod static void testUpdateLeadDataSharing() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;
     Test.startTest();
        Account personAccount = new Account();
        //UtilTestData.createSobject(personAccount, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                    personAccount.RecordTypeId=personRecordtypeid ;
                    personAccount.LastName ='testaccount';
                    personAccount.Email__c='test@mbau.com';
                    personAccount.Email2__c = 'testemail2@test.com';
                    personAccount.Home_Phone_2__c = '00000009842';
                    personAccount.MBK_Data_Source__c = 'Email';
                    personAccount.Mobile__c = '00000009842';
        insert personAccount;
        Lead__c lead = new Lead__c(CAC_Lead_Status__c='New Enquiry',Contact__c = personAccount.Id);
        UtilTestData.createSobject(lead, UtilTestData.LEAD_RT_SALES_LEADS);

        personAccount.Allow_Data_Sharing__c = 'Yes';
        update personAccount;

        lead = [SELECT Allow_Data_Sharing__c FROM Lead__c WHERE Id = :lead.Id];
         Test.stopTest();
        system.assertEquals(lead.Allow_Data_Sharing__c , true);
    }
}