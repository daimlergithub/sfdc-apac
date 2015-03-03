/*
  Name                 : ScheduleCreateWeeklyRegionOBEmails 
  Object               : Account(Delaer), Lead__c
  Requirement          : US-Lead-47
  Refer classes        : 
  Author               : Mouse Liu
  Create Date          : 2013-06-25
  Modify History       : 
 */
global class ScheduleCreateWeeklyRegionOBEmails implements Schedulable {
    global void execute(SchedulableContext sc) {
        Map<Id, UserRole> roleMap = new Map<Id, UserRole>(
            [SELECT Id, (SELECT Id, Email FROM Users) 
             FROM UserRole]
        );

        List<Account> accs = 
            [SELECT Id, Name, Dealer_CRM_Manager_Email__c, 
                Dealer_General_Manager_Email__c, Dealer_Marketing_Manager_Email__c, 
                Dealer_Sales_Manager_Email__c, Owner.Email, 
                OwnerId, Owner.UserRole.ParentRoleId, Dealer_MB_Sub_Region__c,
                Dealer_ND_Code__c, Dealer_LMS__c,
                (SELECT Id, Dealer_Untouched_In_72H__c, Dealer_Audit__c,
                    Dealer_Audit_Result__c, Dealer_Lead_Status__c, CAC_Lead_Status__c,
                    Dealer_Successful_Contacted__c
                FROM Lead_Assigned_Dealer__r
                WHERE Received_Date_Time__c = LAST_WEEK
                AND RecordType.Name = 'Sales Leads') 
            FROM Account WHERE RecordType.Name = 'Dealer'
            AND Dealer_MB_Sub_Region__c != null
            ORDER BY Dealer_MB_Sub_Region__c];

        // Populate the Region with the accounts in it
        Map<String, List<Account>> separatedAccountsBySubRegion = 
            UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(accs);
    }
}