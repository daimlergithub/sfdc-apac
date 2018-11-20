/*
    Type:      class
     Purpose:   1.Update the Lookup relation based on the record Id
*/

public with sharing class InsightResponseHelperAU {

    public static void UpdateRelation(list<Insights_Response__c> listResponses){
        InsightResponseHelperBase.UpdateRelation(listResponses);
    } 
        public static void afterInsertEventShareInsightResponse(list<Insights_Response__c> listResponses){
        InsightResponseHelperBase.afterInsertEventShareInsightResponse(listResponses);
    } 
    
}