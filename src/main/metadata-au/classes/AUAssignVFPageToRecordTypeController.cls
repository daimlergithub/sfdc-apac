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
    public string recordId{get;set;}
    
    public AUAssignVFPageToRecordTypeController(ApexPages.StandardController controller)
    {
        
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
        saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
        recordId = ApexPages.currentPage().getParameters().get('Id');
        if(recordId!=null)
        {
          Account objAcc=[select id, Recordtypeid from account where id=:recordId];
          rType=objAcc.Recordtypeid;
        }
    }
    
    public PageReference redirectToPage() {
        PageReference returnURL;
        // Redirect if Record Type corresponds to custom VisualForce page
        string strPerson=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        string strCompany=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        if(strPerson.contains(rType)) {
            returnURL = new PageReference('/apex/AUOverrideNewandEditForAccount?Type=person');
        }
        else if(strCompany.contains(rType)){
          returnURL = new PageReference('/apex/AUOverrideNewandEditForAccount?Type=company');
        }
        else {
          if(recordId!=null){
            returnURL = new PageReference('/'+recordId+'/e?retURL=%2F'+recordId);
          }
            else
              returnURL = new PageReference('/001/e');  
        }
        if (retURL!=null)returnURL.getParameters().put('retURL', retURL);
        returnURL.getParameters().put('RecordType', rType);
        if (cancelURL!=null)returnURL.getParameters().put('cancelURL', cancelURL);
        if (ent!=null)returnURL.getParameters().put('ent', ent);
        if (confirmationToken!=null)returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
        if (saveNewURL!=null)returnURL.getParameters().put('save_new_url', saveNewURL);
        returnURL.getParameters().put('nooverride', '1');
        if(recordId!=null)returnURL.getParameters().put('recordId', recordId);
        returnURL.setRedirect(true);
        return returnURL;
    }
}