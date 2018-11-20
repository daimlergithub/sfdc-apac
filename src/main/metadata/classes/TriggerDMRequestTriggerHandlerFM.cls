public class TriggerDMRequestTriggerHandlerFM implements TriggerHandlerIf  {
      
    public User u=Utility_FM.getLoggedInUserInfo();
    string market = u.Market__c;

    DMRequestHelperFM dmobj=new DMRequestHelperFM();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
            if(Trigger.isBefore && Trigger.isInsert)
            {
                dmobj.InsertDMRequest(trigger.new,isInsert,market);         
            }
            
            if (Trigger.isBefore && Trigger.isUpdate)
            { 
                dmobj.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
            }
            if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
            { 
			 if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
                dmobj.shareDMRequestRecordsWithDealer(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,market);      
				}
            }
        }
         FMMarketTriggerFactory.run('DMRequest',market,isInsert,isUpdate,isBefore,isDelete,isAfter);
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      List<DM_Request__c> dmrequestNewList=trigger.new;
        String marketcodes=Label.HandleIntegrationTriggerFMCountries;
      
          if(marketcodes.contains(dmrequestNewList[0].Market__c)){
          if(Trigger.isBefore && Trigger.isInsert)
          {
            dmobj.InsertDMRequest(dmrequestNewList,isInsert,market);
          }
          
          if (Trigger.isBefore && Trigger.isUpdate)
          { 
            dmobj.UpdateDMRequest(dmrequestNewList,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
          }
      }
    }
}