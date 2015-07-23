public class DealerLocatorHelper
{
	@Future(callout=true)
    public static void entityNotifyUpdate(string updateType,string serlializedObject)
    {
    	string orgId=UserInfo.getOrganizationId();
    	Schema.DescribeSObjectResult r = Dealer_Locator__c.sObjectType.getDescribe();
		String sfdcId = r.getKeyPrefix();
		string sfdcTypeName='Dealer_Locator__c';
		if(!test.isrunningtest())
			UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,updateType,serlializedObject);
    }
}