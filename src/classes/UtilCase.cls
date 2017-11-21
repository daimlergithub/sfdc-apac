/**
**update related account record having filed ComplaintAmount with number of cases having  RecordType 'MB Complaint' and 'Chrysler Complaint.
** Created By:  Mouse Liu
** Date: 2013/7/9
**Modified By : 
**Modified date : 
**Last Modified date:
**/

public with sharing class UtilCase {
    
   
/**      
	* @Description:update related account record having filed ComplaintAmount with number of cases having  RecordType 'MB Complaint' and 'Chrysler Complaint. 
	* @author :  Mouse Liu
	* @Date :  2013/7/9
	* @param  cases is a list having all the new records of case Object.
	* @return  NA
	* @see   TriggerCaseTriggerHandler(UtilCase.rollupAccountComplaintAmount(trigger.new);)
	         TriggerCaseTriggerHandler(UtilCase.rollupAccountComplaintAmount(trigger.old);)
*/ 
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