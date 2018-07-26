public class DMMaterialHelperTR {
    string market = System.Label.TR; 
    
    public void shareDMMaterialRecordsWithDealer(List<DM_Request__c> triggerNew,string market){
        DMMaterialHelperBase.shareDMMaterialRecordsWithDealer(trigger.new,market);
    }
}