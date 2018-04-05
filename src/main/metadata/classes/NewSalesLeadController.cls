/**
**New Controller Class to Re Direct VF page as per Lead Record Type selection
** Created By: Namitha
** Date: 2018-03-27
History:
Author                         Date                    Description
**/
public with sharing class NewSalesLeadController {
    public Opportunity opp {get;set;}
    public string rec {get;set;}
    public NewSalesLeadController(ApexPages.StandardController controller) {}
    public PageReference goToRecordTypePage() {
	opp = new opportunity();
        opp.recordtypeid = ApexPages.currentPage().getParameters().get('RecordType');
        rec = opp.recordtypeid;
        rec = UtilRecordType.getRecordTypeNameById('Opportunity',rec);
	system.debug('Record Type' + rec);	
        if(rec == Label.Aftersales_Lead){
	PageReference leadPage = new PageReference('/apex/AfterSalesLeadPage');
             leadPage.setRedirect(true);
            return leadPage;
        }
        else if (rec == Label.Sales_Lead)
        {
			PageReference leadPage = new PageReference('/apex/SalesLeadPage');
            leadPage.setRedirect(true);
            return leadPage;            
        }
        return null;
	}
}