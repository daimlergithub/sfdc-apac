/*
    Type:       Controller of of page AddToRetailCampaign
    Purpose:    1. Add case.contact to this retail campaign.
    
    User Story: Release 1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    4-July-2014 Sinow Zhang (NTTData)  Created
*/
public class AddToRetailCampaignController {
    
    private Static final String ErrorMessageInvalidId = 'Invalid Case Id.';
    private Case TheCase { get; set; }
    private Retail_Campaign__c TheRetailCampaign { get; set; }
    
    public AddToRetailCampaignController() {
        String caseId = ApexPages.currentPage().getParameters().get('id');
        if(caseId instanceOf Id) {
            TheCase = [select Id, AccountId, Case_Status__c, Retail_Campaign__c from Case where Id = :caseId];
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessageInvalidId));
        }
    }
    
    public PageReference addTo() {
        Savepoint sp = Database.setSavepoint();
        try {
            insert new Retail_Campaign_Member__c(Contact__c = TheCase.AccountId, From_CAC__c = true, Retail_Campaign__c = TheCase.Retail_Campaign__c);
        }
        catch(exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
        
        try {
            TheRetailCampaign = [select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :TheCase.Retail_Campaign__c];
            if(TheRetailCampaign.Total_CAC_Source_Campaign_Member__c == null) {
                TheRetailCampaign.Total_CAC_Source_Campaign_Member__c = 1;
            }
            else {
                TheRetailCampaign.Total_CAC_Source_Campaign_Member__c += 1;
            }
            update TheRetailCampaign;
        }
        catch(exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
            return null;
        }
        
        try {
            TheCase.Case_Status__c = 'Accepted';
            update TheCase;
        }
        catch(exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
            return null;
        }
        return new pageReference('/' + TheCase.Id);
    }

}