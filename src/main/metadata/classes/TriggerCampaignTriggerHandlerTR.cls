/**
* Handler for Trigger on Campaign for TR(Turkey)
* Author: Hildaa
*/

//SB2017
public class TriggerCampaignTriggerHandlerTR implements TriggerHandlerIf
{
        CampaignHelperTR chb = new CampaignHelperTR();
        Boolean updateflag = true;
        Boolean deleteflag =true;
        Boolean insertflag= true;
        string market = System.Label.TR;
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
           if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
                chb.beforeUpdateEvents(Trigger.new,oldmap,market,parentCampaign);
           }
        }
        
        if((trigger.isAfter && trigger.isInsert))
        {        
           if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
            chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);  
            }          
        }
        
        if(trigger.isAfter && trigger.isUpdate)
        {  if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){      
           chb.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate,market,parentCampaign);       
            }           
        }
        // RSVP for Campaign Members- Asish Kumar Nanda
        if(trigger.isAfter && (trigger.isUpdate || trigger.isdelete) )
        {  if(Util_GetPermissionList.checkAccessOnUser(Label.RSVP)){      
           chb.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market);       
            }           
        }
       
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      List<Campaign> CampaignNewList=trigger.new;
      if(!isDelete && !CampaignNewList.isEmpty() && CampaignNewList.size() > 0 && CampaignNewList[0].Market__c==Label.TR){
          if(CampaignNewList[0].Market__c==Label.TR){
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
}