/**
* Utility for Trigger on Case to handle business logic
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class CaseHelperMY {

    CaseHelperBase caseHelperBaseInstance = new CaseHelperBase();
    string market = System.Label.MarketMY;
    
    public void updateCaseDeadLineAmount(List<case> caselist, string market,Map<Id,Case> oldValcase){
            caseHelperBaseInstance.updateCaseDeadLineAmount(caselist,market,oldValCase);    
    }
    
    public void calculateComplaintAmount(List<Case> cases, string market){
        caseHelperBaseInstance.calculateComplaintAmount(cases,market);
    }
    
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        caseHelperBaseInstance.countRepeatComplaintCase(cases,isInsert,market);    
    }
    
    public void updateCaseOwnerDependsonPrimaryCaseDealer(List<case> cases,boolean isInsert, String market){
        caseHelperBaseInstance.updateCaseOwnerDependsonPrimaryCaseDealer(cases, isInsert, market);
    }
    
    public void updatecommunityurl(List<case> cases, String market){
        caseHelperBaseInstance.updatecommunityurl(cases, market);
    }
    
    public void updateCaseCreator(List<case> cases, String market){
        caseHelperBaseInstance.updateCaseCreator(cases, market);
    }
    
    public void changeDealerAccount(List<case> cases, String market){
        caseHelperBaseInstance.changeDealerAccount(cases, market);
    }
    
    public void updatemarket(List<case> cases){
        caseHelperBaseInstance.updatemarket(cases);
    }
    
    public void CreateRetailCopy(List<case> cases, Map<Id,Case> oldValcase, boolean isInsert, boolean isUpdate, String market){
        caseHelperBaseInstance.CreateRetailCopy(cases, oldValcase, isInsert, isUpdate, market);
    }
    
    public void ShareRecordswithDealers(List<case> cases, boolean isUpdate, String market){
        caseHelperBaseInstance.ShareRecordswithDealers(cases, isUpdate, market);
    }
}