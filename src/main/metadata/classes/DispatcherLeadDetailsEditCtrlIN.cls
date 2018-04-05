/**
** Class		: DispatcherLeadDetailsEditCtrlIN 
** Description	: Class to redirect lead edit page on the basis of recordType
** Created By	: Prem Kumar
** Date			: 29/03/2018
**/

public class DispatcherLeadDetailsEditCtrlIN {
    public Opportunity opp {get;set;}
    public Lead_Details__c leadDetail {get;set;}
    public string recTypeName {get;set;}
    public DispatcherLeadDetailsEditCtrlIN(ApexPages.StandardController controller) {}
    
    public PageReference goToRecordTypePage() {
        leadDetail = [Select id, recordtypeid, Related_Lead__c From Lead_Details__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
        opp = [Select id, recordtypeid From Opportunity Where Id = : leadDetail.Related_Lead__c];
        recTypeName = UtilRecordType.getRecordTypeNameById('Opportunity', opp.RecordTypeId);
        if(recTypeName == System.Label.Aftersales_Lead){
            PageReference leadPage = new PageReference('/apex/AfterSalesLeadEditPage');
            leadPage.getParameters().put('id', opp.id);
            leadPage.setRedirect(true);
            return leadPage;
        }
        else
        {
            PageReference leadPage = new PageReference('/apex/SalesLeadEditPage');
            leadPage.getParameters().put('id', opp.id);
            leadPage.setRedirect(true);
            return leadPage;            
        }
    }
}