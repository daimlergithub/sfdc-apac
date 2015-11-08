/*
    Type:       Extension for SSI standard page "VIN Match" Button - VinMatch page
    Purpose:    Vin Matching Process after 3 steps of data cleansing of SSI.
    User Story: 
    CR: CR-000099, SSI-001
    Used By:    VinMatch.page
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang created on 2013-12-02
    2. Patrick Zhang modified on 2013-12-06
        1) change the base object SSI__c to Task
    3. Patrick Zhang modified on 2013-12-11
        1) add 'CreatedDate >= LAST_N_MONTHS:6'
    4. Barney lai modified on 2014-2-17

*/
public class VinMatchController{

    // public SSI__c fromSSI{get; set;}
    // public SSI__c toSSI{get; set;}
    // InvoiceDate__c of SSI__c is readonly to 'BMBS Sinotrust User', so I have to change SSI__c to 
    // any date type field that is not readonly to Sinotrust.
    public Task fromTask{get; set;}
    public Task toTask{get; set;}
    public SSI_Cleansing_Result__c fromSSI{get; set;}
    public SSI_Cleansing_Result__c toSSI{get; set;}
    public Boolean status{get; set;}
    
    public VinMatchController(){
        //2014-2-17 Barney lai start
        fromSSI = new SSI_Cleansing_Result__c();
        toSSI = new SSI_Cleansing_Result__c();
        //2014-2-17 Barney lai end
        fromTask = new Task();
        toTask = new Task();
    }    

    public PageReference vinMatch(){

        String ssiPrefix = Schema.getGlobalDescribe().get('SSI__c').getDescribe().getKeyPrefix();

        String queryStr = 'SELECT VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, ' 
                        + 'HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c FROM SSI__c ' 
                        + 'WHERE Status__c = \'All Valid\' AND CreatedDate >= LAST_N_MONTHS:6';
        Date startDate;
        Date endDate;
        if (fromTask.Activity_Date__c != null && toTask.Activity_Date__c != null) {
            startDate = fromTask.Activity_Date__c;
            endDate = toTask.Activity_Date__c;
            if (endDate < startDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    System.Label.SSI_Vin_Match_Error_Message));
                return null;
            }
            queryStr = queryStr + ' AND  InvoiceDate__c >= ' 
                                + String.valueOf(startDate) 
                                + ' AND InvoiceDate__c <= '
                                + String.valueOf(endDate);
        }else if (fromTask.Activity_Date__c != null && toTask.Activity_Date__c == null) {
            startDate = fromTask.Activity_Date__c;
            queryStr = queryStr + ' AND  InvoiceDate__c >= ' + String.valueOf(startDate);
        }else if (fromTask.Activity_Date__c == null && toTask.Activity_Date__c != null) {
            endDate = toTask.Activity_Date__c;
            queryStr = queryStr + ' AND InvoiceDate__c <= ' + String.valueOf(endDate);
        }                

        SSIBatchVinMatch vinMatch = new SSIBatchVinMatch(queryStr);
        Id batchId = Database.executeBatch(vinMatch, 100);
        System.debug('SSIBatchVinMatch Batch Job Id: ' + batchId);
        
        PageReference forward = new PageReference('/' + ssiPrefix);
        forward.setRedirect(true);
        return forward;
    }
    
    //2014-2-17 Barney lai start
    public PageReference dealerClean(){

        String ssiPrefix = Schema.getGlobalDescribe().get('SSI__c').getDescribe().getKeyPrefix();

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
        
        status = SSIDataClean.runDealerRule(null,startDate,endDate);
        
        PageReference forward = new PageReference('/' + ssiPrefix);
        forward.setRedirect(true);
        return forward;
    }//2014-2-17 Barney lai end
}