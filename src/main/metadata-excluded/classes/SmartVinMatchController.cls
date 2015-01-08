/*
    Type:       Extension for SmartSSI standard page "VIN Match" Button - VinMatch page
    Purpose:    Vin Matching Process after 3 steps of data cleansing of SmartSSI.
    User Story: 
    CR: US-SMART_SSI-005
    Used By:    SmartVinMatch.page
    ---------------------------------------------------------------
    History:
    
    1. Shuang Li created on 2014-03-17

*/
public class SmartVinMatchController{

    public SmartVinMatchController(){
        fromTask = new Task();
        toTask = new Task();
    }

    public Task fromTask{get; set;}
    public Task toTask{get; set;}

    public PageReference vinMatch(){

        String ssiPrefix = Schema.getGlobalDescribe().get('smart_SSI__c').getDescribe().getKeyPrefix();

        String queryStr = 'SELECT VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, ' 
                        + 'HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c FROM smart_SSI__c ' 
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

        SmartSSIBatchVinMatch vinMatch = new SmartSSIBatchVinMatch(queryStr);
        Id batchId = Database.executeBatch(vinMatch, 100);
        System.debug('SSIBatchVinMatch Batch Job Id: ' + batchId);
        
        System.debug('From月份是：' + startDate);
        System.debug('to月份是：' + endDate);

        PageReference forward = new PageReference('/' + ssiPrefix);
        forward.setRedirect(true);
        return forward;
    }
}