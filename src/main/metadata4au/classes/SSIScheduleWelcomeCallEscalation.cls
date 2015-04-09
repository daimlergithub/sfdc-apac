/*
    Type:       SSI VIN Match 
    Purpose:    At the end of month, system generates Welcome call task based on unmatched DMS record against SSI record. 
    User Story: US-SSI-006
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-21

*/
global class SSIScheduleWelcomeCallEscalation implements Schedulable {
    global void execute(SchedulableContext sc) {
        String monthString = Datetime.now().format('yyyy-MM') + '-01T00:00:00.000Z';
        Date retailCreateDateStart = Date.newInstance(Date.Today().year(), Date.Today().month(), 1);
        Date tempNextMonth = Date.Today().addMonths(1);
        Date retailCreateDateEnd = Date.newInstance(tempNextMonth.year(), tempNextMonth.month(), 1);
        Id rtid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String query = 
            'Select a.Name, a.PersonContactId, ' + 
            //'(Select CreatedDate From Sales_Person_Account__r), ' + 
            '(Select Create_Welcome_Call__c From Vehicle_Relationships2__r), ' + 
            '(Select CreatedDate From Retail_Tasks3__r where Retail_CreatedDate__c >= ' + String.valueOf(retailCreateDateStart) + ' and Retail_CreatedDate__c < ' + String.valueOf(retailCreateDateEnd) + ' and RecordType.Name = \'Retail Activity\' and Type__c = \'Invoice New Vehicle\'), ' +
            '(Select Subject, Status, Task_RecordType_Name__c ' + 
            'From ActivityHistories), ' + 
            '(Select Subject, Status, Task_RecordType_Name__c ' + 
            'From OpenActivities)' +
            ' From Account a ' + 
            'Where CreatedDate >= ' + monthString + 'And ' + 
            'RecordTypeId = \'' + rtId + '\'';
        System.debug(query);

        SSIBatchGenerateWelcomeCall generateWCBatch = 
            new SSIBatchGenerateWelcomeCall(query);
        Id batchId = Database.executeBatch(generateWCBatch, 100);
        System.debug('SSIBatchGenerateWelcomeCall Batch Job Id: ' + batchId);
    }
}