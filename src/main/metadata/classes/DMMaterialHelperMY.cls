public class DMMaterialHelperMY {
    string market = System.Label.MarketMY; 
    
    public void shareDMMaterialRecordsWithDealer(List<DM_Request__c> triggerNew,string market){
        DMMaterialHelperBase.shareDMMaterialRecordsWithDealer(trigger.new,market);
    }
}