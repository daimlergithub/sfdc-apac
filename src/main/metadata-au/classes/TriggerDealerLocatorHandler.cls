public class TriggerDealerLocatorHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        list<Dealer_Locator__c> oldDL = (list<Dealer_Locator__c>)trigger.old;
        list<Dealer_Locator__c> newDL = (list<Dealer_Locator__c>)trigger.new;
        string serializedObject;
        user obj=[select id,profileid,profile.Name from user where id=:userinfo.getuserid()];
        if(trigger.isAfter && trigger.isInsert && obj.profile.Name!='IntegrationAPI')
        {
          serializedObject=json.serialize(newDL);
		   serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            DealerLocatorHelper.entityNotifyUpdate('INSERT',newDL[0].Id,serializedObject);
        }
        if(trigger.isAfter && trigger.isUpdate && obj.profile.Name!='IntegrationAPI')
        {
          serializedObject=json.serialize(newDL);
		   serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
             DealerLocatorHelper.entityNotifyUpdate('UPDATE',newDL[0].Id,serializedObject);
        }
        if(trigger.isbefore && trigger.isDelete && obj.profile.Name!='IntegrationAPI')
        {
          serializedObject=json.serialize(oldDL);
		   serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            DealerLocatorHelper.entityNotifyUpdate('DELETE',oldDL[0].Id,serializedObject);
        }
    }
}
