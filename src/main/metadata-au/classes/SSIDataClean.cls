/*
    Type:       SSI List button 'Data Cleanning' fuction 
    Purpose:    Clean dealer rule and car rule
    User Story: US-SSI-002, US-SSI-003, SSI-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-04-27
    2. Barney lai Modify 2014-02-17
    3. Barney lai Modify 2014-03-05

*/
global class SSIDataClean {

    webService static Boolean runDealerRule(List<SSI__c> originalList, Date startDate, Date endDate){
        Boolean processResult = true;
        
        String queryStr = 
            'Select Id, Dealer__c, VehicleDesc__c From SSI__c Where Status__c = \'Original\' AND New_Used__c != \'Used\'';
            
        //2014-2-17 Barney lai start
        queryStr = queryStr + ' and InvoiceDate__c >=' + String.valueof(startDate).subString(0,10)
            + ' and InvoiceDate__c <=' + String.valueof(endDate).subString(0,10);
        //2014-2-17 Barney lai end

        SSIBatchDealerCheck dealerChecker = new SSIBatchDealerCheck(queryStr);

        Id batchId = Database.executeBatch(dealerChecker, 200);
        
        System.debug('SSIBatchDealerCheck Batch Job Id: ' + batchId);
        
        return processResult;
    }
    

    webService static Boolean runCarModelRule(List<SSI__c> originalList, Boolean continueRestRule){
        
        Boolean processResult = true;
        
        String queryStr = 
            'Select Id, Dealer__c, VehicleDesc__c, VehicleModel__c From SSI__c Where Status__c = \'In Process\'' 
            + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
            + ' And CarModelCheck_Status__c = null ';
                
        return processResult;
    }

    webService static Boolean runRestRule(List<SSI__c> originalList, Boolean continueVINMatch){
        
        Boolean processResult = true;
        
        String queryStr = 
            //2014-3-5 Barney lai start
            'Select VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c, OriginalCustomerName__c, Original_HomeMobilePhone__c, OriginalOfficePhone__c '
            //2014-3-5 Barney lai end
            + 'From SSI__c Where Status__c = \'In Process\'' 
            + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
            + ' And (CarModelCheck_Status__c = \'Valid\' Or CarModelCheck_Status__c = \'Accept\') '
            + ' Order By Invoice_Year__c ASC, Invoice_Month__c ASC, InvoiceDate__c DESC LIMIT 100 ';
                
        SSIBatchRestRuleCheck restRuleChecker = new SSIBatchRestRuleCheck(queryStr);

        Id batchId = Database.executeBatch(restRuleChecker, 100);
        
        System.debug('SSIBatchRestRuleCheck Batch Job Id: ' + batchId);
        
        return processResult;
    }
}