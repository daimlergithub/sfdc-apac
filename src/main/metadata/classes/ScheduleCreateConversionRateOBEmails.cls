/*
  Name                 : BatchCreateConversionRateOBEmails
  Object               : Account(Dealer), Lead
  Requirement          : US-Lead-48
  Refer classes        : ScheduleCreateConversionRateOBEmail
  Author               : Mouse Liu
  Create Date          : 2013-07-23
  Modify History       : 

 */
global class ScheduleCreateConversionRateOBEmails implements Schedulable {
    global void execute(SchedulableContext sc) {
    
      /* Commented by venky need to remove later
       Map<Id, UserRole> roleMap = new Map<Id, UserRole>(
            [SELECT Id, (SELECT Id, Email FROM Users) 
             FROM UserRole]); */

        // The Start Date and End Date of Past 12th Month Start
        // lastDay should be the first day of pasted 11th month
        // firstDay should be the the first day of passed 12th month
        // for example, today is 2013-8-19, 
        // lastDay should be 2012-9-1 00:00:00, firstDay should be 2012-8-1
        Date lastDay = System.today().toStartOfMonth().addMonths(-12);
        Date firstDay = lastDay.addMonths(-1);

        system.debug('Dates :' +lastDay +firstDay);
        // Query Dealers and related leads that accept date is during past 12 months
        List<Account> accsInPast12Months = 
            [SELECT Id, Name, Dealer_CRM_Manager_Email__c, 
                 Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c,
                 Dealer_Sales_Manager_Email__c, Owner.Email,
                 OwnerId, Owner.UserRole.ParentRoleId, Dealer_MB_Sub_Region__c,
                (SELECT Id, Dealer_Untouched_In_72H__c, Dealer_Audit__c,
                    Dealer_Audit_Result__c, Dealer_Lead_Status__c,
                    Purchased_Date__c, CAC_Lead_Status__c, 
                    Dealer_Successful_Contacted__c
                 FROM Lead_Assigned_Dealer__r
                 WHERE Assigned_Date_Time__c >= :firstDay
                 AND Assigned_Date_Time__c < :lastDay
                 AND RecordType.Name = 'Sales Leads')
            FROM Account 
            WHERE RecordType.Name = 'Dealer'
            AND Dealer_MB_Sub_Region__c != null
            ORDER BY Dealer_MB_Sub_Region__c];

        // Populate the Region with the accounts in it
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(accsInPast12Months);
            
        
    }
}