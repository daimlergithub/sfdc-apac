/**
** Class        : DispatcherLeadEditControllerIN 
** Description  : Class to redirect lead edit page on the basis of recordType
** Created By   : Prem Kumar
** Date         : 29/03/2018
**/

public class DispatcherLeadEditControllerIN {
    public Opportunity opp {get;set;}
    public string recTypeName {get;set;}
    public DispatcherLeadEditControllerIN(ApexPages.StandardController controller) {}
    
    public PageReference goToRecordTypePage() {
        opp = [Select id, recordtypeid From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];
        recTypeName = UtilRecordType.getRecordTypeNameById('Opportunity', opp.RecordTypeId);
        if(recTypeName == System.Label.Aftersales_Lead){
            PageReference leadPage = new PageReference('/apex/AfterSalesLeadEditPage');
            leadPage.getParameters().put('id', opp.id);
            leadPage.setRedirect(true);
            return leadPage;
        }
        else if(recTypeName == System.Label.Sales_Lead)

        {
            PageReference leadPage = new PageReference('/apex/SalesLeadEditPage');
            leadPage.getParameters().put('id', opp.id);
            leadPage.setRedirect(true);
            return leadPage;            
        }
        else if(recTypeName == 'Finance Lead'){
            PageReference leadPage = new PageReference('/'+opp.id+'/e?nooverride=1&retURL=%2F'+opp.id);
            //leadPage.getParameters().put('id', opp.id);
            return leadPage;     
        }
        return null;
    }
}