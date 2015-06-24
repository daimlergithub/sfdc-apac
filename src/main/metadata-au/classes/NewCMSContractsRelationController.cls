/*
    Purpose:    Return to Case detail when save the new CMS record
    User Story: quick wins FOS Complaint

    Used By:    
    ---------------------------------------------------------------
    History:

    2015-02-26 Sinow Created
*/
public class NewCMSContractsRelationController {
    
    public Contract_Relation__c CMSContractsRelationInfo {get; set;}
    public Boolean isCase { get; set; }
    
    public NewCMSContractsRelationController() {
        CMSContractsRelationInfo = new Contract_Relation__c();
        String id = ApexPages.currentPage().getParameters().get('id');
        if(id.startswith('500')) {
            isCase = true;
            CMSContractsRelationInfo.Case_No__c = id;
        }
        else {
            isCase = false;
        }
    }
    
    public pageReference saveCMS() {
        try {
            insert CMSContractsRelationInfo;
        }
        catch(exception ex) {
            return null;
        }
        return new PageReference('/' + CMSContractsRelationInfo.Case_No__c);
    }
    
    public pageReference cancelCMS() {
        return new PageReference('/' + CMSContractsRelationInfo.Case_No__c);
    }
    
    public pageReference saveCMSforLead() {
        try {
            insert CMSContractsRelationInfo;
        }
        catch(exception ex) {
            return null;
        }
        return null;
    }
}