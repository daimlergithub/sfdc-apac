/**
* Handler for Trigger on Campaign for MY(Malaysia)
* Author: Sushma Bharti
* Created Date : 2017-10-10
*/

//SB2017
public class TriggerCampaignTriggerHandlerMY implements TriggerHandlerIf
{
        CampaignHelperMY chb = new CampaignHelperMY();
        string market = System.Label.MarketMY;
        string parentCampaign =System.Label.Planning_Design_Campaign; 
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
         
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {

        if(trigger.isUpdate)
        {
           if(trigger.isBefore){
              CampaignHelperBase.updatemarket(Trigger.New);
           }
           if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                chb.beforeUpdateEvents(Trigger.new,oldmap,market,parentCampaign);
           }
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
           if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);  
            }          
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {  if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){      
           chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);       
            }           
        }
       
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      List<Campaign> CampaignNewList=trigger.new;
      if(CampaignNewList[0].MD__c==Label.MY){
          if(trigger.isUpdate)
        {
                chb.beforeUpdateEvents(CampaignNewList,oldmap,market,parentCampaign);
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
            chb.afterInsertUpdateEvents(CampaignNewList,oldmap,trigger.isupdate,market,parentCampaign);  
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {       
           chb.afterInsertUpdateEvents(CampaignNewList,oldmap,trigger.isupdate,market,parentCampaign);       
        }
      }
    }
}