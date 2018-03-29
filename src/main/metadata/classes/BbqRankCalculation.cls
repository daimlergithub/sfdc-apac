/************************************************************************************
* Created By:Sarath M
* Created Date:15-Mar-18
* Company:Infosys Ltd
* Description:Batch class for Rank calculation based on the points {to be scheduled every night} 
*********************************************************************************************/
global class BbqRankCalculation implements Schedulable,Database.Batchable<sObject> {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    } 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query ='SELECT id,points__c from Employee__c ORDER BY points__c DESC';
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Employee__c> referralRankList){
        list<Employee__c> refList=new List<Employee__c>();
        Map<Decimal, Integer> refPointsMap =  new Map<Decimal, Integer>();
        Integer rankRef = 1;
        for(Employee__c ref: referralRankList){
            if (refPointsMap.size()>0 && refPointsMap.get(ref.points__c)!=null){
                ref.Rank__c = refPointsMap.get(ref.points__c);    
            }else{
                ref.Rank__c = rankRef; 
                rankRef++;                
            }
            refList.add(ref);
            refPointsMap.put(ref.points__c, integer.valueof(ref.Rank__c));                
        } 
        if(refList.size()>0){
            update refList;
        }
    }    
     global void finish(Database.BatchableContext bc){
    }
}