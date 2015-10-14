/*
    Type:       Trigger
    Purpose:    1. Retail Campaign Member can not dup.
                
    User Story: Release 1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2014-06-019
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerRetailCampaignMemberHandler
*/
public class TriggerRetailCampaignMemberHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
       
        
        if(trigger.isBefore && trigger.isInsert)
        {
            RetailCampaignMemberHelper.retailCampaignMemberDuplicateCheck(Trigger.new); 
        }
    }
}