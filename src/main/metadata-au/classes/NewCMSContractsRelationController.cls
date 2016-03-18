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
            CMSContractsRelationInfo.Lead__c = id;
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
        return new PageReference('/' + CMSContractsRelationInfo.Lead__c);
    }
    
    public pageReference saveCMSforLeadAndNew() {
        try {
            insert CMSContractsRelationInfo;
        }
        catch(exception ex) {
            return null;
        }
        
        Contract_Relation__c CMSContractsRelationInfo2 = [select Lead__c, Lead__r.Name from Contract_Relation__c where Id = :CMSContractsRelationInfo.Id];
        CMSContractsRelationInfo = new Contract_Relation__c();
        CMSContractsRelationInfo.Lead__c = CMSContractsRelationInfo2.Lead__c;
        return null;
    }
    
    public pageReference cancelforLead() {
        return new PageReference('/' + CMSContractsRelationInfo.Lead__c);
    }
}