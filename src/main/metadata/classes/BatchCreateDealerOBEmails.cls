/*
  Name                 : BatchCreateDealerOBEmails
  Object               : Account(Dealer), Lead
  Requirement          : US-Lead-46, US-Lead-47, US-Lead-48
  Refer classes        : ScheduleCreateMonthlyOBEmailByDealer, 
                         ScheduleCreateWeeklyOBEmailByDealer
  Author               : Mouse Liu
  Create Date          : 2013-06-14
  Modify History       : 
  
 */
global class BatchCreateDealerOBEmails implements Database.Batchable<SObject> {
    private String query;
    private Boolean isMonthly;
    
    global BatchCreateDealerOBEmails(String q, Boolean im) {
        this.query = q;
        this.isMonthly = im;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Map<Id, String> accId2AttachmentBody = new Map<Id, String>();
        String queryStr = 
            'SELECT Id, Name, Dealer_CRM_Manager_Email__c, ' + 
            'Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, ' + 
            'Dealer_Sales_Manager_Email__c, Owner.Email, Dealer_MB_Sub_Region__c, ' +
            'Dealer_ND_Code__c, Dealer_Lead_System__c, ' +
            '(SELECT Id, Dealer_Untouched_In_72H__c, Dealer_Audit__c, ' +
            'Dealer_Lead_Status__c, Dealer_Audit_Result__c, CAC_Lead_Status__c, ' + 
            'Dealer_Successful_Contacted__c ' +
            'FROM Lead_Assigned_Dealer__r ' +
            'WHERE Received_Date_Time__c = ? ' + 
            'AND RecordType.Name = \'Sales Leads\') ' +  
            'FROM Account WHERE RecordType.Name = \'Dealer\'' + 
            'AND Id IN :scope';
        if (isMonthly) {
            queryStr = queryStr.replace('?', 'LAST_MONTH');
        }
        else {
            queryStr = queryStr.replace('?', 'LAST_WEEK');
        }

        for (Account acc : Database.query(queryStr)) {
            // If followup rate is > 90% and is Weekly schedule, no need to send email
            if (!isMonthly && UtilLeadEmailEscalation.checkFollowupRate(acc)) {
                continue;
            }

            String emailBody = '';
            if (isMonthly) {
                emailBody = UtilLeadEmailEscalation.getMonthlyEmailBodyByDealer(acc);
            }
            else {
                emailBody = UtilLeadEmailEscalation.getWeeklyEmailBodyByDealer(acc);
            }

            accId2AttachmentBody.put(acc.Id, emailBody);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}