/**
* Handler for Trigger on Campaign for IN(India)
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/


public class TriggerCampaignTriggerHandlerIN implements TriggerHandlerIf
{
    
        CampaignHelperIN chb = new CampaignHelperIN();
         Boolean updateflag = true;
        Boolean deleteflag =true;
        Boolean insertflag= true;
        string market = System.Label.MarketIN;
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
                if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                chb.beforeUpdateEvents(Trigger.new,oldmap,market,parentCampaign);
           }
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
               if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
            chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);  
            }          
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {         if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
           chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);       
            }           
        }
      
        if(trigger.isAfter && (trigger.isUpdate || trigger.isdelete) )
        {  //if(Util_getPermissions.checkCustomPermission(Label.RSVP)){      
           chb.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market);       
            //}           
        }
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      List<Campaign> CampaignNewList=trigger.new;
    if(!isDelete && !CampaignNewList.isEmpty() && CampaignNewList.size() > 0 && CampaignNewList[0].MD__c==Label.IN){
      if(CampaignNewList[0].MD__c==Label.IN){
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
      
             if(trigger.isAfter && (trigger.isUpdate || trigger.isdelete)){
             
               chb.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market); 
             }
      }
    }
    }
}