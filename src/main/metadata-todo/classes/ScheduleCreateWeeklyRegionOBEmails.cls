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

        List<Outbound_Email__c> emails = new List<Outbound_Email__c>(); 
        for (String subRegion : separatedAccountsBySubRegion.keySet()) {
            List<Account> accsInEverySubRegion = separatedAccountsBySubRegion.get(subRegion);
            emails.add(UtilLeadEmailEscalation.createOutboundEmailByRegion(
                accsInEverySubRegion, false, roleMap));
        }
        
        insert emails;

        // Create Attachment for Outbound Email
        List<Attachment> atts = new List<Attachment>();
        for (Outbound_Email__c email : emails) {
            Attachment att = new Attachment(
                ParentId = email.Id,
                Name = 'Email Template.txt'
            );

            List<Account> accsInEverySubRegion = 
                separatedAccountsBySubRegion.get(email.TargetObjectId__c);

            // Save Email Body to Attachment Body
            String emailBody = UtilLeadEmailEscalation.getWeeklyEmailBodyByRegion(accsInEverySubRegion);
            att.Body = Blob.valueOf(emailBody);

            atts.add(att);
        }

        insert atts;
    }
}