/*
    Type:       controller
    Purpose:    CAC Fields extension Controller
    User Story: US-DPCR-002 - View and edit CAC Fields

    Used By:    VF Page - CACFields.page
    ---------------------------------------------------------------
    History:

    15-July-2013 Sinow zhang (Nttdata)    Created
*/
public class CACFieldsExtension {

    public Case caseInfo { get; set; }
    public boolean isEdit { get; set; }
    
    public CACFieldsExtension (ApexPages.StandardController stdController) 
    {     
        caseInfo = (Case)stdController.getRecord();
        caseInfo = [select Id, Case_Class__c, Case_Type__c, Case_SubType__c, Car_Type__c, Dealer_Feedback__c, Priority, Dealer_Contact__c, Case_RepeatCause__c, Repeat_Complaint_Times__c, Result__c, Final__c, Results_Response__c, Feedback_to_CAC_New__c, Voice_Record_Link__c from Case where Id = :caseInfo.Id];         
        isEdit = false;
    }
    
    public pageReference edit() {
        isEdit = true;
        return null;
    }
    
    public pageReference cancel() {
        isEdit = false;
        return null;
    }
    
    public pageReference save() {
        try {
            update caseInfo;
            isEdit = false;
        }
        catch(Exception ex) {
            system.debug(ex.getMessage());
        }
        return null;
    }
}