/**
* Handler for Trigger on Campaign for MY(Malaysia)
* Author: Sushma Bharti
* Created Date : 2017-10-10
*/

//SB2017
public class TriggerCampaignTriggerHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CampaignHelperMY chb = new CampaignHelperMY();
        string market = System.Label.MarketMY;
        string parentCampaign =System.Label.Planning_Design_Campaign; 
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
         
        if(trigger.isUpdate)
        {
           chb.beforeUpdateEvents(Trigger.new,oldmap,market,parentCampaign);
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
           chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);                  
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {        
           chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);                  
        }
       
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}