public with sharing class AUAssignVFPageToRecordTypeController
{
    //variables used in the page.
    ApexPages.StandardController controller;
    public String selectedRecordType{get;set;}
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String rType {get; set;}
    public String cancelURL {get; set;}
    public String ent {get; set;}
    public String confirmationToken {get; set;}
    
    
    public AUAssignVFPageToRecordTypeController(ApexPages.StandardController controller)
    {
        
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
        saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
    }
    
    public PageReference redirectToPage() {
        PageReference returnURL;
        // Redirect if Record Type corresponds to custom VisualForce page
        string strbusiness=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        IF(strbusiness.contains(rType)) {
            returnURL = new PageReference('/apex/CreateNewAccountwithPrimaryContact');
        }
        ELSE {
            returnURL = new PageReference('/001/e');
        }
        if (retURL!=null)returnURL.getParameters().put('retURL', retURL);
        returnURL.getParameters().put('RecordType', rType);
        if (cancelURL!=null)returnURL.getParameters().put('cancelURL', cancelURL);
        if (ent!=null)returnURL.getParameters().put('ent', ent);
        if (confirmationToken!=null)returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
        if (saveNewURL!=null)returnURL.getParameters().put('save_new_url', saveNewURL);
        returnURL.getParameters().put('nooverride', '1');
        returnURL.setRedirect(true);
        return returnURL;
    }
}