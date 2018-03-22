/**
* Utility for Trigger on Case to handle business logic

* Created Date : 22nd Mar 2018
*/

public class CaseHelperAU {

    CaseHelperBase caseHelperBased = new CaseHelperBase();
    string market = System.Label.MarketAU;
    
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