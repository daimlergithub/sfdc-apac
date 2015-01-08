/*
    Type:      
    Purpose:    
    User Story: 
    CR: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai created on 2014-03-17

*/
public class smartDealerCleanController{

    public smartDealerCleanController(){
        fromSSI = new SSI_Cleansing_Result__c();
        toSSI = new SSI_Cleansing_Result__c();
    }

    public SSI_Cleansing_Result__c fromSSI{get; set;}
    public SSI_Cleansing_Result__c toSSI{get; set;}
    public Boolean status{get; set;}
    
    public PageReference dealerClean(){

        String ssiPrefix = Schema.getGlobalDescribe().get('smart_SSI__c').getDescribe().getKeyPrefix();

        Date startDate;
        Date endDate;
        startDate = fromSSI.SSI_Created_Date__c;
        endDate = toSSI.SSI_Created_Date__c;
        
        if (endDate < startDate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                System.Label.SSI_Invoice_Start_Date_And_End_Date_Error));
            return null;
        }
        
        if (endDate == null || startDate == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                System.Label.SSI_Dealer_Cleans_Error));
            return null;
        }
        
        status = smartSSIDataClean.runDealerRule(null,startDate,endDate);
        
        PageReference forward = new PageReference('/' + ssiPrefix);
        forward.setRedirect(true);
        return forward;
    }
}