public class TriggerDMMaterialTriggerHandlerFM implements TriggerHandlerIf 
{
   public User u=Utility_FM.getLoggedInUserInfo();
   string market = u.Market__c; 
    DMMaterialHelperFM dmobj=new DMMaterialHelperFM();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
            if (Trigger.isAfter && Trigger.isInsert)
            { 
                dmobj.shareDMMaterialRecordsWithDealer(trigger.new,market);                        
            }
        }
        
        
        FMMarketTriggerFactory.run('DMMaterial',market,isInsert,isUpdate,isBefore,isDelete,isAfter);
    }
    
    
     
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        
    }
 
    
}