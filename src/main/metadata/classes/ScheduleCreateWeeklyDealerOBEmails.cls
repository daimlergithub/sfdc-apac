/*
  Name                 : ScheduleCreateWeeklyDealerOBEmails
  Object               : Account(Dealer), Lead__c
  Requirement          : US-Lead-46, US-Lead-47, US-Lead-48
  Refer classes        : 
  Author               : Mouse Liu
  Create Date          : 2013-06-14
  Modify History       : 
  
 */
global class ScheduleCreateWeeklyDealerOBEmails implements Schedulable {
    global void execute(SchedulableContext sc) {
        String query = 
            'SELECT Id, Name, Dealer_CRM_Manager_Email__c, ' + 
            'Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, ' +  
            'Dealer_Sales_Manager_Email__c, Owner.Email, ' + 
            'Dealer_MB_Sub_Region__c ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\'';

        System.debug(query);
        BatchCreateDealerOBEmails emailBatch = new BatchCreateDealerOBEmails(query, false);
        Id batchId = Database.executeBatch(emailBatch, 200);
        System.debug('ScheduleCreateWeeklyDealerOBEmails Batch Job Id: ' + batchId);
    }
}