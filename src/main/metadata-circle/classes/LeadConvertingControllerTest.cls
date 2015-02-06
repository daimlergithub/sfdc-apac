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
        system.debug('RTId___22'+RTId); 
        String ASRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved');
        insert rc;
		system.debug('rc___'+rc.Id);
        Account dealerContact = new Account(LastName = 'Test Amit', RecordTypeId = thirdPartyRTID, phone = '1344444');
        insert dealerContact;
        
        Retail_Campaign_Member__c rtm = new Retail_Campaign_Member__c(Retail_Campaign__c = rc.Id, Contact__c = dealerContact.Id, Status__c = 'Show up');
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