/**
* Handler for Trigger on Campaign for Factory Model
* Author: Ankit Kapoor
* Created Date : 2018-09-09
*/

public class TriggerCampaignTriggerHandlerFM implements TriggerHandlerIf
{
        CampaignHelperFM chb = new CampaignHelperFM();
        Boolean updateflag = true;
        Boolean deleteflag =true;
        Boolean insertflag= true;
   		string market = null;
        string parentCampaign =System.Label.Planning_Design_Campaign; 
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
         
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    { 
      
        User loggedInUser = Utility_FM.getLoggedInUserInfo();
        market=loggedInUser.Market__c;
        
        if(trigger.isUpdate)
        {
           if(trigger.isBefore){
              CampaignHelperBase.updatemarket(Trigger.New);
           }
           if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
              chb.beforeUpdateEvents(Trigger.new,oldmap,market,parentCampaign);
           }
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
           if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
             chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);
            }          
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {  if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){      
         	  chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);
            }           
        }
        // RSVP for Campaign Members- Asish Kumar Nanda
       
        if(trigger.isAfter && (trigger.isUpdate || trigger.isdelete) )
        { // if(Util_GetPermissionList.checkAccessOnUser(Label.RSVP))
            if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){      
           chb.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market);       
            }           
        }
        
       FMMarketTriggerFactory.run('Campaign',market,isInsert,isUpdate,isBefore,isDelete,isAfter);
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      User loggedInUser = Utility_FM.getLoggedInUserInfo();
      market=loggedInUser.Market__c;	
      List<Campaign> CampaignNewList=trigger.new;
      string marketcodes = Label.HandleIntegrationTriggerFMCountries;  //Added for FM markets
      if(!isDelete && !CampaignNewList.isEmpty() && CampaignNewList.size() > 0 && marketcodes.contains(CampaignNewList[0].Market__c)){
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
            // RSVP for Campaign Members- Asish Kumar Nanda
            
             if(trigger.isAfter && (trigger.isUpdate || trigger.isdelete)){
             
               chb.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market); 
             } 

      }
    }
}