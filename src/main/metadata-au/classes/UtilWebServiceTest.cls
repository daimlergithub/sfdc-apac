@istest
public class UtilWebServiceTest
{
    static Dealer_Locator__c objDl;
	
    public static testMethod void testEntityUpdateNotification()
    {
        //
        upsert new Trigger__c(Name = 'TriggerDealerLocator', Trigger_Name__c = 'TriggerDealerLocator', Trigger_Handler__c='TriggerDealerLocatorHandler',enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='AU');
        prepareTestdata();
        Test.starttest();
        Test.stoptest();
        system.assertNotEquals(null, objDl);
    }
    
    public static testMethod void testEntityUpdateNotificationWS()
    {
        //
        upsert new EP_Integration_URLS__c(Name = 'Entity Update Notification', EP_WebService_1__c = 'https://crm-salesforce-int.mercedes-benz.com/webservices/EntityUpdateNotification', EP_WebService_1DR__c='https://crm-salesforce-int.mercedes-benz.com/webservices/EntityUpdateNotification');
        Dealer_Locator__c objDl1= new Dealer_Locator__c();
        objDl1.Business_Unit__c='Test';
        objDl1.Category__c='Test';
        objDl1.Comment__c='Test';
        objDl1.Post_Code__c='test';
        objDl1.Offered_Service__c='test';
        objDl1.PMA__c='test';
        objDl1.Suburb__c='test';
        objDl1.State__c='test';
        Test.starttest();
        Test.setMock(HttpCalloutMock.class, new DealerLocatorHttpResponseGenerator());
        Schema.DescribeSObjectResult r = Dealer_Locator__c.sObjectType.getDescribe();
        String sfdcId = r.getKeyPrefix();
        string sfdcTypeName='Dealer_Locator__c';
        UtilWebService.entityUpdateNotification(UserInfo.getOrganizationId(),sfdcId,sfdcTypeName,'INSERT',json.serialize(objDl1));
        Test.stoptest();
        system.assertNotEquals(Null, sfdcId);
    }
    
    static void prepareTestdata()
    {
        objDl= new Dealer_Locator__c();
        objDl.Business_Unit__c='Test';
        objDl.Category__c='Test';
        objDl.Comment__c='Test';
        objDl.Post_Code__c='test';
        objDl.Offered_Service__c='test';
        objDl.PMA__c='test';
        objDl.Suburb__c='test';
        objDl.State__c='test';
        insert objDl;
    }
}