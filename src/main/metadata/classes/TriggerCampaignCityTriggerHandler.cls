/*
    Type:       Trigger
    Purpose:    Delete all Participating_Dealer__c when the campaignCity is deleted 
    User Story: US-Cpn-002, US-Cpn-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignCityTriggerHandler
*/
public class TriggerCampaignCityTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        

        // get all deleted records
        if (trigger.isDelete && trigger.isBefore)
        {
            if(!trigger.old.isEmpty())
            {           
                UtilCampaignCity.deleteParticipatingDealer(trigger.old);
            }
        }
    }
}