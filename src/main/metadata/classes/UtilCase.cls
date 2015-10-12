/*
  Name                 : UtilCase
  Object               : Case
  Requirement          : US-Cpn-010
  Refer classes        : UtilCase.cls
  Author               : Mouse Liu
  Create Date          : 2013/7/9
  Modify History       : 
 
 */
public with sharing class UtilCase {
    
   
    
    public static void rollupAccountComplaintAmount(List<Case> cases) {
        Set<Id> accIds = new Set<Id>();
        for (Case c : cases) {
            accIds.add(c.AccountId);
        }

        List<Account> accs = 
            [SELECT Id, Complaint_Amount__c,
                (SELECT Id FROM Cases 
                 WHERE RecordType.Name = 'MB Complaint'
                 OR RecordType.Name = 'Chrysler Complaint')
             FROM Account WHERE Id IN :accIds];

        for (Account acc : accs) {
            acc.Complaint_Amount__c = acc.cases.size();
        }

        try {
            update accs;
        }
        catch (DMLException e) {
            if (trigger.isDelete) {
                trigger.old[0].addError(e.getDMLMessage(0));
            }
            else {
                trigger.new[0].addError(e.getDMLMessage(0));
            }
            System.debug('UtilCase.rollupAccountComplaintAmount Exception: ' + e);
        }
    }
	
	
}