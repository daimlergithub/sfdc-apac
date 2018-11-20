public class RetailTaskTriggerHandlerFM implements TriggerHandlerIf{
    public String Market=Utility_FM.getLoggedInUserInfo().Market__c;
    
 public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   
        
        FMMarketTriggerFactory.run('Retail_Task__c',Market,isInsert,isUpdate,isBefore,isDelete,isAfter);
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<Retail_Task__c> RtNewList = Trigger.new;
        //Added for FM Markets
        String MarketCodes = Label.HandleIntegrationTriggerFMCountries;
        if(!isDelete && !RtNewList.isEmpty() && RtNewList.size() > 0 && MarketCodes.contains(RtNewList[0].Market__c))
        {   // Implementation to addedd as required in market
			if(Trigger.isInsert && Trigger.isAfter){
				RetailTaskHelperFM rt=new RetailTaskHelperFM();
				rt.shareRetailTasks(Trigger.new);
              
			}
		}
    }

}