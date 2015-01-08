/*
    Type:       Smart SSI List button 'Data Cleanning' fuction 
    Purpose:    Clean dealer rule and car rule
    User Story: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai Created on 2014-03-14

*/
global class SmartSSIDataClean {

    webService static Boolean runDealerRule(List<smart_SSI__c> originalList, Date startDate, Date endDate){
        Boolean processResult = true;
        
        String queryStr = 
            'Select Id, Dealer__c, VehicleDesc__c From smart_SSI__c Where Status__c = \'Original\' AND New_Used__c != \'Used\'';
            
        queryStr = queryStr + ' and InvoiceDate__c >= ' + String.valueof(startDate).subString(0,10)
            + ' and InvoiceDate__c <= ' + String.valueof(endDate).subString(0,10);
        
        SmartSSIBatchDealerCheck dealerChecker = new SmartSSIBatchDealerCheck(queryStr);

        Id batchId = Database.executeBatch(dealerChecker, 200);
        
        System.debug('SmartSSIBatchDealerCheck Batch Job Id: ' + batchId);
        
        return processResult;
    }
    

    webService static Boolean runCarModelRule(List<smart_SSI__c> originalList, Boolean continueRestRule){
        
        Boolean processResult = true;
        
        String queryStr = 
            'Select Id, Dealer__c, VehicleDesc__c, VehicleModel__c From smart_SSI__c Where Status__c = \'In Process\'' 
            + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
            + ' And CarModelCheck_Status__c = null ';
                
        SmartSSIBatchCarModelCheck carModelChecker = new SmartSSIBatchCarModelCheck(queryStr);

        Id batchId = Database.executeBatch(carModelChecker, 200);
        
        System.debug('SmartSSIBatchCarModelCheck Batch Job Id: ' + batchId);
        
        return processResult;
    }

    webService static Boolean runRestRule(List<smart_SSI__c> originalList, Boolean continueVINMatch){
        
        Boolean processResult = true;
        
        String queryStr = 
            'Select VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c, OriginalCustomerName__c, Original_HomeMobilePhone__c, OriginalOfficePhone__c '
            + 'From smart_SSI__c Where Status__c = \'In Process\'' 
            + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
            + ' And (CarModelCheck_Status__c = \'Valid\' Or CarModelCheck_Status__c = \'Accept\') '
            + ' Order By Invoice_Year__c ASC, Invoice_Month__c ASC, InvoiceDate__c DESC LIMIT 100 ';
                
        SmartSSIBatchRestRuleCheck restRuleChecker = new SmartSSIBatchRestRuleCheck(queryStr);

        Id batchId = Database.executeBatch(restRuleChecker, 100);
        
        System.debug('SmartSSIBatchRestRuleCheck Batch Job Id: ' + batchId);
        
        return processResult;
    }
}