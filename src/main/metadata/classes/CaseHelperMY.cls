/**
* Utility for Trigger on Case to handle business logic
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class CaseHelperMY {

    CaseHelperBase caseHelperBased = new CaseHelperBase();
    string market = System.Label.MarketMY;
    
    public void updateCaseDeadLineAmount(List<case> caselist, string market,Map<Id,Case> oldValcase){
            caseHelperBased.updateCaseDeadLineAmount(caselist,market,oldValCase);    
    }
    
    public void calculateComplaintAmount(List<Case> cases, string market){
        caseHelperBased.calculateComplaintAmount(cases,market);
    }
    
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        caseHelperBased.countRepeatComplaintCase(cases,isInsert,market);    
    }    
}