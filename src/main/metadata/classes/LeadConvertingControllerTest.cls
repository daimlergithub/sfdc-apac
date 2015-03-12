/*
    Type:       test class
    Purpose:    LeadConvertingController test class
    User Story: Release 1.2

    Used By:    LeadConvertingController
    ---------------------------------------------------------------
    History:

    9-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class LeadConvertingControllerTest {
    public static testMethod void testLeadConvertingController(){
        String thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
        String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;
        
        String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        String ASRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved');
        insert rc;

        Account thirdParty = new Account(LastName = 'Test Amit', RecordTypeId = thirdPartyRTID, Phone ='12345678921',PersonOtherPhone='0231456987',PersonHomePhone='0231456989',PersonMobilePhone='0231456439',Retail_Fax__c='0237456989',Retail_Home_Phone__c='0281456989',Retail_Mobile__c='0231456949',Retail_Work_Phone__c='0231056989');
        insert thirdParty;
        
        Retail_Campaign_Member__c rtm = new Retail_Campaign_Member__c(Retail_Campaign__c = rc.Id, Contact__c = thirdParty.Id, Status__c = 'Show up');
        insert rtm;
        
        PageReference leadConverting = Page.LeadConverting;
        leadConverting.getParameters().put('id',rc.id);
        Test.setCurrentPage(leadConverting);
        
        LeadConvertingController extension = new LeadConvertingController();
        extension.converttolead();
        extension.cancel();
        extension.vehicleLooking();
        
        extension.retailCampaignMemberInfos[0].lead.Lead_Desired_Service__c = 'a';
        extension.converttolead();
        
        extension.retailCampaignMemberInfos[0].lead.Retail_Purchase_Time__c  = '0 - 3 months';
        extension.converttolead();
        
        extension.retailCampaignMemberInfos[0].lead.Lead_Type__c = 'a';
        extension.converttolead();
    }
}