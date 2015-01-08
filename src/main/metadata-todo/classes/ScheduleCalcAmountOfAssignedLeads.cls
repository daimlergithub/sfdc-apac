/*
    Type:       Schedule Apex
    Purpose:    Scheduleable calculate assigned lead amount of dealer every day
    User Story: US-Lead-015
    Used By:    Schedule Job
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-5-23
*/
global class ScheduleCalcAmountOfAssignedLeads implements Schedulable {
    global void execute(SchedulableContext sc) {
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\'';

        BatchCalcAmountOfAssignedLeads calcAssignedLeads = 
            new BatchCalcAmountOfAssignedLeads(query);

        Id batchId = Database.executeBatch(calcAssignedLeads, 200);
        System.debug('ScheduleMSASolidBaseRevenue Batch Job Id: ' + batchId);
    }
}