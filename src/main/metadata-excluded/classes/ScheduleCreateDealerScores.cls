/*
  Name                 : ScheduleCreateDealerScores
  Object               : Dealer Scroe
  Requirement          : Release 1.2
  Author               : Sinow
  Create Date          : 2014-05-29
  Modify History       : 
 */
global class ScheduleCreateDealerScores implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Dealer_Score__c> dealerScores = new List<Dealer_Score__c>();
        Date currentDate = Date.Today();
        
        for(Account acc : [select Id from Account where RecordType.Name = 'Dealer' and Dealer_Active__c = true and Dealer_Sales_Type__c includes ('MB')]) {
            dealerScores.add(new Dealer_Score__c(Dealer_Name__c = acc.Id, Score_Month__c = String.valueOf(currentDate.Month()), Score_Year__c = String.valueOf(currentDate.Year()), Score__c = 0));
        }
        
        try {
            insert dealerScores;
        }
        catch(Exception ex) {
            system.debug('ScheduleCreateDealerScores run failed: ' + ex.getMessage());
        }
    }
}