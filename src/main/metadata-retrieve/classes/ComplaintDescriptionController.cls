/*
    Type:       ComplaintDescriptionViewAll Visualforce page 
    Purpose:    Search Complaint_Description__c
    User Story: CR UAT1016-04
    Used By:    ComplaintDescriptionViewAll.page
    ---------------------------------------------------------------
    History:
    
    1. lishuang Created on 2013-12-09
*/
public class ComplaintDescriptionController {
    public Id caseId { get; set; }
    public List<Complaint_Description__c> theResults = new List<Complaint_Description__c>();
    
    public ComplaintDescriptionController() {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
    }
    public List<Complaint_Description__c> getTheResults() {
        for(Complaint_Description__c description : [SELECT  Name, Date_Time__c, Created_By__r.name, Description__c, CreatedDate FROM Complaint_Description__c where Case__c = :caseId order by Date_Time__c desc]) {
            if(!String.isBlank(description.Description__c)) {
                theResults.add(description);
            }
        }
        return theResults;
     }
     
    // Click Cancel to return the master detail page
    public PageReference cancel() {
        return new PageReference('/' + caseId);
    }
}