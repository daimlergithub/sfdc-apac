public class DealerLocatorHelper
{
     @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
    string orgId=UserInfo.getOrganizationId();
          string sfdcTypeName='Dealer_Locator__c';
          if(!test.isrunningtest())
               UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,updateType,serlializedObject);
    }
}