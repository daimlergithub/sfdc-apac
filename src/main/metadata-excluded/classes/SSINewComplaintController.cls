/*
    Type:       Controller for SSINewComplaintStart\SSINewComplaintEnd Visualforce page 
    Purpose:    Add scripts window before and after new complaint page
    User Story: US-SSI-020
    Used By:    SSINewComplaintStart.page, SSINewComplaintEnd.page
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-20
*/

public class SSINewComplaintController {
	
    private String getValueByParam(String param) {
        String value = ApexPages.currentPage().getParameters().get(param);
        return value;
    }
    
    public PageReference newComplaint(){
    	Id rtid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
		String url = '/500/e?RecordType='+ rtid			
            + '&ent=Case'
            + '&CF00N90000006ZqIh=' + getValueByParam('ssiNumber')
            + '&CF00N90000006ZqIh=' + getValueByParam('ssiId')
            + '&saveURL=/apex/SSINewComplaintEnd?customerName=' + getValueByParam('customerName');

        return new PageReference(url);
    }

}